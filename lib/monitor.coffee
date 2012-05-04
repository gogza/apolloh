events = require 'events'
Tweets = require './tweets'

class Monitor extends events.EventEmitter
  constructor: ()->
    @twitter = {track: (searchTerms, next) -> }
  start: ->
    @twitter.track 'search for this', (tweet) ->
      Tweets.create()

module.exports = Monitor