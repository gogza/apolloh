Feature: Looking at a Poll results page
  As visitor
  I want to see the results of a poll
  So that I can tell that this service does what it says it does

  Scenario: Visiting a poll page - sanity check
    When I visit the page for the poll "a65x"
    Then I should see a link to explain what apoll-oh is about
    And a link back to the home page
    And a table for the results
    And the question asked
    And a link to change the ordering of results
