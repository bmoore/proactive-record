class ProactiveRecord
  constructor: (config) ->
    Database = require('./database')
    @db = new Database(config)

config = require('./config')
module.exports = new ProactiveRecord(config)
