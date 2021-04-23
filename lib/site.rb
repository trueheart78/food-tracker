# frozen_string_literal: true

class Site
  attr_reader :url, :domain, :icon, :description

  def initialize(url:, domain:)
    @url         = url
    @domain      = domain
    @icon        = :hamburger
    @description = 'A personalized food tracker.'
  end
end
