Feature: As a customer, I want to see a summary all the training I am recommended to do, So that I can explore my training options

  Background:
    Given I am on the "task_list" page

  @ci @60
  Scenario: Hub Page - Your existing skills
    When I click on "Search for the types of jobs you could retrain to do"
    Then I should see "Explore the type of jobs you could retrain to do"
