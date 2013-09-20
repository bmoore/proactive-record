Model = require('./model')

class ProactiveRecord
  # Private Variables 
  _ready = false
  _onReady = []
  models = {}

  # Private Methods
  Model.db.parseSchema
    success: (schema) ->
      for table of schema.models
        models[table] = createModel(table, schema.models[table])

      ready()

  createModel = (table, model) ->
    class tmpModel extends Model
      table: table
      primaryKey: 'id'
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
