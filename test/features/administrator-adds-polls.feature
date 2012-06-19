Feature: Adding new polls
  As an adminstrator
  I want to add polls
  So that I can keep the website fresh

  Scenario: Set up of monitor
    Given I have the following polls
      | token | question             |
      | abcd  | Is this a question?  |
      | bcde  | Was that a question? |
    Then apoll-oh! monitors for
      | question             |
      | Is this a question?  |
      | Was that a question? |

  Scenario: Visiting the admin page
    Given I have the following polls
      | token | question            |
      | abcd  | Is this a question? |
    When I visit the admin page
    Then I should see the question list
    And the question list should have 1 links
    And I should see the current filter
    And the current filters should include
      | question            |
      | Is this a question? |

  Scenario: Adding a new poll
    Given I have the following polls
      | token | question            |
      | abcd  | Is this a question? |
    When I visit the admin page
    And I add the following polls
      | question          |
      | What is this for? |
    Then I should see the question list
    And the question list should have 2 links
    Then apoll-oh! monitors for
      | question             |
      | Is this a question?  |
      | What is this for? |

