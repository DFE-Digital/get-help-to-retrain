Feature: As a customer
  I want to search job profiles by entering a job title
  So that I can explore which jobs might be suitable for me

  Background:
    Given a job profile exists with the name "Manufacturing Supervisor"

  @ci @56
  Scenario: Happy Path
  Given I am on the "check_your_skills" page
    When I enter "Supervisor" in "Enter your job title" field
    And I click the ".search-button" button
    Then I should see the "job profile search results" page
    And I should see "Manufacturing Supervisor"

  @ci @56
  Scenario: Unhappy Path
    Given I am on the "check_your_skills" page
    When I enter "zzzzzzz" in "name" field
    When I click the ".search-button" button
    Then I see error message "0 results found - try again using a different job title"

# Scenario: Check pagination

# Scenario: Check number of results per page
