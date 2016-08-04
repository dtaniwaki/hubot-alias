"use strict"

expect    = require("chai").expect
path      = require("path")
chai      = require("chai")
sinon     = require("sinon")
chai.use require("sinon-chai")

Robot       = require("hubot/src/robot")
TextMessage = require("hubot/src/message").TextMessage
process.env.HUBOT_LOG_LEVEL ||= 'error'

describe 'alias', ->
  robot = null
  user = null
  adapter = null

  beforeEach (done)->
    robot = new Robot(null, "mock-adapter", false, "hubot")

    robot.adapter.on "connected", ->
      robot.loadFile path.resolve('.', 'src', 'scripts'), 'alias.coffee'

      # load help scripts to test help messages
      hubotScripts = path.resolve 'node_modules', 'hubot', 'src', 'scripts'
      robot.loadFile hubotScripts, 'help.coffee'

      user = robot.brain.userForId '1', {
        name: 'dtaniwaki'
        room: '#mocha'
      }
      adapter = robot.adapter

      # Wait until hubot is ready
      waitForHelp = ->
        if robot.helpCommands().length > 0
          do done
        else
          setTimeout waitForHelp, 100
      do waitForHelp
    do robot.run

  afterEach ->
    do robot.shutdown
    do robot.server.close if robot.server
    process.removeAllListeners 'uncaughtException'

  sharedExample = (done, src, dst)->
    adapter.on "send", (envelope, strings)->
      return if strings[0].indexOf('I made an alias') == 0
      try
        expect(strings).to.have.length(1)
        expect(strings[0]).to.equal dst
        do done
      catch e
        done e
    adapter.receive new TextMessage(user, src)

  describe 'help', ->
    it 'has help messages', ->
      commands = robot.helpCommands()
      expect(commands).to.eql [
        "hubot alias clear - Clear the alias table",
        "hubot alias xxx= - Remove alias xxx for yyy",
        "hubot alias xxx=yyy - Make alias xxx for yyy",
        "hubot help - Displays all of the help commands that Hubot knows about.",
        "hubot help <query> - Displays all help commands that match <query>."
      ]

  describe 'receive hook', ->
    beforeEach ->
      robot.brain.get = -> {foo: 'goo', wow: 'super useful', alias: 'hacked', params: 'goo --name=$1 --message=$2', reverse_params: 'goo --name=$3 --message=$1'}

      # respond to all messages to check them
      robot.respond /(.*)$/i, (msg)->
        s = msg.match[1]
        msg.send s if s != 'alias'

    it 'replaces alias string', (done)->
      sharedExample done, 'hubot foo', 'goo'
    it 'does not replace front-matching string', (done)->
      sharedExample done, 'hubot foos', 'foos'
    it 'does not replace anything', (done)->
      sharedExample done, 'hubot bar', 'bar'

    context 'with placeholders', ->
      it 'replaces alias string', (done)->
        sharedExample done, 'hubot params john hello', 'goo --name=john --message=hello'
      it 'puts empties on unexisting string', (done)->
        sharedExample done, 'hubot params', 'goo --name= --message='
      it 'appends unused string', (done)->
        sharedExample done, 'hubot params john hello hey', 'goo --name=john --message=hello hey'

    context 'with placeholders in an alias action', ->
      it 'does not replace placeholders', (done)->
        sharedExample done, 'hubot alias command=something=$1', 'alias command=something=$1'
        
    context 'with reverse order placeholders', ->
      it 'replaces alias string', (done)->
        sharedExample done, 'hubot reverse_params john hello hey', 'goo --name=hey --message=john hello'
      it 'puts empties on unexisting string', (done)->
        sharedExample done, 'hubot reverse_params', 'goo --name= --message='
      it 'appends unused string', (done)->
        sharedExample done, 'hubot reverse_params john hello hey yay', 'goo --name=hey --message=john hello yay'

    context 'multiple words replace', ->
      it 'replaces alias string', (done)->
        sharedExample done, 'hubot wow', 'super useful'

    context 'with arguments', ->
      it 'replaces alias string', (done)->
        sharedExample done, 'hubot foo 1 2 3', 'goo 1 2 3'
      it 'does not replace anything', (done)->
        sharedExample done, 'hubot bar 1 2 3', 'bar 1 2 3'
      it 'does not replace the arguments', (done)->
        sharedExample done, 'hubot bar foo', 'bar foo'

    context 'reserved words', ->
      beforeEach ->
        robot.brain.get = -> {}

      it 'does not replace anything', (done)->
        sharedExample done, 'hubot alias', "Here you go.\n"

  describe 'respond alias', ->
    beforeEach ->
      @brainSetSpy = sinon.spy()
      robot.brain.get = -> {foo: 'goo', bar: 'par'}
      robot.brain.set = @brainSetSpy

    it 'shows alias table', (done)->
      adapter.on "send", (envelope, strings)->
        try
          expect(strings).to.have.length(1)
          expect(strings[0]).to.equal "Here you go.\nfoo : goo\nbar : par"
          do done
        catch e
          done e
      adapter.receive new TextMessage(user, "hubot alias")

    it 'clears alias table', (done)->
      adapter.on "send", (envelope, strings)->
        try
          expect(strings).to.have.length(1)
          expect(strings[0]).to.equal "I cleared the alias table."
          do done
        catch e
          done e
      adapter.receive new TextMessage(user, "hubot alias clear")
      expect(@brainSetSpy).to.have.been.calledWith sinon.match.string, {}

    it 'sets one word alias', (done)->
      adapter.on "send", (envelope, strings)->
        try
          expect(strings).to.have.length(1)
          expect(strings[0]).to.equal 'I made an alias wow for "useful".'
          do done
        catch e
          done e
      adapter.receive new TextMessage(user, "hubot alias wow=useful")
      expect(@brainSetSpy).to.have.been.calledWith sinon.match.string, {foo: 'goo', bar: 'par', wow: 'useful'}

    it 'sets multiple words alias', (done)->
      adapter.on "send", (envelope, strings)->
        try
          expect(strings).to.have.length(1)
          expect(strings[0]).to.equal 'I made an alias wow for "super useful".'
          do done
        catch e
          done e
      adapter.receive new TextMessage(user, "hubot alias wow=super useful")
      expect(@brainSetSpy).to.have.been.calledWith sinon.match.string, {foo: 'goo', bar: 'par', wow: 'super useful'}

    it 'sets multiple words alias name', (done)->
      adapter.on "send", (envelope, strings)->
        try
          expect(strings).to.have.length(1)
          expect(strings[0]).to.equal 'I made an alias foo bar for "cool".'
          do done
        catch e
          done e
      adapter.receive new TextMessage(user, "hubot alias foo bar=cool")
      expect(@brainSetSpy).to.have.been.calledWith sinon.match.string, {foo: 'goo', bar: 'par', 'foo bar': 'cool'}

    it 'removes an alias', (done)->
      adapter.on "send", (envelope, strings)->
        try
          expect(strings).to.have.length(1)
          expect(strings[0]).to.equal 'I removed the alias bar.'
          do done
        catch e
          done e
      adapter.receive new TextMessage(user, "hubot alias bar=")
      expect(@brainSetSpy).to.have.been.calledWith sinon.match.string, {foo: 'goo'}
