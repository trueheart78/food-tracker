# frozen_string_literal: true

require 'config/environment'
require 'env'

class FoodTracker < Sinatra::Base
  before do
    if Env.force_ssl?(request)
      redirect request.url.sub('http', 'https'), 308
    else
      @url = Env.host(request)
      @image = [@url, 'images', 'hamburger.png'].join '/'
      @domain = Env.domain(request)
    end
  end

  get '/' do
    erb :index
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
