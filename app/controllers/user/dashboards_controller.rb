class User::DashboardsController < ApplicationController
  before_filter :authenticate_user!
end
