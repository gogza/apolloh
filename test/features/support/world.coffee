zombie = require 'zombie'
should = require 'should'
server = require '../../../apolloh'

World = module.exports = (next) ->
  @browser = new zombie.Browser()

  @page = (path) ->
    "http://localhost:" + server.app.address().port + path

  @visit = (path,next) ->
    @browser.visit this.page(path), (err,browser,status) ->
      next(err,browser,status)

  @monitor = server.monitor

  next()