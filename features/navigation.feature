Feature: As a customer
  I want to be able to navigate webite using breadcrumb links
  So that it is easier to jump steps I have followed.

  @ci @138
  Scenario: Check Breadcrumb Navigation
    Given I am on the homepage
    And I click on "Start now"
    When I click on "Check your existing skills"
    And I click on "Home: Get help to retrain"
    Then I should see "Get help to retrain"
