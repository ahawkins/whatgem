When /^I submit the "([^"]*)" form$/ do |name|
  page.execute_script %Q{$("input.name['value=#{name}']").closest('form').submit()}
end
