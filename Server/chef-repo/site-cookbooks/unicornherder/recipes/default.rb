#
# Cookbook Name:: unicornherder
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
bash "install unicornherder" do
  user "root"
  code <<-EOH
    pip install unicornherder
  EOH
end
