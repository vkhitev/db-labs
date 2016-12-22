/* jshint indent: 2 */

module.exports = function (sequelize, DataTypes) {
  return sequelize.define('Agent', {
    id: {
      type: DataTypes.INTEGER(11),
      allowNull: false,
      primaryKey: true,
      autoIncrement: true
    },
    name: {
      type: DataTypes.STRING,
      allowNull: false,
      validate: {
        isAlpha: true,
        notEmpty: true
      }
    }
  }, {
    tableName: 'agent'
  })
}
