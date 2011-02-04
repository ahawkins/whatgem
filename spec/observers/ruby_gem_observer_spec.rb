require 'spec_helper'

describe RubyGemObserver do
  it "should enqueue a job to import dependencies" do
    mock_ruby_gem = mock_model(RubyGem, :name => 'rails')
    Resque.should_receive(:enqueue).with(ImportDependencyJob, 'rails')

    observer.after_create(mock_ruby_gem)
  end
end
