require 'spec_helper'

describe User::RubyGemsController do
  it_should_require_a_user_for :get => :import
end
