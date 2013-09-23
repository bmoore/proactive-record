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
        p = new Person
          name: 'Brian Moore'
          username: 'bmoore'
          email: 'moore.brian.d@gmail.com'

        p.email.should.equal 'moore.brian.d@gmail.com'

        done()

    it 'should have address model', (done) ->
      ProactiveRecord.load 'address', (Address) ->
        a = new Address
          street: '666 Main St.'
          city: 'Portsmouth'
          zipcode: '03801'

        a.city.should.equal 'Portsmouth'

        done()

    it 'should have rando model', (done) ->
      ProactiveRecord.load 'rando', (Rando) ->
        r = new Rando
          phrase: 'lol'

        r.phrase.should.equal 'lol'

        done()

    describe 'Person Model', ->
      it 'should be able to load', (done) ->
        ProactiveRecord.load 'person', (Person) ->
          Person.find 1, (p) ->
            p.name.should.equal('Brian Moore')
            done()

      it 'should be able to save', (done) ->
        ProactiveRecord.load 'person', (Person) ->
          p = new Person
            name: 'Brian Moore'
            username: 'bmoore'
            email: 'moore.brian.d@gmail.com'

          p.save()
          done()

    describe 'Address Model', ->
      it 'should be able to load', (done) ->
        ProactiveRecord.load 'address', (Address) ->
          Address.find 1, (a) ->
            a.city.should.equal('Portsmouth')
            done()

      it 'should be able to save', (done) ->
        ProactiveRecord.load 'address', (Address) ->
          a = new Address
            person_id: 1
            street: '1024 Main St.'
            city: 'Portsmouth'
            zipcode: '03801'

          a.save()
          done()


  after (done) ->
    PostgresAdapterFixtures.tearDown done
