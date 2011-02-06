class User < ActiveRecord::Base
  include HTTParty
  format :json

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :omniauthable, :trackable, :token_authenticatable

  has_many :ruby_gems, :dependent => :destroy

  validates :name, :presence => true, :uniqueness => true

  def self.find_for_github_oauth(access_token, signed_in_resource=nil)
    data = access_token['user_info']
    
    if user = User.find_by_name(data["nickname"])
      user
    else # Create an user with a stub password. 
      User.create! do |user|
        user.name = data['nickname']
        user.gravatar_id = access_token['extra']['user_hash']['gravatar_id']
      end
    end
  end

  def self.find_or_create_by_name!(name)
    if user = where(["LOWER(name) = ?", name.downcase]).first
      user
    else
      User.create! :name => name
    end
  end

  def repos
    response = User.get("http://github.com/api/v2/json/repos/show/#{name}")['repositories']
    response.map { |info| Github::Repo.new info }
  end

  def to_s
    name
  end

  def build_gems_from_github_and_rubygems
    possible_gems = repos.select(&:has_gemspec?)
    possible_gems = possible_gems.reject { |r| RubyGem.named(r.name).present? }
    possible_gems = possible_gems.select { |r| Gemcutter::Gem.find(r.name).present? }
    possible_gems.map {|repo| RubyGem.from_repo(repo)}  
  end
end
