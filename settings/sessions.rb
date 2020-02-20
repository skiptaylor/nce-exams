# Session settings:
#
# Be sure to set your own session secret.

enable :sessions

set :session_secret, 'beansong'

set :protection, except: :session_hijacking

use Rack::Flash