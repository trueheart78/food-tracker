require './booster_pack'
require 'rack/protection'
require 'food_tracker'

use Rack::Session::Cookie, secret: ENV['APP_SECRET_HASH']
use Rack::Protection

run FoodTracker.new
