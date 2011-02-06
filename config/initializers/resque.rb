require 'resque'

resque_config = YAML.load_file(Rails.root.join('config', 'resque.yml'))

if Rails.env.production?
  Resque.redis = ENV["REDISTOGO_URL"]
else
  Resque.redis = resque_config[Rails.env]
end

require 'resque/server'
