Feature: As a customer
  I want to search job profiles by entering a job title
  So that I can explore which jobs might be suitable for me

  Background:
    Given a job profile exists with the name "Manufacturing Supervisor"
    And I am on the "check_your_skills" page

  @ci @56
  Scenario: Happy Path
    When I enter "Supervisor" in "Enter your job title" field
    And I click the ".search-button" button
    Then I should see "Search results for"
    And I should see "Manufacturing Supervisor"

  @ci @56
  Scenario: Unhappy Path
    When I enter "zzzzzzz" in "name" field
    And I click the ".search-button" button
    Then I see error message "0 results"
    And I see error message "Try again using a different job title"

  @wip @104
  Scenario: Search with blank search field
    When I am on the "/check_your_skills" page
    And I click the ".search-button" button
    Then I should see "Check your existing skills"
    And the current url path is "/check_your_skills"
    When I am on the "/explore_occupations" page
    And I click the ".search-button" button
    Then I should see "Explore by job category"
    And the current url path is "/explore_occupations"

  @ci @56
  Scenario: Unhappy Path (case sensitivity)
    When I enter "supervisor" in "Enter your job title" field
    And I click the ".search-button" button
    Then I should see "Search results for"
    And I should see "Manufacturing Supervisor"

# Scenario: Check pagination

# Scenario: Check number of results per page