tweets = []

class Tweets
  @clearAll: ()->
    tweets = []
  @create: ()->
    tweets.push {}
  @getAll: ()->
    tweets

module.exports = Tweets