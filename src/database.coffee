class Database
  constructor: (@config) ->
    adapter = require("./adapters/#{@config.adapter}")
    @adapter = new adapter(@config)

  read: (finder, table, params, options) ->
    success = options.success
    options.success = (results) ->
      if success
        success(results)

    error = options.error
    options.error = (err, query, options) ->
      if error
        error(err, query, otpions)

    @adapter(finder, table, params, options)

module.exports = Database
