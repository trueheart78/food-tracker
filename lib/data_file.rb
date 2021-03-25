# frozen_string_literal: true

# DataFile consumes a text-based file
class DataFile
  class InvalidType < StandardError; end

  def initialize(file_path, type: :in_stock)
    @file_path = file_path
    @errors = []

    raise InvalidType, "Unsupported type: :#{type}" unless self.class.supported_type? type

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
    data_lines.any?(&:expiring?) || data_lines.any?(&:expired?)
  end

  def out_of_stock?
    data_lines.any?
  end

  def display?
    return false unless valid?

    return true if @type == :in_stock
    return true if @type == :expiring && expiring?
    return true if @type == :out_of_stock && data_lines.any?

    false
  end

  def empty?
    @type == :in_stock && data_lines.empty?
  end

  def to_html
    if empty?
      '<ol><li>🦖</li></ol>'
    else
      "<ol>#{data_lines.map(&:to_html).join}</ol>"
    end
  end

  def name
    yaml_data[:name]
  end

  def safe_name
    name.downcase.sub(' ', '_')
  end

  def self.load(type: :in_stock, directory: 'data')
    raise InvalidType, "Unsupported type: :#{type}" unless supported_type? type

    data = Dir["#{directory}/*.yaml"].sort.map { |file| new file, type: type }

    if type == :expiring
      data.select!(&:expiring?)
    elsif type == :out_of_stock
      data.select!(&:out_of_stock?)
    end

    data
  end

  def self.supported_type?(type)
    %i[in_stock expiring out_of_stock].include? type.to_sym
  end

  private

  def location
    @location ||= yaml_data[:location]
  end

  def yaml_data
    return {} unless exists?

    @yaml_data ||= YAML.load_file(@file_path)
  end

  def data_lines
    return [] unless exists?

    return @data_lines if @data_lines

    data = yaml_data[:items].reject(&:empty?).map { |s| DataLine.new s, location: location }
    @data_lines = case @type
                  when :expiring
                    data.reject(&:out_of_stock?).select { |l| l.expiring? || l.expired? }
                  when :out_of_stock
                    data.select(&:out_of_stock?)
                  else
                    data.reject(&:out_of_stock?)
                  end
  end

  def exists?
    File.exist? @file_path
  end
end
