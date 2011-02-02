# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ :name => 'Chicago' }, { :name => 'Copenhagen' }])
#   Mayor.create(:name => 'Daley', :city => cities.first)


gem_names = %w(rspec rspec-rails cucumber cucumber-rails capybara
          devise cancan authlogic passenger mongrel
          ZenTest haml sass will_paginate sunspot faker
          simple_form radiant clearance meta_search forgery
          memcached-northscale webmock thinking-sphinx
          redis resque capistrano rcov simplecov
          jeweler mysql pg sqlite3 mail viewpoint
          vagrant warden watir sinatra bundler
          sproutcore delayed_job activemerchant guides
          thin thor maruku RedCloth rake BlueCloth
          paperclip machinist factory_girl shoulda
          mongo bson mongoid mongo_mapper selenium-webdriver
          webrat chef puppet)

gem_names.each do |name|
  puts "Fetching: #{name}"

  gemcutter = Gemcutter::Gem.find name
  if gemcutter.github_repo
    repo = gemcutter.github_repo
    user = User.find_or_create_by_user_name repo.user
    RubyGem.find_or_create_by_name name, :user =>  user, :homepage => repo.url, :description => gemcutter.info
  end
end
