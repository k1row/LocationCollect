#
# Cookbook Name:: supervisor
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
package 'supervisor' do
  action :install
end

template "supervisord.conf" do
	path "/etc/supervisord.conf"
	source "supervisord.conf.erb"
	owner "root"
	group "root"
	mode 0644
	notifies :reload, "service[supervisord]", :delayed
end

#execute 'chkconfig add supervisord' do
#  action :nothing
#  command "chkconfig --add supervisord"
#  notifies :run, "execute[chkconfig supervisord on]"
#	notifies :reload, "service[supervisord]", :delayed
#end

service "supervisord" do
    supports :status => true, :restart => false, :reload => true
    reload_command "supervisorctl update"
    action [:enable, :start]
end

