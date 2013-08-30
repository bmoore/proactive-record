chai = require('chai')
chai.should()

PostgresAdapter = require(process.cwd()+'/src/adapters/postgres')
PostgresAdapterFixtures = require('./postgresAdapterFixtures')

describe 'PostgresAdapter', ->

  adapter = new PostgresAdapter({
    adapter: 'postgres'
    database: 'proactive'
    username: 'proactive'
    password: 'proactive'
    host: 'localhost'
  })

  before (done) ->
    PostgresAdapterFixtures.bringUp(adapter, done)

  it 'should be able to read query', (done) ->
    adapter.read 'SELECT * FROM information_schema.tables',
      'tables',
      {},
      success: (results) ->
        results.command.should.equal 'SELECT'
        done()

  it 'should be able to find 1', (done) ->
    adapter.read 1, 'person', {primaryKey: 'id'},
      success: (results) ->
        results.rowCount.should.equal 1
        results.rows[0].name.should.equal 'Brian Moore'
        done()

  it 'should be able to find many', (done) ->
    adapter.read [1, 2], 'person', {primaryKey: 'id'},
      success: (results) ->
        results.rowCount.should.equal 2
        results.rows[0].name.should.equal 'Brian Moore'
        results.rows[1].name.should.equal 'Joe Moore'
        done()

  it 'should be able to create', (done) ->
    data =
      name: 'John Doe'
      username: 'jdoe'
      email: 'jdoe@mailinator.com'

    adapter.create 'person', data,
      success: (results) ->
        results.command.should.equal 'INSERT'
        done()

  it 'should be able to update', (done) ->
    data =
      id: 3
      name: 'Lois Lane'
      username: 'lois'
      email: 'lois@mailinator.com'

    adapter.update 'person', 'id', data,
      success: (results) ->
        results.command.should.equal 'UPDATE'
        done()

  it 'should be able to delete', (done) ->
    adapter.delete 'person', 'id', 3,
      success: (results) ->
        results.command.should.equal 'DELETE'
        done()

  it 'should be able to read schema', (done) ->
    adapter.parseSchema
      success: (results) ->
        done()

  after (done) ->
    PostgresAdapterFixtures.tearDown(adapter, done)
