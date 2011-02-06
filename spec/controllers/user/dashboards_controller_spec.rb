require 'spec_helper'

describe User::DashboardsController do

  it "should require a user to view the dashboard" do
    get :show
    response.should_not be_success
  end

end
