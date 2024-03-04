require_relative '../import_from_csv.rb'
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
    db_connection do |connection|
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

  def tests
    tests = []
    db_connection do |connection|
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
end
