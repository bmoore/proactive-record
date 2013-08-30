pg = require('pg')

md5 = (str) ->
  require('crypto').createHash('md5').update(str).digest('hex')

class PostgresAdapter
  constructor: (@config) ->
    @connector = "#{@config.adapter}://#{@config.username}:#{@config.password}@#{@config.host}/#{@config.database}"

  create: () ->

  read: (finder, table, params, options) ->
    # finder is query
    if typeof finder is 'string' and finder.match(/select/i)?
      statement = finder
    else
      statement = "SELECT * FROM #{table}"

    # finder is array
    if Array.isArray finder
      statement = ""
    # finder is object
    # finder is value

  update: () ->

  delete: () ->

  query: (query, options) ->
    throw "query must be string" unless typeof query is 'string'
    statement =
      text: query
      name: md5(query)
      values: options.values ? []

    Pg.connect @connString(), (err, client ,done) ->
      throw err if err?
      query = client.query(statement)

      query.on 'error', (err) ->
        options.error(err, statement, options)

      query.on 'row', (row, result) ->
        result.addRow(row)
        options.onRow(row) if options.onRow?

      query.on 'end', (result) ->
        options.success(result)
        done()

module.exports = PostgresAdapter
