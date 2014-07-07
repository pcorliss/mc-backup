name              "mc-backup"
maintainer        "ModCloth"
maintainer_email  "ops@modcloth.com"
license           "Apache 2.0"
description       "Makes backups easy"
long_description  IO.read( File.join( File.dirname(__FILE__), 'README.md' ) )
version           "0.0.4"
recipe            "backup::default", "Installs backup gem"

%w{ ubuntu debian redhat centos fedora freebsd openbsd mac_os_x windows }.each do |os|
  supports os
end
