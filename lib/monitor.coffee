events = require 'events'
Tweets = require './tweets'
Twitter = require './twitter'

class Monitor extends events.EventEmitter
  constructor: ()->
    @twitter = Twitter
  start: ->
    @twitter.track 'Who will be second in the #sql next season?', (tweet) ->
      Tweets.create()


module.exports = Monitor