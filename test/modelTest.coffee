chai = require('chai')
chai.should()

Model = require(process.cwd()+'/src/model')

# Used to test helper methods
describe 'Model', ->

  it 'should exist', ()->
    Model.should.equal Model
