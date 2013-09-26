Model = require('./model')

class ProactiveRecord
  # Private Variables 
  _ready = false
  _onReady = []
  models = {}

  # Private Methods
  Model.parseSchema
    success: (schema) ->
      for table of schema.models
        models[table] = createModel(table, schema.models[table])

      ready()

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
