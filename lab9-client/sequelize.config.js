module.exports = {
  development: {
    database: 'tolling',
    username: 'vlad',
    password: 'qewret',
    options: {
      dialect: 'mysql',
      host: 'localhost',
      port: 3306,
      timezone: '+02:00',
      logging: console.log
    },
    define: {
      freezeTableName: true,
      underscored: false,
      timestamps: false,
      charset: 'utf8'
    }
  }
}
