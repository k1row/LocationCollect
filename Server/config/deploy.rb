# config valid only for Capistrano 3.1
lock '3.2.1'

set :application, 'AirTrackServer'

set :repo_url, 'git@github.com:CyberAgent/airt-server.git'
set :deploy_to, '/tmp/airt-server'
set :scm, :git
set :branch, :master
set :format, :pretty

set :keep_releases, 5

set :rbenv_type, :system # :system or :user
set :rbenv_ruby, '2.1.2'
set :rbenv_prefix, "RBENV_ROOT=#{fetch(:rbenv_path)} RBENV_VERSION=#{fetch(:rbenv_ruby)} #{fetch(:rbenv_path)}/bin/rbenv exec"
set :rbenv_map_bins, %w{rake gem bundle ruby rails}
set :rbenv_roles, :all # default value

set :linked_dirs, %w{bin log tmp/backup tmp/pids tmp/cache tmp/sockets vendor/bundle}
set :unicorn_pid, "#{shared_path}/tmp/pids/unicorn.pid"

#set :whenever_identifier, ->{ "#{fetch(:application)}_#{fetch(:stage)}" }

after 'deploy:publishing', 'deploy:restart'
namespace :deploy do
  task :restart do
    #invoke 'unicorn:restart'
  end
end
