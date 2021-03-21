# frozen_string_literal: true

# DataLine consumes a string
class DataLine
  class ErroneusBar < StandardError; end
  class ErroneusCarrot < StandardError; end
  class ErroneusCurlyBrace < StandardError; end
  class ErroneusParenthesis < StandardError; end
  class ErroneusSquareBracket < StandardError; end
  class InvalidDate < StandardError; end

  def initialize(string)
    @string = string
    @parsed = false

    @brands = []
    @best_by_dates = []
    @custom_locations = []
    @expiration_dates = []
    @out_of_stock = false
    @errors = []
  end

  def empty?
    parse

    @string.nil? || @string.empty?
  end

  def expiring?
    parse

    return false unless @expiration_dates.any?

    false
  end

  def expired?
    parse

    return false unless @expiration_dates.any?

    expired = false
    @expiration_dates.each do |date|
      if Date.today > date
        expired = true
        break
      end
    end

    expired
  end

  def out_of_stock?
    parse

    @out_of_stock
  end

  def valid?
    parse unless @string.nil?

    return false if @string.nil?
    return false if empty?
    return false if @errors.any?

    true
  end

  def errors?
    parse

    @errors.any?
  end

  def errors
    parse

    @errors
  end

  def to_s
    parse

    @string
  end

  private

  def parse
    return if @parsed

    extract_best_by_dates
    extract_brands
    extract_custom_locations
    extract_expiration_dates
    extract_out_of_stock_marker

    validate_string

    @parsed = true
  end

  # best by dates are notated by bars
  def extract_best_by_dates
    matches = @string.scan(%r{(\|\d+\/\d+\/\d+\|)}).flatten
    matches.each do |match|
      date = match.sub('|', '')
      @best_by_dates << Date.strptime(date, '%m/%d/%y')
      @string = @string.sub(match, '').rstrip
    end
  rescue ArgumentError => e
    raise e unless e.message == 'invalid date'

    @errors << InvalidDate.new("Bad date found in #{matches.join(', ')}")
  end

  # brands are notated by curly braces
  def extract_brands

  end

  # custom locations are notated by parentheses
  def extract_custom_locations
    matches = @string.scan(/(\(candy dish\)|\(counter\)|\(cupboard\)|\(fridge\)|\(freezer\)|\(pantry\))/).flatten
    matches.each do |match|
      @custom_locations << match.sub('(', '').sub(')', '')
      @string = @string.sub(match, '').rstrip
    end
  end

  # expiration dates are notated by square brackets
  def extract_expiration_dates
    matches = @string.scan(%r{(\[\d+\/\d+\/\d+\])}).flatten
    matches.each do |match|
      date = match.sub('[', '').sub(']', '')
      @expiration_dates << Date.strptime(date, '%m/%d/%y')
      @string = @string.sub(match, '').rstrip
    end
  rescue ArgumentError => e
    raise e unless e.message == 'invalid date'

    @errors << InvalidDate.new("Bad date found in #{matches.join(', ')}")
  end

  def extract_out_of_stock_marker
    @out_of_stock = @string.include? '^oos^'
    @string = @string.sub('^oos^', '').rstrip
  end

  def validate_string
    validate_bars
    validate_carrots
    validate_curly_braces
    validate_parentheses
    validate_square_brackets
  end

  def validate_bars
    return unless @string.include? '|'

    @errors << ErroneusBar.new('Extra bar detected')
  end

  def validate_carrots
    return unless @string.include? '^'

    @errors << ErroneusCarrot.new('Extra carrot detected')
  end

  def validate_curly_braces
    if @string.include? '{'
      @errors << ErroneusCurlyBrace.new('Extra opening curly brace detected')
    end

    if @string.include? '}'
      @errors << ErroneusCurlyBrace.new('Extra closing curly brace detected')
    end
  end

  def validate_parentheses
    if @string.include? '('
      @errors << ErroneusParenthesis.new('Extra opening parenthesis detected')
    end

    if @string.include? ')'
      @errors << ErroneusParenthesis.new('Extra closing parenthesis detected')
    end
  end

  def validate_square_brackets
    if @string.include? '['
      @errors << ErroneusSquareBracket.new('Extra opening square bracket detected')
    end

    if @string.include? ']'
      @errors << ErroneusSquareBracket.new('Extra closing square bracket detected')
    end
  end
end
