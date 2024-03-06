require 'sinatra'

get '/' do
  content_type 'text/html'
  File.open('index.html')
end

set :bind, '0.0.0.0'
set :port, 3001
