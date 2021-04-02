# frozen_string_literal: true

require './booster_pack'

use Rack::Session::EncryptedCookie, Helpers::Cookie.settings
use Rack::Protection

run FoodTracker.new
