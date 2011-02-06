class Vote < ActiveRecord::Base
  belongs_to :user
  belongs_to :ruby_gem, :touch => true

  scope :up, where('votes.up' => true)
  scope :down, where('votes.up' => false)
end
