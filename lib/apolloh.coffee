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
    Poll.getFilter (filter) ->
      if filter.length > 0
        monitor.watch filter
    server.start(port)
  @getAllPolls: (next)->
    Poll.getAll next
  @getPoll: (token, next)->
    Poll.get token, next
  @createNewPoll: (question, next)->
    Poll.create question, next
  @getFilter: (next) ->
    Poll.getFilter next
  @adminKey: '54gb'


# mixin static Event Emitter methods
Apolloh[k] = func for k, func of EventEmitter.prototype

# pushing dependency to other classes
Poll.use Apolloh
Tweet.use Apolloh
WebServer.use Apolloh

# Listening for ...

monitor.on "received", (tweet) ->
  Apolloh.emit "monitor/received", tweet

monitor.on "restarted", () ->
  Apolloh.emit "monitor/restarted"

Tweet.on "received", (tweet) ->
  Apolloh.emit "tweet/received", tweet

Poll.on "created", (poll) ->
  Apolloh.emit "poll/created", poll

Poll.on "created", (poll) ->
  Poll.getFilter (filter) ->
    monitor.watch filter

Poll.on "answerAdded", (answer) ->
  Apolloh.emit "poll/answerAdded", answer

Poll.on "unmatchedAnswer", (answer) ->
  Apolloh.emit "poll/unmatchedAnswer", answer


module.exports = Apolloh