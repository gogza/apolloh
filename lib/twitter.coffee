
ntwitter = require 'ntwitter'

assert = require 'assert'

twitter = new ntwitter {
  consumer_key: 'kda1PId7EJVw65pGxBQXg'
  consumer_secret: '76TD1z1EVTGb6tWMmC8xCRb1uZQlPx4epuJuukQuuIE'
  access_token_key: '560439151-NFpf7NsZ9WzfHG0c0vDQIJ9il8rM0GWWeVLDv5SR'
  access_token_secret: 'fBrKlfQ6LECPsbPMN9B4PVFLt7ZRyHtG3OGyrtHio'
}

#    @twitter.verifyCredentials (err, data) ->
#      console.log data if data
#      console.log err if err

liveStream = null

class Twitter
  @verify: ()->
    twitter.verifyCredentials () ->
      console.log arguments
  @track: (filterTerms, next) ->
    assert.ok filterTerms.length > 0, "Twitter.track: Filter Terms must have at least 1 character"
    liveStream.destroy() if liveStream isnt null
    twitter.stream 'statuses/filter', {'track': filterTerms}, (stream)->
      liveStream = stream

      stream.on 'data', (data)->
        next(data)

      stream.on 'destroy', () ->
        console.log "destroyed"
        console.log arguments

    liveStream

module.exports = Twitter