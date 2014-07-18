#
# Cookbook Name:: timezone
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

cookbook_file "profile-airt.sh" do
  path "/etc/profile.d/airt.sh"
end
