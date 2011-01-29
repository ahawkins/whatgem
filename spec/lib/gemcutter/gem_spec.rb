require 'spec_helper'

describe Gemcutter::Gem do
  describe 'Repo#find' do
    it "should use Httparty to get info" do
      mock_response = mock(HTTParty::Response, :parsed_response => {})
      Gemcutter::Gem.should_receive(:get).with('http://rubygems.org/api/v1/gems/rails.json').
        and_return(mock_response)
      Gemcutter::Gem.find('rails')
    end

    it "should use the hash to create a new repo" do
      api_response = {
        "name" => "rails",
        "info" => "Agile web framework",
        "version" => "2.3.5",
        "version_downloads" => 2451,
        "authors" => "David Heinemeier Hansson",
        "downloads" => 134451,
        "project_uri" => "http://rubygems.org/gems/rails",
        "gem_uri" => "http://rubygems.org/gems/rails-2.3.5.gem",
        "homepage_uri" => "http://www.rubyonrails.org/",
        "wiki_uri" => "http://wiki.rubyonrails.org/",
        "documentation_uri" => "http://api.rubyonrails.org/",
        "mailing_list_uri" => "http://groups.google.com/group/rubyonrails-talk",
        "source_code_uri" => "http://github.com/rails/rails",
        "bug_tracker_uri" => "http://rails.lighthouseapp.com/projects/8994-ruby-on-rails",
        "dependencies" => {}
      }

      mock_response = mock(HTTParty::Response, :parsed_response => api_response)
      mock_gem = mock(Gemcutter::Gem)

      Gemcutter::Gem.stub!(:get => mock_response)

      Gemcutter::Gem.should_receive(:new).with(api_response.slice('name',
        'info', 'downloads', 'project_uri', 'homepage_uri',
        'documentation_uri','source_code_uri', 'authors')).and_return(mock_gem)

      Gemcutter::Gem.find('rails').should eql(mock_gem)
    end
  end


  describe "#new" do
    attributes = {
      "name" => "rails",
      "info" => "Agile web framework",
      "authors" => "David Heinemeier Hansson",
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

