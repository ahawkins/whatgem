class User < ActiveRecord::Base
  include HTTParty
  format :json

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :omniauthable, :trackable, :token_authenticatable

  has_many :ruby_gems, :dependent => :destroy

  validates :user_name, :presence => true, :uniqueness => true

  def self.find_for_github_oauth(access_token, signed_in_resource=nil)
    data = access_token['user_info']
    
    if user = User.find_by_user_name(data["nickname"])
      user
    else # Create an user with a stub password. 
      User.create! do |user|
        user.user_name = data['nickname']
      end
    end
  end

  def self.find_by_user_name(user_name)
    where(["LOWER(user_name) = ?", user_name.downcase]).first
  end

  def repos
    response = User.get("http://github.com/api/v2/json/repos/show/#{user_name}")['repositories']
    response.map { |info| Github::Repo.new info }
  end

  def build_gems_from_github_and_rubygems
    possible_gems = repos.map { |repo| RubyGem.new :name => repo.name, :description => repo.description }
    possible_gems = possible_gems.select do |repo|
      begin
        gemcutter_gem = Gemcutter::Gem.find(repo.name)
        repo.homepage = gemcutter_gem.homepage
        true
      rescue
        false
      end
    end
    possible_gems.reject {|gem| RubyGem.exists?(['LOWER(name) = ?', gem.name.downcase]) }
  end
end
