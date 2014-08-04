minion_group = Array.new

search(:users, 'groups:minion') do |u|
  minion_group << u['id']

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

  template "#{home_dir}/.ssh/id_dsa" do
    source "id_dsa.erb"
    owner u['id']
    group u['id']
    mode "0600"
    variables :ssh_private_keys => u['ssh_private_keys']
  end

  template "#{home_dir}/.ssh/authorized_keys" do
    source "authorized_keys.erb"
    owner u['id']
    group u['id']
    mode "0600"
    variables :ssh_keys => u['ssh_keys']
  end
end

group "minion" do
  gid 2600
  members minion_group
end