class CommentsController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_gem!

  def create
    @comment = @ruby_gem.comments.build params[:comment]
    @comment.user = current_user

    @comment.save

    if @comment.save
      @ruby_gem.rescore!
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
