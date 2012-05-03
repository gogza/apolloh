tweets = []

class Tweets
  @clearAll: ()->
  @create: ()->
    tweets.push {}
  @getAll: ()->
    tweets

module.exports = Tweets