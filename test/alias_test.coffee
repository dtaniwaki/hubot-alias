chai   = require 'chai'
sinon  = require 'sinon'
chai.use require 'sinon-chai'

expect = chai.expect

describe 'alias', ->
  beforeEach ->
    @robot =
      respond: sinon.spy()

    require('../src/alias')(@robot)

  it 'respond to a message', ->
    # TODO: Add tests

