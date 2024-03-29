#HTTP Server

#libraries
express = require 'express'

app = {}

# Helpers



# none

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
        res.render 'home', {locals: {
          title: 'apoll-oh!'
          polls:{polls}
          pageType:'home'
        }}

    @server.get '/whatsthisallabout', (req, res)->
      res.render 'whatsthisallabout', {locals: {
        title: "What's this all about?"
      }}

    @server.get '/polls/new', (req, res)->
      res.render 'polls/new', {locals: {
        title: "New question"
      }}

    @server.post '/polls/create', (req, res)->
      app.createNewPoll req.body.question, (token) ->
        res.redirect "/#{token}"

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
            title: "Metrics"
          }}

    @server.get /^\/[a-zA-Z0-9]{4}$/ , (req, res)->
      token = req.url.slice(1)
      app.getPoll token, (poll)->
        res.send 404 if poll is null
        res.render 'poll', {locals: {
          poll: poll
          title: poll.question
        }}


    # start listening
    @server.listen port

module.exports = WebServer

