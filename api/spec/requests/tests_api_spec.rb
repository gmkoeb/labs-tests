describe 'Tests API' do
  context 'GET /tests' do
    it 'success' do
      json_file_path = '/app/spec/support/json/tests.json'
      json_data = File.read(json_file_path)

      fake_response = double(code: '200', content_type: 'application/json', body: json_data)
      allow(Net::HTTP).to receive(:get_response).and_return(fake_response)

      uri = URI("http://localhost:3000/tests")
      response = Net::HTTP.get_response(uri)

      expect(response.code).to eq '200'
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)

      expect(json_response[0]["registration_number"]).to include('123456789')
      expect(json_response[0]["patient_name"]).to include('Paciente Teste')
      expect(json_response[0]["patient_email"]).to include('teste@email.com')
      expect(json_response[0]["birth_date"]).to include('1997-01-01')
      expect(json_response[0]["address"]).to include('165 Rua Teste')
      expect(json_response[0]["city"]).to include('Teste')
      expect(json_response[0]["state"]).to include('Estado teste')
      expect(json_response[0]["crm"]).to include('ABC123456')
      expect(json_response[0]["crm_state"]).to include('Estado Teste')
      expect(json_response[0]["doctor_name"]).to include('Doutor Teste')
      expect(json_response[0]["doctor_email"]).to include('doutor@email.com')
      expect(json_response[0]["token"]).to include('EFG45678')
      expect(json_response[0]["date"]).to include('2021-08-05')
      expect(json_response[0]["type"]).to include('hemácias')
      expect(json_response[0]["type_limits"]).to include('45-52')
      expect(json_response[0]["type_result"]).to include('97')
    end
  end

  context 'GET /patients' do
    it 'success' do
      json_file_path = '/app/spec/support/json/patients.json'
      json_data = File.read(json_file_path)

      fake_response = double(code: '200', content_type: 'application/json', body: json_data)
      allow(Net::HTTP).to receive(:get_response).and_return(fake_response)

      uri = URI("http://localhost:3000/patients")
      response = Net::HTTP.get_response(uri)

      expect(response.code).to eq '200'
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)

      expect(json_response[0]["registration_number"]).to include('123456789')
      expect(json_response[0]["name"]).to include('Paciente Teste')
      expect(json_response[0]["email"]).to include('teste@email.com')
      expect(json_response[0]["birth_date"]).to include('1997-01-01')
      expect(json_response[0]["address"]).to include('165 Rua Teste')
      expect(json_response[0]["city"]).to include('Teste')
      expect(json_response[0]["state"]).to include('Estado teste')
    end
  end

  context 'GET /doctors' do
    it 'success' do
      json_file_path = '/app/spec/support/json/doctors.json'
      json_data = File.read(json_file_path)

      fake_response = double(code: '200', content_type: 'application/json', body: json_data)
      allow(Net::HTTP).to receive(:get_response).and_return(fake_response)

      uri = URI("http://localhost:3000/doctors")
      response = Net::HTTP.get_response(uri)

      expect(response.code).to eq '200'
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)

      expect(json_response[0]["crm"]).to include('ABC123456')
      expect(json_response[0]["crm_state"]).to include('Estado Teste')
      expect(json_response[0]["name"]).to include('Doutor Teste')
      expect(json_response[0]["email"]).to include('doutor@email.com')
    end
  end
end
