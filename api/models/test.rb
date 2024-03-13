require_relative '../data/database'
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
    Database.connection do |connection|
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

  def self.create(attributes)
    test = {}
    Database.connection do |connection|
      begin
        connection.exec('
        INSERT INTO tests (
          patient_id,
          doctor_id,
          token,
          date,
          type,
          type_limits,
          type_result)
          VALUES ($1, $2, $3, $4, $5, $6, $7)',
          [attributes[:patient_id], attributes[:doctor_id], attributes[:token],
          attributes[:date], attributes[:type], attributes[:type_limits], attributes[:type_result]])
        test = last
      rescue PG::Error => e
        test = { error: "Error executing SQL query: #{e.message}" }
      end
    end
    test
  end

  def self.where(attributes)
    tests = []
    Database.connection do |connection|
      begin
        data = connection.exec(
         'SELECT *
          FROM tests
          WHERE id = $1 OR patient_id = $2 OR doctor_id = $3
          OR token = $4 OR date = $5 OR type = $6 OR type_limits = $7
          OR type_result = $8',
          [attributes[:id], attributes[:patient_id], attributes[:doctor_id], attributes[:token],
           attributes[:date], attributes[:type], attributes[:type_limits], attributes[:type_result]]).to_a
        data.each do |test|
          tests << Test.new(id: test['id'], patient_id: test['patient_id'], doctor_id: test['doctor_id'],
                            token: test['token'], type: test['type'], type_limits: test['type_limits'],
                            type_result: test['type_result'], date: test['date'])
        end
      rescue PG::Error => e
        { error: "Error executing SQL query: #{e.message}" }
      end
    end

    tests
  end

  def self.all_with_foreign
    tests = []
    Database.connection do |connection|
      begin
        tests = connection.exec('
        SELECT
        tests.token, tests.date, patients.registration_number,
        patients.name AS patient_name, patients.email AS patient_email,
        patients.birth_date, doctors.crm, doctors.crm_state, doctors.name AS doctor_name,
        tests.type, tests.type_limits, tests.type_result
        FROM tests
        INNER JOIN patients ON tests.patient_id = patients.id
        INNER JOIN doctors ON tests.doctor_id = doctors.id').to_a
      rescue PG::Error => e
        return { error: "Error executing SQL query: #{e.message}" }.to_json
      end
    end
    tests = format_tests_hash(tests)
  end

  def patient
    patient = {}
    Database.connection do |connection|
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

  def doctor
    doctor = {}
    Database.connection do |connection|
      begin
        data = connection.exec('SELECT *
                                FROM doctors
                                WHERE id = $1;',
                                [@doctor_id])

        doctor = Doctor.new(id: data[0]['id'].to_i, name: data[0]['name'], email: data[0]['email'],
        crm: data[0]['crm'], crm_state: data[0]['crm_state'])
      rescue PG::Error => e
        { error: "Error executing SQL query: #{e.message}" }
      end
    end
    doctor
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

  private

  def self.format_tests_hash(tests)
    tests.group_by { |test| test['token'] }.map do |token, tests|
      {
        token: token,
        date: tests.first['date'],
        registration_number: tests.first['registration_number'],
        name: tests.first['patient_name'],
        email: tests.first['patient_email'],
        birth_date: tests.first['birth_date'],
        doctor: {
          crm: tests.first['crm'],
          crm_state: tests.first['crm_state'],
          name: tests.first['doctor_name']
        },
        tests: tests.map do |test|
          {
            type: test['type'],
            type_limits: test['type_limits'],
            type_result: test['type_result']
          }
        end
      }
    end.to_json
  end
end
