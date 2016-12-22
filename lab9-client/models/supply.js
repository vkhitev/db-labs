/* jshint indent: 2 */

module.exports = function (sequelize, DataTypes) {
  return sequelize.define('Supply', {
    id: {
      type: DataTypes.INTEGER(11),
      allowNull: false,
      primaryKey: true,
      autoIncrement: true
    },
    bill_date: {
      type: DataTypes.DATE,
      allowNull: false,
      validate: {
        notEmpty: true
      }
    },
    beet_supplied: {
      type: DataTypes.DECIMAL,
      allowNull: false,
      validate: {
        min: 0
      }
    },
    sugar_estimated: {
      type: DataTypes.DECIMAL,
      allowNull: false,
      validate: {
        min: 0
      }
    },
    bagasse_estimated: {
      type: DataTypes.DECIMAL,
      allowNull: false,
      validate: {
        min: 0
      }
    },
    agent_id: {
      type: DataTypes.INTEGER(11),
      allowNull: false,
      references: {
        model: 'agent',
        key: 'id'
      }
    }
  }, {
    tableName: 'supply'
  })
}
