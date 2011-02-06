Then /^I should see a link to "([^"]*)" in the related gems$/ do |name|
  within('#related') do
    page.should have_content(name)
  end
end

Then /^I should not see any related gems$/ do
  page.should_not have_selector('#related')
end

