RSpec.describe Patient, type: :model do
  describe '#all' do
    it 'retorna todos os pacientes' do
      Patient.create(name: 'Paciente 1', email: 'email@email.com', registration_number: '123',
                     birth_date: '2022-02-03', address: 'Rua teste', city: 'Cidade teste',
                     state: 'Estado teste')
      Patient.create(name: 'Paciente 2', email: 'email2@email.com', registration_number: '321',
                     birth_date: '1999-02-03', address: 'Rua teste', city: 'Cidade teste',
                     state: 'Estado teste')

      patients = Patient.all

      expect(patients).to be_a(Array)
      expect(patients.length).to eq 2
      expect(patients.first.id).to eq 1
      expect(patients.first.registration_number).to eq '123'
      expect(patients.first.name).to eq 'Paciente 1'
      expect(patients.first.email).to eq 'email@email.com'
      expect(patients[1].id).to eq 2
      expect(patients[1].name).to eq 'Paciente 2'
      expect(patients[1].email).to eq 'email2@email.com'
    end
  end

  describe '#tests' do
    it 'retorna todos os exames do paciente' do
      patient = Patient.create(name: 'Paciente', email: 'email@email.com', registration_number: '123',
                               birth_date: '2022-02-03', address: 'Rua teste', city: 'Cidade teste',
                               state: 'Estado teste')
      Doctor.create(name: 'Doutor', email: 'doutor@email.com', crm: 'ABC123', crm_state: 'teste')
      first_test = Test.create(patient_id: 1, doctor_id: 1, token: 'abc123', date: '2022-01-03', type: 'hemácias',
                               type_limits: '97-102', type_result: '412')
      second_test = Test.create(patient_id: 1, doctor_id: 1, token: 'abc123', date: '2022-01-03', type: 'leucócitos',
                                type_limits: '50-90', type_result: '65')

      patient_tests = Patient.last.tests

      expect(patient_tests.first.patient.name).to eq patient.name
      expect(patient_tests.last.patient.name).to eq patient.name
      expect(patient_tests.first.patient.registration_number).to eq patient.registration_number
      expect(patient_tests.first.patient.registration_number).to eq patient.registration_number
    end
  end
end
