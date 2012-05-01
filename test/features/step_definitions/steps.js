var steps = module.exports = function () {
  this.World = require('../support/world');

  this.Given(/^I am on the homepage$/, function(callback) {
    this.visit('/', callback);
  });

  this.Then(/^I should see "([^"]*)"$/, function(text, callback) {
    this.browser.should.have.status(200);
    this.browser.text('body').should.include(text);
    callback();
  });

};