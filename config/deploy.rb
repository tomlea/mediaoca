default_run_options[:pty] = true  
  
set :application, "mediaoca"  
set :repository,  "git@mediaoca:mediaoca.git"  
  
set :deploy_to, "/apps/#{application}"  
  
set :scm, :git  
  
role :app, "mediaoca"  
role :web, "mediaoca"  
role :db,  "mediaoca", :primary => true
 
namespace :deploy do
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end
  
  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end
end