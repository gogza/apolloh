Feature: Monitors tweets about polls
  As visitor
  I want to see the number of tweets we have
  So that I can tell that this service does what it says it does

  @wip
  Scenario: Visiting the home page
    Given there are 2 questions active
    When I visit the homepage
    Then I should see the question list
    And the question list should have 2 links

  Scenario: A tweet arrives
    Given there are 2 tweets stored
    When a new tweet arrives
    And I visit the homepage
    Then I should see 3 tweets
