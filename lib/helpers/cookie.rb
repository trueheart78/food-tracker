# frozen_string_literal: true

module Helpers
  module Cookie
    def settings
      cookie_settings = {
        key:           'usr',
        path:          '/',
        expire_after:  86_400, # 1 day
        secret:        ENV['APP_SECRET_HASH'],
        httponly:      true
      }
      cookie_settings.merge!(secure: true) if Env.production?

      cookie_settings
    end
    
    module_function :settings
  end
end
