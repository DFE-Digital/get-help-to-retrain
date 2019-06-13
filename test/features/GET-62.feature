Feature: As a customer
    I want to see a list of jobs within a category
    So that I can explore which jobs might be suitable for me

    Scenario: Happy Path
        Given I am on the 'explore careers search' page
        When I click on the text link 'a category'
        Then I should see a list of occupations  for 'a category'