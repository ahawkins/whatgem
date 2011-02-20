class RubyGemsController < ApplicationController
  before_filter :authenticate_user!, :only => :update
  before_filter :find_gem!, :only => [:show, :update]

  respond_to :html, :js

  def index
    @ruby_gems = ruby_gems.all.paginate(:page => params[:page])
  end

  def show
    @comment = Comment.new
  end

  def update
    @ruby_gem.update_attributes params[:ruby_gem]

    respond_with(@ruby_gem)
  end

  private
  def ruby_gems
    if params[:tag]
      RubyGem.tagged_with(@tag = params[:tag])
    else
      RubyGem
    end
  end
end
