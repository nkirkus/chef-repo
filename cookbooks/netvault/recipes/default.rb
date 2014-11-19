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

link "/usr/lib64" do
  to "/usr/lib"
end

src_filename = node[:netvault][:file]
src_filepath = "#{Chef::Config['file_cache_path']}/#{src_filename}"
extract_path = "#{Chef::Config['file_cache_path']}"

remote_file src_filepath do
  source node[:netvault][:url]
  checksum node[:netvault][:checksum]
  owner 'root'
  group 'root'
  mode '0644'
end

bash 'extract_module' do
  cwd ::File.dirname(src_filepath)
  code <<-EOH
    tar xzf #{src_filename} -C #{extract_path}
    EOH
  not_if { ::File.exists?("#{extract_path}/netvault") }
end

template "#{extract_path}/netvault/responsefile" do
  source 'responsefile.erb'
  variables(
    :pkg_base => node[:netvault][:pkg_base],
    :password => node[:netvault][:password],
    :language => node[:netvault][:language],
    :node_name => Chef::Config[:node_name]
  )
end

execute "install-netvault" do
  command "cd #{extract_path}/netvault; bash install responsefile"
end
