require_relative '../data/database'
require_relative 'application.rb'

class JobStatus < Application
  attr_accessor :id, :token, :status

  def initialize(id:, token:, status:)
    @id = id
    @token = token
    @status = status
  end

  def self.create(attributes)
    job_status = {}
    Database.connection do |connection|
      begin
        connection.exec('
        INSERT INTO jobs_status (token)
        VALUES ($1)',
        [attributes[:token]])
        job_status = last
      rescue PG::Error => e
        { error: "Error executing SQL query: #{e.message}" }
        pp e.message
      end
    end
    job_status
  end

  def self.all
    jobs_status = []
    Database.connection do |connection|
      begin
        data = connection.exec('SELECT * FROM jobs_status;').to_a
        data.each do |d|
          jobs_status << JobStatus.new(id: d['id'].to_i, status: d['status'], token: d['token'])
        end
      rescue PG::Error => e
        { error: "Error executing SQL query: #{e.message}" }
      end
    end
    jobs_status
  end

  def self.find_by(attributes)
    job_status = {}
    Database.connection do |connection|
      begin
        data = connection.exec(
         'SELECT *
          FROM jobs_status
          WHERE token = $1',
          [attributes[:token]]).to_a.first

        job_status = JobStatus.new(id: data['id'], token: data['token'], status: data['status'])
      rescue PG::Error => e
        { error: "Error executing SQL query: #{e.message}" }
      end
    end
    job_status
  end

  def done
    Database.connection do |connection|
      begin
        connection.exec("UPDATE jobs_status
                         SET status = 'done'
                         WHERE id = $1;",
                         [@id])
      rescue PG::Error => e
        { error: "Error executing SQL query: #{e.message}" }
      end
    end
  end
end
