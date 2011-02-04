Then /^I should not see that tag form$/ do
  page.should_not have_selector('#gem-tags form')
end

