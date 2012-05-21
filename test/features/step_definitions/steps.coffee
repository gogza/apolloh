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

  @Given /^there are (\d+) questions active$/, (noOfQuestions, next) ->
    noOfQuestions = parseInt(noOfQuestions,10)
    action = () -> Poll.create("this question")

    createdSoFar = 0

    Poll.on "created", (poll) ->
      createdSoFar++
      if createdSoFar == noOfQuestions
        next()
      else
        action()

    action()

  @Given /^there are these tweets stored$/, (table, next) ->

    tweets = ({text: tweet.tweets} for tweet in table.hashes())

    add = (tweet) ->
      Tweet.create(tweet)

    callback = () ->
      if tweets.length
        tweet = tweets.pop()
        add tweet
      else
        Poll.removeListener 'answerAdded', callback
        next()

    Poll.on 'answerAdded', callback

    add(tweets.pop())


  @Given /^I have the following polls$/, (table, next) ->
    polls = table.hashes()
    create = (poll) -> Poll.create(poll.question, poll.token)

    callback = (poll) ->
      if polls.length
        poll = polls.pop()
        create poll
      else
        Poll.removeListener "created", callback
        next()

    Poll.on "created", callback

    create(polls.pop())


  @When /^I visit the homepage$/, (next) ->
    @visit '/', next

#  @When /^a new tweet arrives$/, (next) ->
#    track.yield {text:'fake tweet'}
#    setTimeout next, timestep

  @When /^I visit the page for the poll "([^"]*)"$/, (token, next) ->
    @visit '/' + token, next

  @Given /^the following tweets arrive$/, (table, next) ->
    tweets = table.hashes()
#    console.log "tweets are starting to arrive"

    add = (tweet) ->
#      console.log "tweet is: #{tweet}"
      track.yield {text: tweet.tweets}

    callback = (answer) ->
#      console.log "answer #{answer} processed"
#      console.log "tweet length is: #{tweets.length}"
      if tweets.length
        tweet = tweets.pop()
        add tweet
      else
#        console.log "when does this happen?"
        Poll.removeListener "answerAdded", callback
        next()

    Poll.on "answerAdded", callback

#    console.log "listening for the the processed tweets"

    add(tweets.pop())

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
#    console.log @browser.html('table')
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
