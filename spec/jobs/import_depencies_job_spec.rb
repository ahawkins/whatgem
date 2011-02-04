require 'spec_helper'

describe ImportDependencyJob do

  it "should import runtime dependencies" do
    gemcutter = mock(Gemcutter::Gem, :dependencies => {
      'runtime' => [{'name' => 'activesupport'}], 'development' => [{}]
    })

    Gemcutter::Gem.stub(:find).with('rails').and_return(gemcutter)

    Resque.should_receive(:enqueue).with(ImportGemJob, 'activesupport')

    ImportDependencyJob.perform('rails')
  end

  it "should import development dependencies" do
    gemcutter = mock(Gemcutter::Gem, :dependencies => {
      'development' => [{'name' => 'activesupport'}], 'runtime' => [{}]
    })

    Gemcutter::Gem.stub(:find).with('rails').and_return(gemcutter)

    Resque.should_receive(:enqueue).with(ImportGemJob, 'activesupport')

    ImportDependencyJob.perform('rails')
  end
end
