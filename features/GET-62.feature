Feature: As a customer
    I want to see a list of jobs within a category
    So that I can explore which jobs might be suitable for me

    Scenario Outline: Careers Search By Occupation
        Given I am on the "careers-search" page
        When I click the text link "<Occupation>"
        Then I should see a list of occupations for "<Occupation>"
        Examples:
            | Occupation |
            | Healthcare |

    Scenario Outline: Find a Course Service unavailable
        Given I am on the "careers-search" page
        And Find a Course Service is unavailable
        When I click the text link "healthcare"
        Then I see error message "The Service is currently unavailable - please try later"
