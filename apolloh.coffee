express = require 'express'
stylus = require 'stylus'

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
  res.render 'home'

server.listen 9100
