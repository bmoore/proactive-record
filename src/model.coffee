util = require('util')
Database = require('./database')
config = require('./config')

class Model
  db = new Database(config)

  # Static Methods
  @parseSchema: (options) ->
    db.parseSchema options

  @find: (ids, success) ->
    klass = @
    inst = new @
    db.read ids, inst.table, {
      primaryKey: inst.primaryKey}
      success: (results) ->
        inst = new klass results.rows[0]
        success(inst)

  # Instance Methods
  save: (options) ->
    if @_data[@primaryKey] is null
      @create(options)
    else
      @update(options)

  create: (options) ->
    data = {}
    options.data = @_data
    for field of @_data
      if field isnt @primaryKey
        data[field] = @_data[field]

    that = @
    success = options.success
    options.success = (results) ->
      that._data = results.rows[0]
      success(results) if success

    db.create(@table, data, options)

  update: (options) ->
    db.update(@table, @primaryKey, @_data, options)

  delete: (options) ->
    db.delete(@table, @primaryKey, @_data[@primaryKey], options)

  children: (table, cb) ->
    console.log(@hasMany)


module.exports = Model
