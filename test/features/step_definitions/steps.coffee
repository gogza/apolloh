util = require 'util'
sinon = require 'sinon'

Tweet = require '../../../lib/tweet'
Poll = require '../../../lib/poll'

track = null

l = console.log

asyncAdd = (ListenOn, event, items, next, add) ->
  callback = ()->
    if items.length
      add(items.pop())
    else
      ListenOn.removeListener event, callback
      next()

  ListenOn.on event, callback

  add(items.pop())


steps = module.exports = () ->
  @World = require '../support/world'

  @Before (next) ->
    Tweet.clearAll () =>
      Poll.clearAll () =>
        track = sinon.stub @monitor.twitter, 'track'
        next()

  @After (next) ->
    track.restore()
    next()

  @Given /^I am on the homepage$/, (next) ->
    @visit '/', next

  @Then /^I should see "([^"]*)"$/, (text, next) ->
    this.browser.should.have.status 200
    this.browser.text('body').should.include text
    next()

  @Given /^there are (\d+) questions active$/, (noOfQuestions, next) ->
    noOfQuestions = parseInt(noOfQuestions,10)

    questions = ('this question' for i in [1..noOfQuestions])

    asyncAdd Poll, 'created', questions, next, (question) ->
      Poll.create question

  @Given /^there are these tweets stored$/, (table, next) ->

    tweets = ({text: tweet.tweets} for tweet in table.hashes())

    asyncAdd Poll, 'answerAdded', tweets, next, (tweet) ->
      Tweet.create(tweet)


  @Given /^I have the following polls$/, (table, next) ->
    polls = table.hashes()

    asyncAdd @monitor, 'restarted', polls, next, (poll) ->
      Poll.create(poll.question, poll.token)

  @When /^I visit the homepage$/, (next) ->
    @visit '/', next

  @When /^I visit the page for the poll "([^"]*)"$/, (token, next) ->
    @visit '/' + token, next

  @When /^the following tweets arrive$/, (table, next) ->
    tweets = ({text:hash.tweets} for hash in table.hashes())

    asyncAdd Poll, 'answerAdded', tweets, next, (tweet) ->
      track.yield tweet

  @When /^I visit the admin page$/, (next) ->
    @visit '/admin/54gb', next

  @When /^I add the following polls$/, (table, next) ->
    questions = (hash.question for hash in table.hashes())

    numberOfQuestions = questions.length
    formsFilledIn = 0
    serverFinished = false

    clientFinished = () ->
      formsFilledIn is numberOfQuestions

    theServerIsFinished = () ->
      serverFinished = true
      checkIfBothComplete()

    checkIfBothComplete = ()->
      next() if clientFinished() and serverFinished

    submittedFormOnClient = () ->
      formsFilledIn++
      checkIfBothComplete() if clientFinished()

    asyncAdd Poll, 'created', questions, theServerIsFinished, (question) =>
      @browser.fill("#question-text", question).pressButton("#create", submittedFormOnClient)

  @When /^I visit the explanation page$/, (next) ->
    @visit '/whatsthisallabout', next

  @When /^I visit page for adding polls$/, (next) ->
    @visit '/polls/new', next

  @Then /^I should see the page$/, (next) ->
    @browser.text('body').should.include("What's this all about?")
    next()

  @Then /^a link to explain what apoll\-oh is about$/, (next) ->
    @browser.queryAll('a[href="/whatsthisallabout"]').should.not.be.empty
    next()

  @Then /^I should see a link to explain what apoll\-oh is about$/, (next) ->
    @browser.queryAll('a[href="/whatsthisallabout"]').should.not.be.empty
    next()

  @Then /^I should see a link to create a new poll$/, (next) ->
    @browser.queryAll('a[href="/polls/new"]').should.not.be.empty
    next()

  @Then /^a link back to the home page$/, (next) ->
    @browser.queryAll('a[href="/"]').should.not.be.empty
    next()

  @Then /^a table for the results$/, (next) ->
    @browser.queryAll('#results table').should.not.be.empty
    next()

  @Then /^the question displayed is "([^"]*)"$/, (question, next) ->
    @browser.text('header h1').should.include(question)
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

  @Then /^apoll\-oh! monitors for$/, (table, next) ->
    texts = (hash.question for hash in table.hashes())
    try
      track.lastCall.args[0].should.include(text) for text in texts
    catch e
      l track.lastCall.args[0]
      throw e
    next()

  @Then /^I should see the current filter$/, (next) ->
    @browser.queryAll('#filter').should.not.be.empty
    next()

  @Then /^the current filters should include$/, (table, next) ->
    texts = (hash.question for hash in table.hashes())
    filter = @browser.text('#filter')
    filter.should.include(text) for text in texts
    next()

  @Then /^I should see a form to fill in$/, (next)->
    @browser.queryAll('form#add-question').should.not.be.empty
    next()

  @Then /^I should see a create button$/, (next) ->
    @browser.queryAll('form#add-question input[type="submit"][value="Create"]').should.not.be.empty
    next()

  @Then /^I should see the question "([^"]*)"$/, (question, next) ->
    @browser.text('header.bar').should.include(question)
    next()



