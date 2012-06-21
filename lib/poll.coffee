# POLLS

# node.js dependencies
assert = require 'assert'
EventEmitter = require('events').EventEmitter
winston = require 'winston'

# app dependenices
mongoose = require './mongoose'
Logger = require "./logger"

# helpers
logger = new Logger("Poll")
i = logger.info

Poll = null

AnswerSchema = new mongoose.Schema (
  text: String
  tweets: [Object]
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

PollSchema.statics.create = (question, token, next) ->

  if typeof token == "function"
   next = token
   token = undefined

  if next is undefined then next = ()-> 1

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
        next(token)
  else
    poll = new Poll({token: token, question: question})
    poll.save () ->
      Poll.emit "created", {token: token, question: question}
      next(token)

PollSchema.statics.getFilter = (next) ->
  @find {}, ['question'], (err, polls) ->
    filter = (poll.question for poll in polls).join(',')
    next(filter)


tryExtractingFromUrl = (tweet) ->
  token = null

  matchingUrls = (url.expanded_url for url in tweet.entities.urls when url.expanded_url.match(/http:\/\/apolloh\.com\/[a-z0-9]{4}/i))

  if matchingUrls.length is 1
    token = matchingUrls[0].trim().substr(-4)
    i "Matched tweet by url", {token:token}
  token

tryExtractingFromText = (tweet, next) ->
  Poll.find {}, ['question', 'token'], (err, polls) ->
    matchingQuestions = (poll.token for poll in polls when tweet.text.indexOf(poll.question) isnt -1)
    if matchingQuestions.length is 1
      token = matchingQuestions[0]
      i "Matched tweet by text", {token:token}
      next token
    else
      next null

extractToken = (tweet, next) ->
  token = null
  token = tryExtractingFromUrl(tweet)
  if token
    next(token)
    return
  tryExtractingFromText(tweet,next)


PollSchema.statics.use = (app) ->
  app.on 'monitor/received', (tweet) ->
    i "Received tweet", {text:tweet.text}
    assert.ok typeof tweet == "object", "#{tweet} should be an object"

    extractToken tweet, (token) ->
      if token
        i "Found token", {token:token}
        Poll.findOne {token:token}, (err, poll) ->
          if not err and poll
            i "Found poll", {token:token}
            poll.addTweet tweet.text, (answer) ->
              Poll.emit "answerAdded", {token: poll.token, answer: answer}
      else
        i "Unmatched tweet", {text:tweet.text}
        Poll.emit "unmatchedTweet", tweet.text


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

#Virtuals

PollSchema.virtual('tweet').get () ->
  "apolloh.com/#{@token} #{@question}"

Poll = mongoose.model 'Poll', PollSchema

# Listening on ...
#
# Nothing

# making the Poll class a static Event Emitter
Poll[k] = func for k, func of EventEmitter.prototype

module.exports = Poll