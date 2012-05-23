Feature: Looking at a Poll results page
  As visitor
  I want to see the results of a poll
  So I can see how the results are building

  Scenario: Visiting a poll page - sanity check
    Given I have the following polls
      | token | question            |
      | abcd  | Is this a question? |
    When I visit the page for the poll "abcd"
    Then I should see a link to explain what apoll-oh is about
    And a link back to the home page
    And a table for the results
    And the question asked
    And a link to change the ordering of results

  Scenario: There are some different tweets for a poll
    Given I have the following polls
      | token | question            |
      | abcd  | Is this a question? |
    And there are these tweets stored
      | tweets                                        |
      | apolloh.com/abcd Is this a question? #yes |
      | apolloh.com/abcd Is this a question? #no  |
    When I visit the page for the poll "abcd"
    Then I should see a total of 2 tweets in the results table
    And I should see 2 rows in the results table
    And I should see a row for "#yes"
    And the row for "#yes" should have a total of 1
    And I should see a row for "#no"
    And the row for "#no" should have a total of 1

  Scenario: There are some similar tweets for a poll
    Given I have the following polls
      | token | question            |
      | abcd  | Is this a question? |
    Given there are these tweets stored
      | tweets                                     |
      | apolloh.com/abcd Is this a question? #yes  |
      | apolloh.com/abcd Is this a question? #yes  |
    When I visit the page for the poll "abcd"
    Then I should see a total of 2 tweets in the results table
    And I should see 1 rows in the results table
    And I should see a row for "#yes"
    And the row for "#yes" should have a total of 2

  Scenario: Some more tweets arrive
    Given I have the following polls
      | token | question            |
      | abcd  | Is this a question? |
    And there are these tweets stored
      | tweets                                     |
      | apolloh.com/abcd Is this a question? #yes  |
      | apolloh.com/abcd Is this a question? #yes  |
    And the following tweets arrive
      | tweets                                     |
      | apolloh.com/abcd Is this a question? #yes  |
      | apolloh.com/abcd Is this a question? #no   |
    When I visit the page for the poll "abcd"
    Then I should see a total of 4 tweets in the results table
    And I should see 2 rows in the results table
    And I should see a row for "#yes"
    And the row for "#yes" should have a total of 3
    And I should see a row for "#no"
    And the row for "#no" should have a total of 1

