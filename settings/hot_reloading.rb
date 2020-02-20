# Auto reload the app on each request when in the development environment.
#
# Note that this doesn't recognize DB changes.

require 'sinatra/reloader' if development?