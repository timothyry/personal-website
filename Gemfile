# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

ruby '2.4.1'

gem "sinatra"
gem "sinatra-flash"
gem "activerecord"
gem "sinatra-activerecord"
gem "activesupport"
gem "tux"
gem "slim"
gem "twitter"
gem "rake"
gem "redcarpet"

gem 'sqlite3', :group => [:development, :test]
group :production do
  gem 'pg'
  gem 'twitter-text'
end