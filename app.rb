#!/usr/bin/env ruby

# Libraries:::::::::::::::::::::::::::::::::::::::::::::::::::::::
require 'rubygems'
require 'sinatra/base'
require 'slim'
require 'sass'
require 'coffee-script'
require 'zxing'
require 'rake'

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
    ZXing.decode params[:file][:tempfile]
  end
end

if __FILE__ == $0
  MyApp.run! :port => 3000
end