sinon = require 'sinon'

Tweets = require '../../../lib/tweets'
track = null

steps = module.exports = () ->
  @World = require '../support/world'

  @Before (next) ->
    if not track
      track = sinon.stub @monitor.twitter, 'track'
      @monitor.start()
    next()

  @After (next) ->
    next()

  @Given /^I am on the homepage$/, (next) ->
    @visit '/', next

  @Then /^I should see "([^"]*)"$/, (text, next) ->
    this.browser.should.have.status 200
    this.browser.text('body').should.include text
    next()

  @Given /^there are (\d+) tweets stored$/, (noOfTweets, next) ->
    Tweets.clearAll()
    Tweets.create() for i in [1..2]
    next()

  @When /^I visit the homepage$/, (next) ->
    @visit '/', next

  @When /^a new tweet arrives$/, (callback) ->
    track.yield {}
    callback()

  @When 'I visit the page for "$pollCode"', (pollCode, next) ->
    @visit '/' + pollCode, next

  @Then /^I should see (\d+) tweets$/, (noOfTweets, next) ->
    @browser.queryAll('.tweet').length.should.eql(parseInt(noOfTweets,10))
    next()

  @Then /^a link to explain what apoll\-oh is about$/, (next) ->
    @browser.queryAll('a[href="/whatsthisallabout"]').length.should.be.above(0)
    next()
