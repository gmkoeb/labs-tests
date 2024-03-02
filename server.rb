require 'sinatra'
require 'csv'
require_relative 'import_from_csv.rb'

get '/tests' do
  content_type :json
  db_connection do |connection|
    begin
      tests = connection.exec('SELECT * FROM tests;').to_a
      tests.to_json
    rescue PG::Error => e
      status 500
      { error: "Error executing SQL query: #{e.message}" }.to_json
    end
  end
end

set :bind, '0.0.0.0'
set :port, 3000
