#HTTP Server

#libraries
express = require 'express'

app = {}

class WebServer
  constructor: ()->
    server = express.createServer()

    server.configure ()->
      dirname = process.cwd()
      server.set 'views', dirname + '/views'
      server.set 'view engine', 'jade'

      server.use express.bodyParser()
      server.use express.methodOverride()
      server.use express.compiler({src: dirname + "/public", enable: ['less']})
      server.use server.router
      server.use(express.static(dirname + '/public'))

    @server = server

  @use: (apolloh) ->
    app = apolloh

  start: (port) ->

    # define routes
    @server.get '/', (req, res)->
      app.getAllPolls (polls)->
        res.render 'home', {locals: {polls:{polls}}}

    @server.get '/:token' , (req, res)->
      app.getPoll req.params.token, (poll)->
        res.render 'poll', {locals: {poll: poll}}

    # start listening
    @server.listen port

module.exports = WebServer

