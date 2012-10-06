# Description

Uses the `backup` ruby gem for creating backups

Supports everything the [backup](https://github.com/meskyanichi/backup) gem
supports.

## Usage

Backup comes with a `backup` LWRP. All you need to do is supply it a template,
and variables for the template. It will install backup, install your backup
configuration file, and add an entry to the crontab to run it.

``` ruby
backup "postgres" do
  interval "1.day"  # How often to trigger a backup (uses whenever)
  run_at "12:00 am" # What time the backup should run

  # Options that are passed through to a template resource block to render
  # your backup configuration file
  cookbook "myapp"
  source "postgres.rb.erb"
  variables(
    :password => node['mysql']['password']
    # ...
  )
end
```

## Example Usage

You'll need to create a backup configuration file and a recipe to use the
resource in. Much more information about the backup configuration file can
be found here: https://github.com/meskyanichi/backup/wiki

``` ruby
# /cookbooks/myapp/templates/default/backup.rb.erb:
database PostgreSQL do |db|
  db.name               = "<%= @database %>"
  db.username           = "<%= @username %>"
  db.password           = "<%= @password %>"
  db.host               = "localhost"
  db.port               = 5432
  db.socket             = "/tmp/pg.sock"
  db.skip_tables        = ['skip', 'these', 'tables']
  db.only_tables        = ['only', 'these' 'tables']
  db.additional_options = []
  # Optional: Use to set the location of this utility
  #   if it cannot be found by name in your $PATH
  # db.pg_dump_utility = '/opt/local/bin/pg_dump'
end

compress_with Gzip do |compression|
  compression.level = 6
end

encrypt_with OpenSSL do |encryption|
  encryption.password_file = '/path/to/password/file'
  encryption.base64        = true
  encryption.salt          = true
end

store_with Local do |local|
  local.path = '~/backups/'
  local.keep = 5
end

# /cookbooks/myapp/recipes/backup.rb:
backup "myapp" do
  source "backup.rb.erb"
  variables(
    :database => "my_database",
    :username => "my_username",
    :password => node['postgres']['password']
  )
end

```