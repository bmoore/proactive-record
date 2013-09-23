Model = require('./model')

class ProactiveRecord
  # Private Variables 
  _ready = false
  _onReady = []
  models = {}

  # Private Methods
  Model.db.parseSchema
    success: (schema) ->
      for key of schema.constraints
        key = schema.constraints[key]

        if key.primaryKey
          schema.models[key.table].primaryKey = key.primaryKey

        if key.table isnt key.reference
          if key.foreignKey isnt key.column
            schema.models[key.table].belongsTo = schema.models[key.table].belongsTo or {}
            schema.models[key.table].belongsTo[key.reference] = schema.models[key.table].belongsTo[key.reference] || {}
            schema.models[key.table].belongsTo[key.reference][key.foreignKey] = key.column

            schema.models[key.reference].hasMany = schema.models[key.reference].hasMany or {}
            schema.models[key.reference].hasMany[key.table] = schema.models[key.reference].hasMany[key.table] or {}
            schema.models[key.reference].hasMany[key.table][key.column] = key.foreignKey

      for table of schema.models
        models[table] = createModel(table, schema.models[table])

      ready()

  createModel = (table, model) ->
    class tmpModel extends Model
      table: table
      primaryKey: model.primaryKey
      fields: model.fields

      constructor: (obj) ->
        obj = {} unless obj
        for field of @fields
          @[field] = obj[field] || null

    return tmpModel

  @onReady: (cb) ->
    if _ready
      cb()
    else
      _onReady.push(cb)

  @load: (model, cb) ->
    @onReady () ->
      cb(models[model])
      

  # Private methods
  ready = () ->
    _ready = true
    _onReady.forEach (cb) ->
      cb()

module.exports = ProactiveRecord
