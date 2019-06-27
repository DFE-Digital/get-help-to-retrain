Feature:As a customer, I want to be advised about what I should do next, now I've completed the current journey, So that I can find another (better) job

  Background:
    Given there is user with criteria:
      | journey status    |
      | Uncompleted journey |

  @wip @21
  Scenario: User returns to uncompleted journey
    Given I have a user part way through a journey
    When I am on the "next steps" page
    Then I can learn what all my next options are
