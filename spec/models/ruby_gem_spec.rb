require 'spec_helper'

describe RubyGem do
  fixtures(:ruby_gems)

  it { should validate_presence_of(:name) }
  it { should validate_presence_of(:description) }
  
  it "should require a unique name" do
    subject.name = 'cashier'
    subject.should validate_uniqueness_of(:name)
  end
end
