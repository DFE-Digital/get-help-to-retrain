Feature: TBD

  Background:
    Given a job profile exists for a Construction manager

  @ci
  Scenario: Transferable skills
    Given I am on the homepage
    When I click on "Start now"
    And I click on "Search for the types of jobs you could retrain to do"
    And I enter "Construction manager" in "name" field
    And I click the ".search-button" button
    Then I should see "Search results for"
    And I click on "Construction manager"
    Then I should see "Construction manager"
    And I should see "Average Salary"
    And I should see "Typical hours"
    And I should see "You could work"
