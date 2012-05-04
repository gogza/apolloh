events = require 'events'
Tweets = require './tweets'
Twitter = require './twitter'

class Monitor extends events.EventEmitter
  constructor: ()->
    @twitter = Twitter
  start: ->
    @twitter.track 'football', (tweet) ->
      Tweets.create()

module.exports = Monitor