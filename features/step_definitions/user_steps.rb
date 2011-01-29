Then /^"([^"]*)" should be a user$/ do |user_name|
  lambda { User.find_by_user_name!(user_name) }.should_not raise_error
end

