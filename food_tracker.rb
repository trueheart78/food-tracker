# frozen_string_literal: true

# FoodTracker is a Sinatra-based app to display the proper kitchen-based-items.
class FoodTracker < Sinatra::Base
  set :environment, Env.to_sym

  use Honeybadger::Rack::UserInformer
  use Honeybadger::Rack::UserFeedback

  include Helpers::FoodTracker

  before do
    set_header_restrictions

    redirect(request.url.sub('http', 'https'), 308) if Env.force_ssl? request

    @site = site_settings request
    @xsite = Site.new url: Env.url(request), domain: Env.domain(request)
    @twitter = OpenStruct.new creator:   Env.twitter_creator,
                              site:      Env.twitter_site,
                              image_alt: @xsite.icon
  end

  get '/' do
    @image = site_image
    @site[:show_footer] = false unless settings.development?

    @image = @xsite.png
    @xsite.disable_footer unless settings.development?

    site_erb :index
  end

  get '/in-the-kitchen' do
    @data_files = DataFile.load(type: :in_stock).select(&:display?)

    @site[:title] = 'In The Kitchen'
    @xsite.title = 'In The Kitchen'

    site_erb :kitchen
  end

  get '/expiring' do
    @data_files = DataFile.load(type: :expiring).select(&:display?)

    @site[:title] = 'Expiring'
    @site[:style] = :expiring

    @xsite.title = 'Expiring'
    @xsite.style = :expiring

    site_erb :expiring
  end

  get '/out-of-stock' do
    @data_files = DataFile.load(type: :out_of_stock).select(&:display?)

    @site[:title] = 'Out of Stock'
    @site[:style] = :out_of_stock

    @xsite.title = 'Out of Stock'
    @xsite.style = :out_of_stock

    site_erb :out_of_stock
  end

  get '/all-items' do
    @data_files = DataFile.load(type: :all).select(&:display?)

    @site[:title] = 'All Items'
    @site[:style] = :all_items

    @xsite.title = 'All Items'
    @xsite.style = :all_items

    site_erb :all
  end

  get '/env' do
    redirect '/environment'
  end

  get '/environment' do
    redirect '/' unless settings.development?

    @site[:title] = 'Environment Variables'
    @site[:style] = :environment_vars

    @xsite.title = 'Environment Variables'
    @xsite.style = :environment_vars

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
    headers 'Permissions-Policy' => "geolocation=(self \"#{Env.url(request)}\"), microphone=()"
  end
end
