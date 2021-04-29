# frozen_string_literal: true

class Site
  attr_accessor :title, :style
  attr_reader   :url, :domain, :icon, :description

  def initialize(url:, domain:)
    @url         = url
    @domain      = domain
    @icon        = :hamburger
    @title       = 'Food, Pls?'
    @description = 'A personalized food tracker.'
    @style       = :default
    @show_footer = true
  end

  def disable_footer
    @show_footer = false
  end

  def footer?
    @show_footer
  end

  def png_url
    image "#{icon}.png", full_url: true
  end

  def png
    image "#{icon}.png"
  end

  def gif
    image "#{icon}-rotating.gif"
  end

  def type
    style.to_s.tr('_', ' ')
  end

  def stylesheets
    case style
    when :in_stock, :expiring, :out_of_stock, :all_items
      ['main.css', "background-colors/#{style}.css"]
    when :environment_vars
      ['main.css', 'environment_vars.css']
    else
      ['main.css', 'background-colors/default.css']
    end
  end

  def touch_icons
    case style
    when :expiring, :out_of_stock
      {
        default:     "apple-touch-icon-#{transpose}.png",
        precomposed: "apple-touch-icon-procomposed-#{transpose}.png"
      }
    else
      {
        default:     'apple-touch-icon.png',
        precomposed: 'apple-touch-icon-procomposed.png'
      }
    end
  end

  # rubocop:disable Metrics/MethodLength
  def color
    case style
    when :in_stock
      { code: '#c4aead', name: 'silver pink' }
    when :expiring
      { code: '#ffc0cb', name: 'pink' }
    when :out_of_stock
      { code: '#add8e6', name: 'light blue' }
    when :all_items
      { code: '#e9ffdb', name: 'nyanza' }
    when :environment_vars
      { code: '#ffffff', name: 'white' }
    else
      { code: '#ffdb58', name: 'hamburger yellow' }
    end
  end
  # rubocop:enable Metrics/MethodLength

  # rubocop:disable Metrics/MethodLength
  def header
    case style
    when :in_stock
      '🍉 In The Kitchen 🍉'
    when :expiring
      '📅 Expiring 📅'
    when :out_of_stock
      '📝 Out of Stock 📝'
    when :all_items
      '📚 All Items 📚'
    when :environment_vars
      '📖 Environment Variables 📖'
    else
      ''
    end
  end
  # rubocop:enable Metrics/MethodLength

  private

  def image(name, full_url: false)
    return [url, 'images', name].join('/') if full_url

    ['/images', name].join '/'
  end

  def transpose
    style.to_s.tr('_', '-')
  end
end
