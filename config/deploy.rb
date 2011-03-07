require 'bundler/capistrano'

set :application, "whatgem"
set :repository,  "git://github.com/Adman65/whatgem.git"
set :branch, 'production'

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set :user, :deployer
set :use_sudo, false

role :web, "gems.broadcastingadam.com"                          # Your HTTP server, Apache/etc
role :app, "gems.broadcastingadam.com"                          # This may be the same as your `Web` server
role :db,  "gems.broadcastingadam.com", :primary => true # This is where Rails migrations will run
role :db,  "gems.broadcastingadam.com"

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

# namespace :deploy do
#   task :start do ; end
#   task :stop do ; end
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end
