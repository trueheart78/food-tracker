# frozen_string_literal: true

require 'data_line'

# DataFile consumes a text-based file
class DataFile
  def initialize(file_path)
    @file_path = file_path
    @data_lines = []
    @data_loaded = false
  end

  def valid?
    return false unless exists?
    return false if data_lines.none?(&:valid?)

    true
  end

  def to_s
    data_lines.map { |l| "<li>#{l}</li>\n" }.join
  end

  def name
    @name ||= File.basename(@file_path).sub('.txt','').split('_').map(&:capitalize).join(' ')
  end

  def safe_name
    name.downcase.sub(' ', '_')
  end

  private

  def data_lines
    return [] unless exists?
    return @data_lines if data_loaded?

    @data_lines = File.readlines(@file_path).map(&:chomp).reject(&:empty?).map { |s| DataLine.new s }
    @data_loaded = true

    @data_lines
  end

  def exists?
    File.exist? @file_path
  end

  def data_loaded?
    @data_loaded
  end
end
