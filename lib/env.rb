# frozen_string_literal: true

# Env handles environment and request details
class Env
  class << self
    def production?
      ENV['APP_ENV'] == 'production'
    end

    def development?
      ENV['APP_ENV'] == 'development'
    end

    def test?
      ENV['APP_ENV'] == 'test'
    end

    def to_s
      ENV['APP_ENV']
    end

    def to_sym
      ENV['APP_ENV'].to_sym
    end

    def twitter_handle?
      return false if twitter_creator.empty?

      true
    end

    def twitter_creator
      return '' if ENV['TWITTER_CREATOR'].nil?
      return '' if ENV['TWITTER_CREATOR'].empty?

      return "@#{ENV['TWITTER_CREATOR']}" unless ENV['TWITTER_CREATOR'].start_with? '@'

      ENV['TWITTER_CREATOR']
    end

    def twitter_site
      return twitter_creator if ENV['TWITTER_SITE'].nil?
      return twitter_creator if ENV['TWITTER_SITE'].empty?

      return "@#{ENV['TWITTER_SITE']}" unless ENV['TWITTER_SITE'].start_with? '@'

      ENV['TWITTER_SITE']
    end

    def host(request)
      request.base_url
    end

    def domain(request)
      request.base_url.sub('https://', '').sub('http://', '')
    end

    def force_ssl?(request)
      production? && !request.ssl?
    end
  end
end
