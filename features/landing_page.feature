Feature: As a customer, I want to see the eligibility criteria and be able to continue, So that I know if I am eligible and can commence my journey to explore skills / jobs / training

  @ci @35
  Scenario: Verify Landing Page
    Given I am on the homepage
    Then I should see "Get Help to Retrain"

  @ci @35
  Scenario: Verify Landing Page
    Given I am on the homepage
    Then the correct eligibility criteria is displayed

  @ci @35
  Scenario: Verify landing page links to task list
    Given I am on the homepage
    When I click on "Start now"
    Then I should see "Check what you need to do to retrain"
