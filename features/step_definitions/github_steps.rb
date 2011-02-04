Given /^"([^"]*)" has these repos in this github account:$/ do |user, table|
  # table is a Cucumber::Ast::Table

  base = "http://github.com/api/v2/json"

  api_url = "#{base}/repos/show/#{user}"

  response = { :repositories => table.hashes.map {|h| h.merge(:owner => user)} }

  stub_request(:get, api_url).to_return(:body => response.to_json)

  # now stub ALL the other requests that classes use to create the 
  # records with empty values

  table.hashes.each do |hash|
    hash.symbolize_keys!

    # stub requests used to get the pull/issue information
    stub_request(:get, "#{base}/issues/list/#{user}/#{hash[:name]}/closed").to_return(:body => {:issues => []}.to_json)
    stub_request(:get, "#{base}/issues/list/#{user}/#{hash[:name]}/open").to_return(:body => {:issues => []}.to_json)
    stub_request(:get, "#{base}/pulls/#{user}/#{hash[:name]}/open").to_return(:body => {:pulls => []}.to_json)
    stub_request(:get, "#{base}/pulls/#{user}/#{hash[:name]}/closed").to_return(:body => {:pulls => []}.to_json)
    
    # stub request used to get the commit information
    stub_request(:get, "#{base}/commits/list/#{user}/#{hash[:name]}/master").to_return(:body => {:commits => [{:tree => 'tree_sha'}]}.to_json)

    # stub request to get the fiile listing
    
    mock_listing = {:tree => [
      {:name => 'Gemspec'},
      {:name => 'readme.md'},
      {:name => 'spec', :type => 'tree'}
    ]}

    stub_request(:get, "#{base}/tree/show/#{user}/#{hash[:name]}/tree_sha").to_return(:body => mock_listing.to_json)
  end
end

