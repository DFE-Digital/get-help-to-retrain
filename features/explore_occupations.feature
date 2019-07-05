Feature: As a user, I want to be able to search for jobs by title, so I can find an appropriate job

  Background:
    Given a job profile exists for a Construction manager

  @wip @168
  Scenario: Transferable skills
    Given I am on the "task_list" page
    When I click on "Search for the types of jobs you could retrain to do"
    And I enter "Construction manager " in "name" field
    And I click the ".search-button" button
    Then I should see "Search results for"
