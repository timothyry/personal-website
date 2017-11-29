require 'sinatra'
require 'sinatra/activerecord'
require 'slim'
require './models/environments.rb'

class Post < ActiveRecord::Base
end

get '/' do
  slim :index
end

get '/blog' do
  slim :blog
end
