Given /^"([^"]*)" is a gem$/ do |name|
  RubyGem.make :name => name
end

Given /^"([^"]*)" is a user$/ do |name|
  User.make :name => name
end
