require 'sinatra'
require 'slim'

get '/' do
  slim :index
end

get '/blog' do
  slim :blog
end
