actions :create

attribute :label, :kind_of => String, :name_attribute => true, :regex => /[0-9a-zA-Z_-]+/

# These values are passed through to whenever's `every` method:
# every "1.day", :at => "12:00 am"
# https://github.com/javan/whenever
attribute :interval, :default => "1.day"
attribute :run_at, :default => "12:00 am"

# These values that are passed through to a template resource block to render
# the backup configuration file
attribute :cookbook, :kind_of => [ String, FalseClass ], :default => false
attribute :source, :kind_of => String, :required => true
attribute :variables, :kind_of => Hash, :default => {}
