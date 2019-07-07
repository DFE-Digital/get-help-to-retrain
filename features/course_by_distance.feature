Feature: As a user, I want to see courses sorted by distance from my postcode (shortest first), So that I can select the course that best meets my needs

    @wip @123
    Scenario: Signup for a course
        Given I am on the "courses near me" page
        Then I can see a list of courses
        And they are sorted by distance with the shortest distance first

    Scenario: No courses available
        Given there are no courses within 5 miles of my postcode show error message