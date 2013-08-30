chai = require('chai')
chai.should()

ProactiveRecord = require(process.cwd()+'/src')

describe 'Proactive Base', ->
  it 'should have database', ->
    ProactiveRecord.db.exists
