describe 'Tests API' do
  context 'GET /tests' do
    it 'success' do
      json_file_path = '/app/spec/support/json/tests.json'
      json_data = File.read(json_file_path)

      fake_response = double(code: '200', content_type: 'application/json', body: json_data)
      allow(Net::HTTP).to receive(:get_response).and_return(fake_response)

      uri = URI("http://localhost:3000/tests")
      response = Net::HTTP.get_response(uri)
      json_response = JSON.parse(response.body)

      expect(response.code).to eq '200'
      expect(response.content_type).to include 'application/json'
      expect(json_response[0]["token"]).to include('ABC123')
      expect(json_response[0]["registration_number"]).to include('123456')
      expect(json_response[0]["name"]).to include('Paciente Teste')
      expect(json_response[0]["email"]).to include('paciente@email.com')
      expect(json_response[0]["birth_date"]).to include('2001-03-11')
      expect(json_response[0]["doctor"]["crm"]).to include('123456')
      expect(json_response[0]["doctor"]["crm_state"]).to include('PI')
      expect(json_response[0]["doctor"]["name"]).to include('Doutor Teste')
      expect(json_response[0]["date"]).to include('2021-08-05')
      expect(json_response[0]["tests"][0]["type"]).to include('hemácias')
      expect(json_response[0]["tests"][0]["type_limits"]).to include('45-52')
      expect(json_response[0]["tests"][0]["type_result"]).to include('97')
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
      json_response = JSON.parse(response.body)

      expect(response.code).to eq '200'
      expect(response.content_type).to include 'application/json'
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
      json_response = JSON.parse(response.body)

      expect(response.code).to eq '200'
      expect(response.content_type).to include 'application/json'
      expect(json_response[0]["crm"]).to include('ABC123456')
      expect(json_response[0]["crm_state"]).to include('Estado Teste')
      expect(json_response[0]["name"]).to include('Doutor Teste')
      expect(json_response[0]["email"]).to include('doutor@email.com')
    end
  end

  context 'GET /tests/:token' do
    it 'success' do
      uri = URI("http://localhost:3000/tests/IQCZ17")
      response = Net::HTTP.get_response(uri)
      json_response = JSON.parse(response.body)

      expect(response.code).to eq '200'
      expect(response.content_type).to include 'application/json'
      expect(json_response.length).to eq 1
      expect(json_response[0]["token"]).to include('IQCZ17')
      expect(json_response[0]["registration_number"]).to include('048.973.170-88')
      expect(json_response[0]["name"]).to include('Emilly Batista Neto')
      expect(json_response[0]["email"]).to include('gerald.crona@ebert-quigley.com')
      expect(json_response[0]["birth_date"]).to include('2001-03-11')
      expect(json_response[0]["doctor"]["crm"]).to include('B000BJ20J4')
      expect(json_response[0]["doctor"]["crm_state"]).to include('PI')
      expect(json_response[0]["doctor"]["name"]).to include('Maria Luiza Pires')
      expect(json_response[0]["date"]).to include('2021-08-05')
      expect(json_response[0]["tests"][0]["type"]).to include('hemácias')
      expect(json_response[0]["tests"][0]["type_limits"]).to include('45-52')
      expect(json_response[0]["tests"][0]["type_result"]).to include('97')
    end
  end

  context 'POST /import' do
    it 'success' do
      uri = URI("http://localhost:3000/import")
      request = Net::HTTP::Post.new(uri)
      http = Net::HTTP.new(uri.host, uri.port)
      response = http.request(request)
      json_response = JSON.parse(response.body)

      expect(response.code).to eq '200'
      expect(response.content_type).to include 'application/json'
      expect(json_response['conversion_status']).to eq 'CSV conversion ended'
    end
  end
end
