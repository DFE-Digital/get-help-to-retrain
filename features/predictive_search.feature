Feature: As a customer, I want the search job title input field to use predictive matching to list titles as I type, So that I can select a job title without having to enter the complete title in full

  @wip
  Scenario: Predictive search returns results
    Given I am on the "explore_occupations" page
    When I enter at least two letters of a "job title" field
    Then I should see a relevant list job titles
    When I click on a random job title
    Then I should see the "job profile" page

  @wip
  Scenario: Predictive search returns no results
    Given I am on the "explore_occupations" page
    When I enter "xxxxxxx" in "Enter your job title" field
    When I click the ".search-button" button
    Then I should see the "search-results" page
