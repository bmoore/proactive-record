chai = require('chai')
chai.should()

Model = require(process.cwd()+'/src/model')

describe 'Model', ->

  it 'should initialize', ->
    'lol'.should.equal 'lol'
