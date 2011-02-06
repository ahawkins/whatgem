@javascript
Feature: Vote on Gems

  Background:
    Given "sunspot" is a gem

  Scenario: The user votes a gem up
    Given I login as "Adman65"
    And I go to the "sunspot" gem
    When I press "Vote Up"
    And I wait
    Then "Adman65" should've voted "sunspot" up
    And "sunspot" should have "1" vote

  Scenario: The user votes a gem down
    Given I login as "Adman65"
    And I go to the "sunspot" gem
    When I press "Vote Down"
    And I wait
    Then "Adman65" should've voted "sunspot" down
    And "sunspot" should have "1" vote

  Scenario: The user has an existing down vote
    Given "Adman65" is a user
    Given "Adman65" voted "sunspot" down
    And I login as "Adman65"
    When I go to the "sunspot" gem
    And I press "Vote Up"
    And I wait
    Then "Adman65" should've voted "sunspot" up
    And "sunspot" should have "1" vote

  Scenario: The user has an existing up vote
    Given "Adman65" is a user
    Given "Adman65" voted "sunspot" up
    And I login as "Adman65"
    When I go to the "sunspot" gem
    And I press "Vote Down"
    And I wait
    Then "Adman65" should've voted "sunspot" down
    And "sunspot" should have "1" vote
