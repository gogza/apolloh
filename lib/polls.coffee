Tweets = require './tweets'

class Polls
  @get: ()->
    {results: {total: Tweets.getAll().length}}

module.exports = Polls