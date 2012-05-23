Feature: Visting the home page
  As visitor
  I want to see the current state of affairs
  So that I can tell that this service does what it says it does

  Scenario: Visiting the home page
    Given there are 2 questions active
    When I visit the homepage
    Then I should see the question list
    And the question list should have 2 links

  @wip
  Scenario: Visiting the explantion page
    When I visit the explanation page
    Then I should see the page