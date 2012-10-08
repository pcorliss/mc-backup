case node['platform']
when 'smartos'
  default['backup']['dir'] = "/opt/local/etc/backup"
else
  default['backup']['dir'] = "/etc/backup"
end

default['backup']['logpath'] = "/var/log"