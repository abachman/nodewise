Feature:
  In order to manage members
  someone oughta
  be able to fiddle with memberships

  @current
  Scenario: 
    Given I am a logged in treasurer
    And   some members exist
    And   I am on the members page
    When  I follow "Edit membership" for a user
    Then  I should see "Editing Membership for"
