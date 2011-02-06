When /^I fill in the comment box with "([^"]*)"$/ do |comment|
  fill_in('comment_text', :with => comment)
end

When /^I post my comment$/ do
  within('#new_comment') do
    click_button 'Post'
  end
end

Then /^"([^"]*)" should've said "([^"]*)" about "([^"]*)"$/ do |user, comment, gem_name|
  Comment.exists?(
    :text => comment, 
    :user_id => User.find_by_name!(user).id, 
    :ruby_gem_id => RubyGem.find_by_name!(gem_name).id
  ).should be_true
end

When /^I don't fill in the comment box$/ do
  fill_in('comment_text', :with => '')
end

Then /^I should not see the comment form$/ do
  page.should_not have_selector("#new_comment")
end

