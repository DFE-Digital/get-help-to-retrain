Feature: As a customer, I want to see the eligibility criteria and be able to continue, So that I know if I am eligible and can commence my journey to explore skills / jobs / training

  @ci
  Scenario: Verify Landing Page
    Given I am on the homepage
    Then I should see the "Get Help to Retrain" page

  @ci @35
  Scenario: Verify Landing Page
    Given I am on the homepage
    Then the correct eligibility criteria is displayed
    When I click the text link "Start now"
    Then the current page contains text "Check what you need to do to retrain"
