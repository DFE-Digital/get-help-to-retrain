Feature: As a customer, I want to be able to see the details of a course, So that I can decide if the course meets my needs

    @wip @125
    Scenario: View course details
        Given I am on the "courses near me" page
        When I click on ".course"
        Then I should see "Course details"
