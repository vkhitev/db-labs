const { MongoClient } = require('mongodb')

const url = 'mongodb://localhost:27017/treasury'

function normalizeMoney (arr, field) {
  return arr.map(val => Object.assign(val, {
    [field]: val[field].toFixed(2)
  }))
}

// Получить сумму денег, выданную каждому учреждению за всё время,
// которая больше или равна from грн и меньше to грн.
function totalMoneyByInstBetween (institutions, from, to) {
  return institutions
    .aggregate([{
      $unwind: '$estimates'
    }, {
      $unwind: '$estimates.orders'
    }, {
      $group: {
        _id: '$institution',
        total_money: {
          $sum: '$estimates.orders.money'
        }
      }
    }, {
      $match: {
        $and: [{
          total_money: {
            $gte: from
          }
        }, {
          total_money: {
            $lt: to
          }
        }]
      }
    }, {
      $project: {
        _id: 0,
        institution: '$_id',
        total_money: 1
      }
    }])
    .toArray()
}

// Сколько в среднем денег потрачено по КЕКВам
function avgMoneyByKekvs (institutions) {
  return institutions
    .aggregate([{
      $unwind: '$estimates'
    }, {
      $unwind: '$estimates.orders'
    }, {
      $group: {
        _id: '$estimates.orders.kekv',
        money_avg: {
          $avg: '$estimates.orders.money'
        }
      }
    }])
    .toArray()
}

// Учреждения и среднее количество денег по годам
function avgMoneyAndInstitutionsByYear (institutions) {
  return institutions
    .aggregate([{
      $unwind: '$estimates'
    }, {
      $group: {
        _id: '$estimates.year',
        institutions: {
          $addToSet: {
            institution: '$institution'
          }
        },
        limit: {
          $avg: '$estimates.limit'
        }
      }
    }, {
      $project: {
        _id: 0,
        year: '$_id',
        institutions: 1,
        limit: 1
      }
    }, {
      $sort: {
        year: 1
      }
    }])
  .toArray()
}

// Учреждения и сумма потраченных денег по каждому банку
function institutionsAndTotalMoneyByBanks (institutions, banks) {
  return institutions
    .aggregate([{
      $unwind: '$estimates'
    }, {
      $unwind: '$estimates.orders'
    }, {
      $group: {
        _id: '$estimates.orders.bank',
        money_total: {
          $sum: '$estimates.orders.money'
        },
        institutions: {
          $addToSet: {
            institution: '$institution'
          }
        }
      }
    }, {
      $match: {
        _id: {
          $in: banks
        }
      }
    }, {
      $project: {
        _id: 0,
        bank: '$_id',
        money_total: 1,
        institutions: 1
      }
    }])
  .toArray()
}

function joinKekvDescription (institutions) {
  return institutions
    .aggregate([{
      $unwind: '$estimates'
    }, {
      $unwind: '$estimates.orders'
    }, {
      $lookup: {
        from: 'kekvs',
        localField: 'estimates.orders.kekv',
        foreignField: 'code',
        as: 'kekv'
      }
    }, {
      $unwind: '$kekv'
    }, {
      $project: {
        institution: 1,
        estimates: {
          year: 1,
          limit: 1,
          orders: {
            data: 1,
            money: 1,
            bank: 1,
            kekv: '$kekv.description'
          }
        }
      }
    }])
    .toArray()
}

MongoClient.connect(url, (err, db) => {
  if (err) {
    return console.error(err)
  }
  const institutions = db.collection('institutions')

  totalMoneyByInstBetween(institutions, 60000, 70000)
    .then(result => {
      // console.log(result)
      return avgMoneyByKekvs(institutions)
    })
    .then(result => {
      console.log(normalizeMoney(result, 'money_avg'))
      return avgMoneyAndInstitutionsByYear(institutions)
    })
    .then(result => {
      // console.log(normalizeMoney(result, 'limit')[0])
      return institutionsAndTotalMoneyByBanks(institutions, [
        'УкрСиббанк',
        'Ощадбанк'
      ])
    })
    .then(result => {
      // console.log(result[0])
      db.close()
    })
    .catch(err => {
      console.log(err)
      return db.close()
    })
})
