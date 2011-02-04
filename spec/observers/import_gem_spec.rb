require 'spec_helper'

describe ImportGemJob do
  it "should create a gem using the gemcutter information" do
    mock_gemcutter = mock(Gemcutter::Gem)
    Gemcutter::Gem.stub(:find).with('rails').and_return(mock_gemcutter)

    RubyGem.should_receive(:create_from_gemcutter!).with(mock_gemcutter)

    ImportGemJob.perform 'rails'
  end
end

