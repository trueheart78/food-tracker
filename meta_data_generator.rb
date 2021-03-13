#!/usr/bin/env ruby

# frozen_string_literal: true
require './booster_pack'

unless Env.development?
  puts "=> Error: Unable to run outside of development mode. [#{Env}]"
  exit 1
end

meta_data = MetaData.new
puts "Updating meta data. [#{meta_data.data_file_path}]"
if meta_data.valid?
  meta_data.save
  puts '=> Updated meta data.'
else
  puts '=> Errors Found:'
  meta_data.errors.each do |error|
    puts "===> #{error}"
  end
  puts '=> Unable to update meta data.'
end
