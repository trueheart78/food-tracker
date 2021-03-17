# frozen_string_literal: true

class FoodTracker < Sinatra::Base
  set :environment, Env.to_sym

  before do
    if Env.force_ssl?(request)
      redirect request.url.sub('http', 'https'), 308
    else
      @url = Env.host(request)
      @image = [@url, 'images', 'hamburger.png'].join '/'
      @gif = [@url, 'images', 'hamburger-rotating.gif'].join '/'
      @domain = Env.domain(request)
    end
  end

  get '/' do
    erb :index
  end

  get '/caching' do
    erb :caching
  end

  get '/api' do
    json food: 'I love to eat it!'
  end

  # catch-all routes
  get '/*' do
    redirect '/'
  end

  post '/*' do
    404
  end
end
