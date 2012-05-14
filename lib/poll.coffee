# POLLS

assert = require 'assert'
mongoose = require 'mongoose'

Tweet = require './tweet'

mongoose.connect 'mongodb://127.0.0.1/apolloh'

question = 'Who will win the #scottishpremierleague next season?'
token = 'a65x'

AnswerSchema = new mongoose.Schema (
  text: String
  count: {type: Number, default: 0}
)

PollSchema = new mongoose.Schema (
  question: String
  token: String
  results: {
    answers: [AnswerSchema]
    total: {type: Number, default: 0}
  }
)

# Statics

PollSchema.statics.clearAll = (next) ->
  @remove {}, (err, docs) ->
    next()

PollSchema.statics.get = (next) ->
  Poll = @
  @findOne {token: token}, (err, poll) ->
    if not err
      if poll is null
        poll = new Poll({token: token, question: question})
        poll.save()
      next(poll)

# Methods

PollSchema.methods._increaseTotal = (next) ->
  Poll.update {token:token}, {$inc: {"results.total": 1}}, next

PollSchema.methods._increaseAnswerCount = (answer, next) ->
  Poll.update {token:token, "results.answers.text":answer}, {$inc: {"results.answers.$.count": 1}}, next

PollSchema.methods._insertAnswer = (answer, next) ->
  Poll.update {token:token}, {$push: {"results.answers": {text:answer}}}, next

PollSchema.methods.addTweet = (tweet, next) ->
  assert.ok typeof tweet == "string", "Poll.addTweet: #{tweet} is not a string"
  answer = tweet.replace(question, '').trim()

  @_increaseTotal ()=>
    Poll.findOne {token:token, "results.answers.text": answer}, (err, poll) =>
      if poll is null
        @_insertAnswer answer, ()=>
          @_increaseAnswerCount answer, next
      else
        @_increaseAnswerCount answer, next

Poll = mongoose.model 'Poll', PollSchema

Tweet.on 'received', (tweet) ->
  assert.ok typeof tweet == "string", "#{tweet} should be a string"

  Poll.findOne {}, (err, poll) ->
    poll.addTweet tweet, () ->
      true


module.exports = Poll