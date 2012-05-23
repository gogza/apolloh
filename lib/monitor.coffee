#Monitor

#node.js dependencies
assert = require 'assert'
events = require 'events'

#libraries
Twitter = require './twitter'

class Monitor extends events.EventEmitter
  constructor: ()->
    @twitter = Twitter
  watch: (filter) ->
    assert.ok filter.length > 0, "Monitor.watch: filter must have at least 1 character"
    @twitter.track filter , (tweet) =>
      assert.ok typeof tweet == "object", "Monitor: #{tweet} is not an object."
      @emit "received", tweet
    @emit "restarted"


module.exports = Monitor