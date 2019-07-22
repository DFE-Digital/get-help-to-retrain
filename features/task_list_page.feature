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

  @ci @30 @160
  Scenario: Hub Page - Find out what to do next
    When I click on "Get more support to help you on your new career path"
    Then I should see "Advice on how to look for and apply for jobs"
    Then I should see "Find a job"
    Then I should see "Find an apprenticeship"

  @ci @30 @160
  Scenario: Hub Page - Apply for a training course
    When I click on "Find a training course"
    Then I should see "Call the Get help to retrain helpline to speak with an adviser and get free guidance."
    And there are placeholders for "training courses"

  @ci @30
  Scenario: Hub Page - Next Steps
    When I click on "Get more support to help you on your new career path"
    Then there are placeholders for "current course"
