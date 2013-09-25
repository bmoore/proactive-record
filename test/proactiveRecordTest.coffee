util = require('util')
chai = require('chai')
chai.should()

ProactiveRecord = {}
PostgresAdapterFixtures = require('./adapters/postgresAdapterFixtures')

describe 'ProactiveRecord', ->

  before (done) ->
    PostgresAdapterFixtures.bringUp () ->
      ProactiveRecord = require(process.cwd()+'/src/index')
      done()

  it 'should initialize', (done) ->
    ProactiveRecord.onReady () ->
      done()

  describe 'Models', ->
    it 'should have person model', (done) ->
      ProactiveRecord.load 'person', (Person) ->
        Person.prototype.table.should.equal 'person'
        done()

    it 'should have address model', (done) ->
      ProactiveRecord.load 'address', (Address) ->
        Address.prototype.table.should.equal 'address'
        done()

    it 'should have rando model', (done) ->
      ProactiveRecord.load 'rando', (Rando) ->
        Rando.prototype.table.should.equal 'rando'
        done()

    describe 'Person Model', ->
      it 'should be able to create', (done) ->
        ProactiveRecord.load 'person', (Person) ->
          p = new Person
            name: 'Brian Moore'
            username: 'bmoore'
            email: 'moore.brian.d@gmail.com'

          p.save
            success: () ->
              (p.id isnt null).should.equal true
              done()

      it 'should be able to read', (done) ->
        ProactiveRecord.load 'person', (Person) ->
          Person.find 1, (p) ->
            p.name.should.equal('Brian Moore')
            done()


    describe 'Address Model', ->
      it 'should be able to create', (done) ->
        ProactiveRecord.load 'address', (Address) ->
          a = new Address
            person_id: 1
            street: '1024 Main St.'
            city: 'Portsmouth'
            zipcode: '03801'

          a.save
            success: () ->
              (a.id isnt null).should.equal true
              done()

      it 'should be able to load', (done) ->
        ProactiveRecord.load 'address', (Address) ->
          Address.find 1, (a) ->
            a.city.should.equal('Portsmouth')
            done()

    describe 'Rando Model', ->
      it 'should be able to create', (done) ->
        ProactiveRecord.load 'rando', (Rando) ->
          r = new Rando
            person_id: 1
            street: '1024 Main St.'
            city: 'Portsmouth'
            zipcode: '03801'

          r.save
            success: () ->
              (r.rando_id isnt null).should.equal true
              done()

      it 'should be able to load', (done) ->
        ProactiveRecord.load 'rando', (Rando) ->
          Rando.find 1, (r) ->
            r.phrase.should.equal('The Quick Brown Fox')
            done()


  after (done) ->
    PostgresAdapterFixtures.tearDown done
