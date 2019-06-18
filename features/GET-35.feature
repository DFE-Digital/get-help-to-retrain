Feature: As a customer, I want to see the eligibility criteria and be able to continue, So that I know if I am eligible and can commence my journey to explore skills / jobs / training

    @ci
    Scenario: Verify Landing Page
        Given I am on the "home" page
        Then I should see the "Get Help to Retrain" page

    @bdd
    Scenario: Verify Landing Page
        Given I am on the "home" page
        Then the correct eligibility criteria is displayed
        When I click the "Start now" button
        Then the current page contains text "Get help to retrain"
