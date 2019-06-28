Feature: As a customer, I want to see my existing skills, So that I can understand what transferable skills I already have that employers would be looking for

  Background:
    Given there is job profile that thas attributes
      | Atttibute | Job title         |
      | All     | Construction Supervisor |

  @ci @32
  Scenario: Transferable skills
    Given I am on the homepage
    When I click on "Start now"
    And I click on "Check your existing skills"
    When I enter "Construction manager" in "Enter your job title" field
    When I click the ".search-button" button
    And I should see the "job profile search results" page
    And I click on "Construction manager"
    And I should see list of existing skills relevant for job title
