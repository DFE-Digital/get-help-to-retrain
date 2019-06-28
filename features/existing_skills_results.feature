Feature: As a customer, I want to see my existing skills, So that I can understand what transferable skills I already have that employers would be looking for

  Background:
    Given there is user with criteria:
      | journey status |
      | beginning    |

  @ci @31
  Scenario: Transferable skills
    Given that I have chosen an occupation from successful existing skills search results page
    Then I can see a list of my existing skills that have been inferred from my occupation
