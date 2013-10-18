require 'rubygems'
require 'sinatra'
require 'Haml'
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
                    :url
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

    get '/new' do
      @gift = Gift.new
      haml :new
    end

    post '/gift' do
      @gift = Gift.new(params[:gift])
      
      if @gift.save
        redirect '/new'
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
  end
end