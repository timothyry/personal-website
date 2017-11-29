configure :development do
  set :database, 'sqlite3:db/database.db'
  set :show_exceptions, true
end