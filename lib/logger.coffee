winston = require 'winston'
conf = require './conf'

logglyOptions = conf.get 'loggly'

if logglyOptions
  Loggly = require('winston-loggly').Loggly
  winston.add Loggly, logglyOptions
  winston.remove winston.transports.Console

class Logger
  constructor: (label) ->
    @label = label
  info: (info,json) =>
    winston.info "#{@label} -> #{info}", json

module.exports = Logger
