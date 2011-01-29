require 'httparty'

module Gemcutter
  class Gem
    include HTTParty
    format :json

    attr_accessor :name, :info, :downloads, :project_uri, :homepage_uri, 
      :documentation_uri, :source_code_uri, :authors

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
    alias :github_url :source_code_uri

    def github_repo
      return @github_repo if @github_repo

      urls = [github_url, homepage].reject(&:nil?)

      match_url = urls.select {|u| u =~ %r{https?://github.com}}.first

      if match_url
        matches = match_url.match(%r{https?://github.com/(\w+)/(\w+)/?})
        @github_repo = Github::Repo.find(matches[1], matches[2])
      else
        nil
      end
    end

    def self.find(name)
      new(get('http://rubygems.org/api/v1/gems/%s.json' % [name]).parsed_response.slice('name',
        'info', 'downloads', 'project_uri', 'homepage_uri', 
        'documentation_uri',  'source_code_uri', 'authors'))
    end
  end
end
