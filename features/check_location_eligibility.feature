Feature: As a customer, I want to find out that I am not in a private beta area and see my alternative options BUT still be allowed to continue, So that I can explore skills/jobs/training in another way

    @wip @36
    Scenario: Check Location Eligibility
        Given that I am on the check location eligibility page
        When I type in a postcode and press enter
        And the postcode is a valid format
        And the postcode is included on the list of eligible private beta postcodes
        Then I go to the ‘check qualification eligibility’ page**

    @wip @36
    Scenario: Check Location Eligibility - postcode not included on the list of eligible private beta postcodes
        Given that I am on the check location eligibility page
        When I type in a postcode and press enter
        And the postcode is a valid format
        And the postcode is not included on the list of eligible private beta postcodes
        Then I go to the location ineligible page**

    @wip @36
    Scenario: Check Location Eligibility - postcode is an invalid format
        Given that I am on the check location eligibility page
        When I type in a postcode and press enter
        And the postcode is an invalid format
        Then I see an error message