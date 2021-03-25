require './booster_pack'

use Rack::Session::EncryptedCookie, secret: ENV['APP_SECRET_HASH']
use Rack::Protection

run FoodTracker.new
