Feature: As a customer, I want the service to tell me why the service is not designed for me and signpost other services I could use, So that I don't waste time on GHtR and can easily navigate to services better suited to my needs

  @wip @114
  Scenario: Check qualifications eligibility (pass)
    Given I am on the "check_qualifications_eligibility" page
    And I click on "check"
    Then I should see error "select an option"
    And I click on "yes I have a degree"
    And I click on "check"
    Then I should see "qualifications ineligible"
