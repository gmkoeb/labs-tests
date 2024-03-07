require 'sinatra'
require 'csv'
require_relative 'import_from_csv.rb'
require_relative './models/test.rb'
require_relative './models/doctor.rb'
require_relative './models/patient.rb'

set :protection, :except => :json_csrf

before do
  if params[:env] == 'test'
    ENV['RACK_ENV'] = 'test'
  else
    ENV['RACK_ENV'] = 'development'
  end
  content_type :json
  response.headers['Access-Control-Allow-Origin'] = '*'
end

get '/tests' do
  Test.all_with_foreign
end

get '/doctors' do
  Doctor.all.as_json
end

get '/patients' do
  Patient.all.as_json
end

set :bind, '0.0.0.0'
set :port, 3000
