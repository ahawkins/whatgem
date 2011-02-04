require 'spec_helper'

describe UpdateRatingJob do
  it "should update the stats from gemcutter" do
    mock_gemcutter = mock(Gemcutter::Gem)
    Gemcutter::Gem.stub(:find).with('cashier').and_return(mock_gemcutter)

    mock_ruby_gem = mock_model(RubyGem, :name => 'cashier')
    RubyGem.stub(:find).with(1).and_return(mock_ruby_gem)

    mock_ruby_gem.should_receive(:from_gemcutter).and_return(mock_ruby_gem)
    mock_ruby_gem.should_receive(:save!)

    UpdateRatingJob.perform 1
  end
end
