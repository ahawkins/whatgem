require 'spec_helper'

# Specs in this file have access to a helper object that includes
# the RubyGemsHelper. For example:
#
# describe RubyGemsHelper do
#   describe "string concat" do
#     it "concats two strings with spaces" do
#       helper.concat_strings("this","that").should == "this that"
#     end
#   end
# end
describe RubyGemsHelper do
  describe '#link_to_ruby_gems' do
    it "should use the name to create the url" do
      ruby_gem = RubyGem.new :name => 'rails'
      helper.should_receive(:link_to).with('RubyGems', 'http://rubygems.org/gems/rails', {})
      helper.link_to_ruby_gems(ruby_gem)
    end
  end

  describe '#link_to_test_results' do
    it "should use the name to create the url" do
      ruby_gem = RubyGem.new :name => 'rails'
      helper.should_receive(:link_to).with('Test Results', 'http://gem-testers.org/gems/rails', {})
      helper.link_to_test_results(ruby_gem)
    end
  end

  describe '#link_to_github' do
    it "should use the githubl url to create the url" do
      ruby_gem = RubyGem.new :github_url => 'https://github.com/rails/rails'
      helper.should_receive(:link_to).with('Github', 'https://github.com/rails/rails', {})
      helper.link_to_github(ruby_gem)
    end
  end
end
