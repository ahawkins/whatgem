require 'spec_helper'

describe Github::Repo do
  describe 'Repo#find' do
    it "should use Httparty to get info" do
      mock_response = mock(HTTParty::Response, :parsed_response => {'repository' => {}})
      Github::Repo.should_receive(:get).with('http://github.com/api/v2/json/repos/show/Adman65/cashier').
        and_return(mock_response)
      Github::Repo.find('Adman65', 'cashier')
    end

    it "should use the hash to create a new repo" do
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

      mock_response = mock(HTTParty::Response, :parsed_response => api_response)
      mock_repo = mock(Github::Repo)

      Github::Repo.stub!(:get => mock_response)

      Github::Repo.should_receive(:new).with(api_response['repository'].
        except('has_downloads', 'fork', 'size', 'private')).
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
end
