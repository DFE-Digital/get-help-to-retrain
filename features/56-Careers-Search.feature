Feature: As a customer
  I want to search job profiles by entering a job title
  So that I can explore which jobs might be suitable for me

  Background:
    Given a job profile exists with the name "Construction Supervisor"
    When I am on the homepage
    And I click the text link "Start now"

  @ci @56
  Scenario: Happy Path
    When I enter "Supervisor" in "Enter your job title" field
    When I click the ".search-button" button
    Then I should see the "job profile search results" page
    And the current page contains text "Construction Supervisor"

  @ci @56
  Scenario: Unhappy Path
    When I enter "zzzzzzz" in "name" field
    When I click the ".search-button" button
    Then I see error message "0 results found - try again using a different job title"

# Scenario: Check pagination

# Scenario: Check number of results per page
