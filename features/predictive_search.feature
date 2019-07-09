Feature: As a customer, I want the search job title input field to use predictive matching to list titles as I type, So that I can select a job title without having to enter the complete title in full

  @wip @57
  Scenario: Predictive search returns results
    Given I am on the "explore_occupations" page
    When I enter "ma" in "name" field
    Then I should see a relevant list of job titles
    When I click on a first job title
    Then I should see the "job profile" page

  @wip @57
  Scenario: Predictive search returns no results
    Given I am on the "explore_occupations" page
    When I enter "xc" in "name" field
    Then I should not see a relevant list of job titles
