def initialize(*args)
  super
  @action = :create
end

action :create do
  package "libxml2-dev"
  package "libxslt-dev"

  %w[ backup fog mail whenever ].each do |gem_name|
    gem_package gem_name
  end

  %w[ models schedules ].each do |dir|
    directory "#{node[:backup][:dir]}/#{dir}" do
      mode "0775"
      owner "root"
      group "root"
      recursive true
    end
  end

  template "#{node[:backup][:dir]}/config.rb" do
    source "config.rb.erb"
    mode "0664"
    owner "root"
    group "root"
  end

  template "#{node[:backup][:dir]}/models/#{new_resource.label}.rb" do
    cookbook "#{new_resource.cookbook}" if new_resource.cookbook
    source "#{new_resource.source}"
    mode "0664"
    owner "root"
    group "root"

    variables(
      :resource => new_resource.variables
    )
  end

  template "#{node[:backup][:dir]}/schedules/#{new_resource.label}-backup.rb" do
    cookbook "backup"
    source "schedule.rb.erb"
    mode "0664"
    owner "root"
    group "root"

    variables(
      :interval => new_resource.interval,
      :run_at   => new_resource.run_at,
      :trigger  => new_resource.label
    )
  end

  execute "update crontab via whenever for #{new_resource.label}" do
    command "whenever --update-crontab #{new_resource.label} --load-file #{node[:backup][:dir]}/schedules/#{new_resource.label}-backup.rb"
  end
end