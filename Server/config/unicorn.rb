# -*- coding: utf-8 -*-

RAILS_ROOT = File.expand_path("../..", __FILE__)

listen "/tmp/unicorn.sock"
pid "tmp/pids/unicorn.pid"

working_directory "/tmp/airt-server/current"

# ワーカの数を指定
worker_processes 2

# リクエストのタイムアウト秒を指定
timeout 15

# ダウンタイムをなくすため、アプリをプレロード
preload_app true

stdout_path File.expand_path('log/unicorn-stdout.log', ENV['RAILS_ROOT'])
stderr_path File.expand_path('log/unicorn-stderr.log', ENV['RAILS_ROOT'])

# before_fork, after_forkではUnicornのプロセスがフォークする前後の挙動を指定できる
# 以下のおまじないの詳細はドキュメント参照
before_fork do |server, worker|
	defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!

	old_pid = "#{server.config[:pid]}.oldbin"
	unless old_pid == server.pid
		begin
			Process.kill :QUIT, File.read(old_pid).to_i
		rescue Errno::ENOENT, Errno::ESRCH
		end
	end

	defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
end

after_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end

def rails_root
  require "pathname"
  Pathname.new(__FILE__) + "../../"
end
