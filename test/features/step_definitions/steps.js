var Tweets = require('../../../lib/tweets');

var steps = module.exports = function () {
  this.World = require('../support/world');

  this.Given(/^I am on the homepage$/, function(next) {
    this.visit('/', next);
  });

  this.Then(/^I should see "([^"]*)"$/, function(text, next) {
    this.browser.should.have.status(200);
    this.browser.text('body').should.include(text);
    next();
  });

  this.Given(/^there are (\d+) tweets stored$/, function(noOfTweets, next) {
    Tweets.clearAll();
    for(var i = 0; i < noOfTweets; i++) {
      Tweets.create();	
    }
    next();
  });

  this.When(/^I visit the homepage$/, function(next) {
    this.visit('/', next);
  });

  this.Then(/^I should see (\d+) tweets$/, function(noOfTweets, next) {
    this.browser.queryAll('.tweet').length.should.eql(parseInt(noOfTweets,10));
    next();
  });

};