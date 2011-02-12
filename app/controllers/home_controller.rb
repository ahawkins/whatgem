class HomeController < ApplicationController
  def index
    @ruby_gems = RubyGem.all.paginate(
      :page => params[:page], :per_page => RubyGem.per_page)
  end
end
