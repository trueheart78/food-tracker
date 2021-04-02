#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../booster_pack'

Dir['data/*.yaml'].sort.each do |filename|
  puts "=> Opening #{filename}"
  data = YAML.load_file filename

  puts '==> Sorting'
  data[:types].sort!
  data[:items].sort!
  File.open(filename, 'w+') do |file|
    puts '==> Saving'
    file.write data.to_yaml.sub("\n:items:", "\n\n:items:").gsub("\n-", "\n  -")
  end
  puts '==> Complete!'
end