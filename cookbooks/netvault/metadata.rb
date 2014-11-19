maintainer       "PharmMD Admins"
maintainer_email "admins@pharmmd.com"
name             "netvault"
license          "Apache 2.0"
description      "Configures and installs Netvault"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "0.0.1"

%w{debian ubuntu}.each do |os|
  supports os
end
