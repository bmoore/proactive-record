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

    statement += " returning * "

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
      else if typeof finder is 'object'
        for key of finder
          select.where("#{key} = ?", finder[key])
      else
        select.where("#{params.primaryKey} = $1")
          .limit(1)
        options.values = [finder]

      statement = select.toString()

    @query(statement, options)

  update: (table, primaryKey, data, options) ->
    id = data[primaryKey]

    cols = []
    vals = []
    for col of data
      if col isnt primaryKey
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
    semaphore = {}
    models = {}
    constraints = {}

    semaphore.tables = false
    table_query = squel.select()
      .from('information_schema.tables')
      .where("table_schema = 'public'")
      .toString()
    @query table_query,
      success: (results) ->
        for row in results.rows
          models[row.table_name] = models[row.table_name] or {}
          models[row.table_name].table = {}

        semaphore.tables = true
        buildSchema()

    semaphore.columns = false
    columns_query = squel.select()
      .from('information_schema.columns')
      .where("table_schema = 'public'")
      .toString()
    @query columns_query,
      success: (results) ->
        for row in results.rows
          models[row.table_name] = models[row.table_name] or {}
          models[row.table_name].fields = models[row.table_name].fields or {}
          models[row.table_name].fields[row.column_name] = {}

        semaphore.columns = true
        buildSchema()

    semaphore.keys = false
    keys_query = squel.select()
      .from('information_schema.key_column_usage')
      .where("table_schema = 'public'")
      .toString()
    @query keys_query,
      success: (results) ->
        for row in results.rows
          constraints[row.constraint_name] = constraints[row.constraint_name] or {}
          constraints[row.constraint_name].table = row.table_name
          if row.constraint_name.search('pkey') isnt -1
            constraints[row.constraint_name].primaryKey = row.column_name
          else
            constraints[row.constraint_name].foreignKey = row.column_name

        semaphore.keys = true
        buildSchema()

    semaphore.constraints = false
    constraint_query = squel.select()
      .from('information_schema.constraint_column_usage')
      .where("table_schema = 'public'")
      .toString()
    @query constraint_query,
      success: (results) ->
        for row in results.rows
          constraints[row.constraint_name] = constraints[row.constraint_name] or {}
          constraints[row.constraint_name].reference = row.table_name
          constraints[row.constraint_name].column = row.column_name

        semaphore.constraints = true
        buildSchema()

    semaphore.tconstraints = false
    table_constraints = squel.select()
      .from('information_schema.table_constraints')
      .where("table_schema = 'public'")
      .toString()
    @query table_constraints,
      success: (results) ->
        semaphore.tconstraints = true
        buildSchema()

    buildSchema = () ->
      built = true;
      for part of semaphore
        if semaphore[part] is false
          built = false;

      if built is true
        options.success(
          models: models
          constraints: constraints
        )
        
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
