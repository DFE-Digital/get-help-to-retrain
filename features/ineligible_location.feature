Feature: As a customer, I want to find out that I am not in a private beta area and see my alternative options BUT still be allowed to continue, So that I can explore skills/jobs/training in another way

    # Background:
    #     Given I am a customer at an ineligible location

    @wip @39
    Scenario: Location Ineligible
        Given I am on the "courses near me" page
        Then I do not see any courses that are not listed on the list of approved providers
        