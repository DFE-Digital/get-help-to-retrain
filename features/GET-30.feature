Feature: As a customer
    I want to see my complete journey,
    So that I am less overwhelmed by all the steps involved in retraining

    Scenario: Hub Page - Your existing skills
        Given I am on the "home" page
        When I click the text link "Your existing skills"
        And there are placeholders for "courses hub"
        And the link "next steps" is inactive

    Scenario: Hub Page - Find a new occupation
        Given I am on the "home" page
        When I click the text link "Find a new occupation"
        And there are placeholders for "occupations"
        And the link "next steps" is inactive

    Scenario: Hub Page - Apply for a training course
        Given I am on the "home" page
        When I click the text link "Apply for a training course"
        And there are placeholders for "training courses"
        And the link "next steps" is inactive

    Scenario: Hub Page - Next Steps
        Given I am on the "home" page
        When I click the text link "Next steps"
        And there are placeholders for "current course"
        And the link "next steps" is inactive
