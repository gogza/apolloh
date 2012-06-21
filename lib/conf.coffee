nconf = require 'nconf'

env = process.env.NODE_ENV
env = 'production' if not env

nconf.set 'env', env

path = "./config/#{env}.json"
nconf.file {file: path}

module.exports = nconf
