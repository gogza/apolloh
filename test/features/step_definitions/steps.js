var sinon = require('sinon');

var Tweets = require('../../../lib/tweets');
var track;

var steps = module.exports = function () {
  this.World = require('../support/world');

  this.Before( function(next){
    if (!track) {
      track = track || sinon.stub(this.monitor.twitter, 'track');
      this.monitor.start();	
    }
    next();
  });

  this.After( function(next){
    next();
  });

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

  this.When(/^a new tweet arrives$/, function(callback) {
    track.yield({});
    callback();
  });

  this.When('I visit the page for "$pollCode"', function(pollCode, next) {
    this.visit('/' + pollCode, next);
  });

  this.Then(/^I should see (\d+) tweets$/, function(noOfTweets, next) {
    this.browser.queryAll('.tweet').length.should.eql(parseInt(noOfTweets,10));
    next();
  });

};