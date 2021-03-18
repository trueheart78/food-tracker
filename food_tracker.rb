# frozen_string_literal: true

# FoodTracker is a Sinatra-based application to display the proper kitchen-based-items.
class FoodTracker < Sinatra::Base
  set :environment, Env.to_sym

  before do
    if Env.force_ssl?(request)
      redirect request.url.sub('http', 'https'), 308
    else
      @site = { url:    Env.host(request),
                image:  image('hamburger.png', request: request),
                domain: Env.domain(request),
                title: 'Food, Pls?',
                color: '#ffdb58'
      }
    end
  end

  get '/' do
    @image = image 'hamburger.png'

    erb :index
  end

  get '/in-the-kitchen' do
    @data_files = Dir['data/*.yaml'].sort.map { |file| DataFile.new(file) }

    @site[:title] = 'In The Kitchen'

    erb :kitchen
  end

  get '/expiring' do
    @data_files = Dir['data/*.yaml'].sort.map { |file| DataFile.new(file) }.select(&:expiring?)

    @site[:color] = '#ffc0cb'
    @site[:title] = 'Expiring'
    @success_gif = image 'hamburger-rotating.gif'

    erb :expiring
  end

  get '/caching' do
    @gif = image 'hamburger-rotating.gif'

    erb :caching
  end

  get '/api' do
    json food: 'I love to eat it!'
  end

  get '/env' do
    redirect '/environment'
  end

  get '/environment' do
    redirect '/' unless settings.development?

    @site[:title] = 'Environment Variables'
    @site[:color] = '#ffffff'

    erb :environment
  end

  # catch-all routes
  get '/*' do
    redirect '/'
  end

  post '/*' do
    404
  end

  # private

  def image(name, request: nil)
    return [Env.host(request), 'images', name].join('/') if request

    ['/images', name].join '/'
  end
end
