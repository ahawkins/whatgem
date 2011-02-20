class HomeController < ApplicationController
  def index
    @ruby_gems = RubyGem.all(:limit => 15)
  end
end
