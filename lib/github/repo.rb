require 'httparty'

module Github
  class RateLimitExceeded < RuntimeError ; end 

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

    def self.find(user, repo_name)
      res = get_with_success('http://github.com/api/v2/json/repos/show/%s/%s' % [user, repo_name])
      new(res.parsed_response['repository'])
    end

    def self.find_by_user_and_name(user, name)
      find(user, name)
    end

    def initialize(attributes = {}) 
      our_attributes = attributes.symbolize_keys.slice(*ATTRIBUTES)

      our_attributes.each_pair do |name, value|
        self.send("#{name}=", value)
      end
    end

    def number_of_closed_issues
      res = Repo.get_with_success("http://github.com/api/v2/json/issues/list/#{user}/#{name}/closed")['issues'].size
    end

    def number_of_open_issues
      Repo.get_with_success("http://github.com/api/v2/json/issues/list/#{user}/#{name}/open")['issues'].size
    end

    def number_of_open_pull_requests
      Repo.get_with_success("http://github.com/api/v2/json/pulls/#{user}/#{name}/open")['pulls'].size
    end

    def number_of_closed_pull_requests
      Repo.get_with_success("http://github.com/api/v2/json/pulls/#{user}/#{name}/closed")['pulls'].size
    end

    def has_readme?
      current_tree.select { |file| file['name'] =~ /readme/i }.first.present?
    end

    def has_license?
      current_tree.select { |file| file['name'] =~ /license/i }.first.present?
    end


    def has_examples?
      current_tree.select { |file| file['name'] =~ /examples/i && file['type'] == 'tree' }.first.present?
    end

    def has_gemspec?
      current_tree.select { |file| file['name'] =~ /gemspec/i  }.first.present?
    end

    def user
      owner
    end

    private
    def commits
      Repo.get_with_success("http://github.com/api/v2/json/commits/list/#{user}/#{name}/master")['commits']
    end
    
    def current_tree
      sha = commits.first['tree']

      Repo.get_with_success("http://github.com/api/v2/json/tree/show/#{user}/#{name}/#{sha}")['tree']
    end

    def self.get_with_success(*args)
      http_response = get(*args)
  
      if http_response.response.is_a?(Net::HTTPForbidden)
        raise RateLimitExceeded
      elsif !http_response.response.is_a?(Net::HTTPOK)
        raise RuntimeError, "Expected the response to be success but was: #{http_response.response.class}"
      end

      http_response
    end
  end
end
