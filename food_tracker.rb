# frozen_string_literal: true

# FoodTracker is a Sinatra-based app to display the proper kitchen-based-items.
class FoodTracker < Sinatra::Base
  include Helpers::FoodTracker

  set :environment, Env.to_sym

  before do
    headers 'Referrer-Policy' => 'strict-origin-when-cross-origin'
    headers 'Strict-Transport-Security' => 'max-age=16070400; includeSubDomains'
    headers 'X-Xss-Protection' => '0'

    redirect(request.url.sub('http', 'https'), 308) if Env.force_ssl? request

    @site = site_settings request
  end

  get '/' do
    @image = site_image

    site_erb :index
  end

  get '/in-the-kitchen' do
    @data_files = DataFile.load

    @site[:title] = 'In The Kitchen'

    site_erb :kitchen
  end

  get '/expiring' do
    @data_files = DataFile.load type: :expiring

    @site[:color] = '#ffc0cb'
    @site[:title] = 'Expiring'
    @success_gif = site_gif

    site_erb :expiring
  end

  get '/out-of-stock' do
    @data_files = DataFile.load type: :expiring

    @site[:color] = '#add8e6'
    @site[:title] = 'Out of Stock'
    @success_gif = site_gif

    site_erb :out_of_stock
  end

  get '/env' do
    redirect '/environment'
  end

  get '/environment' do
    redirect '/' unless settings.development?

    @site[:title] = 'Environment Variables'
    @site[:color] = '#ffffff'

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

    erb view.to_sym
  end
end
