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
    data_lines.any?(&:expiring?) || data_lines.any?(&:expired?)
  end

  def to_s
    return '<li>🦖</li>' unless data_lines.any?

    data_lines.map { |l| "<li>#{l}</li>\n" }.join
  end

  def name
    yaml_data[:name]
  end

  def safe_name
    name.downcase.sub(' ', '_')
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

  def exists?
    File.exist? @file_path
  end
end
