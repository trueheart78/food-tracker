# frozen_string_literal: true

# DataFile consumes a text-based file
class DataFile
  def initialize(file_path)
    @file_path = file_path
    @data = []
    @data_loaded = false
  end

  def valid?
    return false unless exists?

    true
  end

  def to_s
    data
  end

  private

  def data
    return [] unless exists?
    return @data if data_loaded?

    @data = File.readlines(@file_path).map(&:chomp)
    @data_loaded = true
  end

  def exists?
    File.exist? @file_path
  end

  def data_loaded?
    @data_loaded
  end
end
