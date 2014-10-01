###


package 'libaio1' do
  action :install
end

package 'libstdc++5' do
  action :install
end

directory "/var/lock/subsys" do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

directory "/root/NVB" do
  owner 'root'
  group 'root'
  mode '0755'
  action :create
end

link "/usr/lib64" do
  to "/usr/lib"
end

filename = "netvault-R2014APR29-SECRETARIAT-V10-Linux-Pure64-ClientOnly.tar.gz"

remote_file "/root/#{filename}" do
  source 'https://s3.amazonaws.com/pharmmd-public/' + filename
end

execute "untar-filename" do
  command "yes | tar -xvzf /root/#{filename} -C /root/"
end

template "/root/netvault/responsefile" do
  source 'responsefile.erb'
end

execute "install-netvault" do
  command "cd /root/netvault/; bash install responsefile"
end
