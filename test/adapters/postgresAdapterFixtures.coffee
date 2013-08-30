adapter = {}
order = []

dropTables = (done) ->
  adapter.query "DROP TABLE IF EXISTS person",
    success: (results) ->
      callNext(done)
  
createTables = (done) ->
  adapter.query "CREATE TABLE person (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    username VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL
    )",
    success: (results) ->
      callNext(done)

addRecords = (done) ->
  adapter.query "INSERT INTO person (
      name,
      username,
      email
    ) VALUES (
      'Brian Moore',
      'bmoore',
      'moore.brian.d@gmail.com'
    ), (
      'Joe Moore',
      'jmoore',
      'jmoore@mailinator.com'
    ), (
      'Lois Lane',
      'llane',
      'llane@mailinator.com'
    )",
      success: (results) ->
        callNext(done)

callNext = (done) ->
  if next = order.shift()
    next(done)
  else
    done()

module.exports = 
  bringUp: (asset, done) ->
    adapter = asset

    order = [
      dropTables,
      createTables,
      addRecords
    ]

    callNext(done)

  tearDown: (asset, done) ->
    adapter = asset

    order = [
      dropTables
    ]

    callNext(done)
