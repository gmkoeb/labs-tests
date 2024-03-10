require 'sidekiq'
require_relative '../data/database'

class DataConversionJob
  include Sidekiq::Job

  def perform(rows, env)
    columns = rows.shift
    if env == 'test'
      populate_test_tables(rows)
    else
      populate_development_tables(rows)
    end
  end

  private

  def populate_test_tables(rows)
    connection = PG.connect(dbname:'test', user: 'postgres', password: 'postgres', host: 'postgres')
    pp 'Data conversion started'
    rows.map do |row|
      Database.populate_tables(row, connection)
    end
    pp 'Data conversion ended'
  end

  def populate_development_tables(rows)
    Database.connection do |connection|
      pp 'Data conversion started'
      rows.map do |row|
        Database.populate_tables(row, connection)
      end
      pp 'Data conversion ended'
    end
  end
end
