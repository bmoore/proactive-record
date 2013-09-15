chai = require('chai')
chai.should()

Database = require(process.cwd()+'/src/database')
PostgresAdapterFixtures = require('./adapters/postgresAdapterFixtures')

describe 'Database', ->

  db = new Database({
    adapter: 'postgres'
    database: 'proactive'
    username: 'proactive'
    password: 'proactive'
    host: 'localhost'
  })

  before (done) ->
    PostgresAdapterFixtures.bringUp(db.adapter, done)

  it 'should have an adapter', ->
    db.adapter.connector.should.equal 'postgres://proactive:proactive@localhost/proactive'

  it 'should be able to create', (done) ->
    data =
      name: 'John Doe'
      username: 'jdoe'
      email: 'jdoe@mailinator.com'

    db.create 'person', data,
      success: (results) ->
        results.command.should.equal 'INSERT'
        done()

  it 'should be able to read', (done) ->
    db.read 1,
      'person',
      {primaryKey: 'id'},
      success: (results) ->
        results.command.should.equal("SELECT")
        done()

  it 'should be able to update', (done) ->
    data =
      id: 3
      name: 'Lois Lane'
      username: 'lois'
      email: 'lois@mailinator.com'

    db.update 'person', 'id', data,
      success: (results) ->
        results.command.should.equal 'UPDATE'
        done()

  it 'should be able to delete', (done) ->
    db.delete 'person', 'id', 3,
      success: (results) ->
        results.command.should.equal 'DELETE'
        done()

  it 'should be able to read schema', (done) ->
    db.parseSchema
      success: (models) ->
        done()

  after (done) ->
    PostgresAdapterFixtures.tearDown(db.adapter, done)
