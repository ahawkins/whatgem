Then /^there should be this gem:$/ do |table|
  # table is a Cucumber::Ast::Table
  
  attributes = table.hashes.first

  RubyGem.exists?(attributes).should be_true
end

Given /^there are these tags: "([^"]*)"$/ do |tag_string|
  tag_string.split(/(?:,|and)/).map(&:strip).each do |tag|
    ActsAsTaggableOn::Tag.create! :name => tag
  end
end
 
Then /^"([^"]*)" should be tagged with "([^"]*)"$/ do |name, tag_string|
  ruby_gem = RubyGem.find_by_name!(name)

  tag_string.split(/(?:,|and)/).map(&:strip).each do |tag|
    ruby_gem.tag_list.should include(tag.downcase)
  end
end

Then /^"([^"]*)" and "([^"]*)" should be related$/ do |gem_name1, gem_name2|
  gem1 = RubyGem.find_by_name!(gem_name1)
  gem2 = RubyGem.find_by_name!(gem_name2)

  gem1.related_gems.should include(gem2)
  gem2.related_gems.should include(gem1)
end

