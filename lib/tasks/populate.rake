desc "Populate the db with some demo data" 
task :populate => :environment do
  require 'blueprints'

  15.times do
    User.find_or_create_by_name!(Forgery::GithubUserName.name)
  end

  30.times do
    gem_name = Forgery::GemName.name
    RubyGem.make(:name => gem_name) unless RubyGem.named(gem_name)
  end

  100.times { Comment.make }
end
