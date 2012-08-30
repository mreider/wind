require 'sequel'
require 'mysql2'
require 'sequel/extensions/pagination'

require_relative 'lib/atstart.rb'
require_relative 'lib/datasync.rb'
require_relative 'lib/extend_string.rb'

configure do
    services = JSON.parse(ENV['VCAP_SERVICES'])
    mysql_key = services.keys.select { |svc| svc =~ /mysql/i }.first
    mysql = services[mysql_key].first['credentials']
    mysql_conf = {:host => mysql['hostname'], :port => mysql['port'],
        :username => mysql['user'], :password => mysql['password']}
    @@client = Mysql2::Client.new mysql_conf
end

# Plugins.
Dir['plugins/*.rb'].each { |plugin| require_relative plugin }  

# Database connection.
DB = Sequel.connect @@client

# Sequel schema plugin.
Sequel::Model.plugin :schema

# Database models.
Dir['models/*.rb'].each { |model| require_relative model }

# Sinatra configurations.
configure do
  enable :sessions
end

# Application helpers.
helpers do
  require_relative 'helpers'
end

# Blog configurations.
 $settings = Setting.from_database

# Posts per page
PAGE_SIZE = 10

at_start_execution
