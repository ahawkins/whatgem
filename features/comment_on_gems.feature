Feature: Comment on gems
  
  Background:
    Given "cashier" is a gem

  Scenario: The user is logged in
    Given I login as "Adman65"
    When I go to the "cashier" gem
    And I fill in the comment box with "Sweet!"
    And I post my comment
    Then I should see a success message
    And "Adman65" should've said "Sweet!" about "cashier"

  Scenario: The user does not fill in the comment box
    Given I login as "Adman65"
    When I go to the "cashier" gem
    And I don't fill in the comment box
    And I post my comment
    Then I should see an error message

  Scenario: The user isn't logged int
    Given I go to the "cashier" gem
    Then I should not see the comment form
