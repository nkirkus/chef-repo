#
# Cookbook Name:: helloworld
# Recipe:: default
#
# Copyright 2014, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#
# This is an example Chef recipe
 
template "/tmp/helloworld.txt" do
  source "helloworld.txt.erb"
end
