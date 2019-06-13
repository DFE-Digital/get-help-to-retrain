Feature: As a customer
    I want to see my complete journey,
    So that I am less overwhelmed by all the steps involved in retraining

    Scenario: Hub Page - Existing Skills Check
        Given I am on the "hub" page
        Then I should see all stages of the journey
        When I click the text link "check your existing skills"
        And there are placeholders for "courses hub"
        And the link "next steps" is inactive

    Scenario: Hub Page - Occupations
        Given I am on the "hub" page
        Then I should see what all stages of the journey
        When I click the text link "check type  of job you can do."
        And there are placeholders for "occupations"
        And the link "next steps" is inactive

    Scenario: Hub Page - Training Courses
        Given I am on the "hub" page
        Then I should see what all stages of the journey
        When I click the text link "training courses"
        And there are placeholders for "training courses"
        And the link "next steps" is inactive