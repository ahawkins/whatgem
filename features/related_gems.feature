Feature: Related gems

  Scenario: The gems are related by name
    Given "autotest" is a gem
    And "autotest-rails" is a gem
    Then "autotest" and "autotest-rails" should be related

  Scenario: The child is added before the parent
    Given "autotest-rails" is a gem
    And "autotest" is a gem
    Then "autotest" and "autotest-rails" should be related

  Scenario Outline: The gem name uses a shortened prefix
    Given "<parent>" is a gem
    And "<child>" is a gem
    Then "<parent>" and "<child>" should be related

    Examples:
      | parent | child |
      | datamapper | dm-state_machine |
      | resque | resque_scheduler |
      | engineyard | ey-flex |
      | faker-medical | faker |
      | capistrano-ext | capistrano-colors |
      | extjs-mvc | extjs-theme |
      | dm-is-list | dm-money |
      | engineyard-serverside | ey-flex |

  Scenario: The geme has related gems
    Given "autotest" is a gem
    And "autotest-rails" is a gem
    And "autotest-sinatra" is a gem
    When I go to the "autotest" gem
    Then I should see a link to "autotest-rails" in the related gems
    And I should see a link to "autotest-sinatra" in the related gems

  Scenario: A gem has no related gems
    Given "autotest" is a gem
    When I go to the "autotest" gem
    Then I should not see any related gems
