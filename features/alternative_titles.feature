Feature: As a user, I want to see alternate job titles on job detail page, in order to see alaternative relevant jobs.

    @wip
    Scenario: Alternate Job Title On Job Detail Page From Existing Skills Search Page
        Given I am on the "check_your_skills" page
        And I have searched for the occupation "Supervisor"
        Then I should see the alternative title under the first result title

    @wip
    Scenario: Alternate Job Title On Job Detail Page From Explore Occupations Search Page
        Given I am on the "explore_occupations" page
        And I have searched for the occupation "manager"
        Then I should see the alternative title under the first result title
