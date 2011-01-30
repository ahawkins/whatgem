When /^I submit the "([^"]*)" form$/ do |name|
  page.execute_script %Q{$("#import-gems form.#{name}").submit()}
end

When /^I fill in "([^"]*)" with "([^"]*)" in the "([^"]*)" form$/ do |field, value, name|
  steps %Q{Then I fill in "#{field}" with "#{value}" within "form.#{name}"}
end

When /^I check "([^"]*)" in the "([^"]*)" form$/ do |field, name|
  steps %Q{Then I check "#{field}" within "form.#{name}"}
end
