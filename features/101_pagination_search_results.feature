Feature: As a user, I want to see what page of search results I am on, So that I can navigate through my search results

  @bdd @101
  Scenario: Search Existing Skills (Results pagination)
    Given that I search existing skills that results in more than one page of results
    Then I should see the pagination on the page
    When I click the last page link
    Then I see the end of results

  @bdd @101
  Scenario: Search By Job Title (Results pagination)
    Given that I search by job title that results in more than one page of results
    Then I should see the pagination on the page
    When I click the last page link
    Then I see the end of results

  @bdd @101
  Scenario: Search By Job Title (Less than one page of results)
    Given that I search by job title that results in less than one page of results
    Then I should not see the pagination on the page

  @bdd @101
  Scenario: Search Existing Skills (Less than one page of results)
    Given that I search existing skills that results in less than one page of results
    Then I should not see the pagination on the page