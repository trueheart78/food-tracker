# frozen_string_literal: true

require 'honeybadger'

Honeybadger.configure do |config|
  config.api_key = ENV['HONEYBADGER_API_KEY']
  # config.exceptions.ignore += [CustomError]
end
