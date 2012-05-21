# APOLLOH App

#node.js dependencies
assert = require 'assert'
EventEmitter = require('events').EventEmitter

#app dependencies
Monitor = require './monitor'
WebServer = require './server'
Tweet = require './tweet'
Poll = require './poll'

#creating external interfaces
monitor = new Monitor()
server = new WebServer()


class Apolloh
  @monitor: monitor # exposed for testing
  @server: server.server #exposed for testing
  @start: (port) ->
    monitor.start()
    server.start(port)
  @getAllPolls: (next)->
    Poll.getAll next
  @getPoll: (token, next)->
    Poll.get token, next

# mixin static Event Emitter methods
Apolloh[k] = func for k, func of EventEmitter.prototype

# pushing dependency to other classes
Poll.use Apolloh
Tweet.use Apolloh
WebServer.use Apolloh

# Listening for ...

monitor.on "received", (tweet) ->
  Apolloh.emit "monitor/received", tweet

Tweet.on "received", (tweet) ->
  Apolloh.emit "tweet/received", tweet

Poll.on "created", (poll) ->
  Apolloh.emit "poll/created", poll

Poll.on "answerAdded", (answer) ->
  Apolloh.emit "poll/answerAdded", answer

Poll.on "unmatchedAnswer", (answer) ->
  Apolloh.emit "poll/unmatchedAnswer", answer


module.exports = Apolloh