class User::RubyGemsController < ApplicationController
  before_filter :authenticate_user!

  respond_to :html, :js

  def import
    @ruby_gems = current_user.build_gems_from_github_and_rubygems
  end

  def create
    @ruby_gem = current_user.ruby_gems.build params[:ruby_gem]
    @ruby_gem.save

    respond_with(@ruby_gem)
  end

  def update
    @ruby_gem = RubyGem.find params[:id]

    @ruby_gem.update_attributes(params[:ruby_gem])

    respond_with(@ruby_gem)
  end
end
