util = require 'util'
sinon = require 'sinon'

Tweet = require '../../../lib/tweet'
Poll = require '../../../lib/poll'

track = null
timestep = 200

steps = module.exports = () ->
  @World = require '../support/world'

  @Before (next) ->
    Tweet.clearAll () =>
      Poll.clearAll () =>
        Poll.get () =>
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

#  @Given /^there are (\d+) tweets stored$/, (noOfTweets, next) ->
#    time = 0
#    action = () -> Tweet.create({text:'fake tweet'})
#    for i in [1..noOfTweets]
#      setTimeout action, time
#      time =+ timestep
#    setTimeout next, time + timestep

  @Given /^there are (\d+) questions active$/, (noOfQuestions, next) ->
    time = 0
    action = () -> Poll.create("this question")
    for i in [1..noOfQuestions]
      setTimeout action, time
      time =+ timestep
    setTimeout next, time + timestep

  @Given /^there are these tweets stored$/, (tweets, next) ->
    tweetObjects = ({text: tweet.tweets} for tweet in tweets.hashes())
    time = 0
    for tweet in tweetObjects
      do (tweet) ->
        action = () -> Tweet.create(tweet)
        setTimeout action, time
        time += timestep
    setTimeout next, time + timestep

  @When /^I visit the homepage$/, (next) ->
    @visit '/', next

  @When /^a new tweet arrives$/, (next) ->
    track.yield {text:'fake tweet'}
    setTimeout next, timestep

  @When 'I visit the page for the poll "$pollCode"', (pollCode, next) ->
    @visit '/' + pollCode, next

#  @Then /^I should see (\d+) tweets$/, (noOfTweets, next) ->
#    @browser.queryAll('.tweet').length.should.eql(parseInt(noOfTweets,10))
#    next()

  @Then /^a link to explain what apoll\-oh is about$/, (next) ->
    @browser.queryAll('a[href="/whatsthisallabout"]').should.not.be.empty
    next()

  @Then /^I should see a link to explain what apoll\-oh is about$/, (next) ->
    @browser.queryAll('a[href="/whatsthisallabout"]').should.not.be.empty
    next()

  @Then /^a link back to the home page$/, (next) ->
    @browser.queryAll('a[href="/"]').should.not.be.empty
    next()

  @Then /^a table for the results$/, (next) ->
    @browser.queryAll('#results table').should.not.be.empty
    next()

  @Then /^the question asked$/, (next) ->
    @browser.queryAll('#question').should.not.be.empty
    next()

  @Then /^a link to change the ordering of results$/, (next) ->
    @browser.queryAll('a#change-order').should.not.be.empty
    next()

  @Then /^I should see a total of (\d+) tweets in the results table$/, (tweetCount, next) ->
    @browser.text('#total').should.eql(tweetCount)
    next()

  @Then /^I should see (\d+) rows in the results table$/, (noOfTweets, next) ->
    @browser.queryAll('tbody tr').length.should.eql(parseInt(noOfTweets,10))
    next()

  @Then /^I should see a row for "([^"]*)"$/, (answer, next) ->
    @browser.queryAll('tr th:contains('+answer+')').should.not.be.empty
    next()

  @Then /^the row for "([^"]*)" should have a total of (\d+)$/, (answer, total, next) ->
    @browser.text('td[data-answer='+answer+']').should.eql(total)
    next()

  @Then /^I should see the question list$/, (next) ->
    @browser.queryAll('#questions ul').should.not.be.empty
    next()

  @Then /^the question list should have (\d+) links$/, (noOfLinks, next) ->
    @browser.queryAll('#questions ul li a').length.toString().should.eql(noOfLinks)
    next()
