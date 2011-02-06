class CommentsController < ApplicationController
  before_filter :authenticate_user!

  def create
    @ruby_gem = RubyGem.find params[:ruby_gem_id]
    @comment = @ruby_gem.comments.build params[:comment]
    @comment.user = current_user

    @comment.save

    if @comment.save
      respond_to do |wants|
        flash[:notice] = "Thanks for the comment. This will bump #{@ruby_gem}'s rating a bit!"
        wants.html { redirect_to ruby_gem_path(@ruby_gem) }
      end
    else
      respond_to do |wants|
        flash[:error] = "Did you fill the comment box in?"
        wants.html { redirect_to ruby_gem_path(@ruby_gem) }
      end
    end
  end
end
