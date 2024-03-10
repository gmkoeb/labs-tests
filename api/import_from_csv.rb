require 'csv'
require 'pg'
require_relative './data/database'

if __FILE__ == $PROGRAM_NAME
  Database.convert_data
end
