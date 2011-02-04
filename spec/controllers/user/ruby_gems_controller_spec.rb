require 'spec_helper'

describe User::RubyGemsController do
  before(:each) do 
    stub_request(:get, "http://github.com/api/v2/json/repos/show/Adman65").
         to_return(:status => 200, :body => "{repositories: []}", :headers => {})
  end

  it "should require a user to import gems" do
    get :import
    response.should_not be_success
  end

  it "should require a user to create  gems" do
    post :create
    response.should_not be_success
  end

  it "shoudl require a user to update a gem" do
    put :update, :id => 1
    response.should_not be_success
  end
end
