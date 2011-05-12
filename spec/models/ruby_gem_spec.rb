require 'spec_helper'

describe RubyGem do
  fixtures(:ruby_gems)

  it { should have_and_belong_to_many(:related_gems) }

  it { should have_many(:dependencies).through(:gem_dependencies) }
  it { should have_many(:comments).dependent(:destroy) }
  it { should have_many(:votes).dependent(:destroy) }

  it { should validate_presence_of(:name, :description, :github_url) }

  it "should require a unique name" do
    subject.name = 'cashier'
    subject.should validate_uniqueness_of(:name)
  end

  it "should require a unique github repo" do
    subject.github_url = "https://gitihub.com/Adman65/cashier"
    subject.should validate_uniqueness_of(:github_url)
  end

  describe 'RubyGem#from_repo' do
    it "should create a new object then call from_repo" do
      mock_gem = mock(RubyGem)
      RubyGem.stub(:new => mock_gem)

      mock_repo = mock(Github::Repo)
      mock_gem.should_receive(:from_repo).with(mock_repo)
      RubyGem.from_repo(mock_repo)
    end
  end

  describe "RubyGem#create_from_gemcutter!" do
    it "should make a new gem and save it" do
      mock_ruby_gem = mock_model(RubyGem)
      RubyGem.stub! :new => mock_ruby_gem

      mock_gemcutter = mock(Gemcutter::Gem)

      mock_ruby_gem.should_receive(:from_gemcutter).with(mock_gemcutter).and_return(mock_ruby_gem)
      mock_ruby_gem.should_receive(:save!)

      RubyGem.create_from_gemcutter!(mock_gemcutter)
    end
  end

  describe "Rubygem#named" do
    it "should be case insensitive" do
      RubyGem.named('Cashier').should eql(ruby_gems(:cashier))
    end
  end
  
  it "should use the name for #to_s" do
    subject.name = 'rails'
    subject.to_s.should eql('rails')
  end

  describe '#closed_issue_precentage' do
    it "should be 0 if there are no issues" do
      subject.number_of_closed_issues = 0
      subject.number_of_open_issues = 0
      subject.closed_issue_percentage.should eql(0.0)
    end

    it "should use the total # of issues to calculate the close rate" do
      subject.number_of_closed_issues = 2
      subject.number_of_open_issues = 2
      subject.closed_issue_percentage.should eql(0.5) # (2/(2+2))
    end
  end

  describe '#merged_pull_request_percentage' do
    it "should be 1 if there are no pulls" do
      subject.number_of_closed_pull_requests = 0
      subject.number_of_open_pull_requests = 0
      subject.merged_pull_request_percentage.should eql(0.0)
    end

    it "should use the total # of issues to calculate the close rate" do
      subject.number_of_closed_pull_requests = 2
      subject.number_of_open_pull_requests = 2
      subject.merged_pull_request_percentage.should eql(0.5) # (2/(2+2))
    end
  end

  describe '#has_documentation?' do
    it "should be true if the documentation_url is present" do
      subject.documentation_url = 'http://rdoc.info'
      subject.should have_documentation
    end

    it "should be false if the documentation_url is blank" do
      subject.documentation_url = nil
      subject.should_not have_documentation
    end
  end

  describe "#from_gemcutter" do
    before(:each) do
      @gemcutter = mock(Gemcutter::Gem).as_null_object
      subject.stub(:from_repo)
    end

    it "should set the gem name from gemcutter" do
      @gemcutter.stub(:name => 'cashier')
      subject.from_gemcutter(@gemcutter)
      subject.name.should eql('cashier')
    end

    it "should set the description from gemcutter" do
      @gemcutter.stub(:info => 'Tag based caching')
      subject.from_gemcutter(@gemcutter)
      subject.description.should eql('Tag based caching')
    end

    it "should update the stats from the associated github repo" do
      @gemcutter.stub(:github_repo => mock(Github::Repo))
      subject.should_receive(:from_repo).with(@gemcutter.github_repo)
      subject.from_gemcutter(@gemcutter)
    end
  end

  describe '#from_repo' do
    before(:each) do
      @repo = mock(Github::Repo, :owner => 'Adman65').as_null_object
    end

    it "should set the github url from the repo" do
      @repo.stub :url => 'https://github.com/Adman65/cashier'
      subject.from_repo(@repo)
      subject.github_url.should eql('https://github.com/Adman65/cashier')
    end

    it "should set the number of closed issues" do
      @repo.stub :number_of_closed_issues => 0
      subject.from_repo(@repo)
      subject.number_of_closed_issues.should eql(0)
    end

    it "should set the number of open issues" do
      @repo.stub :number_of_open_issues => 0
      subject.from_repo(@repo)
      subject.number_of_open_issues.should eql(0)
    end

    it "should set the number of open pull requests" do
      @repo.stub :number_of_open_pull_requests => 0
      subject.from_repo(@repo)
      subject.number_of_open_pull_requests.should eql(0)
    end

    it "should set the number of closed pull requests" do
      @repo.stub :number_of_closed_pull_requests => 0
      subject.from_repo(@repo)
      subject.number_of_closed_pull_requests.should eql(0)
    end

    it "should set the readme flag" do
      @repo.stub :has_readme? => true
      subject.from_repo(@repo)
      subject.should have_readme
    end

    it "should ste the license flag" do
      @repo.stub :has_license? => true
      subject.from_repo(@repo)
      subject.should have_license
    end

    it "should set the examples flag" do
      @repo.stub :has_examples? => true
      subject.from_repo(@repo)
      subject.should have_examples
    end
  end

  describe "#up_vote_percentage" do
    it "should be 0 if there are no votes" do
      RubyGem.new.up_vote_percentage.should eql(0.0)
    end

    it "should be the ratio of up votes over total votes" do
      ruby_gem = ruby_gems(:cashier)
      5.times { Vote.make(:down, :ruby_gem => ruby_gem) }
      5.times { Vote.make(:up, :ruby_gem => ruby_gem) }

      ruby_gem.up_vote_percentage.should eql(0.5)
    end
  end

  describe "#calculate_rating" do
    before(:each) do
      subject.rating = 0
    end

    it "should get 40% for passing all tests" do

      mock_log = 'real log goes here'

      subject.test_log = mock_log
      LogAnalyzer.should_receive(:pass_rate).with(mock_log).and_return(1.0)

      lambda { subject.calculate_rating }.should change(subject, :rating).by(0.4)
    end

    it "should get 20% for having documentation" do
      subject.documentation_url = 'http://rdoc.info/gem/name'
      lambda { subject.calculate_rating }.should change(subject, :rating).by(0.2)
    end

    it "should get 10% for having a readme" do
      subject.has_readme = true
      lambda { subject.calculate_rating }.should change(subject, :rating).by(0.1)
    end

    it "should get 5% for having examples" do
      subject.has_examples = true
      lambda { subject.calculate_rating }.should change(subject, :rating).by(0.05)
    end

    it "should get 5% for having a license" do
      subject.has_license = true
      lambda { subject.calculate_rating }.should change(subject, :rating).by(0.05)
    end

    it "should get 5% for having closed issues issues" do
      subject.number_of_open_issues = 0
      subject.number_of_closed_issues = 1
      lambda { subject.calculate_rating }.should change(subject, :rating).by(0.05)
    end

    it "should get 5% for having handled pull requests" do
      subject.number_of_open_pull_requests = 0
      subject.number_of_closed_pull_requests = 1
      lambda { subject.calculate_rating }.should change(subject, :rating).by(0.05)
    end

    it "should get 10% from vote percentage" do
      cashier = ruby_gems(:cashier)
      cashier.rating = 0
      Vote.make(:up, :ruby_gem => cashier)
      lambda { cashier.calculate_rating }.should change(cashier, :rating).by(0.1)
    end

    it "should get half a precent for each comment" do
      cashier = ruby_gems(:cashier)
      cashier.rating = 0
      Comment.make :ruby_gem => cashier
      lambda { cashier.calculate_rating }.should change(cashier, :rating).by(0.005)
    end

    it "should never be more than 100%" do
      cashier = ruby_gems(:cashier)
      cashier.stub_chain(:comments, :count).and_return(10000000)
      cashier.calculate_rating
      cashier.rating.should eql(1.0)
    end
  end

  it "should use the name for the parameter" do
    subject.name = 'cashier'
    subject.to_param.should eql('cashier')
  end

  describe "Setting the gem dependencies" do
    let(:redis) { ruby_gems(:redis) }
    let(:memcached) { ruby_gems(:memcached) }

    it "should find existing gems by the name" do
      subject.dependent_names = [redis.name, memcached.name]
      subject.save!
      subject.dependencies.should include(redis)
      subject.dependencies.should include(memcached)
    end

    it "should import new gems that haven't been imported yet" do
      subject.dependent-names = ['rails']
      subject.save!
      Resque.should_receive(:enqueue).with(ImportGemJob, 'rails')
    end
  end
end
