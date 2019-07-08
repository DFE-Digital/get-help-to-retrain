Feature: As a customer
  I want to be able to contact an adviser
  So that I can get the support I need to complete my journey

  @ci @29
  Scenario Outline: Check phone number is present
    Given I am on the "<Page>" page
    Then there is a phone number present to contact a careers adviser
    And I can click on the phone number if I am using mobile
    Examples:
      | Page                  |
      | check_your_skills     |
      | explore_occupations   |
      | next_steps            |
