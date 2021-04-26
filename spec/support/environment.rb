# frozen_string_literal: true

module Support
  module Environment
    def dummy_request(url:, ssl: false)
      OpenStruct.new base_url: url, ssl?: ssl
    end

    def set_env(name, value)
      name = name.to_s

      cached_vars[name] = ENV[name]
      ENV[name] = value.to_s
    end

    def restore_env(name: nil)
      if name.nil?
        cached_vars.each do |(key, value)|
          ENV[key] = value
        end

        reset_cached_vars
      else
        ENV[name] = cached_vars.delete name
      end
    end

    def cached_vars
      @cached_vars ||= {}
    end

    def reset_cached_vars
      @cached_vars = {}
    end
  end
end
