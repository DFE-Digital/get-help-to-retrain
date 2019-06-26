Feature: As a customer
  I want to be able to contact an adviser
  So that I can get the support I need to complete my journey

  @bdd @86
  Scenario: Check phone number is present
    Given that I am on any page that is not the landing page
    Then there is a phone number present to contact a careers adviser
    And I can click on the phone number if I am using mobile