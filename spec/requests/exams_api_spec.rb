require 'net/http'
require 'json'

describe 'Tests API' do
  context 'GET /tests' do
    it 'success' do
      uri = URI("http://localhost:3000/tests")
      response = Net::HTTP.get_response(uri)

      expect(response.code).to eq '200'
    end
  end
end
