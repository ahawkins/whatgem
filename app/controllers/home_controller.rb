class HomeController < ApplicationController
  def index
    @ruby_gems = RubyGem.all
  end
end
