require_relative '../data/database'
require_relative 'application.rb'

class Doctor < Application
  attr_accessor :id, :name, :email, :crm, :crm_state

  def initialize(id:, name:, email:, crm:, crm_state:)
    @id = id
    @name = name
    @email = email
    @crm = crm
    @crm_state = crm_state
  end

  def self.all
    doctors = []
    Database.connection do |connection|
      begin
        data = connection.exec('SELECT * FROM doctors;').to_a
        data.each do |d|
          doctors << Doctor.new(id: d['id'].to_i, name: d['name'], email: d['email'],
          crm: d['crm'], crm_state: d['crm_state'])
        end
      rescue PG::Error => e
        { error: "Error executing SQL query: #{e.message}" }
      end
    end
    doctors
  end

  def self.create(attributes)
    doctor = {}
    Database.connection do |connection|
      begin
        connection.exec('
        INSERT INTO doctors (
          name,
          email,
          crm,
          crm_state)
          VALUES ($1, $2, $3, $4)',
          [attributes[:name], attributes[:email], attributes[:crm], attributes[:crm_state]])
        doctor = last
      rescue PG::Error => e
        { error: "Error executing SQL query: #{e.message}" }
      end
    end
    doctor
  end

  def tests
    tests = []
    Database.connection do |connection|
      begin
        data = connection.exec('SELECT *
                                FROM tests
                                WHERE doctor_id = $1;',
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
      name: @name,
      email: @email,
      crm: @crm,
      crm_state: @crm_state
    }
  end
end
