var express = require('express')

var server = express.createServer();

server.configure(function() {
  server.set('views', __dirname + '/views');
  server.set('view engine', 'jade');
});

server.get('/', function (req, res) {
  res.render('home');
});

server.listen(9100);
