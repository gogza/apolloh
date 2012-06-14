Feature: Visting the home page
  As visitor
  I want to see the current state of affairs
  So that I can tell that this service does what it says it does

  Scenario: Home page sanity check
    When I visit the homepage
    Then I should see a link to explain what apoll-oh is about
    And I should see a link to create a new poll

  Scenario: Visiting the home page
    Given there are 2 questions active
    When I visit the homepage
    Then I should see the question list
    And the question list should have 2 links

  Scenario: Visiting the explantion page
    When I visit the explanation page
    Then I should see the page