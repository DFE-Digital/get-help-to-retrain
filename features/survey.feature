Feature: User storyAs NRSI need to capture qualitative feedback from unmoderated users of the serviceSo that we can continually improve the service based on user feedback and insights

    @ci @134
    Scenario Outline: Survey link visible on all pages
        Given I am on the "<page>" page
        Then the page should contain link text "feedback"
        Examples:
            | page                  |
            | explore_occupations   |
            | check_your_skills     |
            | find_training_courses |
            | next_steps            |
            | find_training_courses |
