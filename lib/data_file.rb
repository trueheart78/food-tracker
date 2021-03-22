# frozen_string_literal: true

# DataFile consumes a text-based file
class DataFile
  class InvalidType < StandardError; end

  def initialize(file_path, type: :in_stock)
    @file_path = file_path
    @errors = []

    raise InvalidType, "Unsupported type: :#{type}" unless supported_type? type

    @type = type
  rescue InvalidType => e
    @errors << e
  end

  def valid?
    return false if @errors.any?
    return false unless File.extname(@file_path) == '.yaml'
    return false unless exists?
    return false if data_lines.none?(&:valid?)

    true
  end

  def errors?
    @errors.any?
  end

  def errors
    @errors
  end

  def expiring?
    in_stock_data_lines.any?(&:expiring?) || in_stock_data_lines.any?(&:expired?)
  end

  def out_of_stock?
    out_of_stock_data_lines.any?
  end

  def empty?

  end

  def to_s
    binding.pry
    return '<li>🦖</li>' unless data_lines.any?

    data_lines.map { |l| "<li>#{l}</li>\n" }.join
  end

  def name
    yaml_data[:name]
  end

  def safe_name
    name.downcase.sub(' ', '_')
  end

  def self.load(type: :in_stock, directory: 'data')
    raise InvalidType, "Unsupported type: :#{type}" unless supported_type? type

    # return data.select(&:expiring?) if type == :expiring
    # return data.select(&:out_of_stock?) if type == :out_of_stock
    Dir["#{directory}/*.yaml"].sort.map { |file| new file, type: type }
  end

  private

  def self.supported_type?(type)
    %i[in_stock expiring out_of_stock].include? type.to_sym
  end

  def supported_type?(type)
    %i[in_stock expiring out_of_stock].include? type.to_sym
  end

  def yaml_data
    return {} unless exists?

    @yaml_data ||= YAML.load_file(@file_path)
  end

  def data_lines
    return [] unless exists?

    # return @data_lines if @data_lines

    data = yaml_data[:items].reject(&:empty?)
    if @type == :in_stock
      @data_lines = data.map { |s| DataLine.new s }.reject(&:out_of_stock?)
    elsif @type == :expiring
      @data_lines = data.map { |s| DataLine.new s }.reject(&:out_of_stock).select { |l| l.expiring? || l.expired? }
    elsif @type == :out_of_stock
      @data_lines = data.map { |s| DataLine.new s }.select(&:out_of_stock?)
    end
  end

  def exists?
    File.exist? @file_path
  end
end
