# frozen_string_literal: true

source 'https://rubygems.org'

# Heroku needs this. Keep this in sync with .ruby-version, .rubocop.yml, and .circleci/config.yml
ruby '2.7.4'

gem 'encrypted_cookie'
gem 'honeybadger', require: false
gem 'puma'
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
