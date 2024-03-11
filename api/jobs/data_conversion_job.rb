require 'sidekiq'
require_relative '../data/database'
require_relative '../models/job_status'

class DataConversionJob
  include Sidekiq::Job

  def perform(rows, env, token)
    columns = rows.shift
    if env == 'test'
      populate_test_tables(rows)
    else
      populate_development_tables(rows, token)
    end
  end

  private

  def populate_test_tables(rows)
    connection = PG.connect(dbname:'test', user: 'postgres', password: 'postgres', host: 'postgres')
    rows.map do |row|
      Database.populate_tables(row, connection)
    end
  end

  def populate_development_tables(rows, token)
    JobStatus.create(token:)
    Database.connection do |connection|
      rows.map do |row|
        Database.populate_tables(row, connection)
      end
    end
    JobStatus.find_by(token:).done
  end
end
