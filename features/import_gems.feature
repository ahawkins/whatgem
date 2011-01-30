@javascript
Feature: Import Gems

  Background:
    Given "Adman65" has these repos in this github account:
      | name    | description       |
      | cashier | Tag based caching |
      | mail    | Ruby mail library |
    And Rubygems.org is tracking these gems:
      | name    | homepage_uri                      |
      | cashier | http://github.com/Adman65/cashier |
      | mail    | http://github.com/mikel/mail      |


  Scenario: The user imports all their gems
    Given I login as "Adman65"
    When I follow "Import Gems"
    When I submit the "cashier" form
    Then I should see "cashier added!"
    And there should be this gem:
      | name | description | homepage |
      | cashier | Tag based caching | http://github.com/Adman65/cashier |
    When I submit the "mail" form
    Then I should see "cashier added!"
    And there should be this gem:
      | name | description | homepage |
      | mail | Ruby mail library | http://github.com/mikel/mail |

  @error
  Scenario: The gem is missing a name
    Given I login as "Adman65"
    When I follow "Import Gems"
    And I fill in "Name" with "" in the "cashier" form
    And I submit the "cashier" form
    Then I should see an error message

  @error
  Scenario: The gem is missing a description
    Given I login as "Adman65"
    When I follow "Import Gems"
    And I fill in "Description" with "" in the "cashier" form
    And I submit the "cashier" form
    Then I should see an error message
    And I fill in "Description" with "cashier" in the "cashier" form
    And I submit the "cashier" form
    Then I should see a success message

  @error
  Scenario: The gem is missing a homepage
    Given I login as "Adman65"
    When I follow "Import Gems"
    And I fill in "Homepage" with "" in the "cashier" form
    And I submit the "cashier" form
    Then I should see an error message
    And I fill in "Homepage" with "cashier" in the "cashier" form
    And I submit the "cashier" form
    Then I should see a success message
