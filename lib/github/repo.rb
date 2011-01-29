require 'httparty'

module Github
  class Repo
    include HTTParty
    format :json

    attr_accessor :has_issues, :url, :watchers, :forks, :created_at, :pushed_at,
      :has_wiki, :name, :owner, :description, :open_issues

    def initialize(attributes = {}) 
      attributes.each_pair do |name, value|
        self.send("#{name}=", value)
      end
    end

    def user
      owner
    end

    def self.find(user, repo_name)
      new(get('http://github.com/api/v2/json/repos/show/%s/%s' % [user, repo_name]).
         parsed_response['repository'].except('has_downloads', 'fork', 'size', 'private'))
    end
  end
end
