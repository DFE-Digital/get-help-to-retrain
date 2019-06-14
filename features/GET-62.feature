Feature: As a customer
    I want to see a list of jobs within a category
    So that I can explore which jobs might be suitable for me

    Scenario: Happy Path
        Given I am on the 'careers-search' page
        When I click the text link 'Healthcare'
        Then I should see a list of occupations for 'Healthcare'