class ApplicationController < ActionController::Base
  protect_from_forgery

  def find_gem!
    @ruby_gem = RubyGem.named(params[:id] || params[:ruby_gem_id])
    if @ruby_gem.blank?
      respond_to do |wants|
        wants.html { render :file => "public/404.html", :status => :not_found, :layout => false }
      end
    end
  end
end
