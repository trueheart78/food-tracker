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
                domain: Env.domain(request)
      }
    end
  end

  get '/' do
    @image = image 'hamburger.png'

    erb :index
  end

  get '/in-the-kitchen' do
    # TODO: if cache is not up-to-date, redirect to '/caching'
    @image = image 'hamburger.png'

    files = Dir['data/*.txt'].sort
    output = []
    files.each do |file|
      output << file
      output += File.readlines(file).map(&:chomp)
    end

    data = output.reject { |o| o == '' }.map { |o| "<li>#{o} </li>\n" }
    erb :kitchen do
      "<ol>#{data.join}</ol>"
    end
  end

  get '/caching' do
    @gif = image 'hamburger-rotating.gif'

    erb :caching
  end

  get '/caching-perform' do
    # TODO: make sure this isn't already running
    20.times { sleep 1 }

    redirect '/'
  end

  get '/caching-flush' do
    # TODO: flush the cache

    redirect '/in-the-kitchen'
  end

  get '/api' do
    json food: 'I love to eat it!'
  end

  get '/env' do
    redirect '/' unless Env.development?

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
