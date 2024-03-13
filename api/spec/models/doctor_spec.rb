RSpec.describe Doctor, type: :model do
  describe '#all' do
    it 'retorna todos os médicos' do
      Doctor.create(name: 'Doutor 1', email: 'doutor1@email.com', crm: 'ABC123', crm_state: 'PR')
      Doctor.create(name: 'Doutor 2', email: 'doutor2@email.com', crm: 'DEF456', crm_state: 'PR')

      doctors = Doctor.all

      expect(doctors).to be_a(Array)
      expect(doctors.length).to eq 2
      expect(doctors.first.id).to eq 1
      expect(doctors.first.name).to eq 'Doutor 1'
      expect(doctors.first.email).to eq 'doutor1@email.com'
      expect(doctors.first.crm).to eq 'ABC123'
      expect(doctors.first.crm_state).to eq 'PR'
      expect(doctors[1].name).to eq 'Doutor 2'
      expect(doctors[1].email).to eq 'doutor2@email.com'
      expect(doctors[1].crm).to eq 'DEF456'
      expect(doctors[1].crm_state).to eq 'PR'
    end
  end

  describe '#tests' do
    it 'retorna todos os exames do médico' do
      Patient.create(name: 'Paciente', email: 'email@email.com', registration_number: '123',
                     birth_date: '2022-02-03', address: 'Rua teste', city: 'Cidade teste',
                     state: 'Estado teste')
      doctor = Doctor.create(name: 'Doutor', email: 'doutor@email.com', crm: 'ABC123', crm_state: 'teste')
      first_test = Test.create(patient_id: 1, doctor_id: 1, token: 'abc123', date: '2022-01-03', type: 'hemácias',
                               type_limits: '97-102', type_result: '412')
      second_test = Test.create(patient_id: 1, doctor_id: 1, token: 'abc123', date: '2022-01-03', type: 'leucócitos',
                                type_limits: '50-90', type_result: '65')

      doctor_tests = Doctor.first.tests

      expect(doctor_tests).to be_a(Array)
      expect(doctor_tests.first.doctor.name).to eq doctor.name
      expect(doctor_tests[1].doctor.name).to eq doctor.name
      expect(doctor_tests.first.type).to eq first_test.type
      expect(doctor_tests[1].type).to eq second_test.type
    end
  end

  describe '#create' do
    it 'cria médico com sucesso' do
      Doctor.create(name: 'Doutor', email: 'doutor@email.com',
                    crm: 'ABC123', crm_state: 'TE')

      expect(Doctor.last.name).to eq 'Doutor'
      expect(Doctor.last.email).to eq 'doutor@email.com'
      expect(Doctor.last.crm).to eq 'ABC123'
      expect(Doctor.last.crm_state).to eq 'TE'
    end

    it 'email deve ser único' do
      Doctor.create(name: 'Doutor', email: 'doutor@email.com',
                    crm: 'ABC123', crm_state: 'TE')
      doctor = Doctor.create(name: 'Doutor Não criado', email: 'doutor@email.com',
                             crm: 'ABC123', crm_state: 'TE')

      expect(Doctor.last.name).to eq 'Doutor'
      expect(doctor[:error]).to include 'duplicate key value violates unique constraint "doctors_email_key"'
      expect(doctor[:error]).to include 'Key (email)=(doutor@email.com) already exists.'
    end

    it 'crm deve ser único para cada estado' do
      Doctor.create(name: 'Doutor', email: 'doutor@email.com',
                    crm: 'ABC123', crm_state: 'TE')
      doctor = Doctor.create(name: 'Doutor Não criado', email: 'doutor2@email.com',
                             crm: 'ABC123', crm_state: 'TE')

      expect(Doctor.last.name).to eq 'Doutor'
      expect(doctor[:error]).to include 'Key (crm, crm_state)=(ABC123, TE) already exists'
      expect(doctor[:error]).to include 'duplicate key value violates unique constraint "doctors_crm_crm_state_key"'
    end
  end
end
