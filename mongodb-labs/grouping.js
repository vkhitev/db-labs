const { MongoClient } = require('mongodb')

const url = 'mongodb://localhost:27017/treasury'

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

  joinKekvDescription(institutions)
    .then(result => {
      console.log(result[0])
      db.close()
    })
    .catch(err => {
      console.log(err)
      return db.close()
    })
})
