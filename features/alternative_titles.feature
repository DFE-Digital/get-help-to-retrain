
Feature: As a user, I want to see alternate job titles on job detail page, in order to see alaternative relevant jobs.

  Background:
    Given the following categories are available
      | Name           |
      | Construction   |
      | Administration |
    And the following job profiles are available
      | Name                   | Alternative titles | Category       |
      | Construction manager   | Weird title        | Construction   |
      | Administration manager | Weirder title      | Administration |

  @ci @169
  Scenario: Alternate Job Title On Job Detail Page From Existing Skills Search Page
    Given I am on the "check-your-skills" page
    When I have searched for the occupation "Construction manager"
    Then I should see "Weird title"

  @wip @169
  Scenario: Alternate Job Title On Job Detail Page From Explore Occupations Search Page
    Given I am on the "explore-occupations" page
    And I have searched for the occupation "Administration manager"
    When I click on "Administration manager"
    Then I should see "Weirder title"

  @ci @177
  Scenario: Search includes alternative job titles
    Given I am on the "explore-occupations" page
    When I have searched for the occupation "Weird"
    Then I should see "Construction manager"
    When I am on the "check-your-skills" page
    And I have searched for the occupation "Weird title "
    Then I should see "Construction manager"
