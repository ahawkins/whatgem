class RubyGemsController < ApplicationController
  def show
    @ruby_gem = RubyGem.find params[:id]
  end
end
