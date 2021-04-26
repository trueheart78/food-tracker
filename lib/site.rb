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

  def stylesheets
    case style
    when :expiring, :out_of_stock, :all_items
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
        default:     "apple-touch-icon-#{type}.png",
        precomposed: "apple-touch-icon-procomposed-#{type}.png"
      }
    else
      {
        default:     'apple-touch-icon.png',
        precomposed: 'apple-touch-icon-procomposed.png'
      }
    end
  end

  def color
    case style
    when :expiring
      '#ffc0cb' # pink
    when :out_of_stock
      '#add8e6' # light blue
    when :all_items
      '#e9ffdb' # nyanza
    when :environment_vars
      '#ffffff' # white
    else
      '#ffdb58' # hamburger yellow
    end
  end

  private

  def image(name, full_url: false)
    return [url, 'images', name].join('/') if full_url

    ['/images', name].join '/'
  end

  def type
    style.to_s.tr('_', '-')
  end
end
