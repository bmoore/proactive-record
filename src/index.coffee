Model = require('./model')

class ProactiveRecord
  # Private Variables
  _ready = false
  _onReady = []

  # Initializer
  Model.parseSchema
    success: (schema) ->
      ready()

  # Public Methods
  @onReady: (cb) ->
    if _ready
      cb()
    else
      _onReady.push(cb)

  @load: (model, cb) ->
    @onReady () ->
      cb(Model.getModel(model))

  # Private methods
  ready = () ->
    _ready = true
    _onReady.forEach (cb) ->
      cb()

module.exports = ProactiveRecord
