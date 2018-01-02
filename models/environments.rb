configure :development do
  set :database, 'sqlite3:db/database.db'
  set :show_exceptions, true
end

configure :production do
  configure :production do
  set :database, {adapter: 'postgresql',  encoding: 'unicode', database: 'dcs55vldcse690', pool: 2, username: 'rhmddzqfnsizqt', password: '
2235a02522f1bba39df217276873ce6a0c6b3786a11f356a768dfd0d953c9eae'}
  set :show_exceptions, true
end