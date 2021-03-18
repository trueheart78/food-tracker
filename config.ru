require './booster_pack'

use Rack::Session::Cookie, secret: ENV['APP_SECRET_HASH']
use Rack::Protection

run FoodTracker.new
