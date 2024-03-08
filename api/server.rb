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

get '/tests/:token' do
  token = params[:token]
  tests = Test.where(token:)
  format_tests_response(tests)
end

get '/doctors' do
  Doctor.all.as_json
end

get '/patients' do
  Patient.all.as_json
end

post '/import' do
  convert_data

  {conversion_status: 'CSV conversion ended'}.to_json
end

set :bind, '0.0.0.0'
set :port, 3000

private

def format_tests_response(tests)
  tests.group_by { |test| test.token }.map do |token, tests|
    {
      token: token,
      date: tests.first.date,
      registration_number: tests.first.patient.registration_number,
      name: tests.first.patient.name,
      email: tests.first.patient.email,
      birth_date: tests.first.patient.birth_date,
      doctor: {
        crm: tests.first.doctor.crm,
        crm_state: tests.first.doctor.crm_state,
        name: tests.first.doctor.name
      },
      tests: tests.map do |test|
        {
          type: test.type,
          type_limits: test.type_limits,
          type_result: test.type_result
        }
      end
    }
  end.to_json
end
