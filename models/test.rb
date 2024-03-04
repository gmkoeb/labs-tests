require_relative '../import_from_csv.rb'
require_relative '../data_structures/array.rb'
require_relative 'application.rb'

class Test < Application
  attr_accessor :id, :patient_id, :doctor_id, :token, :date, :type, :type_limits, :type_result

  def initialize(id:, patient_id:, doctor_id:, token:, date:, type:, type_limits:, type_result:)
    @id = id
    @patient_id = patient_id
    @doctor_id = doctor_id
    @token = token
    @date = date
    @type = type
    @type_limits = type_limits
    @type_result = type_result
  end

  def self.all
    tests = []
    db_connection do |connection|
      begin
        data = connection.exec('SELECT * FROM tests;').to_a
        data.each do |d|
          tests << Test.new(id: d['id'].to_i, patient_id: d['patient_id'].to_i, doctor_id: d['doctor_id'].to_i,
          token: d['token'], date: d['date'], type: d['type'], type_limits: d['type_limits'],
          type_result: d['type_result'])
        end
      rescue PG::Error => e
        { error: "Error executing SQL query: #{e.message}" }
      end
    end
    tests
  end

  def self.all_with_foreign
    tests = []
    db_connection do |connection|
      begin
        tests = connection.exec('SELECT tests.id, patients.name AS patient_name, patients.registration_number, patients.email AS patient_email,
                                 patients.birth_date, patients.address, patients.city, patients.state,
                                 doctors.name AS doctor_name, doctors.email AS doctor_email, doctors.crm, doctors.crm_state,
                                 tests.date, tests.token, tests.type, tests.type_limits, tests.type_result
                                 FROM tests
                                 INNER JOIN patients ON tests.patient_id = patients.id
                                 INNER JOIN doctors ON tests.doctor_id = doctors.id;').to_a
      rescue PG::Error => e
        { error: "Error executing SQL query: #{e.message}" }
      end
    end
    tests.to_json
  end

  def patient
    patient = {}
    db_connection do |connection|
      begin
        data = connection.exec('SELECT *
                                FROM patients
                                WHERE id = $1;',
                                [@patient_id])

        patient = Patient.new(id: data[0]['id'].to_i, registration_number: data[0]['registration_number'],
        name: data[0]['name'], email: data[0]['email'], birth_date: data[0]['birth_date'], address: data[0]['address'],
        city: data[0]['city'], state: data[0]['state'])
      rescue PG::Error => e
        { error: "Error executing SQL query: #{e.message}" }
      end
    end
    patient
  end

  def as_json
    {
      id: @id,
      patient_id: @patient_id,
      doctor_id: @doctor_id,
      token: @token,
      date: @date,
      type: @type,
      type_limits: @type_limits,
      type_result: @type_result
    }
  end
end
