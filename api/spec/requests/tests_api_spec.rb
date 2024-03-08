require 'net/http/post/multipart'

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
      Patient.create(name: 'Paciente de Teste', email: 'email@email.com', registration_number: '123.456',
                     birth_date: '2022-02-03', address: 'Rua teste', city: 'Cidade teste',
                     state: 'Estado teste')
      Doctor.create(name: 'Doutor 1', email: 'doutor1@email.com', crm: 'ABC123', crm_state: 'TE')
      Doctor.create(name: 'Doutor de Teste', email: 'doutor@email.com', crm: 'DEF456', crm_state: 'TE')
      Test.create(patient_id: 1, doctor_id: 1, token: 'TOKEN123', date: '2022-01-03', type: 'hemácias',
                  type_limits: '97-102', type_result: '412')
      Test.create(patient_id: 1, doctor_id: 1, token: 'Token456', date: '2022-01-03', type: 'hemácias',
                  type_limits: '97-102', type_result: '412')
      uri = URI("http://localhost:3000/tests/TOKEN123?env=test")
      response = Net::HTTP.get_response(uri)
      json_response = JSON.parse(response.body)

      expect(response.code).to eq '200'
      expect(response.content_type).to include 'application/json'
      expect(json_response.length).to eq 1
      expect(json_response[0]["token"]).to include('TOKEN123')
      expect(json_response[0]["registration_number"]).to include('123.456')
      expect(json_response[0]["name"]).to include('Paciente de Teste')
      expect(json_response[0]["email"]).to include('email@email.com')
      expect(json_response[0]["birth_date"]).to include('2022-02-03')
      expect(json_response[0]["doctor"]["crm"]).to include('ABC123')
      expect(json_response[0]["doctor"]["crm_state"]).to include('TE')
      expect(json_response[0]["doctor"]["name"]).to include('Doutor 1')
      expect(json_response[0]["date"]).to include('2022-01-03')
      expect(json_response[0]["tests"][0]["type"]).to include('hemácias')
      expect(json_response[0]["tests"][0]["type_limits"]).to include('97-102')
      expect(json_response[0]["tests"][0]["type_result"]).to include('412')
      expect(json_response[1]).to eq nil
    end
  end

  context 'POST /import' do
    it 'success' do
      csv_file_path = '/app/spec/support/csv/test.csv'
      uri = URI("http://localhost:3000/import?env=test")
      request = Net::HTTP::Post.new(uri)
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Post::Multipart.new(uri,
      {
        'file' => UploadIO.new(File.open(csv_file_path), 'text/csv', File.basename(csv_file_path))
      })
      response = http.request(request)
      json_response = JSON.parse(response.body)
      expect(response.code).to eq '200'
      expect(response.content_type).to include 'application/json'
      expect(json_response['conversion_status']).to eq 'CSV conversion ended'
    end

    it 'falha caso extensão de arquivo não seja csv' do
      pdf_file_path = '/app/spec/support/pdf/dummy.pdf'
      uri = URI("http://localhost:3000/import?env=test")
      request = Net::HTTP::Post.new(uri)
      http = Net::HTTP.new(uri.host, uri.port)
      request = Net::HTTP::Post::Multipart.new(uri,
      {
        'file' => UploadIO.new(File.open(pdf_file_path), 'application/pdf', File.basename(pdf_file_path))
      })
      response = http.request(request)
      json_response = JSON.parse(response.body)
      expect(response.code).to eq '200'
      expect(response.content_type).to include 'application/json'
      expect(json_response['conversion_status']).to eq 'File extension not supported'
    end
  end
end
