require 'sinatra'
require 'sinatra/activerecord'
require 'slim'
require './models/environments.rb'
require './lib/twitter_miner.rb'

class Post < ActiveRecord::Base
end

triggerTime = Time.now + (60*15)
  
get '/' do
  slim :index
end

get '/blog' do
  slim :blog
end

get '/admin' do
  slim :admin
end
