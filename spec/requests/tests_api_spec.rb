require 'net/http'
require 'json'

describe 'Tests API' do
  context 'GET /tests' do
    it 'success' do
      uri = URI("http://localhost:3000/tests")
      response = Net::HTTP.get_response(uri)

      expect(response.code).to eq '200'
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response[0]["registration_number"]).to include('048.973.170-88')
      expect(json_response[0]["patient_name"]).to include('Emilly Batista Neto')
      expect(json_response[0]["patient_email"]).to include('gerald.crona@ebert-quigley.com')
      expect(json_response[0]["patient_birth_date"]).to include('2001-03-11')
      expect(json_response[0]["patient_address"]).to include('165 Rua Rafaela')
      expect(json_response[0]["patient_city"]).to include('Ituverava')
      expect(json_response[0]["patient_state"]).to include('Alagoas')
      expect(json_response[0]["doctor_crm"]).to include('B000BJ20J4')
      expect(json_response[0]["doctor_crm_state"]).to include('PI')
      expect(json_response[0]["doctor_name"]).to include('Maria Luiza Pires')
      expect(json_response[0]["doctor_email"]).to include('denna@wisozk.biz')
      expect(json_response[0]["doctor_name"]).to include('Maria Luiza Pires')
      expect(json_response[0]["exam_token"]).to include('IQCZ17')
      expect(json_response[0]["exam_date"]).to include('2021-08-05')
      expect(json_response[0]["exam_type"]).to include('hemácias')
      expect(json_response[0]["exam_type_limits"]).to include('45-52')
      expect(json_response[0]["exam_type_result"]).to include('97')
    end
  end
end
