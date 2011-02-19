source 'http://rubygems.org'

gem 'rails', '3.0.3'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'sqlite3', :require => 'sqlite3'
gem 'pg'
gem 'heroku'
gem "devise", :git => 'https://github.com/plataformatec/devise.git'
gem "haml"
gem "haml-rails"
gem 'formtastic'
gem 'httparty'
gem 'resque'
gem "oa-oauth", :require => "omniauth/oauth"
gem 'jquery-rails'
gem 'acts-as-taggable-on'
gem 'mechanize'
gem 'will_paginate'
gem 'maruku'

group :production do
  gem "dalli"
end

group :development do
  gem 'wirble'
  gem 'hirb'
  gem 'infinity_test'
  gem 'ruby-debug19'
  gem 'nifty-generators'
end

group :test, :development do 
  gem "rspec-rails"
  gem 'machinist'
  gem 'forgery'
end

group :test do
  gem 'capybara'
  gem 'cucumber-rails'
  gem 'simplecov'
  gem 'remarkable_activerecord', '>=4.0.0.alpha2'
  gem 'webmock'
  gem 'database_cleaner'
end

