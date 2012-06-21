Feature: Adding polls
  As visitor
  I want to add my own polls
  So that I can find out what other twitter users think

  Scenario: Add poll page sanity check
    When I visit page for adding polls
    Then I should see a form to fill in
    And I should see a create button

  @wip
  Scenario: Visitor adds a poll
    When I visit page for adding polls
    And I add the following polls
      | question                     |
      | What is the meaning of life? |
    Then I should see the question "What is the meaning of life?"
    And a table for the results