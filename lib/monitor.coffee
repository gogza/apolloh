assert = require 'assert'
events = require 'events'
Tweets = require './tweets'
Twitter = require './twitter'

class Monitor extends events.EventEmitter
  constructor: ()->
    @twitter = Twitter
  start: ->
    @twitter.track 'Who will be second in the #sql next season?', (tweet) ->
#    @twitter.track '#football', (tweet) ->
      assert.ok typeof tweet == "object", "Monitor: #{tweet} is not an object."
      Tweets.create tweet


module.exports = Monitor