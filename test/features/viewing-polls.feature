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

  Scenario: There are some different tweets for a poll
    Given there are these tweets stored
      | tweets                                                         |
      | Who will win the #scottishpremierleague next season? #stmirren |
      | Who will win the #scottishpremierleague next season? #rangers  |
    When I visit the page for the poll "a65x"
    Then I should see a total of 2 tweets in the results table
    And I should see 2 rows in the results table
    And I should see a row for "#stmirren"
    And the row for "#stmirren" should have a total of 1
    And I should see a row for "#rangers"
    And the row for "#rangers" should have a total of 1

  Scenario: There are some similar tweets for a poll
    Given there are these tweets stored
      | tweets                                                         |
      | Who will win the #scottishpremierleague next season? #stmirren |
      | Who will win the #scottishpremierleague next season? #stmirren |
    When I visit the page for the poll "a65x"
    Then I should see a total of 2 tweets in the results table
    And I should see 1 rows in the results table
    And I should see a row for "#stmirren"
    And the row for "#stmirren" should have a total of 2
