maintainer        "PharmMD"
maintainer_email  "admins@pharmmd.com"
license           "Apache 2.0"
description       "Installs and configures iwatch"
version           "0.1.0"

recipe "iwatch", "Installs and configures iwatch"

%w{ ubuntu debian }.each do |os|
  supports os
end
