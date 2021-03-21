# frozen_string_literal: true

# DataFile consumes a text-based file
class DataFile
  def initialize(file_path)
    @file_path = file_path
  end

  def valid?
    return false unless File.extname(@file_path) == '.yaml'
    return false unless exists?
    return false if data_lines.none?(&:valid?)

    true
  end

  def expiring?
    in_stock_data_lines.any?(&:expiring?) || in_stock_data_lines.any?(&:expired?)
  end

  def out_of_stock?
    out_of_stock_data_lines.any?
  end

  def to_s(in_stock: true)
    lines = (in_stock) ? in_stock_data_lines : out_of_stock_data_lines

    return '<li>🦖</li>' unless lines.any?

    lines.map { |l| "<li>#{l}</li>\n" }.join
  end

  def name
    yaml_data[:name]
  end

  def safe_name
    name.downcase.sub(' ', '_')
  end

  def self.load(type: :all)
    data = Dir['data/*.yaml'].sort.map { |file| new file }

    return data.select(&:expiring?) if type == :expiring
    return data.select(&:out_of_stock?) if type == :out_of_stock

    data
  end

  private

  def yaml_data
    return {} unless exists?

    @yaml_data ||= YAML.load_file(@file_path)
  end

  def data_lines
    return [] unless exists?

    @data_lines ||= yaml_data[:items].reject(&:empty?).map { |s| DataLine.new s }
  end

  def in_stock_data_lines
    @in_stock_data_lines ||= data_lines.reject(&:out_of_stock?)
  end

  def out_of_stock_data_lines
    @out_of_stock_data_lines ||= data_lines.select(&:out_of_stock?)
  end

  def exists?
    File.exist? @file_path
  end
end
