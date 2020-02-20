# Uses ./Gemfile for gem management
require 'bundler'
Bundler.require

require 'sinatra/namespace'
require 'net/http'

# Sets environment, defaults to development
#   ~: rake app:server env=production
set :environment, ENV['RACK_ENV'] || ENV['env'] || :development

use Rack::Protection, :except => :session_hijacking

enable :sessions
set :session_secret, 'secret123'

# Requires the necessary files, in order, for the app
['settings', 'libraries', 'models', 'routes'].each do |directory|
	Dir["./#{directory}/**/*.rb"].each { |file| require file }
end

# Catches all routes and attempts to match them to a view file
#   This must load AFTER all other routes
#   Otherwise it catches all incoming GET requests
get '/*/?' do
	puts "--> #{request.referrer} // #{request.user_agent} // #{request.xhr?} // #{request.ip}"
	erb :"#{params[:splat].first}"
end

# Finalizes the models
DataMapper.finalize
