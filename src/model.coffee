Database = require('./database')

class Model
  tableName: ''
  primaryKey: 'id'
  fields: {}
  db: {}

  initialize: () ->
    
    

  constructor: (data = {}) ->
    @_data = {}
    @_initData = data
    @_dirtyData = {}
    @_dirty = false
    @_new = true

    for field of @fields
      do (field) =>
        # Configure the getter/setters for the model fields
        Object.defineProperty @, field,
          get: -> @_data[field]
          set: (val) ->
            @_data[field] = val
            @_dirtyData[field] = val
            @_dirty = true

          enumerable: true
          configurable: true

      if @_initData[field]
        @_data[field] = @_initData[field]
      else
        @_data[field] = null

module.exports = Model
