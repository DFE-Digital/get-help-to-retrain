Feature: As a user, I want to be able to search for jobs by title, so I can find an appropriate job

  Background:
    Given a job profile exists with the name "Construction manager"

  @ci @168
  Scenario: Transferable skills
    Given I am on the "task-list" page
    When I click on "Search for the types of jobs you could retrain to do"
    And I enter "Construction manager " in "search" field
    And I click the ".search-button" button
    Then I should see "Search results for"
