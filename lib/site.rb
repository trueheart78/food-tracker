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
end
