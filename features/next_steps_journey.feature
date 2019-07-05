Feature: As a customer, I want to be advised about what I should do next, now I've completed the current journey, So that I can find another (better) job

  @ci @21
  Scenario: User returns to uncompleted journey
    Given I am on the "task_list" page
    When I click on "Get more support to help you on your new career path"
    Then I can learn what all my next options are
