class VotesController < ApplicationController
  before_filter :authenticate_user!
  before_filter :find_gem!
  before_filter :destroy_existing_vote

  respond_to :js

  def up
    @vote = @ruby_gem.votes.up.build
    @vote.user = current_user

    @vote.save

    @ruby_gem.rescore!

    respond_with(@vote)
  end

   def down
    @vote = @ruby_gem.votes.down.build
    @vote.user = current_user

    @vote.save

    @ruby_gem.rescore!

    respond_with(@vote)
  end

  private
  def destroy_existing_vote
    @ruby_gem.votes.where('votes.user_id' => current_user.id).destroy_all
  end
end
