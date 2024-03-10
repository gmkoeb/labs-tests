require_relative '../data/database'
require_relative 'application.rb'

class Patient < Application
  attr_accessor :id, :registration_number, :name, :email, :birth_date, :address, :city, :state

  def initialize(id:, registration_number:, name:, email:, birth_date:, address:, city:, state:)
    @id = id
    @registration_number = registration_number
    @name = name
    @email = email
    @birth_date = birth_date
    @address = address
    @city = city
    @state = state
  end

  def self.all
    patients = []
    Database.connection do |connection|
      begin
        data = connection.exec('SELECT * FROM patients;').to_a
        data.each do |d|
          patients << Patient.new(id: d['id'].to_i, registration_number: d['registration_number'],
          name: d['name'], email: d['email'], birth_date: d['birth_date'], address: d['address'],
          city: d['city'], state: d['state'])
        end
      rescue PG::Error => e
        { error: "Error executing SQL query: #{e.message}" }
      end
    end
    patients
  end

  def self.create(attributes)
    patient = {}
    Database.connection do |connection|
      begin
        patient = connection.exec('
        INSERT INTO patients (
          registration_number,
          name,
          email,
          birth_date,
          address,
          city,
          state)
          VALUES ($1, $2, $3, $4, $5, $6, $7)',
          [attributes[:registration_number], attributes[:name], attributes[:email],
           attributes[:birth_date], attributes[:address], attributes[:city], attributes[:state]])
      rescue PG::Error => e
        { error: "Error executing SQL query: #{e.message}" }
      end
    end
    patient = last
  end

  def tests
    tests = []
    Database.connection do |connection|
      begin
        data = connection.exec('SELECT *
                                FROM tests
                                WHERE patient_id = $1;',
                                [@id])

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

  def as_json
    {
      id: @id,
      registration_number: @registration_number,
      name: @name,
      email: @email,
      birth_date: @birth_date,
      address: @address,
      city: @city,
      state: @state
    }
  end
end
