util = require('util')
Database = require('./database')
config = require('./config')

class Model
  # Private Variables
  db = new Database(config)
  models = {}

  # Private Methods
  createModel = (table, model) ->
    class tmpModel extends Model
      table: table
      primaryKey: model.primaryKey
      fields: model.fields
      hasMany: model.children
      belongsTo: model.parent

      constructor: (data = {}) ->
        @_data = {}
        for field of @fields then do (field) =>
          Object.defineProperty @, field,
            enumerable: true
            configurable: true
            get: ->
              @_data[field] || null
            set: (val) ->
              return if field is @primaryKey
              if @_data[field] isnt val
                @_data[field] = val

          @_data[field] = data[field] || null

    return tmpModel

  # Static Methods
  @parseSchema: (options) ->
    success = options.success
    options.success = (schema) ->
      for table of schema.models
        models[table] = createModel(table, schema.models[table])
      success(schema) if success
    db.parseSchema options

  @getModel: (model) ->
    models[model]

  @find: (finder, success) ->
    table = @table || (new @).table
    primaryKey = @primaryKey || (new @).primaryKey
    db.read finder, table, {
      primaryKey: primaryKey}
      success: (results) ->
        if results.rows.length > 0
          ret = []
          for row in results.rows
            ret.push new models[table] row

          if ret.length < 2
            ret = ret[0] 
        else
          ret = new models[table]

        success(ret)

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
    finder = {}
    model = models[table]

    for key of @hasMany[table]
      child_key = @hasMany[table][key]
      finder[child_key] = @_data[@primaryKey]

    model.find finder, (children) ->
      children = [children] if not Array.isArray children
      cb(children)

  parent: (table, cb) ->
    finder = []
    model = models[table]

    for key of @belongsTo[table]
      finder.push @_data[key]

    model.find finder, (parent) ->
      cb(parent)

module.exports = Model
