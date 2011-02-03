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

    it "should return nil if the api returns anything other than success" do
      stub_request(:get, 'http://github.com/api/v2/json/repos/show/Adman65/cashier').
        to_return(:status => 4040)

      Github::Repo.find('Adman65', 'cashier').should be_nil
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
     
  describe '#number_of_closed_issues' do
    before(:each) do
      api_response = %Q{{
        "issues": [
          {
            "gravatar_id": "b8dbb1987e8e5318584865f880036796",
            "position": 1.0,
            "number": 8,
            "votes": 3,
            "created_at": "2010/01/22 17:56:29 -0800",
            "comments": 10,
            "body": "Maybe this? \r\n\r\n<http://www.htmldoc.org>",
            "title": "PDF",
            "updated_at": "2010/12/10 21:48:53 -0800",
            "closed_at": null,
            "user": "defunkt",
            "labels": [
              "feature"
            ],
            "state": "open"
          }
        ]
      }}

      stub_request(:get, 'http://github.com/api/v2/json/issues/list/schacon/showoff/closed').to_return(:body => api_response)
    end

    it "should use the issues array to determine the size" do
      repo = Github::Repo.new :name => 'showoff', :owner => 'schacon'
      repo.number_of_closed_issues.should eql(1)
    end
  end

  describe '#number_of_open_issues' do
    before(:each) do
      api_response = %Q{{
        "issues": [
          {
            "gravatar_id": "b8dbb1987e8e5318584865f880036796",
            "position": 1.0,
            "number": 8,
            "votes": 3,
            "created_at": "2010/01/22 17:56:29 -0800",
            "comments": 10,
            "body": "Maybe this? \r\n\r\n<http://www.htmldoc.org>",
            "title": "PDF",
            "updated_at": "2010/12/10 21:48:53 -0800",
            "closed_at": null,
            "user": "defunkt",
            "labels": [
              "feature"
            ],
            "state": "open"
          }
        ]
      }}

      stub_request(:get, 'http://github.com/api/v2/json/issues/list/schacon/showoff/open').to_return(:body => api_response)
    end

    it "should use the issues array to determine the size" do
      repo = Github::Repo.new :name => 'showoff', :owner => 'schacon'
      repo.number_of_open_issues.should eql(1)
    end
  end

  describe '#number_of_open_pull_requests' do
    before(:each) do
      api_response = %Q{
        {
          "pulls": [
            {
              "state": "open",
              "base": {
                "label": "technoweenie:master",
                "ref": "master",
                "sha": "53397635da83a2f4b5e862b5e59cc66f6c39f9c6"
              },
              "head": {
                "label": "smparkes:synchrony",
                "ref": "synchrony",
                "sha": "83306eef49667549efebb880096cb539bd436560"
              },
              "title": "Synchrony",
              "position": 4.0,
              "number": 15,
              "votes": 0,
              "comments": 4,
              "diff_url": "https://github.com/technoweenie/faraday/pull/15.diff",
              "patch_url": "https://github.com/technoweenie/faraday/pull/15.patch",
              "labels": [],
              "html_url": "https://github.com/technoweenie/faraday/pull/15",
              "issue_created_at": "2010-10-04T12:39:18-07:00",
              "issue_updated_at": "2010-11-04T16:35:04-07:00",
              "created_at": "2010-10-04T12:39:18-07:00",
              "updated_at": "2010-11-04T16:30:14-07:00"
            }
          ]
        }
      }

      stub_request(:get, 'http://github.com/api/v2/json/pulls/technoweenie/faraday/open').to_return(:body => api_response)
    end

    it "should use the pulls attribute to determine the size" do
      repo = Github::Repo.new :name => 'faraday', :owner => 'technoweenie'
      repo.number_of_open_pull_requests.should eql(1)
    end
  end

  describe '#number_of_closed_pull_requests' do
    before(:each) do
      api_response = %Q{
        {
          "pulls": [
            {
              "state": "closed",
              "base": {
                "label": "technoweenie:master",
                "ref": "master",
                "sha": "53397635da83a2f4b5e862b5e59cc66f6c39f9c6"
              },
              "head": {
                "label": "smparkes:synchrony",
                "ref": "synchrony",
                "sha": "83306eef49667549efebb880096cb539bd436560"
              },
              "title": "Synchrony",
              "position": 4.0,
              "number": 15,
              "votes": 0,
              "comments": 4,
              "diff_url": "https://github.com/technoweenie/faraday/pull/15.diff",
              "patch_url": "https://github.com/technoweenie/faraday/pull/15.patch",
              "labels": [],
              "html_url": "https://github.com/technoweenie/faraday/pull/15",
              "issue_created_at": "2010-10-04T12:39:18-07:00",
              "issue_updated_at": "2010-11-04T16:35:04-07:00",
              "created_at": "2010-10-04T12:39:18-07:00",
              "updated_at": "2010-11-04T16:30:14-07:00"
            }
          ]
        }
      }

      stub_request(:get, 'http://github.com/api/v2/json/pulls/technoweenie/faraday/closed').to_return(:body => api_response)
    end

    it "should use the pulls attribute to determine the size" do
      repo = Github::Repo.new :name => 'faraday', :owner => 'technoweenie'
      repo.number_of_closed_pull_requests.should eql(1)
    end
  end

  describe 'Repo#find_by_user_and_name' do
    it "should delegate to find" do
      Github::Repo.should_receive(:find).with('Adman65', 'cashier')
      Github::Repo.find_by_user_and_name('Adman65', 'cashier')
    end
  end

  describe '#has_readme?' do
    before(:each) do
      commits = %Q{
        commits: [{ tree: 'a6a09ebb4ca4b1461a'}]
      }

      stub_request(:get, 'http://github.com/api/v2/json/commits/list/Adman65/cashier/master').to_return(:body => commits)
    end

    subject { Github::Repo.new :owner => 'Adman65', :name => 'cashier' }

    it "should use the most recent commit to check the files" do
      tree = %Q{
        {
          tree: [
            { name: 'readme.md' },
            { name: 'Rakefile' }
          ]
        }
      }

      stub_request(:get, 'http://github.com/api/v2/json/tree/show/Adman65/cashier/a6a09ebb4ca4b1461a').to_return(:body => tree)

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

      stub_request(:get, 'http://github.com/api/v2/json/tree/show/Adman65/cashier/a6a09ebb4ca4b1461a').to_return(:body => tree)

      subject.should have_readme
    end
  end

  describe '#has_license?' do
    before(:each) do
      commits = %Q{
        commits: [{ tree: 'a6a09ebb4ca4b1461a'}]
      }

      stub_request(:get, 'http://github.com/api/v2/json/commits/list/Adman65/cashier/master').to_return(:body => commits)
    end

    subject { Github::Repo.new :owner => 'Adman65', :name => 'cashier' }

    it "should use the most recent commit to check the files" do
      tree = %Q{
        {
          tree: [
            { name: 'license' },
            { name: 'Rakefile' }
          ]
        }
      }

      stub_request(:get, 'http://github.com/api/v2/json/tree/show/Adman65/cashier/a6a09ebb4ca4b1461a').to_return(:body => tree)

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

      stub_request(:get, 'http://github.com/api/v2/json/tree/show/Adman65/cashier/a6a09ebb4ca4b1461a').to_return(:body => tree)

      subject.should have_license
    end
  end

  describe '#has_tests?' do
    before(:each) do
      commits = %Q{
        commits: [{ tree: 'a6a09ebb4ca4b1461a'}]
      }

      stub_request(:get, 'http://github.com/api/v2/json/commits/list/Adman65/cashier/master').to_return(:body => commits)
    end

    subject { Github::Repo.new :owner => 'Adman65', :name => 'cashier' }

    it "should have tests if there is a specs folder" do
      tree = %Q{
        {
          tree: [
            { name: 'spec', type: 'tree' },
            { name: 'Rakefile' }
          ]
        }
      }

      stub_request(:get, 'http://github.com/api/v2/json/tree/show/Adman65/cashier/a6a09ebb4ca4b1461a').to_return(:body => tree)

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

      stub_request(:get, 'http://github.com/api/v2/json/tree/show/Adman65/cashier/a6a09ebb4ca4b1461a').to_return(:body => tree)

      subject.should have_tests
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

    it "should have examples if there is an examples folder" do
      tree = %Q{
        {
          tree: [
            { name: 'examples', type: 'tree' },
            { name: 'Rakefile' }
          ]
        }
      }

      stub_request(:get, 'http://github.com/api/v2/json/tree/show/Adman65/cashier/a6a09ebb4ca4b1461a').to_return(:body => tree)

      subject.should have_examples
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

    it "should be true if there is a features directory" do
      tree = %Q{
        {
          tree: [
            { name: 'features', type: 'tree' },
            { name: 'Rakefile' }
          ]
        }
      }

      stub_request(:get, 'http://github.com/api/v2/json/tree/show/Adman65/cashier/a6a09ebb4ca4b1461a').to_return(:body => tree)

      subject.should have_features
    end
  end
end
