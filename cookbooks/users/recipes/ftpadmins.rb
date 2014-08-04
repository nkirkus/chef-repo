#
# Cookbook Name:: users
# Recipe:: ftpadmins
#
# Copyright 2009, Opscode, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#     http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
ftpadmin_group = Array.new

# data bags if chef server, node attributes if chef-solo
users = Array.new
if Chef::Config[:solo]
  node[:data_bags][:users].each do |u|
    if u[:groups].include?('ftpadmin')
      users << u
    end
  end
else
  search(:users, 'groups:ftpadmin') do |u|
    users << u
  end
end

users.each do |u|
  ftpadmin_group << u['id']

  home_dir = if u['id'] != 'root'
    if u['id'] == nil or u['id'] == ''
      "/home/#{u['id']}"
    else
      "#{u['home_dir']}"
    end
  else
    "/#{u['id']}"
  end

  user u['id'] do
    uid u['uid']
    shell u['shell']
    comment u['comment']
    supports :manage_home => true
    home home_dir
  end

  directory "#{home_dir}/.ssh" do
    owner u['id']
    group u['id']
    mode "0700"
  end

  template "#{home_dir}/.ssh/authorized_keys" do
    source "authorized_keys.erb"
    owner u['id']
    group u['id']
    mode "0600"
    variables :ssh_keys => u['ssh_keys']
  end
end

group "ftpadmin" do
  gid 2301
  members ftpadmin_group
end
