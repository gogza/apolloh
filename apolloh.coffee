express = require 'express'
stylus = require 'stylus'
Tweet = require './lib/tweet'
Poll = require './lib/poll'
Monitor = require './lib/monitor'

monitor = new Monitor()
monitor.start()

server = express.createServer()

server.configure ()->
  server.set 'views', __dirname + '/views'
  server.set 'view engine', 'jade'

  server.use express.bodyParser()
  server.use express.methodOverride()
  server.use express.compiler({src: __dirname + "/public", enable: ['less']})
  server.use server.router
  server.use(express.static(__dirname + '/public'))

server.get '/', (req, res)->
  tweets = Tweet.getAll (tweets) ->
    res.render 'home', {locals: {tweets: tweets}}

server.get '/a65x', (req, res)->
  Poll.get (poll)->
    res.render 'poll', {locals: {poll: poll}}

server.listen 9100


exports.app = server
exports.monitor = monitor