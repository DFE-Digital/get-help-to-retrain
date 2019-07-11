Feature: As a customer
  I want to see my complete journey,
  So that I am less overwhelmed by all the steps involved in retraining

  Background:
    Given I am on the homepage
    When I click on "Start now"

  @ci @30
  Scenario: Hub Page - Your existing skills
    When I click on "Check your existing skills"
    Then there are placeholders for "courses hub"

  @ci @30
  Scenario: Hub Page - Find a new occupation
    When I click on "Search for the types of jobs you could retrain to do "
    Then there are placeholders for "occupations"

  @ci @30
  Scenario: Hub Page - Apply for a training course
    When I click on "Talk to an adviser to find and apply to a training course near you"
    Then there are placeholders for "training courses"

  @ci @30
  Scenario: Hub Page - Next Steps
    When I click on "Get more support to help you on your new career path"
    Then there are placeholders for "current course"