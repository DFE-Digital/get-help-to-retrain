Feature: As a customer, I want to find out if my location is eligible for private beta areas along with being shown alternative options, So that I can explore skills/jobs/training efficently.

    @wip @36
    Scenario: Check Location Eligibility (valid format, and postcode is on the list of eligible private beta postcodes)
        Given I am on the "check_location_eligibility" page
        When I enter "E1 3BG" in ".address-postcode" field
        And I click the ".govuk-buttonbutton" button
        Then I should see "location eligible"

    @wip @36
    Scenario: Check Location Eligibility (valid format, and postcode is NOT on the list of eligible private beta postcodes)
        Given I am on the "check_location_eligibility" page
        When I enter "E1 3BG" in ".address-postcode" field
        And I click the ".govuk-button" button
        Then I should see "location ineligible"

    @wip @36
    Scenario: Check Location Eligibility - (invalid format)
        Given I am on the "check_location_eligibility" page
        When I enter "1012RP" in ".address-postcode" field
        And I click the ".govuk-button" button
        Then I should see "location ineligible"
