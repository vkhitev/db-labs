exports.insertDocuments = function (db, collectionName, options) {
  const collection = db.collection(collectionName)
  return collection
    .insertMany(options)
    .then((results) => {
      console.log('Data inserted')
      return results
    })
    .catch((err) => {
      console.error('Can not insert data')
      return err
    })
}

exports.findDocuments = function (db, collectionName, options) {
  const collection = db.collection(collectionName)
  return collection
    .find(options)
    .toArray()
    .then((results) => {
      console.log('Data found')
      return results
    })
    .catch((err) => {
      console.error('Can not find data')
      return err
    })
}

exports.updateDocument = function (db, collectionName, oldOptions, newOptions) {
  const collection = db.collection(collectionName)
  return collection
    .updateOne(oldOptions, { $set: newOptions })
    .then((results) => {
      console.log('Data updated')
      return results
    })
    .catch((err) => {
      console.error('Can not update data')
      return err
    })
}

exports.deleteDocument = function (db, collectionName, options) {
  const collection = db.collection(collectionName)
  return collection
    .deleteOne(options)
    .then((results) => {
      console.log('Data deleted')
      return results
    })
    .catch((err) => {
      console.error('Can not delete data')
      return err
    })
}

exports.createIndex = function (db, collectionName, options) {
  const collection = db.collection(collectionName)
  return collection
    .createIndex(options)
    .then((results) => {
      console.log('Index created')
      return results
    })
    .catch((err) => {
      console.error('Can not create index')
      return err
    })
}
