Given /^"([^"]*)" has these repos in this github account:$/ do |user, table|
  # table is a Cucumber::Ast::Table

  api_url = "http://github.com/api/v2/json/repos/show/#{user}"

  response = { :repositories => table.hashes }

  stub_request(:get, api_url).to_return(:body => response.to_json)
end

