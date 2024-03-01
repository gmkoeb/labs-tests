require 'sinatra'
require 'csv'

get '/tests' do
  rows = CSV.read("./data/data.csv", col_sep: ';')

  columns = rows.shift

  rows.map do |row|
    row.each_with_object({}).with_index do |(cell, acc), idx|
      column = columns[idx]
      acc[column] = cell
    end
  end.to_json
end

set :bind, '0.0.0.0'
set :port, 3000
