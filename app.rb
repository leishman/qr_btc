#!/usr/bin/env ruby

# Libraries:::::::::::::::::::::::::::::::::::::::::::::::::::::::
require 'rubygems'
require 'sinatra/base'
require 'slim'
require 'sass'
require 'coffee-script'

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

  # Configuration:::::::::::::::::::::::::::::::::::::::::::::::
  set :public, File.dirname(__FILE__) + '/'
  set :views, File.dirname(__FILE__) + '/views'

  # Route Handlers::::::::::::::::::::::::::::::::::::::::::::::
  get '/' do
    slim :index
  end

  post '/qr' do
    params[:file].inspect
    # redirect to('/after_qr')
  end

  get '/after_qr' do
    "WHAAT"
  end

end

if __FILE__ == $0
  MyApp.run! :port => 4567
end