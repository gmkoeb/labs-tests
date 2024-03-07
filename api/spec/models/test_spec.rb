RSpec.describe Test, type: :model do
  describe '#all' do
    it 'retorna todos os exames' do
      Patient.create(name: 'Paciente', email: 'email@email.com', registration_number: '123',
                     birth_date: '2022-02-03', address: 'Rua teste', city: 'Cidade teste',
                     state: 'Estado teste')
      Doctor.create(name: 'Doutor', email: 'doutor@email.com', crm: 'ABC123', crm_state: 'teste')
      Test.create(patient_id: 1, doctor_id: 1, token: 'abc123', date: '2022-01-03', type: 'hemácias',
                  type_limits: '97-102', type_result: '412')
      Test.create(patient_id: 1, doctor_id: 1, token: 'abc123', date: '2022-01-03', type: 'leucócitos',
                  type_limits: '50-90', type_result: '65')

      tests = Test.all

      expect(tests).to be_a(Array)
      expect(tests.length).to eq 2
      expect(tests.first.id).to eq 1
      expect(tests.first.patient_id).to eq 1
      expect(tests.first.doctor_id).to eq 1
      expect(tests.first.date).to eq '2022-01-03'
      expect(tests.first.token).to eq 'abc123'
      expect(tests.first.type).to eq 'hemácias'
      expect(tests.first.type_limits).to eq '97-102'
      expect(tests.first.type_result).to eq '412'
      expect(tests[1].id).to eq 2
      expect(tests[1].patient_id).to eq 1
      expect(tests[1].doctor_id).to eq 1
      expect(tests[1].token).to eq 'abc123'
    end
  end

  describe '#patient' do
    it 'retorna paciente relacionado ao exame' do
      Patient.create(name: 'Paciente', email: 'email@email.com', registration_number: '123',
                     birth_date: '2022-02-03', address: 'Rua teste', city: 'Cidade teste',
                     state: 'Estado teste')
      Doctor.create(name: 'Doutor', email: 'doutor@email.com', crm: 'ABC123', crm_state: 'teste')
      Test.create(patient_id: 1, doctor_id: 1, token: 'abc123', date: '2022-01-03', type: 'hemácias',
                  type_limits: '97-102', type_result: '412')
      Test.create(patient_id: 1, doctor_id: 1, token: 'abc123', date: '2022-01-03', type: 'leucócitos',
                  type_limits: '50-90', type_result: '65')

      patient = Test.first.patient

      expect(patient.id).to eq 1
      expect(patient.name).to eq 'Paciente'
      expect(patient.registration_number).to eq '123'
      expect(patient.email).to eq 'email@email.com'
      expect(patient.birth_date).to eq '2022-02-03'
      expect(patient.address).to eq 'Rua teste'
      expect(patient.city).to eq 'Cidade teste'
      expect(patient.state).to eq 'Estado teste'
    end
  end

  describe '#doctor' do
    it 'retorna médico relacionado ao exame' do
      Patient.create(name: 'Paciente', email: 'email@email.com', registration_number: '123',
                     birth_date: '2022-02-03', address: 'Rua teste', city: 'Cidade teste',
                     state: 'Estado teste')
      Doctor.create(name: 'Doutor', email: 'doutor@email.com', crm: 'ABC123', crm_state: 'teste')
      Test.create(patient_id: 1, doctor_id: 1, token: 'abc123', date: '2022-01-03', type: 'hemácias',
                  type_limits: '97-102', type_result: '412')
      Test.create(patient_id: 1, doctor_id: 1, token: 'abc123', date: '2022-01-03', type: 'leucócitos',
                  type_limits: '50-90', type_result: '65')

      doctor = Test.first.doctor

      expect(doctor.id).to eq 1
      expect(doctor.name).to eq 'Doutor'
      expect(doctor.email).to eq 'doutor@email.com'
      expect(doctor.crm).to eq 'ABC123'
      expect(doctor.crm_state).to eq 'teste'
    end
  end

  describe '#as_json' do
    it 'retorna todos os exames formatados em JSON' do
      Patient.create(name: 'Paciente', email: 'email@email.com', registration_number: '123',
                     birth_date: '2022-02-03', address: 'Rua teste', city: 'Cidade teste',
                     state: 'Estado teste')
      Doctor.create(name: 'Doutor', email: 'doutor@email.com', crm: 'ABC123', crm_state: 'teste')
      Test.create(patient_id: 1, doctor_id: 1, token: 'abc123', date: '2022-01-03', type: 'hemácias',
                  type_limits: '97-102', type_result: '412')
      Test.create(patient_id: 1, doctor_id: 1, token: 'abc123', date: '2022-01-03', type: 'leucócitos',
                  type_limits: '50-90', type_result: '65')

      result = Test.all.as_json

      tests = JSON.parse(result)
      expect(tests.first).to be_a(Hash)
      expect(tests.first['id']).to eq 1
      expect(tests.first['doctor_id']).to eq 1
      expect(tests.first['patient_id']).to eq 1
      expect(tests.first['token']).to eq 'abc123'
    end
  end

  describe '#all_with_foreign' do
    it 'retorna json de testes formatado corretamente' do
      Patient.create(name: 'Paciente', email: 'paciente@email.com', registration_number: '123',
                      birth_date: '2022-02-03', address: 'Rua teste', city: 'Cidade teste',
                      state: 'Estado teste')
      Doctor.create(name: 'Doutor', email: 'doutor@email.com', crm: 'ABC123', crm_state: 'teste')
      Test.create(patient_id: 1, doctor_id: 1, token: 'abc123', date: '2022-01-03', type: 'hemácias',
                  type_limits: '97-102', type_result: '412')
      Test.create(patient_id: 1, doctor_id: 1, token: 'abc123', date: '2022-01-03', type: 'leucócitos',
                  type_limits: '50-90', type_result: '65')

      result = Test.all_with_foreign
      tests = JSON.parse(result)

      expect(tests).to be_a(Array)
      expect(tests.first).to be_a(Hash)
      expect(tests.first['name']).to eq 'Paciente'
      expect(tests.first['email']).to eq 'paciente@email.com'
      expect(tests.first['registration_number']).to eq '123'
      expect(tests.first['birth_date']).to eq '2022-02-03'
      expect(tests.first['doctor']['name']).to eq 'Doutor'
      expect(tests.first['token']).to eq 'abc123'
      expect(tests.first['date']).to eq '2022-01-03'
      expect(tests.first['tests'][0]['type']).to eq 'hemácias'
      expect(tests.first['tests'][0]['type_limits']).to eq '97-102'
      expect(tests.first['tests'][0]['type_result']).to eq '412'
      expect(tests.first['tests'][1]['type']).to eq 'leucócitos'
      expect(tests.first['tests'][1]['type_limits']).to eq '50-90'
      expect(tests.first['tests'][1]['type_result']).to eq '65'
    end
  end
end
