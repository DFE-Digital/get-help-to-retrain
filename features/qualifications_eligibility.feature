Feature: As a customer, I want *to confirm that I do not have qualifications at a level that mean the GHtR service is not best suited to me, So that I don't waste time using the service
    
    @wip @114
    Scenario: Check qualifications eligibility
        Given that I am on the check qualifications eligibility page
        And I select "yes I have a degree'
        Then I am taken to "qualifications ineligible' page
        And I select "no I don"t have a degree'
        Then I continue through to the tasklist hub page
        And I don"t select an option
        Then I can"t continue until I select an option