Feature:
  In order to become a member
  People should be able to sign up

  @current
  Scenario: 
    Given I am on the root page
    And   I follow "sign up"
    Then  I should be on the new user registration page
