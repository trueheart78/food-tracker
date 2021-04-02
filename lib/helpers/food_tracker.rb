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
        title:       'Food, Pls?',
        description: site_description,
        style:       :default,
        show_footer: true
      }
    end

    def twitter_settings
      {
        image_alt: site_icon,
        creator:   Env.twitter_creator,
        site:      Env.twitter_site
      }
    end

    def insert_stylesheets(site)
      site[:stylesheets] = case site[:style]
                           when :expiring
                             ['main.css', 'background-colors/expiring.css']
                           when :out_of_stock
                             ['main.css', 'background-colors/out_of_stock.css']
                           when :environment_vars
                             ['main.css', 'environment_vars.css']
                           else
                             ['main.css', 'background-colors/default.css']
                           end
      site
    end

    def insert_touch_icons(site)
      site[:touch_icons] = case site[:style]
                           when :expiring, :out_of_stock
                             type = site[:style].to_s.tr('_', '-')
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
      site
    end

    def insert_assigned_color(site)
      site[:color] = case site[:style]
                     when :expiring
                       '#ffc0cb'
                     when :out_of_stock
                       '#add8e6'
                     when :environment_vars
                       '#ffffff'
                     else
                       '#ffdb58'
                     end
      site
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
