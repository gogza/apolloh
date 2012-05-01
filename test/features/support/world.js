var zombie = require('zombie');
var should = require('should');
var server = require('../../../apolloh');

var World = module.exports = function(callback) {
  this.browser = new zombie.Browser();

  this.page = function (path) {
    return "http://localhost:" + server.app.address().port + path;
  };

  this.visit = function(path,callback) {
    this.browser.visit(this.page(path), function(err,browser,status) {
      callback(err,browser,status);
    });
  };

  callback();
};