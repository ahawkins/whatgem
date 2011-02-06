require 'spec_helper'

describe Comment do
  it { should belong_to(:user) }
  it { should belong_to(:ruby_gem, :touch => true) }
  it { should validate_presence_of(:user_id, :ruby_gem_id) }
  it { should validate_presence_of(:text).allow_blank(false) }
end
