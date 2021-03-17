# frozen_string_literal: true

source 'https://rubygems.org'

ruby '~> 2.6.6' # keep this in sync with .ruby-version

gem 'puma'
gem 'sinatra'
gem 'sinatra-contrib'

group :development do
  gem 'shotgun'
end

group :development, :test do
  gem 'dotenv', require: false
end

group :test do
  gem 'rspec'
  gem 'simplecov', require: false
end
