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
    addCallbacks(options)
    @adapter.parseSchema(options)

  addCallbacks = (options) ->
    success = options.success
    options.success = (results) ->
      if success
        success(results)

    error = options.error
    options.error = (err, query, options) ->
      if error
        error(err, query, otpions)

module.exports = Database
