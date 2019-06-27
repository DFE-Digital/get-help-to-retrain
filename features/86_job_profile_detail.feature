Feature: As a user, I only want to see certain attributes from the explore careers scraping, So that I only have to read information relevant to me

  Background:
    Given there is job profile that thas attributes
      | Atttibute |
      | All     |

  @wip @86
  Scenario: Check attributes
    Given I am on the "job profile information" page
    Then I only see the attributes outlined on the attached CSV file
