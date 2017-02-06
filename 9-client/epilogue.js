module.exports = function (app) {
  const epilogue = require('epilogue')
  const db = require('./models')

  epilogue.initialize({
    app: app,
    sequelize: db.sequelize,
    base: '/api'
  })

  epilogue.resource({
    model: db.Agent,
    endpoints: ['/agents', '/agents/:id']
  })

  epilogue.resource({
    model: db.Supply,
    endpoints: ['/supplies', '/supplies/:id']
  })

  epilogue.resource({
    model: db.Shipment,
    endpoints: ['/shipments', '/shipments/:id']
  })
}
