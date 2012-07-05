
# Node dependencies
assert = require 'assert'

# 3rd party dependencies
ntwitter = require 'ntwitter'

# application dependencies
conf = require './conf'

options = conf.get 'twitter'

twitter = new ntwitter(options)

liveStream = null

class Twitter
  @verify: ()->
    twitter.verifyCredentials () ->
      console.log arguments
  @track: (filterTerms, next) ->
    assert.ok filterTerms.length > 0, "Twitter.track: Filter Terms must have at least 1 character"

    # remove from filter
    #   apostrophes '
    #   dashes -
    #   exclamation marks !
    #   asterisk *
    #   open paren (
    #   close paren )
    #   open angle <
    #   close angle >

    filterTerms = filterTerms.replace(/[\'|\-|!|*|(|)|<|>]/g, " ");

    liveStream.destroy() if liveStream isnt null
    twitter.stream 'statuses/filter', {'track': filterTerms}, (stream)->
      liveStream = stream

      stream.on 'data', (data)->
        next(data)

    liveStream

module.exports = Twitter