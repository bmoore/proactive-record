class Database
  constructor: (@config) ->
    adapter = require("./adapters/#{@config.adapter}")
    @adapter = new adapter(@config)

  create: (table, data, options) ->
    addCallbacks(options)
    @adapter.create(table, data, options)

  read: (finder, table, params, options) ->
    addCallbacks(options)
    @adapter.read(finder, table, params, options)

  update: (table, primaryKey, data, options) ->
    addCallbacks(options)
    @adapter.update(table, primaryKey, data, options)

  delete: (table, field, value, options) ->
    addCallbacks(options)
    @adapter.delete(table, field, value, options)

  parseSchema: (options) ->
    success = options.success
    options.success = (schema) ->
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

      if success
        success(schema)
    @adapter.parseSchema(options)

  addCallbacks = (options) ->
    success = options.success
    options.success = (results) ->
      success(results) if success

    error = options.error
    options.error = (err, query, options) ->
      console.log(err)
      error(err, query, otpions) if error

module.exports = Database
