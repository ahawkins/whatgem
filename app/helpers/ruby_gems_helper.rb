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

  def guage_for(number)
    score = number || 0
    class_name = case score
    when 0.9..1
      'green'
    when 0.8..8.9
      'yellow'
    when 0.7..7.9
      'orange'
    else
      'red'
    end
    content_tag('span', number_to_percentage(score * 100, :precision => 2), :class => "guage #{class_name}")
  end
end
