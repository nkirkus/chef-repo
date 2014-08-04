#
# Cookbook Name:: users
# Recipe:: deployers
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
rvm_group = Array.new

search(:users, 'groups:rvm') do |u|
  create_user = false
  if u.has_key?("hosts")
    u[:hosts].each do |host|
      if host == node[:full_node_name]
        create_user = true
      end
    end
  else
    create_user = true
  end

  if create_user == true
    rvm_group << u['id']

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
  end
end

group "rvm" do
  gid 2401
  members rvm_group
end
