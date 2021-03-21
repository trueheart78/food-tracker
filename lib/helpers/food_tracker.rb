# frozen_string_literal: true

module Helpers
  module FoodTracker
    def site_icon
      'hamburger'
    end

    def site_description
      'A personalized food tracker.'
    end

    def site_settings(request)
      {
        url:         Env.host(request),
        image:       image("#{site_icon}.png", request: request),
        twitter:     twitter_settings,
        domain:      Env.domain(request),
        title:       default_settings[:title],
        description: site_description,
        color:       default_settings[:color]
      }
    end

    def twitter_settings
      {
        image_alt: site_icon,
        creator:   Env.twitter_creator,
        site:      Env.twitter_site
      }
    end

    def default_settings
      {
        title: 'Food, Pls?',
        color: '#ffdb58'
      }
    end

    def insert_touch_icons(site)
      site[:touch_icon] = 'apple-touch-icon.png'
      site[:precomposed_icon] = 'apple-touch-icon-procomposed.png'

      unless site[:color] == default_settings[:color]
        color = site[:color].downcase.sub('#', '')

        site[:touch_icon] = touch_icon(color) if public? touch_icon(color)
        site[:precomposed_icon] = precomposed_icon(color) if public? precomposed_icon(color)
      end

      site
    end

    def public?(file)
      File.exist? File.join('public', file)
    end

    def touch_icon(color)
      "apple-touch-icon-#{color}.png"
    end

    def precomposed_icon(color)
      "apple-touch-icon-precomposed-#{color}.png"
    end

    def image(name, request: nil)
      return [Env.host(request), 'images', name].join('/') if request

      ['/images', name].join '/'
    end

    def site_image
      image "#{site_icon}.png"
    end

    def site_gif
      image "#{site_icon}-rotating.gif"
    end
  end
end
