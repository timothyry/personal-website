require 'sinatra'
require 'sinatra/activerecord'
require 'sinatra/flash'
require 'slim'
require './models/user.rb'
require './models/post.rb'
require './lib/twitter_miner.rb'
require 'digest'
require 'twitter-text'
require 'redcarpet'
require 'active_support/core_ext/string/output_safety'

include Twitter::TwitterText::Autolink

enable :sessions
set :database_file, 'config/database.yml'

def markdown(text)
  markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML)
  markdown.render(text)
end

def authed?
  return !session[:id].nil?
end
  
get '/' do
  slim :index
end

get '/blog' do
  slim :blog
end

get '/blog/login' do
  slim :login
end

get '/blog/newPost' do
  if not authed?
    redirect '/blog/login'
    return
  end
  
  slim :newPost
end

get '/logout' do
  session[:id] = nil
  slim :blog
end

get '/admin' do
  slim :admin
end

get '/blog/post/*' do
  if Post.find_by(id: params[:splat])
    session[:lastPost] = params[:splat]
    slim :showPost
  else
    redirect :blog
  end
end

get '/blog/deletePost' do
  post = Post.find_by(id: session[:lastPost])
  post.destroy if !post.nil?
  redirect :blog
end

post '/blog/newPost' do
  
  if not authed?
    redirect '/blog/login'
    return
  end
    
  if params[:id].nil?
    post = Post.new
    post[:title] = params[:title]
    post[:body] = params[:body]
    post[:owner] = session[:id]
    post.save
  else
    post = Post.find_by(id: params[:id])
    if post.nil?
      flash[:error] = "Woah, something went wrong!"
      redirect '/blog/newPost'
    else
      post[:title] = params[:title]
      post[:body] = params[:body]
      post.save
      redirect '/blog/post/' + post[:id].to_s
    end
  end
end

post '/blog/login' do
  user = User.find_by(name: params[:name])
  test_pw = Digest::SHA256.digest(params[:password]).encode('UTF-8', 'binary', invalid: :replace, undef: :replace, replace: '')
  if !user
    puts "test 1"
    flash[:error] = "You've entered the wrong name or password. Try again."
    redirect '/blog/login'
  else
    stored_pw = user[:password]
    puts stored_pw
    puts test_pw
    puts stored_pw == test_pw
    if test_pw == stored_pw
      session[:id] = user.id
      flash[:error] = "Welcome back, #{user[:name]}!"
      redirect '/blog'
    else
      puts "test 2"
      flash[:error] = "You've entered the wrong name or password. Try again."
      redirect '/blog/login'
    end
  end
end
