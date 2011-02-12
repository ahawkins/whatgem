class RubyGemsController < ApplicationController
  before_filter :authenticate_user!, :only => :update
  before_filter :find_gem!

  respond_to :html, :js

  def show
    @comment = Comment.new
  end

  def update
    @ruby_gem.update_attributes params[:ruby_gem]

    respond_with(@ruby_gem)
  end
end
