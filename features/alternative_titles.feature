
Feature: As a user, I want to see alternate job titles on job detail page, in order to see alaternative relevant jobs.

  Background:
    Given a job profile exists with the name "Construction manager"

  @wip @169
  Scenario: Alternate Job Title On Job Detail Page From Existing Skills Search Page
    Given I am on the "check_your_skills" page
    When I have searched for the occupation "Construction manager"
    Then I should see the alternative titles under the first result title
    And I should see "Damage controller, Construction maniac"

  @wip @169
  Scenario: Alternate Job Title On Job Detail Page From Explore Occupations Search Page
    Given I am on the "explore_occupations" page
    When I have searched for the occupation "Construction manager"
    Then I should see the alternative titles under the first result title
    And I should see "Damage controller, Construction maniac"

  @wip @177
  Scenario: Search includes alternative job titles
    Given I am on the "explore_occupations" page
    When I have searched for the occupation "Damage controller"
    Then I should see "Construction manager"
    When I am on the "check_your_skills" page
    And I have searched for the occupation "Construction maniac"
Then I should see "Construction manager"