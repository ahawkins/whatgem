class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :omniauthable, :trackable, :token_authenticatable

  validates :user_name, :presence => true, :uniqueness => true

  def self.find_for_github_oauth(access_token, signed_in_resource=nil)
    user_info = access_token.user_info
    
    if user = User.find_by_user_name(data["nickname"])
      user
    else # Create an user with a stub password. 
      user = User.new
      user.user_name = data['nickname']
      user.save!
      user
    end
  end
end
