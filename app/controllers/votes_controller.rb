class VotesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :destroy_existing_vote

  respond_to :js

  def up
    @ruby_gem = RubyGem.find params[:ruby_gem_id]
    @vote = @ruby_gem.votes.up.build
    @vote.user = current_user

    @vote.save

    respond_with(@vote)
  end

  def down
    @ruby_gem = RubyGem.find params[:ruby_gem_id]
    @vote = @ruby_gem.votes.down.build
    @vote.user = current_user

    @vote.save

    respond_with(@vote)
  end

  private
  def destroy_existing_vote
    @ruby_gem = RubyGem.find params[:ruby_gem_id]
    @ruby_gem.votes.where('votes.user_id' => current_user.id).destroy_all
  end
end
