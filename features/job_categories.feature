Feature: As a customer
  I want to see a list of jobs within a category
  So that I can explore which jobs might be suitable for me

  @ci @62
  Scenario Outline: Careers Search By Occupation
    Given I am on the "explore_occupations" page
    When I click the text link "<Occupation>"
    Then I should see a list of occupations for "<Occupation>"
    Examples:
      | Occupation     |
      | Healthcare     |
      | Administration |
      | Animal care    |

  @wip @62
  Scenario Outline: Find a Course Service unavailable
    Given I am on the "explore_occupations" page
    And Find a Course Service is unavailable
    When I click the text link "Healthcare"
    Then I see error message "The Service is currently unavailable - please try later"
    When Find a Course Service is available again
    And  I click the text link "healthcare"
    Then I should see a list of occupations for "Service"
