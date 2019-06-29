Feature: As a customer, I want to see information about the occupation I have selected, So that I can decide if it is suitable for me

  Background:
    Given a job profile exists for a Construction manager

  @ci @26
  Scenario: View Job Profile Information
    Given I am on the "Construction manager" job profile page
    Then I can see all the information I need to learn more about that occupation

  @ci @161
  Scenario: Verify training course link
    Given I am on the "Construction manager" job profile page
    When I click on "Find a training course"
    Then I should see "Find and apply to a training course near you"
