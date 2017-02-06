/* global $ */

$(document).ready(function () {
  createTable()
})

var tables = ['agents', 'supplies', 'shipments']

function createTable () {
  tables.forEach(function (table) {
    var node = $.find('#table_' + table)
    if (node.length) {
      console.log('OK', table)
      generateTable(table)
    }
  })
}

function generateTable (tableName) {
  $('#table_' + tableName).simpletable({
    getURL: function () {
      return 'http://localhost:3000/api/' + tableName
    },
    deleteURL: function (idPrime) {
      return 'http://localhost:3000/api/' + tableName + '/' + idPrime
    },
    editURL: function (idPrime) {
      return 'http://localhost:3000/api/' + tableName + '/' + idPrime
    },
    addURL: function (idPrime) {
      return 'http://localhost:3000/api/' + tableName
    },
    dataFormatter: function (dataraw) {
      dataraw.forEach(function (row) {
        if (row.bill_date) {
          row.bill_date = row.bill_date.replace(/T.+/, '')
        }
      })
      return dataraw
    },
    format: 'json'
  })
}
