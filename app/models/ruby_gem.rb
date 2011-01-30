class RubyGem < ActiveRecord::Base
  belongs_to :user

  validates :name, :description, :homepage, :presence => true
  validates :name, :uniqueness => true

  acts_as_taggable_on :tags
end
