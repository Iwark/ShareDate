# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'ShareDate'
set :repo_url, 'git@github.com:Iwark/ShareDate.git'

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/home/ec2-user/share-date'

# Default value for :scm is :git
set :scm, :git

set :rbenv_ruby, '2.1.2'

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

set :linked_files, %w{config/secrets.yml}
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/assets}

set :default_stage, "production"

set :default_env, {
  rbenv_root: "/home/ec2-user/rbenv",
  path: "/home/ec2-user/rbenv/shims:/home/ec2-user/rbenv/bin:$PATH"
}

set :unicorn_rack_env, "production"
set :unicorn_config_path, 'config/unicorn.conf'

after 'deploy:publishing', 'deploy:restart'
namespace :deploy do

  desc 'Restart application'
  task :restart do
    invoke 'unicorn:restart'
  end

  after :publishing, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
    end
  end

end
