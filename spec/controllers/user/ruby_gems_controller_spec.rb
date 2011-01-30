require 'spec_helper'

describe User::RubyGemsController do
  # before(:each) do 
  #   users(:Adman65).stub!(:build_gems_from_gitub_and_ruby_gems => [])
  # end

  it_should_require_a_user_for :get => :import
end
