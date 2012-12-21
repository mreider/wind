require 'sequel'
require 'mysql2'
require 'json'
require 'sequel/extensions/pagination'

require_relative 'lib/atstart.rb'
require_relative 'lib/datasync.rb'
require_relative 'lib/extend_string.rb'

# require 'cfruntime/mysql'

# Plugins.
Dir['plugins/*.rb'].each { |plugin| require_relative plugin }  

# Database connection.

require 'uri'
begin
  database_uri = URI.parse(ENV["DATABASE_URL"] || 'mysql://root:@localhost/wind')
rescue URI::InvalidURIError
  raise "Invalid DATABASE_URL"
end

DB = Sequel.connect(:adapter=>'mysql2', :host=>database_uri.host, :database=> (database_uri.path || "").split("/")[1] , :user=> database_uri.user, :password=> database_uri.password)

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
