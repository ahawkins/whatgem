require 'spec_helper'

describe Github::Repo do
  fixtures(:users)

  describe 'Repo#find' do
    it "should use the github api to get the info" do
      api_response = {"repository" => 
        { "has_issues" => true, 
          "url"=>"https://github.com/Adman65/cashier",
          "watchers" => 2, 
          "forks" => 2,
          "has_downloads" => true, 
          "fork" => false,
          "created_at" => "2010/12/30 01:43:20 -0800", 
          "pushed_at"=> "2011/01/05 19:50:17 -0800", 
          "size" => 568, 
          "private" => false,
          "has_wiki" => true, 
          "name" => "cashier", 
          "owner" => "Adman65", 
          "description" => "TODO: one-line summary of your gem", 
          "open_issues" => 0 
        }
      }

      api_url = 'http://github.com/api/v2/json/repos/show/Adman65/cashier'

      stub_request(:get, api_url).to_return(:body => api_response.to_json)
      mock_repo = mock(Github::Repo)

      Github::Repo.should_receive(:new).with(api_response['repository']).
        and_return(mock_repo)

      Github::Repo.find('Adman65', 'cashier').should eql(mock_repo)
    end
  end

  describe "#new" do
   attributes = {
      "has_issues" => true, 
      "url"=>"https://github.com/adman65/cashier",
      "watchers" => 2, 
      "forks" => 2,
      "created_at" => "2010/12/30 01:43:20 -0800", 
      "pushed_at"=> "2011/01/05 19:50:17 -0800", 
      "has_wiki" => true, 
      "name" => "cashier", 
      "owner" => "Adman65", 
      "description" => "Fancy caching!", 
      "open_issues" => 0 
    }.each_pair do |attr, value|
      it "should set #{attr}" do
        repo = Github::Repo.new(attr => value)
        repo.send(attr).should eql(value)
      end
    end
  end

  describe '#user' do
    it "should be an alias for the owner" do
      subject.owner = 'Adman65'
      subject.user.should eql('Adman65')
    end
  end

  describe "#repos" do
    subject { users(:Adman65) }

    it "should create an array of repos using the github api" do
      api_url = "http://github.com/api/v2/json/repos/show/Adman65"
      User.stub!(:get).with(api_url).and_return({'repositories' => [{:repo => :data}]})

      mock_repo = mock(Github::Repo)
      Github::Repo.should_receive(:new).with(:repo => :data).and_return(mock_repo)

      subject.repos.should eql([mock_repo])
    end
  end
     

  describe 'Repo#find_by_user_and_name' do
    it "should delegate to find" do
      Github::Repo.should_receive(:find).with('Adman65', 'cashier')
      Github::Repo.find_by_user_and_name('Adman65', 'cashier')
    end
  end
end
