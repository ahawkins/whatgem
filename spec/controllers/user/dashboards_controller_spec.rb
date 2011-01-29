require 'spec_helper'

describe User::DashboardsController do

  it_should_require_a_user_for :get => :show

end
