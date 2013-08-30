pg = require('pg')
squel = require('squel')

md5 = (str) ->
  require('crypto').createHash('md5').update(str).digest('hex')

class PostgresAdapter
  constructor: (@config) ->
    @connector = "#{@config.adapter}://#{@config.username}:#{@config.password}@#{@config.host}/#{@config.database}"

  create: (table, data, options) ->
    cols = []
    vals = []
    for col of data
      cols.push col
      vals.push data[col]

    insert = squel.insert(usingValuePlaceholders: true)
      .into(table)

    insert.set(cols[i], "$#{i+1}") for i in [0...cols.length]
    statement = insert.toString()

    options.values = vals

    @query(statement, options)

  read: (finder, table, params, options) ->
    # finder is query
    if typeof finder is 'string' and finder.match(/^select/i)?
      statement = finder
    else
      select = squel.select(usingValuePlaceholders: true)
        .from(table)
      if Array.isArray finder
        select.where("#{params.primaryKey} IN ?", finder)
      else
        select.where("#{params.primaryKey} = $1")
          .limit(1)
        options.values = [finder]

      statement = select.toString()

    @query(statement, options)

  update: (table, primaryKey, data, options) ->
    id = data[primaryKey]
    delete data[primaryKey]

    cols = []
    vals = []
    for col of data
      cols.push col
      vals.push data[col]

    update = squel.update(usingValuePlaceholders: true)
      .table(table)

    update.set(cols[i], "$#{i+1}") for i in [0...cols.length]

    update.where("#{primaryKey} = $#{i+1}")
    statement = update.toString()

    options.values = vals
    options.values.push(id)

    @query(statement, options)

  delete: (table, field, value, options) ->
    del = squel.delete(usingValuePlaceholders: true)
      .from(table)
      .where("#{field} = $1")

    del.limit(options.limit) if options.limit?

    statement = del.toString()

    options.values = [value]

    @query(statement, options)

  parseSchema: (options) ->
    table_query = squel.select()
      .from('information_schema.tables')
      .where("table_schema = 'public'")
      .toString()
    @query table_query,
      success: (results) ->
        console.log(results.rows)
        tables = results.rows

        options.success({})

    columns_query = squel.select()
      .from('information_schema.columns')
      .where("table_schema = 'public'")
      .toString()
    @query columns_query,
      success: (results) ->
        console.log(results.rows)

    keys_query = squel.select()
      .from('information_schema.key_column_usage')
      .where("table_schema = 'public'")
      .toString()
    @query keys_query,
      success: (results) ->
        console.log(results.rows)

    constraint_query = squel.select()
      .from('information_schema.constraint_column_usage')
      .where("table_schema = 'public'")
      .toString()
    @query constraint_query,
      success: (results) ->
        console.log(results.rows)

    table_constraints = squel.select()
      .from('information_schema.table_constraints')
      .where("table_schema = 'public'")
      .toString()
    @query table_constraints,
      success: (results) ->
        console.log(results.rows)

  query: (query, options) ->
    throw "query must be string" unless typeof query is 'string'
    statement =
      text: query
      name: md5(query)
      values: options.values ? []

    pg.connect @connector, (err, client ,done) ->
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
