# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
class DataLine
  class ErroneusBar < StandardError; end

  class ErroneusCarrot < StandardError; end

  class ErroneusCurlyBrace < StandardError; end

  class ErroneusParenthesis < StandardError; end

  class ErroneusSquareBracket < StandardError; end

  class InvalidDate < StandardError; end

  class InvalidLocation < StandardError; end

  OUT_OF_STOCK_MARKER = '^oos^'

  attr_reader :errors

  def initialize(string, location:)
    @string = string
    @location = location
    @parsed = false

    @brands = []
    @best_by_dates = []
    @custom_locations = []
    @expiration_dates = []
    @out_of_stock = false
    @errors = []

    parse
  end

  def empty?
    @string.nil? || @string.empty?
  end

  def expiring?
    return false unless @expiration_dates.any?

    expiring = false
    @expiration_dates.each do |expiration_date|
      return false if already_expired? expiration_date

      if expiring_soon? expiration_date
        expiring = true
        break
      end
    end

    expiring
  end

  def expired?
    return false unless @expiration_dates.any?

    expired = false
    @expiration_dates.each do |expiration_date|
      if already_expired? expiration_date
        expired = true
        break
      end
    end

    expired
  end

  def out_of_stock?
    @out_of_stock
  end

  def valid?
    return false if @string.nil?
    # return false if empty?
    return false if @errors.any?

    true
  end

  def errors?
    @errors.any?
  end

  def name
    @string
  end

  def to_s
    @string
  end

  def to_html
    return '🦖' if empty?

    [@string, expiration_html].join(' ')
  end

  private

  def safe_name
    name.tr('"', '')
  end

  def date_format
    '%-m/%-d/%y'
  end

  # rubocop:disable Metrics/MethodLength
  def expiration_html
    return '' unless @expiration_dates.any?

    [].tap do |html|
      @expiration_dates.each do |expiration_date|
        css_class = if already_expired? expiration_date
                      :expired
                    elsif expiring_soon? expiration_date
                      :expiring
                    else
                      :unexpired
                    end
        html << "<span class='#{css_class}'>[#{expiration_date.strftime(date_format)}]</span>"
      end
    end.join(' ')
  end
  # rubocop:enable Metrics/MethodLength

  def already_expired?(date)
    date <= Date.today
  end

  def expiring_soon?(date)
    date <= (Date.today + 3)
  end

  def supported_custom_location?(location)
    [
      'candy dish',
      'counter',
      'cupboard',
      'fridge',
      'freezer',
      'pantry'
    ].include? location
  end

  def parse
    return if @parsed || @string.nil?

    validate_location

    extract_best_by_dates
    extract_brands
    extract_custom_locations
    extract_expiration_dates
    extract_out_of_stock_marker

    validate_string

    @parsed = true
  end

  # Best By dates are notated by bars
  def extract_best_by_dates
    matches = @string.scan(%r{\|\d+/\d+/\d+\|})
    matches.each do |match|
      date = match.sub('|', '')
      @string = @string.sub(match, '').rstrip
      @best_by_dates << Date.strptime(date, '%m/%d/%y')
    end
    @best_by_dates.uniq!
  rescue ArgumentError => e
    raise e unless e.message == 'invalid date'

    @errors << InvalidDate.new("Bad date found in #{matches.join(', ')}")
  end

  # Brands are notated by curly braces
  def extract_brands
    matches = @string.scan(/(?<=\{)[^}]+(?=\})/)
    matches.each do |brand|
      @string = @string.sub("{#{brand}}", '').rstrip
      @brands << brand
    end
    @brands.uniq!
  end

  # Custom Locations are notated by parentheses
  # rubocop:disable Style/GuardClause
  def extract_custom_locations
    matches = @string.scan(/(?<=\()[^)]+(?=\))/)
    matches.each do |custom_location|
      @string = @string.sub("(#{custom_location})", '').rstrip
      if supported_custom_location? custom_location
        @custom_locations << custom_location.split.map(&:capitalize).join(' ')
      else
        raise InvalidLocation, "Unsupported custom location found: #{custom_location}"
      end
    end
    @custom_locations.uniq!
  rescue InvalidLocation => e
    @errors << e
  end
  # rubocop:enable Style/GuardClause

  # Expiration Dates are notated by square brackets
  def extract_expiration_dates
    matches = @string.scan(%r{\[\d+/\d+/\d+\]})
    matches.each do |match|
      date = match.sub('[', '').sub(']', '')
      @string = @string.sub(match, '').rstrip
      @expiration_dates << Date.strptime(date, '%m/%d/%y')
    end
    @expiration_dates.uniq!
  rescue ArgumentError => e
    raise e unless e.message == 'invalid date'

    @errors << InvalidDate.new("Bad date found in #{matches.join(', ')}")
  end

  def extract_out_of_stock_marker
    @out_of_stock = @string.include? OUT_OF_STOCK_MARKER
    @string = @string.sub(OUT_OF_STOCK_MARKER, '').rstrip
  end

  def validate_location
    unless supported_custom_location? @location.downcase
      raise InvalidLocation, "Unsupported default location found: #{@location}"
    end
  rescue InvalidLocation => e
    @errors << e
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
    @errors << ErroneusCurlyBrace.new('Extra opening curly brace detected') if @string.include? '{'

    @errors << ErroneusCurlyBrace.new('Extra closing curly brace detected') if @string.include? '}'
  end

  def validate_parentheses
    @errors << ErroneusParenthesis.new('Extra opening parenthesis detected') if @string.include? '('

    @errors << ErroneusParenthesis.new('Extra closing parenthesis detected') if @string.include? ')'
  end

  # rubocop:disable Style/GuardClause
  def validate_square_brackets
    if @string.include? '['
      @errors << ErroneusSquareBracket.new('Extra opening square bracket detected')
    end

    if @string.include? ']'
      @errors << ErroneusSquareBracket.new('Extra closing square bracket detected')
    end
  end
  # rubocop:enable Style/GuardClause
end
# rubocop:enable Metrics/ClassLength
