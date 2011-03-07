$:.unshift(File.expand_path('./lib', ENV['rvm_path']))

require "rvm/capistrano" 
require 'bundler/capistrano'

set :application, "whatgem"
set :repository,  "git://github.com/Adman65/whatgem.git"
set :branch, 'production'
set :deploy_to, '/apps/whatgem'

set :scm, :git

set :user, :deployer
set :use_sudo, false

set :god_path, '/usr/local/rvm/bin/bootup_god'

role :web, "gems.broadcastingadam.com"                          # Your HTTP server, Apache/etc
role :app, "gems.broadcastingadam.com"                          # This may be the same as your `Web` server
role :db,  "gems.broadcastingadam.com", :primary => true # This is where Rails migrations will run
role :db,  "gems.broadcastingadam.com"

namespace :deploy do
  task :link_configs, :roles => :app do
    %w(database resque).each do |config|
      run "ln -sf ~/configs/#{fetch(:application)}/#{config}.yml #{current_path}/config/#{config}.yml"
    end
  end
  after 'deploy:symlink', 'deploy:link_configs' 

  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

  desc "Update the crontab file"
  task :update_crontab, :roles => :app, :except => { :no_release => true } do
    run "cd #{release_path} && bundle exec whenever --update-crontab #{application}"
  end
  after 'deploy:update_code', 'deploy:update_crontab'
end

namespace :god do  
  desc "Deploy the God file"
  task :deploy, :roles => :app  do
    sudo "#{fetch(:god_path)} load #{current_path}/config/whatgem.god"
  end

  desc "Start God watches" 
  task :start, :roles => :app do
    sudo "#{fetch(:god_path)}  start #{fetch(:application)}"
  end

  desc "Stop God watches"
  task :stop, :roles => :app do
    sudo "#{fetch(:god_path)} stop #{fetch(:application)}"
  end

  desc "Unload & stop God watches"
  task :unload, :roles => :app do
    sudo "#{fetch(:god_path)} stop #{fetch(:application)}"
    sudo "#{fetch(:god_path)}  remove #{fetch(:application)}"
  end
end

namespace :ruby_gems do
  desc "Run tests for all gems in the db" 
  task :tests, :roles => :app do
    run "cd #{current_path} ; rake ruby_gems:test RAILS_ENV=production"
  end
end

before "deploy", "deploy:web:disable"
before "deploy", "god:stop"

after "deploy", "god:start"
after "deploy", "deploy:web:enable"
