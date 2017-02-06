/* eslint-disable */

const { MongoClient } = require('mongodb')

const url = 'mongodb://localhost:27017/audit'

// q1
function auditors (checkings) {
  return checkings
    .aggregate([{
      $unwind: '$sections'
    }, {
      $unwind: '$sections.posts'
    }, {
      $group: {
        _id: {
          client: '$client',
          auditor: '$sections.posts.auditor'
        },
        posts: {
          $addToSet: '$sections.posts.post'
        }
      }
    }, {
      $group: {
        _id: '$_id.client',
        auditors: {
          $addToSet: {
            auditor: '$_id.auditor',
            posts: '$posts'
          }
        }
      }
    }, {
      $project: {
        _id: 0,
        client: '$_id',
        auditors: 1
      }
    }])
    .toArray()
}

// q2
function leads (checkings) {
  return checkings
    .aggregate([{
      $unwind: '$sections'
    }, {
      $group: {
        _id: {
          client: '$client',
          lead: '$sections.lead'
        },
        sections: {
          $addToSet: '$sections.section'
        }
      }
    }, {
      $group: {
        _id: '$_id.client',
        leads: {
          $addToSet: {
            lead: '$_id.lead',
            sections: '$sections'
          }
        }
      }
    }, {
      $project: {
        _id: 0,
        client: '$_id',
        leads: 1
      }
    }])
    .toArray()
}

// q3
function lastModified (checkings) {
  return checkings
    .aggregate([{
      $unwind: '$sections'
    }, {
      $unwind: '$sections.posts'
    }, {
      $group: {
        _id: {
          client: '$client',
          section: '$sections.section'
        },
        last_modified: {
          $max: '$sections.posts.checked'
        }
      }
    }, {
      $group: {
        _id: '$_id.client',
        sections: {
          $addToSet: {
            section: '$_id.section',
            last_modified: '$last_modified'
          }
        }
      }
    }, {
      $project: {
        _id: 0,
        client: '$_id',
        sections: 1
      }
    }])
    .toArray()
}

function getPostsList (posts) {
  return posts.find({}, { _id: 0, post: 1 }).toArray()
}

// q4
function notCompleted (checkings, posts) {
  return getPostsList(posts)
    .then(result => {
      const postsList = result.map(val => val.post)
      return checkings
        .aggregate([{
          $unwind: '$sections'
        }, {
          $unwind: '$sections.posts'
        }, {
          $group: {
            _id: {
              client: '$client',
              section: '$sections.section'
            },
            posts: {
              $addToSet: '$sections.posts.post'
            }
          }
        }, {
          $group: {
            _id: '$_id.client',
            sections: {
              $addToSet: {
                section: '$_id.section',
                completed: '$posts',
                not_completed: {
                  $filter: {
                    input: {
                      $setDifference: [{
                          $let: {
                            vars: {
                              posts: postsList
                            },
                            in: '$$posts'
                          }
                        },
                        '$posts'
                      ]
                    },
                    as: 'post',
                    cond: {
                      $eq: [{
                        $substr: ['$$post', 0, 1]
                      }, {
                        $substr: [{
                          $arrayElemAt: ['$posts', 0]
                        }, 0, 1]
                      }]
                    }
                  }
                }
              }
            }
          }
        }, {
          $project: {
            _id: 0,
            client: '$_id',
            sections: 1
          }
        }])
        .toArray()
    })
}

// q5
function joinPosts (checkings) {
  return checkings
    .aggregate([{
      $unwind: '$sections'
    }, {
      $unwind: '$sections.posts'
    }, {
      $lookup: {
        from: 'posts',
        localField: 'sections.posts.post',
        foreignField: 'post',
        as: 'description'
      }
    }, {
      $unwind: '$description'
    }, {
      $group: {
        _id: '$client',
        rest: {
          $addToSet: {
            posts: {
              post: '$sections.posts.post',
              conclusion: '$description.name'
            }
          }
        }
      }
    }, {
      $project: {
        _id: 0,
        client: '$_id',
        posts: '$rest.posts'
      }
    }])
    .toArray()
}

MongoClient.connect(url, (err, db) => {
  if (err) {
    return console.error(err)
  }
  const checkings = db.collection('checkings')
  const posts = db.collection('posts')

  Promise.resolve()
    .then(() => {
      return joinPosts(checkings, posts)
    })
    .then(result => {
      // console.log(JSON.stringify(result, null, 2))
      console.dir(result, { depth: null, colors: true })

      db.close()
    })
    .catch(err => {
      console.log(err)
      return db.close()
    })
})

// FIX DATES CODE BELOW

// return checkings.find().forEach((doc) => {
//   doc.started = stringToDate(doc.started, 'yyyy-mm-dd', '-')
//
//   doc.sections.forEach((s) => {
//     s.posts.forEach((p) => {
//       p.checked = stringToDate(p.checked, 'yyyy-mm-dd', '-')
//     })
//   })
//   checkings.save(doc)
// })
//
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
