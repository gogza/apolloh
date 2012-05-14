# TWEETS


assert = require('assert')
EventEmitter = require('events').EventEmitter

mongoose = require 'mongoose'
mongoose.connect 'mongodb://127.0.0.1/apolloh'

schema = new mongoose.Schema (
  text: String
)

schema.statics[k] = func for k, func of EventEmitter.prototype

schema.statics.clearAll = (next) ->
  @remove {}, (err, docs) ->
    next()

schema.statics.create = (json)->
  Model = @
  assert.ok typeof json == 'object', "Tweets: #{json} is not an object."
  assert.ok typeof json.text == 'string', "Tweets: #{json.text} is not a string."

  tweet = new Model({text: json.text})
  tweet.save (e) ->
    if not e
      Model.emit 'received', tweet.text

schema.statics.getAll = (next)->
  @find {}, (err, docs) ->
    next(docs)

Tweet = mongoose.model 'Tweet', schema

# making the Tweets class an Event Emitter
Tweet[k] = func for k, func of EventEmitter.prototype

module.exports = Tweet