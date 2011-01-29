Feature: Sign in with Github

  Scenario: The user's credentials are correct
    When I go to the home page
    Then I follow "Sign in with Github"
    And Github replies with "Adman65"
    Then I should see a success message
    And "Adman65" should be a user
