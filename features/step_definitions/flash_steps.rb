Then /^I should see a success message$/ do
  page.should have_selector("#flash_notice")
end

Then /^I should see an error message$/ do
  page.should have_selector("#flash_error")
end
