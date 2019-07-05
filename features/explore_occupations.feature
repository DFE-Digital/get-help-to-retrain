Feature: As a user, I want to be able to search for jobs by title, so I can find an appropriate job

  Background:
    Given a job profile exists for a Construction manager

  @ci @160
  Scenario: Transferable skills
    Given I am on the 'task_list' page
    When I click on "Search for the types of jobs you could retrain to do"
    And I enter "Construction manager" in "name" field
    And I click the ".search-button" button
    Then I should see "Search results for"
    And I should see "Select a role from the results below to find out what it involves, and what skills and training are required. These are job profiles, not live jobs you can apply for."
