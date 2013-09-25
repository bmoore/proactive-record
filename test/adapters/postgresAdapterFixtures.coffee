PostgresAdapter = require(process.cwd()+'/src/adapters/postgres')
adapter = new PostgresAdapter({
  adapter: 'postgres'
  database: 'proactive'
  username: 'proactive'
  password: 'proactive'
  host: 'localhost'
})

order = []

dropTables = (done) ->
  adapter.query "DROP TABLE IF EXISTS address",
    success: (results) ->
      adapter.query "DROP TABLE IF EXISTS person",
        success: (results) ->
          adapter.query "DROP TABLE IF EXISTS rando",
            success: (results) ->
              callNext(done)
        error: (err) ->
          console.log(err)
          process.exit(1)
    error: (err) ->
      console.log(err)
      process.exit(1)
  
createTables = (done) ->
  adapter.query "CREATE TABLE person (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    username VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL
    )",
    success: (results) ->
      adapter.query "CREATE TABLE address (
        id SERIAL PRIMARY KEY,
        person_id INTEGER NOT NULL,
        street VARCHAR(255) NOT NULL,
        city VARCHAR(255) NOT NULL,
        zipcode VARCHAR(10) NOT NULL,
        FOREIGN KEY (person_id) REFERENCES person(id)
        )",
        success: (results) ->
          adapter.query "CREATE TABLE rando (
            rando_id SERIAL PRIMARY KEY,
            phrase VARCHAR(255)
            )",
            success: (results) ->
              callNext(done)
            error: (err) ->
              console.log(err)
              process.exit(1)
        error: (err) ->
          console.log(err)
          process.exit(1)
    error: (err) ->
      console.log(err)
      process.exit(1)

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
      adapter.query "INSERT INTO rando (
          phrase
        ) VALUES (
          'The Quick Brown Fox'
        ), (
          '12345.6789'
        ), (
          '(function() { console.log(this); })()'
        )",
        success: (results) ->
          adapter.query "INSERT INTO address (
              person_id,
              street,
              city,
              zipcode
            ) VALUES (
              '1',
              '666 Main St.',
              'Portsmouth',
              '03801'
            )",
            success: (results) ->
              callNext(done)
            error: (err) ->
              console.log(err)
              process.exit(1)
        error: (err) ->
          console.log(err)
          process.exit(1)
    error: (err) ->
      console.log(err)
      process.exit(1)

callNext = (done) ->
  if next = order.shift()
    next(done)
  else
    done()

module.exports = 
  bringUp: (done) ->
    order = [
      dropTables,
      createTables,
      addRecords
    ]

    callNext(done)

  tearDown: (done) ->
    order = [
      dropTables
    ]

    callNext(done)
