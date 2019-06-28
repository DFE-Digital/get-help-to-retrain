Feature:As a customer, I want to be advised about what I should do next, now I've completed the current journey, So that I can find another (better) job

  Background:
    Given I am on the "task_list" page

  @ci @21
  Scenario: User returns to uncompleted journey
    When I click on "Find out what you can do next"
    Then I should see "Advice on how to look for and apply for jobs"
    And I should see "Find a job"
    And I should see "Find an apprenticeship"
