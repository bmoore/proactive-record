Database = require('./database')
config = require('./config')

class Model
  @db = new Database(config)

  # Static Methods
  @find: (ids, success) ->
    klass = @
    inst = new @
    @db.read ids, inst.table, {
      primaryKey: inst.primaryKey}
      success: (results) ->
        inst = new klass results.rows[0]
        success(inst)

  # Instance Methods
  save: () ->
  delete: () ->

module.exports = Model
