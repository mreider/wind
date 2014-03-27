require 'sequel'
require 'mysql2'
require 'json'
require 'sequel/extensions/pagination'

require_relative 'lib/atstart.rb'
require_relative 'lib/datasync.rb'
require_relative 'lib/extend_string.rb'

db = JSON.parse(ENV['VCAP_SERVICES'])["p-mysql"]
  credentials = db.first["credentials"]
  host = credentials["hostname"]
  username = credentials["username"]
  password = credentials["password"]
  database = credentials["name"]
  port = credentials["port"]

# Plugins.
Dir['plugins/*.rb'].each { |plugin| require_relative plugin }  

# Database connection.
DB = Sequel.connect(:adapter=>'mysql2', :host=>host, :database=>database, :user=>username, :password=>password, :port=>port)

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
