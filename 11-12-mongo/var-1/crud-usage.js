const { MongoClient } = require('mongodb')
const crud = require('./crud-functions')

const url = 'mongodb://localhost:27017/test_project'
const collection = 'test_collection'

MongoClient.connect(url, (err, db) => {
  if (err) {
    return console.error(err)
  }
  const institutions = db.collection('institutions')
  crud.insertDocuments(db, collection, [{ a: 1 }, { b: 2 }, { c: 3 }, { e: 5 }])
    .then(results => {
      console.log(results.ops)
      return crud.createIndex(db, collection, { a: 1 })
    })
    .then(results => {
      console.log(results.ops)
      return crud.createIndex(db, collection, { a: 1 })
    })
    .then(results => {
      console.log(results)
      return crud.updateDocument(db, collection, { a: 1 }, { d: 4 })
    })
    .then(results => {
      console.log(results.result)
      return crud.findDocuments(db, collection, { a: 1 })
    })
    .then(results => {
      console.log(results)
      return crud.deleteDocument(db, collection, { b: 2 })
    })
    .then(results => {
      console.log(results.result)
      return db.close()
    })
    .catch(err => {
      console.error(err)
    })
})
