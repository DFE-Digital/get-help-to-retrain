Feature:As a customer, I want to see information about the occupation I have selected, So that I can decide if it is suitable for me

  @wip @26
  Scenario Outline: View Job Profile Information
    Given I am on the "explore_occupations" page
    When I click the text link "<Occupation>"
    And I click on first job title
    Then I should see the "show occupation information" page
    Examples:
      | Occupation     |
      | Healthcare     |
      | Administration |
      | Animal care    |
