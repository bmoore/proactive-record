chai = require('chai')
chai.should()

Database = require(process.cwd()+'/src/database')

describe 'Database', ->
  db = new Database({
    adapter: 'postgres'
    database: 'proactive'
    username: 'proactive'
    password: 'proactive'
    host: 'localhost'
  })

  it 'should have an adapter', ->
    db.adapter.connector.should.equal 'postgres://proactive:proactive@localhost/proactive'

  it 'should be able to read', (done) ->
    db.read 'SELECT * FROM information_schema.tables',
      'tables',
      {},
      success: (results) ->
        results.command.should.equal 'SELECT'
        done()
