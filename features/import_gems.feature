@javascript
Feature: Import Gems

  Background:
    Given "Adman65" has these repos in this github account:
      | name    | description       | url |
      | cashier | Tag based caching | http://github.com/Adman65/cashier |
      | mail    | Ruby mail library | http://github.com/Adman65/mail |
    And Rubygems.org is tracking these gems:
      | name    |
      | cashier |
      | mail    |

  # for some really annoying reason this scenario
  # fails randomly. Could be a timing bug.
  # I can't seem to figure it out. If you run it byself
  # it usually passes. If your run rake cucumber
  # it usually fails. Everyone once and a while it will pass.
  # Very annoying.

  Scenario: The user imports all their gems
    Given I login as "Adman65"
    When I follow "Import Gems"
    When I submit the "cashier" form
    Then I should see "cashier added!"
    And there should be this gem:
      | name | description | github_url |
      | cashier | Tag based caching | http://github.com/Adman65/cashier |
    When I submit the "mail" form
    Then I should see "mail added!"
    And there should be this gem:
      | name | description | github_url |
      | mail | Ruby mail library | http://github.com/Adman65/mail |

  Scenario: The user chooses some tags
    Given there are these tags: "caching and background"
    And I login as "Adman65"
    When I follow "Import Gems"
    And I check "Caching" in the "cashier" form
    And I check "Background" in the "cashier" form
    And I submit the "cashier" form
    And I wait
    Then "cashier" should be tagged with "caching and background"

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
    And I fill in "Github URL" with "" in the "cashier" form
    And I submit the "cashier" form
    Then I should see an error message
    And I fill in "Github URL" with "cashier" in the "cashier" form
    And I submit the "cashier" form
    Then I should see a success message
