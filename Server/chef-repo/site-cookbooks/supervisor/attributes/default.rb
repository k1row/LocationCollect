default[:supervisor][:user] = "ec2-user"

default[:supervisor][:directory] = "/tmp/airt-server/current/"


default[:supervisor][:stdout_log][:path] = "/tmp/airt-server/current/log"
default[:supervisor][:stdout_log][:name] = "unicorn-stdout.log"

default[:supervisor][:stderr_log][:path] = "/tmp/airt-server/current/log"
default[:supervisor][:stderr_log][:name] = "unicorn-stderr.log"
