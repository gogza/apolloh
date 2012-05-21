Apolloh = require "./lib/apolloh"

Apolloh.start(9100)

exports.app = Apolloh.server
exports.monitor = Apolloh.monitor