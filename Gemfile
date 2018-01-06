# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

ruby '2.4.1'

gem "sinatra"
gem "sinatra-flash"
gem "activerecord"
gem "sinatra-activerecord"
gem "tux"
gem "slim"
gem "twitter"
gem "twitter-text"
gem "rake"

gem 'sqlite3', :group => [:development, :test]
group :production do
  gem 'pg'
end