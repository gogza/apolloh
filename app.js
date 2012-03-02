var express = require('express')

var server = express.createServer();

server.get('/', function (req, res) {
  res.send('hello world');
});

server.listen(9100);
