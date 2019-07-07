Feature: As a customer, I want to find out that I am not in a private beta area and see my alternative options BUT still be allowed to continue, So that I can explore skills/jobs/training in another way

    @wip @36
    Scenario: Check Location Eligibility (valid format) postcode is included on the list of eligible private beta postcodes
        Given I am on the "check location eligibility" page
        When I enter "E1 3BG" in ".address-postcode" field
        And I click the ".govuk-buttonbutton" button
        Then I should see "location eligible"

    @wip @36
    Scenario: Check Location Eligibility - (valid format) postcode not included on the list of eligible private beta postcodes
        Given I am on the "check location eligibility" page
        When I enter "E1 3BG" in ".address-postcode" field
        And I click the ".govuk-button" button
        Then I should see "location ineligible"

    @wip @36
    Scenario: Check Location Eligibility - (invalid format)
        Given I am on the "check location eligibility" page
        When I enter "1012RP" in ".address-postcode" field
        And I click the ".govuk-button" button
        Then I should see "location ineligible"