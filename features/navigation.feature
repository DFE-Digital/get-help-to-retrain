Feature: As a customer
  I want to be able to navigate webite using breadcrumb links
  So that it is easier to jump steps I have followed.

  @ci @138
  Scenario Outline: Check Breadcrumb Navigation
    Given I am on the "<path>" page
    And I click on "Home: Get help to retrain"
    Then I should see "Get help to retrain"
    Examples:
      | path                                          |
      | explore_occupations                           |
      | check_your_skills                             |
      | find_training_courses                         |
      | next_steps                                    |
