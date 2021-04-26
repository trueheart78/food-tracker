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

  private

  def image(name, full_url: false)
    return [url, 'images', name].join('/') if full_url

    ['/images', name].join '/'
  end
end
