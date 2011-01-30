require 'spec_helper'

describe User::RubyGemsController do
  before(:each) do 
    stub_request(:get, "http://github.com/api/v2/json/repos/show/Adman65").
         to_return(:status => 200, :body => "{repositories: []}", :headers => {})
  end

  it_should_require_a_user_for :get => :import
end
