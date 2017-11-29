# frozen_string_literal: true

source "https://rubygems.org"

git_source(:github) {|repo_name| "https://github.com/#{repo_name}" }

ruby '2.4.1'

gem "sinatra"
gem "activerecord"
gem "sinatra-activerecord"
gem "tux"
gem "slim"

group :development do
  gem 'sqlite3'
end

group :production do
  gem 'pg'
end