require 'sinatra'
require 'csv'
require_relative './data/database'
require_relative './models/test.rb'
require_relative './models/doctor.rb'
require_relative './models/patient.rb'
require_relative './jobs/data_conversion_job'

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
  tests = Test.where(token: params[:token])
  if tests.any?
    format_tests_response(tests)
  else
    { test_not_found: "Nenhum exame com código #{params[:token]} encontrado" }.to_json
  end
end

get '/doctors' do
  Doctor.all.as_json
end

get '/patients' do
  Patient.all.as_json
end

get '/job_status/:token' do
  status = JobStatus.find_by(token: params[:token]).status
  { job_status: status }.to_json
end

post '/import' do
  if params[:file]
    process_file(params[:file])
  else
    { conversion_error: 'Nenhum arquivo fornecido' }.to_json
  end
end

set :bind, '0.0.0.0'
set :port, 3000
set :protection, :except => :json_csrf

Database.create_tables

private

def process_file(file)
  file_extension = File.extname(file[:filename])
  if file_extension == '.csv'
    file_data = file[:tempfile]
    rows = CSV.read(file_data, col_sep: ';')
    token = SecureRandom.alphanumeric(8).upcase

    DataConversionJob.perform_async(rows, params[:env], token)

    { token: token }.to_json
  else
    { conversion_error: 'Extensão não suportada' }.to_json
  end
end

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
  end.first.to_json
end
