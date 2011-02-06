Feature: Related gems

  Scenario: A gem has related gems
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
