#Monitor

#node.js dependencies
assert = require 'assert'
events = require 'events'

#libraries
Twitter = require './twitter'

#helpers

i = console.log


filter = ""
lastTrackStarted = null
aRestartIsScheduled = false

minutesAgo = (mins) ->
  date = new Date()
  date.setTime((new Date()).getTime() - (mins * 60 * 1000))
  date

nextTimeCanStart = (mins) ->
  date = new Date()
  date.setTime(lastTrackStarted.getTime() + (mins * 60 * 1000))
  date


class Monitor extends events.EventEmitter
  constructor: () ->
    @twitter = Twitter
    @timeout = 2
  watch: (newFilter) ->
    assert.ok newFilter.length > 0, "Monitor.watch: filter must have at least 1 character"

    filter = newFilter
    i "Monitor: storing the filter '#{filter}'"
    if (lastTrackStarted is null) or (lastTrackStarted < minutesAgo(@timeout))
       @track()
    else
      i "Monitor: can't restart now"
      if not aRestartIsScheduled
        periodUntilNextPossibleStart = nextTimeCanStart(@timeout) - (new Date())
        i "Monitor: will re-start in #{periodUntilNextPossibleStart/1000}s"
        scopedTrack = ()=> @track() # cos setTimeout switches to global scope
        setTimeout scopedTrack, periodUntilNextPossibleStart
        aRestartIsScheduled = true

  track: () ->
    i "Monitor: starting to track '#{filter}'"
    @twitter.track filter, (tweet) =>
      assert.ok typeof tweet == "object", "Monitor: #{tweet} is not an object."
      @emit "received", tweet
    lastTrackStarted = new Date()
    aRestartIsScheduled = false
    i "Monitor: tracking '#{filter}'"
    @emit "restarted", lastTrackStarted


module.exports = Monitor