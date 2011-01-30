Given /^Rubygems\.org is tracking these gems:$/ do |table|
  table.hashes.each do |hash|
    hash.symbolize_keys!

    name = hash[:name]
    api_url = "http://rubygems.org/api/v1/gems/#{name}.json"
    stub_request(:get, api_url).to_return(:body => hash.to_json)
  end
end

