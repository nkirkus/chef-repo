#
# Cookbook Name:: users
# Recipe:: postgres
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

postgres_group = Array.new

# data bags if chef server, node attributes if chef-solo
users = Array.new
if Chef::Config[:solo]
  node[:data_bags][:users].each do |u|
    if u[:groups].include?('postgres')
      users << u
    end
  end
else
  search(:users, 'groups:postgres') do |u|
    users << u
  end
end

users.each do |u|
  postgres_group << u['id']

  home_dir = if u['id'] != 'root'
    "/home/#{u['id']}"
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

  if node.roles.include?("database_master")
    template "/home/postgres/.ssh/id_#{u['ssh_private_key_type']}" do
      source "id_dsa.erb"
      owner 'postgres'
      group 'postgres'
      mode "0600"
      variables :ssh_private_keys => u['ssh_private_key']
    end
  end

  if node.roles.include?("database_slave")
    template "/home/postgres/.ssh/authorized_keys" do
      source "authorized_keys.erb"
      owner 'postgres'
      group 'postgres'
      mode "0600"
      variables :ssh_keys => u['ssh_keys']
    end
  end
end


group "postgres" do
  gid 4006
  members postgres_group
end
