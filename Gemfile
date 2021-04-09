# frozen_string_literal: true

source 'https://rubygems.org'

# keep this in sync with .ruby-version, .rubocop.yml, and .circleci/config.yml
ruby '2.7.2'

gem 'encrypted_cookie'
gem 'puma'
gem 'rollbar'
gem 'sinatra'
gem 'sinatra-contrib'
gem 'zeitwerk'

group :development do
  gem 'shotgun'
end

group :development, :test do
  gem 'dotenv', require: false
  gem 'pry'
  gem 'rubocop', require: false
  gem 'rubocop-rspec', require: false
end

group :test do
  gem 'rspec'
  gem 'simplecov', require: false
  gem 'timecop'
end
