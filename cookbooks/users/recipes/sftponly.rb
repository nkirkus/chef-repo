#
# Cookbook Name:: users
# Recipe:: sftponly
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

# Required for password support
gem_package "ruby-shadow"

sftponly_group = Array.new

# data bags if chef server, node attributes if chef-solo
users = Array.new
if Chef::Config[:solo]
  node[:data_bags][:users].each do |u|
    if u[:groups].include?('sftponly')
      users << u
    end
  end
else
  search(:users, 'groups:sftponly') do |u|
    users << u
  end
end

users.each do |u|
  if u[:action] == 'remove'
    user u[:id] do
      action u[:action]
    end
  else
    sftponly_group << u['id']

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
      if u['password'] != nil
        password u['password']
      end
    end

    # Allow directories to be added from a user data bag
    if u['directories']
      u['directories'].each do |d|
        directory "#{home_dir}/#{d['name']}" do
          owner d['owner'] ? d['owner'] : u['id']
          group d['group'] ? d['group'] : u['id']
          if d['mode']
            mode d['mode']
          end
        end
      end
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
end

group "sftponly" do
  gid 2302
  members sftponly_group
end
