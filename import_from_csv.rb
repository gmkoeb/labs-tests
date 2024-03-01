require 'csv'
require 'pg'

def convert_data
  rows = CSV.read("./data/data.csv", col_sep: ';')

  columns = rows.shift

  create_table
  pp 'Data conversion started'
  rows.map do |row|
    populate_table(row)
  end
  pp 'Data conversion ended'
end

def db_connection
  begin
    connection = PG.connect(dbname: 'postgres', user: 'postgres', password: 'postgres', host: 'postgres')
    yield(connection)
  rescue PG::Error => e
    puts "Error connecting to database: #{e.message}"
  ensure
    connection.close if connection
  end
end

def create_table
  db_connection do |connection|
    connection.exec('CREATE TABLE tests (
      registration_number VARCHAR(255),
      patient_name VARCHAR(255),
      patient_email VARCHAR(255),
      patient_birth_date DATE,
      patient_address VARCHAR(255),
      patient_city VARCHAR(255),
      patient_state VARCHAR(255),
      doctor_crm VARCHAR(255),
      doctor_crm_state VARCHAR(255),
      doctor_name VARCHAR(255),
      doctor_email VARCHAR(255),
      exam_token VARCHAR(255),
      exam_date DATE,
      exam_type VARCHAR(255),
      exam_type_limits VARCHAR(255),
      exam_type_result VARCHAR(255)
    );')
    puts "Table 'tests' created successfully"
  rescue PG::Error => e
    puts "Error creating table: #{e.message}"
  end
end

def populate_table(row)
  db_connection do |connection|
    connection.exec('INSERT INTO tests (
      registration_number,
      patient_name,
      patient_email,
      patient_birth_date,
      patient_address,
      patient_city,
      patient_state,
      doctor_crm,
      doctor_crm_state,
      doctor_name,
      doctor_email,
      exam_token,
      exam_type,
      exam_type_limits,
      exam_type_result
    ) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14, $15)',
    [row[0], row[1], row[2], row[3], row[4], row[5], row[6], row[7], row[8], row[9], row[10], row[11], row[12], row[13], row[14]])
  end
end

convert_data
