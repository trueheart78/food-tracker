# frozen_string_literal: true

# FoodTracker is a Sinatra-based app to display the proper kitchen-based-items.
class FoodTracker < Sinatra::Base
  include Helpers::FoodTracker

  set :environment, Env.to_sym

  before do
    set_header_restrictions

    redirect(request.url.sub('http', 'https'), 308) if Env.force_ssl? request

    @site = site_settings request
  end

  get '/' do
    @image = site_image
    @site[:show_footer] = false unless settings.development?

    site_erb :index
  end

  get '/in-the-kitchen' do
    @data_files = DataFile.load

    @site[:title] = 'In The Kitchen'

    site_erb :kitchen
  end

  get '/expiring' do
    @data_files = DataFile.load(type: :expiring).select(&:display?)

    @site[:title] = 'Expiring'
    @site[:style] = :expiring
    @success_gif = site_gif

    site_erb :expiring
  end

  get '/out-of-stock' do
    @data_files = DataFile.load(type: :out_of_stock).select(&:display?)

    @site[:title] = 'Out of Stock'
    @site[:style] = :out_of_stock
    @success_gif = site_gif

    site_erb :out_of_stock
  end

  get '/env' do
    redirect '/environment'
  end

  get '/environment' do
    redirect '/' unless settings.development?

    @site[:title] = 'Environment Variables'
    @site[:style] = :environment_vars

    site_erb :environment
  end

  # catch-all routes
  get '/*' do
    redirect '/'
  end

  post '/*' do
    404
  end

  private

  def site_erb(view)
    @site = insert_touch_icons @site
    @site = insert_stylesheets @site
    @site = insert_assigned_color @site

    erb view.to_sym
  end

  def set_header_restrictions
    # strict-origin-when-cross-origin is also valid
    headers 'Referrer-Policy' => 'no-referrer'
    headers 'Strict-Transport-Security' => 'max-age=16070400; includeSubDomains'
    headers 'X-Content-Type-Options' => 'nosniff'
    headers 'X-Download-Options' => 'noopen'
    headers 'X-Frame-Options' => 'sameorigin'
    headers 'X-Permitted-Cross-Domain-Policies' => 'none'
    headers 'X-XSS-Protection' => '0'
    headers 'Permissions-Policy' => "geolocation=(self \"#{Env.host(request)}\"), microphone=()"
  end
end
