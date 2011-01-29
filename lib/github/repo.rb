require 'httparty'

module Github
  class Repo
    include HTTParty
    format :json

    ATTRIBUTES = [
      :has_issues, :url, :watchers,
      :forks, :created_at, :pushed_at,
      :has_wiki, :name, :owner, 
      :description, :open_issues
    ]
    
    ATTRIBUTES.each {|attr| attr_accessor attr }

    def initialize(attributes = {}) 
      our_attributes = attributes.symbolize_keys.slice(*ATTRIBUTES)

      our_attributes.each_pair do |name, value|
        self.send("#{name}=", value)
      end
    end

    def user
      owner
    end

    def self.find(user, repo_name)
      res = get('http://github.com/api/v2/json/repos/show/%s/%s' % [user, repo_name])
      new(res.parsed_response['repository'])
    end

    def self.find_by_user_and_name(user, name)
      find(user, name)
    end
  end
end
