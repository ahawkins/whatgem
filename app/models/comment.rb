class Comment < ActiveRecord::Base
  belongs_to :user
  belongs_to :ruby_gem, :touch => true

  validates :user_id, :ruby_gem_id, :presence => true
  validates :text, :presence => { :allow_blank => false }

  default_scope order('created_at ASC')
end
