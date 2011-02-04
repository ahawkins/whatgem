require 'spec_helper'

describe RubyGem do
  fixtures(:ruby_gems)

  it { should validate_presence_of(:name, :description, :github_url) }

  describe 'RubyGem#from_repo' do
    it "should create a new object then call from_repo" do
      mock_gem = mock(RubyGem)
      RubyGem.stub(:new => mock_gem)

      mock_repo = mock(Github::Repo)
      mock_gem.should_receive(:from_repo).with(mock_repo)
      RubyGem.from_repo(mock_repo)
    end
  end
  
  it "should require a unique name" do
    subject.name = 'cashier'
    subject.should validate_uniqueness_of(:name)
  end

  it "should require a unique github repo" do
    subject.github_url = "https://gitihub.com/Adman65/cashier"
    subject.should validate_uniqueness_of(:github_url)
  end

  it "should use the name for #to_s" do
    subject.name = 'rails'
    subject.to_s.should eql('rails')
  end

  describe '#closed_issue_precentage' do
    it "should be 1 if there are no issues" do
      subject.number_of_closed_issues = 0
      subject.number_of_open_issues = 0
      subject.closed_issue_percentage.should eql(100)
    end

    it "should use the total # of issues to calculate the close rate" do
      subject.number_of_closed_issues = 2
      subject.number_of_open_issues = 2
      subject.closed_issue_percentage.should eql(50.0) # (2/(2+2))
    end
  end

  describe '#merged_pull_request_percentage' do
    it "should be 1 if there are no pulls" do
      subject.number_of_closed_pull_requests = 0
      subject.number_of_open_pull_requests = 0
      subject.merged_pull_request_percentage.should eql(100)
    end

    it "should use the total # of issues to calculate the close rate" do
      subject.number_of_closed_pull_requests = 2
      subject.number_of_open_pull_requests = 2
      subject.merged_pull_request_percentage.should eql(50.0) # (2/(2+2))
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

  describe '#from_repo' do
    it "should do a lot of things \o/"
  end

  it "should calculate the rating before the record is saved" do
    subject.stub!(:valid? => true)
    subject.should_receive(:calculate_rating)
    subject.save
  end
end
