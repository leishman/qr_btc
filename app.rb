#!/usr/bin/env ruby

# Libraries:::::::::::::::::::::::::::::::::::::::::::::::::::::::
require 'rubygems'
require 'sinatra/base'
require 'slim'
require 'sass'
require 'coffee-script'
require 'zxing'
require 'rake'
require 'uri'
require 'byebug'

# Application:::::::::::::::::::::::::::::::::::::::::::::::::::
class SassHandler < Sinatra::Base

  set :views, File.dirname(__FILE__) + '/assets/stylesheets'

  get '/css/*.css' do
    filename = params[:splat].first
    sass filename.to_sym
  end

end

class CoffeeHandler < Sinatra::Base
  set :views, File.dirname(__FILE__) + '/assets/coffeescript'

  get "/js/*.js" do
    filename = params[:splat].first
    coffee filename.to_sym
  end
end

class MyApp < Sinatra::Base
  use SassHandler
  use CoffeeHandler

  set :bind, '0.0.0.0'

  # Configuration:::::::::::::::::::::::::::::::::::::::::::::::
  set :public, File.dirname(__FILE__) + '/'
  set :views, File.dirname(__FILE__) + '/views'

  # Route Handlers::::::::::::::::::::::::::::::::::::::::::::::
  get '/' do
    slim :index
  end

  get '/uri_test' do
    slim :uri_test
  end

  get '/parse/*' do
    btc_uri = parse_btc_uri
    @address = btc_uri.host
    @amount = @btc_params['amount']
    slim :parse
  end

  post '/qr' do
    ZXing.decode params[:file][:tempfile]
  end

  def parse_btc_uri
    btc_uri = params[:splat].first[0..-2] # remove end junk character
    ind = btc_uri.index('n:/')
    btc_uri.insert(ind + 2, '/') # add extra slash
    btc_uri_parsed =  URI.parse(btc_uri)
    @btc_params = {}
    btc_uri_parsed.query.split('=').each_slice(2) { |pair| @btc_params[pair.first] = pair.last }
    btc_uri_parsed
  end
end

if __FILE__ == $0
  MyApp.run! :port => 3000
end