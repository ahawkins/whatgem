Given /^"([^"]*)" is a gem$/ do |name|
  RubyGem.make :name => name
end
