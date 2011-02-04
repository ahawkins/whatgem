@javascript
Feature: Import Gems

  Background:
    Given "Adman65" has these repos in this github account:
      | name    | description       | url                               |
      | sunspot | Solr search       | http://github.com/Adman65/sunspot |
      | mail    | Ruby mail library | http://github.com/Adman65/mail    |
    And Rubygems.org is tracking these gems:
      | name    |
      | sunspot |
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
    When I submit the "sunspot" form
    Then I should see "sunspot added!"
    And there should be this gem:
      | name    | description | github_url                        |
      | sunspot | Solr search | http://github.com/Adman65/sunspot |
    When I submit the "mail" form
    Then I should see "mail added!"
    And there should be this gem:
      | name | description       | github_url                     |
      | mail | Ruby mail library | http://github.com/Adman65/mail |

  Scenario: The user chooses some tags
    Given there are these tags: "caching and background"
    And I login as "Adman65"
    When I follow "Import Gems"
    And I check "Caching" in the "sunspot" form
    And I check "Background" in the "sunspot" form
    And I submit the "sunspot" form
    And I wait
    Then "sunspot" should be tagged with "caching and background"

  @error
  Scenario: The gem is missing a name
    Given I login as "Adman65"
    When I follow "Import Gems"
    And I fill in "Name" with "" in the "sunspot" form
    And I submit the "sunspot" form
    Then I should see an error message

  @error
  Scenario: The gem is missing a description
    Given I login as "Adman65"
    When I follow "Import Gems"
    And I fill in "Description" with "" in the "sunspot" form
    And I submit the "sunspot" form
    Then I should see an error message
    And I fill in "Description" with "sunspot" in the "sunspot" form
    And I submit the "sunspot" form
    Then I should see a success message

  @error
  Scenario: The gem is missing a homepage
    Given I login as "Adman65"
    When I follow "Import Gems"
    And I fill in "Github URL" with "" in the "sunspot" form
    And I submit the "sunspot" form
    Then I should see an error message
    And I fill in "Github URL" with "sunspot" in the "sunspot" form
    And I submit the "sunspot" form
    Then I should see a success message
