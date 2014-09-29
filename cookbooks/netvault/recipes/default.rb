

package 'libaio1' do
	action :install
end

package 'libstdc++5' do
	action :install
end

package 'unzip' do
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

remote_file "/root/NetVault-Backup-Distribution-for-Linux-x86-Pure-64-bit-Build_100.zip" do
	source 'https://s3.amazonaws.com/pharmmd-public/NetVault-Backup-Distribution-for-Linux-x86-Pure-64-bit-Build_100.zip'
end

filename = "NetVault-Backup-Distribution-for-Linux-x86-Pure-64-bit-Build_100.zip"

execute "unzip-filename" do
    command "yes | unzip -j /root/#{filename} -d /root/NVB/"
end

execute "untar-filename" do
    command "yes | tar -xvzf /root/NVB/netvault-R2014APR29-SECRETARIAT-V10-Linux-Pure64-ClientOnly.tar.gz -C /root/NVB/"
end

template "/root/NVB/netvault/responsefile" do
    source 'responsefile.erb'
end

execute "install-netvault" do
    command "cd /root/NVB/netvault/; bash install responsefile"
end
