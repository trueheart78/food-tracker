# frozen_string_literal: true

# DataLine consumes a string
class DataLine
  def initialize(string)
    @string = string
  end

  def empty?
    @string.nil? || @string.empty?
  end

  def valid?
    return false if empty?

    true
  end

  def to_s
    @string
  end
end
