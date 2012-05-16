assert = require 'assert'
events = require 'events'
Tweet = require './tweet'
Twitter = require './twitter'

class Monitor extends events.EventEmitter
  constructor: ()->
    @twitter = Twitter
  start: ->
#   @twitter.track 'Who will be second in the #sql next season?', (tweet) ->
    @twitter.track '#football', (tweet) ->
      assert.ok typeof tweet == "object", "Monitor: #{tweet} is not an object."
      Tweet.create tweet


module.exports = Monitor