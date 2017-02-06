const { MongoClient } = require('mongodb')

const url = 'mongodb://localhost:27017/lab12'

// Количество неотвеченных гражданам писем, группировка по теме
function numberOfOpenedQuestions (complaints) {
  return complaints
    .aggregate([{
      $unwind: '$questions'
    }, {
      $unwind: '$questions.answer'
    }, {
      $group: {
        _id: '$subject',
        not_answered: {
          $sum: 1
        }
      }
    }, {
      $project: {
        _id: 0,
        subject: '$_id',
        not_answered: 1
      }
    }])
    .toArray()
}

// Количество написанных в министерство писем, группировка по теме
function numberOfListsSent (complaints) {
  return complaints
    .aggregate([{
      $unwind: '$lists'
    }, {
      $group: {
        _id: '$subject',
        lists_sent: {
          $sum: 1
        }
      }
    }, {
      $project: {
        _id: 0,
        subject: '$_id',
        lists_sent: 1
      }
    }])
    .toArray()
}

// Количество просроченных писем от министерства, группировка по теме
function overdueAnswers (complaints) {
  return complaints
    .aggregate([{
      $unwind: '$lists'
    }, {
      $group: {
        _id: {
          subject: '$subject',
          lists: '$lists'
        }
      }
    }, {
      $project: {
        _id: 0,
        subject: '$_id.subject',
        to: '$_id.lists.to',
        question_date: '$_id.lists.question.question_date',
        answer_date: '$_id.lists.answer.answer_date',
        term: '$_id.lists.term',
        overdue: {
          $subtract: [{
            $divide: [{
              $subtract: [
                '$_id.lists.answer.answer_date',
                '$_id.lists.question.question_date'
              ]
            }, (24 * 60 * 60 * 1000)]
          },
            '$_id.lists.term'
          ]
        }
      }
    }, {
      $match: {
        overdue: {
          $gt: 0
        }
      }
    }])
    .toArray()
}

// Вопросы, которые задавал каждый человек
function questionsByName (complaints) {
  return complaints
    .aggregate([{
      $unwind: '$questions'
    }, {
      $group: {
        _id: {
          from: '$questions.from',
          text: '$questions.question.text'
        }
      }
    }, {
      $project: {
        _id: 0,
        from: '$_id.from',
        text: '$_id.text'
      }
    }])
    .toArray()
}

// Объединить коллекции и дополнительно достать название района, в котором проживает человек
function questionsByNameAndDistrict (complaints) {
  return complaints
    .aggregate([{
      $unwind: '$questions'
    }, {
      $group: {
        _id: {
          from: '$questions.from',
          text: '$questions.question.text'
        }
      }
    }, {
      $project: {
        _id: 0,
        from: '$_id.from',
        text: '$_id.text'
      }
    }, {
      $lookup: {
        from: 'livings',
        localField: 'from',
        foreignField: 'name',
        as: 'living'
      }
    }, {
      $unwind: '$living'
    }, {
      $project: {
        from: 1,
        text: 1,
        district: '$living.district'
      }
    }])
    .toArray()
}

MongoClient.connect(url, (err, db) => {
  if (err) {
    return console.error(err)
  }
  const complaints = db.collection('complaints')

  Promise.resolve()
    .then(() => {
      return questionsByNameAndDistrict(complaints)
    })
    .then(result => {
      console.log(result)

      db.close()
    })
    .catch(err => {
      console.log(err)
      return db.close()
    })
})

// FIX DATES CODE BELOW

// complaints.find().forEach((doc) => {
//   doc.questions.forEach((q) => {
//     q.question.question_date = stringToDate(q.question.question_date, 'yyyy-mm-dd', '-')
//     if (q.answer)
//       q.answer.answer_date = stringToDate(q.answer.answer_date, 'yyyy-mm-dd', '-')
//   })
//   doc.lists.forEach((q) => {
//     q.question.question_date = stringToDate(q.question.question_date, 'yyyy-mm-dd', '-')
//     if (q.answer)
//       q.answer.answer_date = stringToDate(q.answer.answer_date, 'yyyy-mm-dd', '-')
//   })
//   complaints.save(doc)
// })

// function stringToDate (_date, _format, _delimiter)
// {
//   var formatLowerCase = _format.toLowerCase()
//   var formatItems = formatLowerCase.split(_delimiter)
//   var dateItems = _date.split(_delimiter)
//   var monthIndex = formatItems.indexOf('mm')
//   var dayIndex = formatItems.indexOf('dd')
//   var yearIndex = formatItems.indexOf('yyyy')
//   var month = parseInt(dateItems[monthIndex])
//   month -= 1
//   var formatedDate = new Date(dateItems[yearIndex], month, dateItems[dayIndex])
//   return formatedDate
// }
