Tweets = require './tweets'

results = []
results.total = 0

Tweets.on 'received', (tweet) ->
  results.push tweet
  results.total += 1

class Polls
  @get: ()->
    {results: results}

module.exports = Polls