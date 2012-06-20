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
    And the question displayed is "Is this a question?"

  Scenario: There are some different tweets for a poll
    Given I have the following polls
      | token | question            |
      | abcd  | Is this a question? |
    And there are these tweets stored
      | tweets                                 | links                   |
      | t.co/YbsHGvbH Is this a question? #yes | http://apolloh.com/abcd |
      | t.co/YbsHGvbH Is this a question? #no  | http://apolloh.com/abcd |
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
      | tweets                                 | links                   |
      | t.co/YbsHGvbH Is this a question? #yes | http://apolloh.com/abcd |
      | t.co/YbsHGvbH Is this a question? #yes | http://apolloh.com/abcd |
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
      | tweets                                 | links                   |
      | t.co/YbsHGvbH Is this a question? #yes | http://apolloh.com/abcd |
      | t.co/YbsHGvbH Is this a question? #yes | http://apolloh.com/abcd |
    And the following tweets arrive
      | tweets                                 | links                   |
      | t.co/YbsHGvbH Is this a question? #yes | http://apolloh.com/abcd |
      | Is this a question? #no                | http://nowhere.com/abcd |
      | t.co/YbsHGvbJ Is this a random tweet   | http://nowhere.com/abcd |
    When I visit the page for the poll "abcd"
    Then I should see a total of 4 tweets in the results table
    And I should see 2 rows in the results table
    And I should see a row for "#yes"
    And the row for "#yes" should have a total of 3
    And I should see a row for "#no"
    And the row for "#no" should have a total of 1

