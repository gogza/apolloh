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

    @server.get '/whatsthisallabout', (req, res)->
      res.render 'whatsthisallabout'

    @server.get '/:token' , (req, res)->
      app.getPoll req.params.token, (poll)->
        res.render 'poll', {locals: {poll: poll}}

    @server.post "/admin/#{app.adminKey}/polls/add" , (req, res)->
      app.createNewPoll req.body.question, () ->
        res.redirect 'back'

    @server.get "/admin/#{app.adminKey}" , (req, res)->
      app.getFilter (filter)->
        app.getAllPolls (polls)->
          res.render 'admin', {locals: {
            polls:{polls}
            adminKey: app.adminKey
            filter: filter
          }}

    # start listening
    @server.listen port

module.exports = WebServer

