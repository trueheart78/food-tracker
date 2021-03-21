# frozen_string_literal: true

module Support
  module Coverage
    def self.included(klass)
      require 'simplecov'

      SimpleCov.minimum_coverage 90

      SimpleCov.start do
        add_filter '/spec/'
      end
    end
  end
end