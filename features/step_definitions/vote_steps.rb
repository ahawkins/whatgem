Then /^"([^"]*)" should've voted "([^"]*)" up$/ do |user, gem_name|
  ruby_gem = RubyGem.find_by_name!(gem_name)
  ruby_gem.votes.up.exists?(:user_id => User.find_by_name!(user)).should be_true
end

Then /^"([^"]*)" should have "([^"]*)" vote$/ do |gem_name, count|
  RubyGem.find_by_name!(gem_name).votes.count.should eql(count.to_i)
end

Then /^"([^"]*)" should've voted "([^"]*)" down$/ do |user, gem_name|
  ruby_gem = RubyGem.find_by_name!(gem_name)
  ruby_gem.votes.down.exists?(:user_id => User.find_by_name!(user)).should be_true
end

Given /^"([^"]*)" voted "([^"]*)" down$/ do |user_name, gem_name|
  user = User.find_by_name!(user_name)
  ruby_gem = RubyGem.find_by_name!(gem_name)

  ruby_gem.votes.down.create! :user => user
end

Given /^"([^"]*)" voted "([^"]*)" up$/ do |user_name, gem_name|
  user = User.find_by_name!(user_name)
  ruby_gem = RubyGem.find_by_name!(gem_name)

  ruby_gem.votes.up.create! :user => user
end

