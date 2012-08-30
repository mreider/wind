require 'sequel'
require 'mysql2'
require 'json'
require 'sequel/extensions/pagination'

require_relative 'lib/atstart.rb'
require_relative 'lib/datasync.rb'
require_relative 'lib/extend_string.rb'

require 'cfruntime/mysql'

# Plugins.
Dir['plugins/*.rb'].each { |plugin| require_relative plugin }  

# Database connection.
DB = Sequel.connect(:adapter=>'mysql2', :host=>'localhost', :database=>'wind', :user=>'root', :password=>'')

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
