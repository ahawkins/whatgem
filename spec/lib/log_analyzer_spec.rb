require 'spec_helper'

describe LogAnalyzer do
  subject { LogAnalyzer }

  describe "Test::Unit" do
    it "should count failures" do
      log = "24 tests, 38 assertions, 9 failures, 0 errors, 0 skips"
      subject.pass_rate(log).should eql(15.0/24.0)
    end

    it "should count errors as failures" do
      log = "24 tests, 38 assertions, 0 failures, 4 errors, 0 skips"
      subject.pass_rate(log).should eql(20.0/24.0)
    end

    it "should count errors as failures" do
      log = "29 tests, 2907 assertions, 0 failures, 0 errors"
      subject.pass_rate(log).should eql(1.0)
    end
  end

  describe "Rspec" do
    it "should count failures" do
      log = "116 examples, 10 failures, 1 pending"
      subject.pass_rate(log).should eql(106.0/116.0)
    end
  end

  it "should be 0 if there is no log" do
    subject.pass_rate(nil).should eql(0.0)
    subject.pass_rate("").should eql(0.0)
  end

  it "should be 0 if the log is junk" do
    subject.pass_rate("adfs98743mo8u7").should eql(0.0)
  end
end
