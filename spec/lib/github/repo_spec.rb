require 'spec_helper'

describe Github::Repo do
  fixtures(:users)

  describe 'Repo#find_by_user_and_name' do
    it "should delegate to find" do
      Github::Repo.should_receive(:find).with('Adman65', 'cashier')
      Github::Repo.find_by_user_and_name('Adman65', 'cashier')
    end
  end

  describe 'Repo#find' do
    let(:api_url) {
      'http://github.com/api/v2/json/repos/show/Adman65/cashier'
    }

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
      stub_request(:get, api_url).to_return(:body => api_response.to_json)
      mock_repo = mock(Github::Repo)
      Github::Repo.should_receive(:new).with(api_response['repository']).and_return(mock_repo)

      Github::Repo.find('Adman65', 'cashier').should eql(mock_repo)
    end

    it "should raise an error if the repo does not exists" do
      stub_request(:get, api_url).
        to_return(:status => 404)

      lambda { Github::Repo.find('Adman65', 'cashier') }.should raise_error
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

  describe '#number_of_closed_issues' do
    subject { Github::Repo.new :name => 'showoff', :owner => 'schacon' }

    let(:api_url) { 'http://github.com/api/v2/json/issues/list/schacon/showoff/closed' }

    it "should use the issues array to determine the size" do
      api_response = %Q{{"issues": [{}]}}
      stub_request(:get, api_url).to_return(:body => api_response)

      subject.number_of_closed_issues.should eql(1)
    end

    it "should raise an error if the rate limit is exceeded" do
      stub_request(:get, api_url).to_return(:status => 403)
      lambda { subject.number_of_closed_issues}.
        should raise_error(Github::RateLimitExceeded)
    end
  end

  describe '#number_of_open_issues' do
    subject { Github::Repo.new :name => 'showoff', :owner => 'schacon' }

    let(:api_url) { 'http://github.com/api/v2/json/issues/list/schacon/showoff/open' }

    it "should use the issues array to determine the size" do
      api_response = %Q{{"issues": [{}]}}
      stub_request(:get, api_url).to_return(:body => api_response)

      subject.number_of_open_issues.should eql(1)
    end

    it "should raise an error if the rate limit is exceeded" do
      stub_request(:get, api_url).to_return(:status => 403)
      lambda { subject.number_of_open_issues}.
        should raise_error(Github::RateLimitExceeded)
    end
  end

  describe '#number_of_open_pull_requests' do
    subject { Github::Repo.new :name => 'faraday', :owner => 'technoweenie' }

    let(:api_url) { 'http://github.com/api/v2/json/pulls/technoweenie/faraday/open' }

    it "should use the pulls attribute to determine the size" do
      api_response = %Q{{"pulls": [{}]}}
      stub_request(:get, api_url).to_return(:body => api_response)
      subject.number_of_open_pull_requests.should eql(1)
    end

    it "should raise an error if the rate limit is exceeded" do
      stub_request(:get, api_url).to_return(:status => 403)
      lambda { subject.number_of_open_pull_requests}.
        should raise_error(Github::RateLimitExceeded)
    end
  end

  describe '#number_of_closed_pull_requests' do
    subject { Github::Repo.new :name => 'faraday', :owner => 'technoweenie' }

    let(:api_url) { 'http://github.com/api/v2/json/pulls/technoweenie/faraday/closed' }

    it "should use the pulls attribute to determine the size" do
      api_response = %Q{{"pulls": [{}]}}
      stub_request(:get, api_url).to_return(:body => api_response)
      subject.number_of_closed_pull_requests.should eql(1)
    end

    it "should raise an error if the rate limit is exceeded" do
      stub_request(:get, api_url).to_return(:status => 403)
      lambda { subject.number_of_closed_pull_requests}.
        should raise_error(Github::RateLimitExceeded)
    end
  end

  describe '#has_readme?' do
    before(:each) do
      commits = %Q{commits: [{ tree: 'a6a09ebb4ca4b1461a'}]}
      stub_request(:get, 'http://github.com/api/v2/json/commits/list/Adman65/cashier/master').to_return(:body => commits)
    end

    subject { Github::Repo.new :owner => 'Adman65', :name => 'cashier' }

    let(:api_url) { 'http://github.com/api/v2/json/tree/show/Adman65/cashier/a6a09ebb4ca4b1461a' }

    it "should use the most recent commit to check the files" do
      tree = %Q{
        {
          tree: [
            { name: 'readme.md' },
            { name: 'Rakefile' }
          ]
        }
      }

      stub_request(:get, api_url).to_return(:body => tree)

      subject.should have_readme
    end


    it "should be case insensitive" do
      tree = %Q{
        {
          tree: [
            { name: 'README.md' },
            { name: 'Rakefile' }
          ]
        }
      }

      stub_request(:get, api_url).to_return(:body => tree)

      subject.should have_readme
    end

    it "should raise an error if the rate limit is exceeded" do
      stub_request(:get, api_url).to_return(:status => 403)

      lambda { subject.has_readme? }.should raise_error(Github::RateLimitExceeded)
    end
  end

  describe '#has_license?' do
    before(:each) do
      commits = %Q{commits: [{ tree: 'a6a09ebb4ca4b1461a'}]}
      stub_request(:get, 'http://github.com/api/v2/json/commits/list/Adman65/cashier/master').to_return(:body => commits)
    end

    subject { Github::Repo.new :owner => 'Adman65', :name => 'cashier' }

    let(:api_url) { 'http://github.com/api/v2/json/tree/show/Adman65/cashier/a6a09ebb4ca4b1461a' }

    it "should use the most recent commit to check the files" do
      tree = %Q{
        {
          tree: [
            { name: 'license' },
            { name: 'Rakefile' }
          ]
        }
      }

      stub_request(:get, api_url).to_return(:body => tree)

      subject.should have_license
    end


    it "should be case insensitive" do
      tree = %Q{
        {
          tree: [
            { name: 'LICENSE' },
            { name: 'Rakefile' }
          ]
        }
      }

      stub_request(:get, api_url).to_return(:body => tree)

      subject.should have_license
    end

    it "should raise an error if the rate limit is exceeded" do
      stub_request(:get, api_url).to_return(:status => 403)
      lambda { subject.has_license? }.
        should raise_error(Github::RateLimitExceeded)
    end
  end

  describe '#has_tests?' do
    before(:each) do
      commits = %Q{commits: [{ tree: 'a6a09ebb4ca4b1461a'}]}
      stub_request(:get, 'http://github.com/api/v2/json/commits/list/Adman65/cashier/master').to_return(:body => commits)
    end

    subject { Github::Repo.new :owner => 'Adman65', :name => 'cashier' }

    let(:api_url) { 'http://github.com/api/v2/json/tree/show/Adman65/cashier/a6a09ebb4ca4b1461a' }

    it "should have tests if there is a specs folder" do
      tree = %Q{
        {
          tree: [
            { name: 'spec', type: 'tree' },
            { name: 'Rakefile' }
          ]
        }
      }

      stub_request(:get, api_url).to_return(:body => tree)

      subject.should have_tests
    end


    it "should have tests if there is a test folder" do
      tree = %Q{
        {
          tree: [
            { name: 'test', type: 'tree' },
            { name: 'Rakefile' }
          ]
        }
      }

      stub_request(:get, api_url).to_return(:body => tree)

      subject.should have_tests
    end

    it "should raise an error if the rate limit is exceeded" do
      stub_request(:get, api_url).to_return(:status => 403)
      lambda { subject.has_tests? }.
        should raise_error(Github::RateLimitExceeded)
    end
  end

  describe '#has_examples?' do
    before(:each) do
      commits = %Q{
        commits: [{ tree: 'a6a09ebb4ca4b1461a'}]
      }

      stub_request(:get, 'http://github.com/api/v2/json/commits/list/Adman65/cashier/master').to_return(:body => commits)
    end

    subject { Github::Repo.new :owner => 'Adman65', :name => 'cashier' }

    let(:api_url) { 'http://github.com/api/v2/json/tree/show/Adman65/cashier/a6a09ebb4ca4b1461a' }

    it "should have examples if there is an examples folder" do
      tree = %Q{
        {
          tree: [
            { name: 'examples', type: 'tree' },
            { name: 'Rakefile' }
          ]
        }
      }

      stub_request(:get, api_url).to_return(:body => tree)

      subject.should have_examples
    end

    it "should raise an error if the rate limit is exceeded" do
      stub_request(:get, api_url).to_return(:status => 403)
      lambda { subject.has_examples? }.
        should raise_error(Github::RateLimitExceeded)
    end
  end

  describe '#has_features?' do
    before(:each) do
      commits = %Q{
        commits: [{ tree: 'a6a09ebb4ca4b1461a'}]
      }

      stub_request(:get, 'http://github.com/api/v2/json/commits/list/Adman65/cashier/master').to_return(:body => commits)
    end

    subject { Github::Repo.new :owner => 'Adman65', :name => 'cashier' }

    let(:api_url) { 'http://github.com/api/v2/json/tree/show/Adman65/cashier/a6a09ebb4ca4b1461a' }

    it "should be true if there is a features directory" do
      tree = %Q{
        {
          tree: [
            { name: 'features', type: 'tree' },
            { name: 'Rakefile' }
          ]
        }
      }

      stub_request(:get, api_url).to_return(:body => tree)

      subject.should have_features
    end

    it "should raise an error if the rate limit is exceeded" do
      stub_request(:get, api_url).to_return(:status => 403)
      lambda { subject.has_features? }.
        should raise_error(Github::RateLimitExceeded)
    end
  end
end
