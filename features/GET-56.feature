Feature: As a customer
    I want to search job profiles by entering a job title
    So that I can explore which jobs might be suitable for me

    Scenario: Happy Path
        Given I am on the "careers-search" page
        When I enter "tester" in "job title" field
        When I click the "Search" button
        Then I should see the "job profile search results" page

    Scenario: Unhappy Path
        Given I am on the "careers-search" page
        When I enter "zzzzzzz" in "job title" field
        When I click the "Search" button
        Then I see error message "0 results found - try again using a different job title"
