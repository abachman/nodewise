Feature:
  In order to access their information
  Members should be able to login

  Scenario: 
    Given I am an active confirmed member
    And   I go to the new user session page
    When  I fill in "Email" with "member@email.com"
    And   I fill in "Password" with "password"
    And   I press "Sign in"
    Then  I should be on the root page
    And   I should see "Signed in successfully"

  Scenario:
    Given I am an active unconfirmed member
    And   I go to the new user session page
    When  I fill in "Email" with "member@email.com"
    And   I fill in "Password" with "password"
    And   I press "Sign in"
    Then  I should be on the new user session page
    And   I should see "You have to confirm your account before continuing"

