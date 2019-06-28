Feature:As a customer, I want to see information about the occupation I have selected, So that I can decide if it is suitable for me

  Background:
    Given a job profile exists for a Construction manager

  @ci @26
  Scenario: View Job Profile Information
    Given I am on the "Construction manager" job profile page
    Then I should see "Construction manager"
    And I should see "Average Salary"
    And I should see "Typical hours"
    And I should see "You could work"

  @ci @161
  Scenario: Verify training course link
    Given I am on the "Construction manager" job profile page
    And I click on "Find a training course"
    Then I should see "Find and apply to a training course near you"
