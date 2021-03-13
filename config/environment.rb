ENV['RACK_ENV'] = 'development' unless ENV['RACK_ENV']

set :environment, ENV['RACK_ENV'].to_sym