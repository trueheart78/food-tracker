require './booster_pack'
require 'rack/protection'
require 'food_tracker'

use Rack::Protection

run FoodTracker.new
