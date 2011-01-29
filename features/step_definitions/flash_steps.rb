Then /^I should see a success message$/ do
  page.should have_selector("#flash_notice")
end

