Feature: As a customer, I want to see courses from providers that are approved by NRS, So that the training is suitable and funding has been agreed for all the courses I am shown

  @wip @107
  Scenario: Only show courses that are on list of approved training providers
    Given I am on the "courses near me" page
    Then I do not see any courses that are not listed on the list of approved providers
