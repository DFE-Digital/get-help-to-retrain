Feature: As a customer, I want to see a summary all the training I am recommended to do, So that I can explore my training options

  Background:
    Given I am on the "task_list" page

  @ci @60
  Scenario: Hub Page - Your existing skills
    When I click the text link "Find and apply to training courses near you"
    Then the current page contains text "Find and apply to a training course near you"
