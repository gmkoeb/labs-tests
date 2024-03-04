require 'sinatra'
require 'csv'
require_relative 'import_from_csv.rb'

get '/tests' do
  content_type :json
  db_connection do |connection|
    begin
      tests = connection.exec('SELECT tests.id, patients.name AS patient_name, patients.registration_number, patients.email AS patient_email,
                               patients.birth_date, patients.address, patients.city, patients.state,
                               doctors.name AS doctor_name, doctors.email AS doctor_email, doctors.crm, doctors.crm_state,
                               tests.date, tests.token, tests.type, tests.type_limits, tests.type_result
                               FROM tests
                               INNER JOIN patients ON tests.patient_id = patients.id
                               INNER JOIN doctors ON tests.doctor_id = doctors.id;').to_a
      tests.to_json
    rescue PG::Error => e
      status 500
      { error: "Error executing SQL query: #{e.message}" }.to_json
    end
  end
end

set :bind, '0.0.0.0'
set :port, 3000
