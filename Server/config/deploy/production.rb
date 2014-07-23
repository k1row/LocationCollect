# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary server in each group
# is considered to be the first unless any hosts have the primary
# property set.  Don't declare `role :all`, it's a meta role.
set :stage, :production

set :rails_env, 'production'
set :bundle_gemfile, -> { release_path.join('Gemfile') }
set :bundle_dir, -> { shared_path.join('bundle') }
set :bundle_flags, nil
set :bundle_without, %w{development test}.join(' ')
set :bundle_binstubs, nil
set :bundle_roles, :all

role :web, %w{ec2-user@xxx}
role :app, %w{ec2-user@xxx}
role :db, %w{ec2-user@xxx}

server 'xxx', user: 'ec2-user', roles: %w{web app db}

set :ssh_options, {
  keys: [File.expand_path('~/.ssh/xxx.pem')],
  forward_agent: true,
  #verbose: :debug,
}
