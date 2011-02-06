@javascript
Feature: Tag gems

  Background:
    Given there are these tags: "caching and background"
    Given "sunspot" is a gem

  Scenario: The user is logged in
    Given I login as "Adman65"
    When I go to the "sunspot" gem
    And I check "Caching"
    And I wait
    Then "sunspot" should be tagged with "caching"
    When I check "Background"
    And I wait
    Then "sunspot" should be tagged with "background"

  Scenario: The user is not logged in
    When I go to the "sunspot" gem
    Then I should not see that tag form
