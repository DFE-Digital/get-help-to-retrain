Feature: As a customer
  I want to see my complete journey,
  So that I am less overwhelmed by all the steps involved in retraining

  Background:
    Given I am on the homepage
    When I click the text link "Start now"

  @ci @30
  Scenario: Hub Page - Your existing skills
    When I click the text link "Check your existing skills"
    And there are placeholders for "courses hub"

  @ci @30
  Scenario: Hub Page - Find a new occupation
    When I click the text link "Search for the types of jobs you could retrain to do "
    And there are placeholders for "occupations"

  @ci @30
  Scenario: Hub Page - Apply for a training course
    When I click the text link "Find and apply to training courses near you"
    And there are placeholders for "training courses"

  @ci @30
  Scenario: Hub Page - Next Steps
    When I click the text link "Find out what you can do next"
    And there are placeholders for "current course"
