#
# Cookbook Name:: timezone
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

bash "cp localtime" do
  user "root"
  code <<-EOH
    ln -sf /usr/share/zoneinfo/Asia/Tokyo /etc/localtime
  EOH
end

#template "/etc/sysconfig/clock" do
#  path "/etc/sysconfig/clock"
#  source "timezone.conf.erb"
#  owner "root"
#  group "root"
#  mode 0644
#end
