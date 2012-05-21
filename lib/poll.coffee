# POLLS

#node.js dependencies
assert = require 'assert'
EventEmitter = require('events').EventEmitter

#app dependenices
mongoose = require './mongoose'

AnswerSchema = new mongoose.Schema (
  text: String
  count: {type: Number, default: 0}
)

PollSchema = new mongoose.Schema (
  question: String
  token: {type: String, unique: true}
  results: {
    answers: [AnswerSchema]
    total: {type: Number, default: 0}
  }
)

# Statics

PollSchema.statics.clearAll = (next) ->
  @remove {}, (err, docs) ->
    next()

PollSchema.statics.getAll = (next) ->
  @find {}, ['question', 'token'], (err, polls) ->
    next(polls)

PollSchema.statics.get = (token, next) ->
  @findOne {token: token}, (err, poll) ->
    if not err
      next(poll)

PollSchema.statics.create = (question, token) ->
  Poll = @

  createUniqueToken = (next) ->
    token = Math.random().toString(32).substr(2,4)
    Poll.findOne {token:token}, (err, poll) ->
      if poll is null
        next(token)
      else
        createUniqueToken(next)

  if not token
    createUniqueToken (token) ->
      poll = new Poll({token: token, question: question})
      poll.save () ->
        Poll.emit "created", {token: token, question: question}
  else
    poll = new Poll({token: token, question: question})
    poll.save () ->
      Poll.emit "created", {token: token, question: question}

PollSchema.statics.use = (app) ->
  app.on 'tweet/received', (tweet) ->
    assert.ok typeof tweet == "string", "#{tweet} should be a string"
    found = tweet.match(/apolloh\.com\/[a-z0-9]{4}\s/i)

    if found and found.length is 1
      token = found[0].trim().substr(-4)
      Poll.findOne {token:token}, (err, poll) ->
        if not err and poll
          poll.addTweet tweet, (answer) ->
            Poll.emit "answerAdded", {token: poll.token, answer: answer}
    else
      Poll.emit "unmatchedTweet", tweet


# Methods

PollSchema.methods._increaseTotal = (next) ->
  Poll.update {token:@token}, {$inc: {"results.total": 1}}, next

PollSchema.methods._increaseAnswerCount = (answer, next) ->
  Poll.update {token:@token, "results.answers.text":answer}, {$inc: {"results.answers.$.count": 1}}, (err)->
    next

PollSchema.methods._insertAnswer = (answer, next) ->
  Poll.update {token:@token}, {$push: {"results.answers": {text:answer}}}, next

PollSchema.methods.addTweet = (tweet, next) ->
  assert.ok typeof tweet == "string", "Poll.addTweet: #{tweet} is not a string"

  found = tweet.match(new RegExp(@question, 'i'))
  answer = tweet.substr(found.index + @question.length).trim()

  @_increaseTotal ()=>
    Poll.findOne {token:@token, "results.answers.text": answer}, (err, poll) =>
      if poll is null
        @_insertAnswer answer, ()=>
          @_increaseAnswerCount answer, next(answer)
      else
        @_increaseAnswerCount answer, next(answer)

Poll = mongoose.model 'Poll', PollSchema

# Listening on ..

# making the Poll class a static Event Emitter
Poll[k] = func for k, func of EventEmitter.prototype

module.exports = Poll