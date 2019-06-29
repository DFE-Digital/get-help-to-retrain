Feature: As a customer, I want to see my existing skills, So that I can understand what transferable skills I already have that employers would be looking for

  Background:
    Given a job profile exists for a Construction manager

  @ci @31 @32
  Scenario: Transferable skills
    Given I am on the homepage
    When I click on "Start now"
    And I click on "Check your existing skills"
    And I enter "Construction manager" in "Enter your job title" field
    And I click the ".search-button" button
    Then I should see "Search results for"
    And I click on "Construction manager"
    Then I should see list of existing skills relevant for job title

  @ci @31 @32
  Scenario: Transferable skills
    Given I am on the "Construction manager" job profile skills page
    When I click on "Explore jobs you could do"
    Then I should see "Explore occupations"
