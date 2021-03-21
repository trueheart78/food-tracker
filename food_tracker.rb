# frozen_string_literal: true

# FoodTracker is a Sinatra-based application to display the proper kitchen-based-items.
class FoodTracker < Sinatra::Base
  set :environment, Env.to_sym

  before do
    redirect(request.url.sub('http', 'https'), 308) if Env.force_ssl?request
    
    @default = { color: '#ffdb58' }
      
    @site = { url:             Env.host(request),
              image:           image('hamburger.png', request: request),
              image_alt:       'hamburger',
              twitter_creator: Env.twitter_creator,
              twitter_site:    Env.twitter_site,
              domain:          Env.domain(request),
              title:           'Food, Pls?',
              color:           @default[:color]
    }
    end
  end

  get '/' do
    @image = image 'hamburger.png'

    site_erb :index
  end

  get '/in-the-kitchen' do
    @data_files = Dir['data/*.yaml'].sort.map { |file| DataFile.new(file) }

    @site[:title] = 'In The Kitchen'

    site_erb :kitchen
  end

  get '/expiring' do
    @data_files = Dir['data/*.yaml'].sort.map { |file| DataFile.new(file) }.select(&:expiring?)

    @site[:color] = '#ffc0cb'
    @site[:title] = 'Expiring'
    @success_gif = image 'hamburger-rotating.gif'

    site_erb :expiring
  end
  
  get '/out-of-stock' do
    @data_files = Dir['data/*.yaml'].sort.map { |file| DataFile.new(file) }.select(&:out_of_stock?)

    @site[:color] = '#add8e6'
    @site[:title] = 'Out of Stock'
    @success_gif = image 'hamburger-rotating.gif'

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
    set_site_icons
    
    erb view.to_sym
  end
  
  def set_site_icons
    @site[:touch_icon] = 'apple-touch-icon.png'
    @site[:precomposed_icon] = 'apple-touch-icon-procomposed.png'
    
    unless @site[:color] == @default[:color]
      @site[:touch_icon] = touch_icon if public_file? touch_icon
      @site[:precomposed_icon] = precomposed_icon if public_file? precomposed_json
    end
  end
  
  def public_file?(file)
    File.exist? File.join('public', file)
  end
  
  def touch_icon
    "apple-touch-icon-#{@site[:color].sub('#', '')}.png"
  end
  
  def precomposed_icon
    "apple-touch-icon-precomposed-#{@site[:color].sub('#', '')}.png"
  end

  def image(name, request: nil)
    return [Env.host(request), 'images', name].join('/') if request

    ['/images', name].join '/'
  end
end
