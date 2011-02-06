require 'spec_helper'

describe VotesController do

  it "should require a user to create an up vote" do
    post :up, :ruby_gem_id => 1
    response.should_not be_success
  end

  it "should require a user to create a down vote" do
    post :down, :ruby_gem_id => 1
    response.should_not be_success
  end
end
