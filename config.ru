require File.expand_path('app.rb', File.dirname(__FILE__))

# Rack config
use Rack::Static, :urls => [ '/javascripts', '/style.css', '/favicon.ico', 'custom', '/robots.txt'], :root => 'public'

run WindApp
