#!/usr/bin/env ruby

require 'json'

# Array gets monkey-patched to include #pluck
class Array
  def pluck(key)
    map { |hash| hash[key] }
  end
end

# MetaData wrapper to verify everything is good
class MetaData
  attr_reader :errors

  def initialize
    @errors = []
    @valid = false
  end

  def save
    return unless valid?

    File.open('data/meta_data.json', 'w+') do |file|
      file.write JSON.pretty_generate(data)
    end
  end

  def valid?
    @valid = false

    @valid = valid_files? relationships.pluck(:file)

    @valid
  end

  def valid_files?(files)
    new_files = existing_files.reject { |f| files.include? f }
    missing_files = files.reject { |f| File.exist? path(f) }
    return true unless new_files.any? || missing_files.any?

    new_files.each     { |file| add_error 'New file does not have metadata.', file }
    missing_files.each { |file| add_error 'Data file does not exist.', file }

    false
  end

  def existing_files
    Dir['data/*.txt'].map { |file| file.sub('data/', '').sub('.txt', '') }
  end

  def path(file)
    "data/#{file}.txt"
  end

  def add_error(message, var)
    @errors.push "#{message} [#{var}]"
  end

  def types
    %w[dessert drink simple snack sweet]
  end

  def locations
    %w[counter cupboard fridge freezer]
  end

  def relationships
    [
      {
        file: 'drinks',
        type: %w[sweet simple],
        location: %w[fridge]
      },
      {
        file: 'icecream',
        type: %w[sweet snack dessert],
        location: %w[freezer]
      },
      {
        file: 'leftovers',
        type: %w[snack dinner],
        location: %w[counter fridge freezer]
      }
    ]
  end

  def data
    [
      {
        types: types,
        locations: locations,
        relationships: relationships
      }
    ]
  end

end

md = MetaData.new
if md.valid?
  md.save
else
  puts 'Errors Found:'
  md.errors.each do |error|
    puts "=> #{error}"
  end
end
