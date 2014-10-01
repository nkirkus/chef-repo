maintainer        "PharmMD"
maintainer_email  "admins@pharmmd.com"
license           "Apache 2.0"
description       "Installs and cofigures Dell's NetVault client"
version           "0.0.1"

recipe "netvault", "Installs and configures NetVault Client"

%w{ ubuntu debian }.each do |os|
  supports os
end
