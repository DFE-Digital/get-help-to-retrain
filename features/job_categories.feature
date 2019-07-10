Feature: As a customer
  I want to see a list of jobs within a category
  So that I can explore which jobs might be suitable for me

  Background:
    Given the following categories are available
      | Name           |
      | Administration |
      | Home services  |
      | Bookkeeper     |
    And the following job profiles are available
      | Name                 | Category       | Alternative titles |
      | Accommodation warden | Home services  | Housing officer    |
      | Admin assistant      | Administration | Admin clerk        |
      | Auditor              | Administration | Senior Auditor     |

  @ci @62
  Scenario: Explore occupations categories
    Given I am on the "explore_occupations" page
    Then I should see "Administration"
    And I should see "Home services"
    And I should not see "Bookkeeper"

  @ci @62
  Scenario: Careers Search By Occupation categories
    Given I am on the "explore_occupations" page
    When I click on "Administration"
    Then I should see "Admin assistant"
    And I should see "Auditor"

