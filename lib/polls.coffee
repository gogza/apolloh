Tweets = require './tweets'

question = 'Who will win the #scottishpremierleague next season?'

results = {
  answers: {}
  total: 0
}

Tweets.on 'received', (tweet) ->
  answer = tweet.replace(question, '').trim()
  if results.answers.hasOwnProperty(answer)
    results.answers[answer]++
  else
    results.answers[answer] = 1
  results.total++

class Polls
  @clearAll: () ->
    results = {
      answers: {}
      total: 0
    }

  @get: ()->
    {results: results}

module.exports = Polls