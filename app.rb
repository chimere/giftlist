require 'sinatra'
require 'haml'
require 'mongo'
require 'uri'
require 'mongoid'

module Giftlist
  class Gift
    include Mongoid::Document
 
    field :title, type: String
    field :size, type: String
    field :price, type: Float
    field :image, type: String
    field :url, type: String
    field :clicks, type: Integer, default: 0
    field :purchased, type: Boolean, default: false

    attr_accessible :title,
                    :price,
                    :image,
                    :url,
                    :size
  end

  class App < Sinatra::Application
    configure do
      enable :sessions, :logging, :dump_errors

      # set :root, File.dirname(__FILE__)
      # logger = Logger.new($stdout)
  
      Mongoid.load!("config/mongoid.yml")
    end

    get '/' do
      @gifts = Gift.where(purchased: false)
      haml :index
    end

    get '/admin' do
      @gifts = Gift.all
      haml :admin
    end

    get '/edit/:id' do |id|
      @gift = Gift.find(id)
      haml :edit
    end

    put '/update/:id' do
      @gift = Gift.find(params[:id])
      if @gift.update_attributes(params[:gift])
        redirect '/admin'
      else
        "Error saving doc"
      end
    end

    post '/gift' do
      @gift = Gift.new(params[:gift])
      
      if @gift.save
        redirect '/admin'
      else
        "Error saving doc"
      end
    end

    put '/gift/:id/purchased' do |id|
      @gift = Gift.find(id)
      @gift.update_attribute(:purchased, true)
      redirect '/'
    end

    delete '/gift/:id' do
      @gift = Gift.find(params[:id])
      @gift.delete
      redirect '/admin'   
    end



    helpers do
      def yes_no(boolean)
        return "Yes" if boolean
        return "No"
      end

      def size_applicable(size)
        return size if size
        return "n/a"
      end
    end
  end
end