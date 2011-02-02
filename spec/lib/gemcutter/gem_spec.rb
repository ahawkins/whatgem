require 'spec_helper'

describe Gemcutter::Gem do
  describe 'Gemcutter::Gem#find' do
    it "use the gemcutter api to find the info" do
      
      api_response = %Q{
        {
          "name": "rails",
          "info": "Rails is a framework for building web-application using CGI, FCGI, mod_ruby,
                   or WEBrick on top of either MySQL, PostgreSQL, SQLite, DB2, SQL Server, or 
                   Oracle with eRuby- or Builder-based templates.",
          "version": "2.3.5",
          "version_downloads": 2451,
          "authors": "David Heinemeier Hansson",
          "downloads": 134451,
          "project_uri": "http://rubygems.org/gems/rails",
          "gem_uri": "http://rubygems.org/gems/rails-2.3.5.gem",
          "homepage_uri": "http://www.rubyonrails.org/",
          "wiki_uri": "http://wiki.rubyonrails.org/",
          "documentation_uri": "http://api.rubyonrails.org/",
          "mailing_list_uri": "http://groups.google.com/group/rubyonrails-talk",
          "source_code_uri": "http://github.com/rails/rails",
          "bug_tracker_uri": "http://rails.lighthouseapp.com/projects/8994-ruby-on-rails",
          "dependencies": {
            "runtime": [
              {
                "name": "activesupport",
                "requirements": ">= 2.3.5"
              }
            ],
            "development": [ ]
          }
        }
      }        
      
      api_url = 'http://rubygems.org/api/v1/gems/rails.json'
      stub_request(:get, api_url).to_return(:body => api_response, :status => 200)
      mock_gem = mock(Gemcutter::Gem)

      Gemcutter::Gem.should_receive(:new).with(ActiveSupport::JSON.decode(api_response)).and_return(mock_gem)
      Gemcutter::Gem.find('rails').should eql(mock_gem)
    end

    it "should return nil when the api returns something other than success" do
      stub_request(:get, 'http://rubygems.org/api/v1/gems/rails.json').to_return(:status => 404)
      Gemcutter::Gem.find('rails').should be_nil
    end
  end


  describe "#new" do
    attributes = {
      "name" => "rails",
      "info" => "Agile web framework",
      "downloads" => 134451,
      "project_uri" => "http://rubygems.org/gems/rails",
      "homepage_uri" => "http://www.rubyonrails.org/",
      "documentation_uri" => "http://api.rubyonrails.org/",
      "source_code_uri" => "http://github.com/rails/rails",
    }.each_pair do |attr, value|
      it "should set #{attr}" do
        repo = Gemcutter::Gem.new(attr => value)
        repo.send(attr).should eql(value)
      end
    end
  end


  describe "#project_url" do
    it "should be an alias for project_uri" do
      subject.project_uri = "test.com"
      subject.project_url.should eql('test.com')
    end
  end
  
  describe "#homepage_url" do
    it "should be an alias for documentation_uri" do
      subject.homepage_uri = "test.com"
      subject.homepage_url.should eql('test.com')
    end
  end

  describe "#documentation_url" do
    it "should be an alias for documentation_uri" do
      subject.documentation_uri = "test.com"
      subject.documentation_url.should eql('test.com')
    end
  end
  
  describe "#source_code_uri" do
    it "should be an alias for source_code_uri" do
      subject.source_code_uri = "test.com"
      subject.source_code_url.should eql('test.com')
    end
  end

  describe '#gitub_repo' do
    describe "When the source url is a github address" do
      subject { Gemcutter::Gem.new(:source_code_uri => 'http://github.com/Adman65/cashier') }

      it "should find the github repo from the github url" do
        mock_repo = mock(Github::Repo)
        Github::Repo.should_receive(:find).with('Adman65', 'cashier').and_return(mock_repo)
        subject.github_repo.should eql(mock_repo)
      end
    end

    describe "When the homepage is a git address" do
      subject { Gemcutter::Gem.new(:homepage_uri => 'http://github.com/Adman65/cashier') }

      it "should find the github repo from the github url" do
        mock_repo = mock(Github::Repo)
        Github::Repo.should_receive(:find).with('Adman65', 'cashier').and_return(mock_repo)
        subject.github_repo.should eql(mock_repo)
      end
    end


    describe "When neither match" do
      it "should be nil" do
        subject.github_repo.should be_nil
      end
    end
  end
end

