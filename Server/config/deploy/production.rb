# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary server in each group
# is considered to be the first unless any hosts have the primary
# property set.  Don't declare `role :all`, it's a meta role.

role :web, %w{ec2-user@airt1}
role :app, %w{ec2-user@airt1}
role :db, %w{ec2-user@airt1}

role :web, %w{ec2-user@airt2}
role :app, %w{ec2-user@airt2}
role :db, %w{ec2-user@airt2}

role :web, %w{ec2-user@airt3}
role :app, %w{ec2-user@airt3}
role :db, %w{ec2-user@airt3}

server 'airt1', user: 'ec2-user', roles: %w{web app db}
server 'airt2', user: 'ec2-user', roles: %w{web app db}
server 'airt3', user: 'ec2-user', roles: %w{web app db}

set :ssh_options, {
  keys: [File.expand_path('~/.ssh/airtrack.pem')],
  forward_agent: true,
  verbose: :debug,
}
