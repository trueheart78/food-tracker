#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative '../booster_pack'

class SortData
  class << self
    def run!(directory: 'data')
      puts "=> Sorting file contents in the [#{directory}] directory"
      files = Dir["#{directory}/*.yaml"].sort

      files.each { |filename| sort filename: filename }

      puts '=> Complete!'
    end

    private

    def sort(filename:)
      print "==> Opening #{filename} "
      data = YAML.load_file filename

      print '==> Sorting '
      data[:types].sort!
      data[:items].sort!

      save filename: filename, data: data

      puts '==> Complete!'
    end

    def save(filename:, data:)
      File.open(filename, 'w+') do |file|
        print '==> Saving '
        file.write yamlize(data: data)
      end
    end

    def yamlize(data:)
      data.to_yaml.sub("\n:items:", "\n\n:items:").gsub("\n-", "\n  -")
    end
  end
end

SortData.run!
