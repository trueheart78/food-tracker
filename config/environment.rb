ENV['APP_ENV'] = 'development' unless ENV['RAPP_ENV']
if ENV['APP_ENV'] != 'production'
  require 'dotenv'
  Dotenv.load ".env.#{ENV['APP_ENV']}", '.env.local', '.env'
end
