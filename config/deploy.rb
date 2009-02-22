default_run_options[:pty] = true

set :application, "mediaoca"
set :deploy_to, "/apps/#{application}"

set :scm, :git
set :deploy_via, :remote_cache
set :repository,  "git@mediaoca:mediaoca.git"

role :app, "mediaoca"
role :web, "mediaoca"
role :db,  "mediaoca", :primary => true

set :use_sudo, false

namespace :deploy do
  desc "Restarting mod_rails with restart.txt"
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{current_path}/tmp/restart.txt"
  end

  [:start, :stop].each do |t|
    desc "#{t} task is a no-op with mod_rails"
    task t, :roles => :app do ; end
  end

  desc "Link config files from server side shared path."
  task :link_site_config do
    run "for F in #{shared_path}/config/*; do ln -sf $F #{release_path}/config/; done"
  end

  task :install_gems do
    run "cd #{current_path} && sudo rake gems:install"
  end

  desc "write the crontab file"
  task :write_crontab, :roles => :app do
    run "cd #{release_path} && whenever --write-crontab"
  end
end

after "deploy:update_code" do
  deploy.link_site_config
end

after "deploy:symlink" do
  deploy.write_crontab
end
