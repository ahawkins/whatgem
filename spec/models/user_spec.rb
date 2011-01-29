require 'spec_helper'

describe User do
  fixtures :users

  it { should have_many(:gems).class_name('RubyGem').dependent(:destroy) }

  it { should validate_presence_of(:user_name) }

  it "should require a unique user name" do
    user = User.new :user_name => 'Adman65'
    user.should validate_uniqueness_of(:user_name)
  end

  describe 'User#find_for_github_oauth' do
    it "should return the user if the user name exists" do
      actual_user = User.find_for_github_oauth('user_info' => {'nickname' => 'Adman65'})
      users(:Adman65).should eql(actual_user)
    end

    it "should make new user if the user name does not exist" do
      expect { 
        User.find_for_github_oauth('user_info' => {'nickname' => 'datapimp'}) 
      }.to change(User, :count).by(1)
    end
  end

  describe 'User#find_by_user_name' do
    it "should be case insensitive" do
      User.find_by_user_name('Adman65').should eql(users(:Adman65))
      User.find_by_user_name('adman65').should eql(users(:Adman65))
    end
  end
end
