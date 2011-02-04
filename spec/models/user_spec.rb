require 'spec_helper'

describe User do
  fixtures :users

  it { should have_many(:ruby_gems).dependent(:destroy) }

  it { should validate_presence_of(:name) }

  it "should require a unique user name" do
    user = User.new :name => 'Adman65'
    user.should validate_uniqueness_of(:name)
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

  describe 'User#find_or_create_by_name!' do
    it "should find an existing user" do
      User.find_or_create_by_name!('adman65').should eql(users(:Adman65))
    end

    it "should create new users" do
      lambda { User.find_or_create_by_name!('datapimp') }.should change(User, :count).by(1)
    end
  end

  describe "#repos" do
    it "should use the github api to load all the repos" do
      api_response = {
        :repositories => [{:repo => :info}]
      }

      stub_request(:get, 'http://github.com/api/v2/json/repos/show/Adman65').
        to_return(:body => api_response.to_json)

      mock_repo = mock(Github::Repo)
      Github::Repo.should_receive(:new).with('repo' => 'info').and_return(mock_repo)

      users(:Adman65).repos.should eql([mock_repo])
    end
  end

  it "should use the name for #to_s" do
    subject.name = 'Adman65'
    subject.to_s.should eql('Adman65')
  end
end
