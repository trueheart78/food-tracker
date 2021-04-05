# frozen_string_literal: true

require 'rollbar/middleware/sinatra'

Rollbar.configure do |config|
  config.environment  = ENV['APP_ENV']
  config.access_token = ENV['ROLLBAR_ACCESS_TOKEN']
end
