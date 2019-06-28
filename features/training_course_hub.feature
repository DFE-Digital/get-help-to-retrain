Feature: As a customer, I want to see a summary all the training I am recommended to do, So that I can explore my training options

  Background:
    Given there is user with criteria:
      | journey status                    |
      | Existing training recommendations |

  @ci @60
  Scenario: Hub Page - Your existing skills
    Given I am on the homepage
    When I click the text link "Start now"
    Then the current page contains text "Find and apply to training courses near you"
