# frozen_string_literal: true

class Env
  def self.production?
    ENV['RACK_ENV'] == 'production'
  end

  def self.development?
    ENV['RACK_ENV'] == 'development'
  end

  def self.test?
    ENV['RACK_ENV'] == 'test'
  end
  
  def self.to_s
    ENV['RACK_ENV']
  end
  
  def self.to_sym
    ENV['RACK_ENV'].to_sym
  end
  
  def self.twitter_handle?
    return false if self.twitter_creator.empty?
    
    true
  end

  def self.twitter_creator
    if ENV['TWITTER_CREATOR'] && !ENV['TWITTER_CREATOR'].empty?
      return ENV['TWITTER_CREATOR'] if ENV['TWITTER_HANDLE'].start_with? '@'
      return "@#{ENV['TWITTER_CREATOR']}"
    end
    
    ''
  end
  
  def self.twitter_site
    if ENV['TWITTER_SITE'] && !ENV['TWITTER_SITE'].empty?
      return ENV['TWITTER_SITE'] if ENV['TWITTER_SITE'].start_with? '@'
      return "@#{ENV['TWITTER_SITE']}"
    end
    
    self.twitter_creator
  end
  
  def self.host(request)
    request.base_url
  end

  def self.domain(request)
    request.base_url.sub('https://','').sub('http://','')
  end

  def self.force_ssl?(request)
    self.production? && !request.ssl?
  end
end
