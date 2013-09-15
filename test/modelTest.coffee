chai = require('chai')
chai.should()

Model = require(process.cwd()+'/src/model')

describe 'Model', ->

  it 'should initialize', ->
    Model.initialize().should.equal true
