# frozen_string_literal: true

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

    File.open(data_file_path, 'w+') do |file|
      file.write JSON.pretty_generate(data)
    end
  end

  def data_file_path
    'data/meta_data.json'
  end

  def valid?
    @valid = true

    validate_files
    validate_types
    # TODO validate_default_locations
    validate_locations

    @valid
  end

  private

  def validate_files
    local_valid = valid_files? relationships.pluck(:file)
    @valid = local_valid if @valid
  end

  def validate_types
    local_valid = valid_types? relationships.pluck(:type)
    @valid = local_valid if @valid
  end

  # TODO loop through known files and validate their locations (in parens)

  # TODO validate_default_locations
  def validate_locations
    local_valid = valid_locations? relationships.pluck(:location)
    @valid = local_valid if @valid
  end

  def valid_files?(files)
    new_files = existing_files.reject { |f| files.include? f }
    missing_files = files.reject { |f| File.exist? path(f) }
    return true unless new_files.any? || missing_files.any?

    new_files.each     { |file| add_error 'File does not have metadata.', file }
    missing_files.each { |file| add_error 'Data file does not exist.', file }

    false
  end

  def valid_types?(types)
    types = types.flatten.uniq.sort
    new_types = types.reject { |t| supported_types.include? t }

    return true unless new_types.any?

    new_types.each { |type| add_error 'Type not supported.', type }

    false
  end

  def valid_locations?(locations)
    locations = locations.flatten.uniq.sort
    new_locations = locations.reject { |l| supported_locations.include? l }

    return true unless new_locations.any?

    new_locations.each { |location| add_error 'Location not supported.', location }

    false
  end

  def existing_files(symbols: true)
    if symbols
      Dir['data/*.txt'].map { |file| file.sub('data/', '').sub('.txt', '').to_sym }.sort
    else
      Dir['data/*.txt'].sort
    end
  end

  def path(file)
    "data/#{file}.txt"
  end

  def add_error(message, var)
    @errors.push "#{message} [#{var}]"
  end

  def supported_types
    @supported_types ||= %i[breakfast dessert dinner dip lunch meal salty sauce side simple snack spreadable sweet]
  end

  def supported_locations
    @supported_locations ||= %i[cookie_dish counter cupboard fridge freezer pantry]
  end

  # rubocop:disable Metrics/MethodLength
  def relationships
    [
      {
        file: :snacks,
        type: %i[sweet snack dessert],
        location: :fridge
      },
      {
        file: :soups,
        type: %i[lunch dinner meal],
        location: :cupboard
      },
      {
        file: :sweets,
        type: %i[sweet snack dessert],
        location: :counter
      },
      {
        file: :vegetables,
        type: %i[side],
        location: :freezer
      }
    ]
  end
  # rubocop:enable Metrics/MethodLength

  def data
    [
      {
        supported_types: supported_types,
        supported_locations: supported_locations,
        relationships: relationships
      }
    ]
  end
end
