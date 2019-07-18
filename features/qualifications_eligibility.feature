Feature: As a customer, I want *to confirm that I do not have qualifications at a level that mean the GHtR service is not best suited to me, So that I don't waste time using the service

  @wip @114
  Scenario: Check qualifications eligibility (no option selected)
    Given I am on the "check_qualifications_eligibility" page
    And I click on "check"
    Then I should see "Error: select an option"

  @wip @114
  Scenario: Check qualifications eligibility (no option selected)
    Given I am on the "check_qualifications_eligibility" page
    And I click on "no I don't have a degree"
    And I click on "check"
    Then I should see the "tasklist hub" page
