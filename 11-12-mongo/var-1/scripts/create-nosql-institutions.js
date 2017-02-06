const fs = require('fs')
const path = require('path')

const banks = require(path.join(process.cwd(), process.argv[2], 'banks'))
const estimates = require(path.join(process.cwd(), process.argv[2], 'estimates'))
const institutions = require(path.join(process.cwd(), process.argv[2], 'institutions'))
const kekvs = require(path.join(process.cwd(), process.argv[2], 'kekvs'))
const paymentOrders = require(path.join(process.cwd(), process.argv[2], 'payment_orders'))

function extractOne (arr, field, key) {
  return arr.find(val => val[field] === key)
}

function extractOrders (orders, estimate) {
  return orders.filter(order => (
    order.order_date.startsWith(estimate.year) &&
    order.institution_id === estimate.institution_id &&
    order.kekv_id === estimate.kekv_id
  ))
}

function extractEstimates (estimates, institution) {
  return estimates.filter(estimate => (
    estimate.institution_id === institution.id
  ))
}

const nosqlData = institutions.map(institution => ({
  institution: institution.name,
  estimates: extractEstimates(estimates, institution).map(estimate => ({
    year: estimate.year,
    limit: estimate.money_limit,
    orders: extractOrders(paymentOrders, estimate).map(order => ({
      date: order.order_date
        .replace(/ .+/, '')
        .replace(/^\d{4}-/, '')
        .replace('-', '/'),
      money: order.money,
      kekv: extractOne(kekvs, 'id', order.kekv_id).code,
      bank: extractOne(banks, 'id', order.bank_id).name
    }))
  }))
}))

nosqlData.forEach((doc) => {
  if (doc.estimates && !doc.estimates.length) {
    delete doc.estimates
  } else {
    doc.estimates.forEach((est) => {
      if (est.orders && !est.orders.length) {
        delete est.orders
      }
    })
  }
})

fs.writeFileSync(
  path.resolve(process.cwd(), process.argv[3]),
  JSON.stringify(nosqlData, null, 2)
)
