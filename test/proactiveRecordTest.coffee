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

      it 'should be able to update', (done) ->
        ProactiveRecord.load 'person', (Person) ->
          Person.find 2, (p) ->
            p.name = 'Zoidberg'
            p.save
              success: () ->
                Person.find 2, (z) ->
                  z.name.should.equal 'Zoidberg'
                  done()

      it 'should be able to delete', (done) ->
        ProactiveRecord.load 'person', (Person) ->
          Person.find 3, (p) ->
            p.delete
              success: () ->
                Person.find 3, (z) ->
                  (z.id is null).should.equal true
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

      it 'should be able to read', (done) ->
        ProactiveRecord.load 'address', (Address) ->
          Address.find 1, (a) ->
            a.city.should.equal('Portsmouth')
            done()

      it 'should be able to update', (done) ->
        ProactiveRecord.load 'address', (Address) ->
          Address.find 2, (a) ->
            a.street = '21 Daniel St.'
            a.save
              success: () ->
                Address.find 2, (z) ->
                  z.street.should.equal '21 Daniel St.'
                  done()

      it 'should be able to delete', (done) ->
        ProactiveRecord.load 'address', (Address) ->
          Address.find 3, (a) ->
            a.delete
              success: () ->
                Address.find 3, (z) ->
                  (z.id is null).should.equal true
                  done()

    describe 'Rando Model', ->
      it 'should be able to create', (done) ->
        ProactiveRecord.load 'rando', (Rando) ->
          r = new Rando
            phrase: 'Testing a new phrase'

          r.save
            success: () ->
              (r.rando_id isnt null).should.equal true
              done()

      it 'should be able to read', (done) ->
        ProactiveRecord.load 'rando', (Rando) ->
          Rando.find 1, (r) ->
            r.phrase.should.equal('The Quick Brown Fox')
            done()

      it 'should be able to update', (done) ->
        ProactiveRecord.load 'rando', (Rando) ->
          Rando.find 2, (r) ->
            r.phrase = 'Follow the white rabbit'
            r.save
              success: () ->
                Rando.find 2, (z) ->
                  z.phrase.should.equal 'Follow the white rabbit'
                  done()

      it 'should be able to delete', (done) ->
        ProactiveRecord.load 'rando', (Rando) ->
          Rando.find 3, (r) ->
            r.delete
              success: () ->
                Rando.find 3, (z) ->
                  (z.rando_id is null).should.equal true
                  done()


  after (done) ->
    PostgresAdapterFixtures.tearDown done
