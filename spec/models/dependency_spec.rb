require 'spec_helper'

describe Dependency do
  it { should belong_to(:ruby_gem) }
  it { should belong_to(:dependent_ruby_gem).class_name('RubyGem') }
end
