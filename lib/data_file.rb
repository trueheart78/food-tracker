# frozen_string_literal: true

class DataFile
  class InvalidType < StandardError; end

  attr_reader :errors, :data_lines

  def initialize(file_path, type: :all_items)
    @file_path = file_path
    @data_lines = nil
    @errors = []

    raise InvalidType, "Unsupported type: :#{type}" unless self.class.supported_type? type

    @type = type.to_sym

    parse_yaml_file
  rescue InvalidType => e
    @errors << e
  end

  def valid?
    return false if @errors.any?
    return false unless File.extname(@file_path) == '.yaml'
    return false unless exists?
    return false if @data_lines.none?(&:valid?)

    true
  end

  def errors?
    @errors.any?
  end

  def expiring?
    @data_lines.any?(&:expiring?) || @data_lines.any?(&:expired?)
  end

  def out_of_stock?
    @data_lines.any?
  end

  def display?
    return false unless valid?
    return false unless valid_type?

    true
  end

  def name
    @yaml_data[:name]
  end

  def safe_name
    name.downcase.sub(' ', '_')
  end

  def location
    @yaml_data[:location]
  end

  def self.load(type: :in_stock, directory: 'data')
    raise InvalidType, "Unsupported type: :#{type}" unless supported_type? type

    data = Dir["#{directory}/*.yaml"].sort.map { |file| new file, type: type }

    case type
    when :expiring
      data.select!(&:expiring?)
    when :out_of_stock
      data.select!(&:out_of_stock?)
    end

    data
  end

  def self.supported_type?(type)
    %i[all_items in_stock expiring out_of_stock].include? type.to_sym
  end

  private

  def valid_type?
    return true if @type == :all_items
    return true if @type == :in_stock
    return true if @type == :expiring && expiring?
    return true if @type == :out_of_stock && @data_lines.any?

    false
  end

  def load_yaml_data
    @yaml_data ||= YAML.load_file(@file_path)

    true
  rescue Errno::ENOENT => e
    @errors << e

    false
  end

  def parse_yaml_file
    return unless load_yaml_data

    data = if show_everything?
             @yaml_data[:items].uniq.map { |s| DataLine.new s, location: location }
           else
             @yaml_data[:items].uniq.reject(&:empty?).map { |s| DataLine.new s, location: location }
           end

    @data_lines = select_data data
  end

  def show_everything?
    %i[in_stock all_items].include? @type
  end

  # rubocop:disable Metrics/CyclomaticComplexity
  def select_data(data)
    case @type
    when :expiring
      data.reject(&:out_of_stock?).select { |l| l.expiring? || l.expired? }
    when :out_of_stock
      data.select(&:out_of_stock?)
    when :in_stock
      data.reject(&:out_of_stock?)
    else
      data
    end
  end
  # rubocop:enable Metrics/CyclomaticComplexity

  def exists?
    File.exist? @file_path
  end
end
