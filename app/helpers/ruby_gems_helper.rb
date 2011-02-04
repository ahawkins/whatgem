module RubyGemsHelper
  def link_to_ruby_gems(ruby_gem, options = {})
    url = "http://rubygems.org/gems/#{ruby_gem.name}"
    link_to 'RubyGems', url, options
  end

  def link_to_test_results(ruby_gem, options = {})
    url = "http://gem-testers.org/gems/#{ruby_gem.name}"
    link_to 'Test Results', url, options
  end

  def link_to_github(ruby_gem, options = {})
    link_to 'Github', ruby_gem.github_url, options
  end
end
