require 'sinatra'
require 'csv'
require_relative 'import_from_csv.rb'
require_relative './models/test.rb'

get '/tests' do
  content_type :json
  Test.all_with_foreign
end

set :bind, '0.0.0.0'
set :port, 3000
