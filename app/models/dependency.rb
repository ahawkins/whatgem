class Dependency < ActiveRecord::Base
  belongs_to :ruby_gem
  belongs_to :dependent_ruby_gem, :class_name => "RubyGem"
end
