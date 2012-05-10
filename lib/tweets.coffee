EventEmitter = require('events').EventEmitter

tweets = []

class Tweets
  @clearAll: ()->
    tweets = []
  @create: ()->
    tweet = {}
    tweets.push tweet
    Tweets.emit 'received', tweet
  @getAll: ()->
    tweets

Tweets[k] = func for k, func of EventEmitter.prototype


module.exports = Tweets