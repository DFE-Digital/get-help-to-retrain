Feature: As a customer, I want to see a summary all the training I am recommended to do, So that I can explore my training options

  Background:
    Given there is user with criteria:
      | journey status                    |
      | Existing training recommendations |

  @bdd2 @60
  Scenario: Hub Page - Your existing skills
    Given I am on the homepage
    When I click the text link "Start now"
    Then I should see the "Training hub" page
