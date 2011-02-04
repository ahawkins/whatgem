require 'httparty'

module Gemcutter
  class Gem
    include HTTParty
    format :json

    attr_accessor :name, :info, :version, :downloads, :version_downloads, 
      :project_uri, :gem_uri, :homepage_uri, :wiki_uri, 
      :documentation_uri, :mailing_list_uri, :source_code_uri, 
      :bug_tracker_uri, :dependencies, :authors

    def self.find(name)
      response = get("http://rubygems.org/api/v1/gems/#{name}.json")
      if response.response.is_a?(Net::HTTPSuccess)
        new(response.parsed_response)
      else
        nil
      end
    end

    def initialize(attributes = {}) 
      attributes.each_pair do |name, value|
        self.send("#{name}=", value)
      end
    end

    def project_url
      project_uri
    end

    def homepage_url
      homepage_uri
    end
    alias :homepage :homepage_url

    def documentation_url
      documentation_uri
    end

    def source_code_url
      source_code_uri
    end

    def github_repo
      return @github_repo if @github_repo

      if github_url
        matches = github_url.match(%r{https?://github.com/([^/]+)/([^/]+)/?})
        @github_repo = Github::Repo.find(matches[1], matches[2])
      else
        nil
      end
    end

    private
    def github_url
      urls = [source_code_url, homepage_url, project_url].compact

      urls.select {|u| u =~ %r{https?://github.com}}.first
    end
  end
end
