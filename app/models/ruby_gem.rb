class RubyGem < ActiveRecord::Base
  belongs_to :user

  validates :name, :description, :presence => true
  validates :name, :uniqueness => true
end
