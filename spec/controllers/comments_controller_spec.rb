require 'spec_helper'

describe CommentsController do

  it "should require a user to make a comment" do
    post :create, :ruby_gem_id => 1
    response.should_not be_success
  end

end
