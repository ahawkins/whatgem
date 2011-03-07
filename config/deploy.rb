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
end

namespace :god do  
  desc "Deploy theGod file"
  task :deploy, :roles => :app  do
    sudo "#{fetch(:god_path)} load #{current_path}/config/whatgem.god"
  end

  desc "Start God watches" 
  task :start, :roles => :app do
    sudo "#{fetch(:god_path)}  start #{stage}"  
  end

  desc "Stop God watches"
  task :stop, :roles => :app do
    sudo "#{fetch(:god_path)} stop #{stage}"  
  end

  desc "Unload & stop God watches"
  task :unload, :roles => :app do
    sudo "#{fetch(:god_path)} stop #{stage}"
    sudo "#{fetch(:god_path)}  remove #{stage}"  
  end
end

before "deploy", "deploy:web:disable"

before "deploy", "god:stop"

after "deploy", "god:start"
after "deploy", "deploy:web:enable"

before 'deploy:restart', 'god:stop'
after 'deploy:restart', 'god:start'
