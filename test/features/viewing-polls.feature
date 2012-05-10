Feature: Looking at a Poll results page
  As visitor
  I want to see the results of a poll
  So I can see how the results are building

  Scenario: Visiting a poll page - sanity check
    When I visit the page for the poll "a65x"
    Then I should see a link to explain what apoll-oh is about
    And a link back to the home page
    And a table for the results
    And the question asked
    And a link to change the ordering of results

  Scenario: There are some tweets for a poll
    Given there are 2 tweets stored
    When I visit the page for the poll "a65x"
    Then I should see a total of 2 tweets in the results table
    And I should see 2 rows in the results table

