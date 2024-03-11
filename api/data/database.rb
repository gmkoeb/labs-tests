require 'pg'
require 'csv'

class Database
  def self.convert_data
    rows = CSV.read("./data/data.csv", col_sep: ';')

    columns = rows.shift

    Database.connection do |connection|
      pp 'Data conversion started'
      rows.map do |row|
        populate_tables(row, connection)
      end
      pp 'Data conversion ended'
    end
  end

  def self.connection
    begin
      dbname = if ENV['RACK_ENV'] == 'test'
        'test'
      else
        'postgres'
      end
      connection = PG.connect(dbname:, user: 'postgres', password: 'postgres', host: 'postgres')
      yield(connection)
    rescue PG::Error => e
      puts "Error connecting to database: #{e.message}"
    ensure
      connection.close if connection
    end
  end

  def self.create_tables
    connection do |connection|
      connection.exec(
        'CREATE TABLE patients (
          id SERIAL PRIMARY KEY,
          registration_number VARCHAR(255) UNIQUE,
          name VARCHAR(255),
          email VARCHAR(255) UNIQUE,
          birth_date DATE,
          address VARCHAR(255),
          city VARCHAR(255),
          state VARCHAR(255)
        );')

      connection.exec(
        'CREATE TABLE doctors (
          id SERIAL PRIMARY KEY,
          name VARCHAR(255),
          email VARCHAR(255) UNIQUE,
          crm VARCHAR(255),
          crm_state VARCHAR(255),
          UNIQUE (crm, crm_state)
        );')

      connection.exec(
        'CREATE TABLE tests (
          id SERIAL PRIMARY KEY,
          patient_id INT REFERENCES patients(id),
          doctor_id INT REFERENCES doctors(id),
          token VARCHAR(255),
          date DATE,
          type VARCHAR(255),
          type_limits VARCHAR(255),
          type_result VARCHAR(255),
          UNIQUE (token, type)
        );')

      connection.exec(
        "CREATE TABLE job_status (
          id SERIAL PRIMARY KEY,
          token VARCHAR(8),
          status VARCHAR(10) DEFAULT 'pending'
        );")
    rescue PG::Error => e
      puts "Error creating table: #{e.message}"
    end
  end

  def self.populate_tables(row, connection)
    patient_id = find_or_create_patient(row, connection)
    doctor_id = find_or_create_doctor(row, connection)
    connection.exec(
      'INSERT INTO tests (
        patient_id,
        doctor_id,
        token,
        date,
        type,
        type_limits,
        type_result
      )
      VALUES ($1, $2, $3, $4, $5, $6, $7)',
      [patient_id, doctor_id, row[11], row[12], row[13], row[14], row[15]]
    )
  end

  def self.drop_tables
    connection do |connection|
      connection.exec("DROP TABLE tests, patients, doctors, job_status")
    end
  end

  def self.create_test_db
    begin
      db_connection = PG.connect(dbname: 'postgres', user: 'postgres', password: 'postgres', host: 'postgres')
      db_connection.exec('CREATE DATABASE test')
      puts "Database 'test' created successfully."
    rescue PG::Error
    ensure
      db_connection.close if db_connection
    end
  end

  private

  def self.find_or_create_patient(row, connection)
    patient_id_query = connection.exec(
      'SELECT id FROM patients
        WHERE registration_number = $1',
        [row[0]]
    )
    if patient_id_query.to_a.empty?
      patient_id_query = connection.exec(
        'INSERT INTO patients (
          registration_number,
          name,
          email,
          birth_date,
          address,
          city,
          state
        )
        VALUES ($1, $2, $3, $4, $5, $6, $7)
        RETURNING id',
        [row[0], row[1], row[2], row[3], row[4], row[5], row[6]])
    end
    patient_id_query.first['id']
  end

  def self.find_or_create_doctor(row, connection)
    doctor_id_query = connection.exec(
      'SELECT id FROM doctors
        WHERE crm = $1',
        [row[7]]
      )
    if doctor_id_query.to_a.empty?
      doctor_id_query = connection.exec(
        'INSERT INTO doctors(
          crm,
          crm_state,
          name,
          email
          )
          VALUES ($1, $2, $3, $4)
          RETURNING id',
          [row[7], row[8], row[9], row[10]])
    end
    doctor_id_query.first['id']
  end
end
