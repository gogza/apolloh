Feature: Monitors tweets about polls
  As visitor
  I want to see the number of tweets we have
  So that I can tell that this service does what it says it does

  Scenario: Visiting the home page
    Given there are 2 tweets stored
    When I visit the homepage
    Then I should see 2 tweets

  Scenario: A tweet arrives
    Given there are 2 tweets stored
    When a new tweet arrives
    And I visit the homepage
    Then I should see 3 tweets

  Scenario: Viewing the poll page
    Given there are 2 tweets stored
    When I visit the page for "a65x"
    Then I should see 2 tweets
