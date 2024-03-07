RSpec.describe Application, type: :model do
  describe '#first' do
    context 'tests' do
      it 'retorna o primeiro exame da lista de exames' do
        Patient.create(name: 'Paciente', email: 'email@email.com', registration_number: '123',
                       birth_date: '2022-02-03', address: 'Rua teste', city: 'Cidade teste',
                       state: 'Estado teste')
        Doctor.create(name: 'Doutor', email: 'doutor@email.com', crm: 'ABC123', crm_state: 'teste')
        Test.create(patient_id: 1, doctor_id: 1, token: 'abc123', date: '2022-01-03', type: 'hemácias',
                    type_limits: '97-102', type_result: '412')
        Test.create(patient_id: 1, doctor_id: 1, token: 'abc123', date: '2022-01-03', type: 'leucócitos',
                    type_limits: '50-90', type_result: '65')

        first_test = Test.first

        expect(first_test.id).to eq Test.all[0].id
        expect(first_test.token).to eq Test.all[0].token
      end
    end
    context 'patients' do
      it 'retorna o primeiro paciente da lista de pacientes' do
        Patient.create(name: 'Paciente 1', email: 'email@email.com', registration_number: '123',
                       birth_date: '2022-02-03', address: 'Rua teste', city: 'Cidade teste',
                       state: 'Estado teste')
        Patient.create(name: 'Paciente 2', email: 'email2@email.com', registration_number: '321',
                       birth_date: '1999-02-03', address: 'Rua teste', city: 'Cidade teste',
                       state: 'Estado teste')

        first_patient = Patient.first

        expect(first_patient.id).to eq 1
        expect(first_patient.registration_number).to eq '123'
        expect(first_patient.name).to eq 'Paciente 1'
      end
    end
    context 'doctors' do
      it 'retorna o primeiro médico da lista de médicos' do
        Doctor.create(name: 'Doutor 1', email: 'doutor@email.com', crm: 'ABC123', crm_state: 'teste')
        Doctor.create(name: 'Doutor 2', email: 'doutor2@email.com', crm: 'DEF456', crm_state: 'teste')

        first_doctor = Doctor.first

        expect(first_doctor.id).to eq 1
        expect(first_doctor.name).to eq 'Doutor 1'
      end
    end
  end

  describe '#last' do
    context 'tests' do
      it 'retorna o último exame da lista de exames' do
        Patient.create(name: 'Paciente', email: 'email@email.com', registration_number: '123',
                       birth_date: '2022-02-03', address: 'Rua teste', city: 'Cidade teste',
                       state: 'Estado teste')
        Doctor.create(name: 'Doutor', email: 'doutor@email.com', crm: 'ABC123', crm_state: 'teste')
        Test.create(patient_id: 1, doctor_id: 1, token: 'abc123', date: '2022-01-03', type: 'hemácias',
                    type_limits: '97-102', type_result: '412')
        Test.create(patient_id: 1, doctor_id: 1, token: 'abc123', date: '2022-01-03', type: 'leucócitos',
                    type_limits: '50-90', type_result: '65')

        last_test = Test.last

        expect(last_test.id).to eq 2
        expect(last_test.type).to eq 'leucócitos'
      end
    end
    context 'patients' do
      it 'retorna o último paciente da lista de pacientes' do
        Patient.create(name: 'Paciente 1', email: 'email@email.com', registration_number: '123',
        birth_date: '2022-02-03', address: 'Rua teste', city: 'Cidade teste',
        state: 'Estado teste')
        Patient.create(name: 'Paciente 2', email: 'email2@email.com', registration_number: '321',
                birth_date: '1999-02-03', address: 'Rua teste', city: 'Cidade teste',
                state: 'Estado teste')

        last_patient = Patient.last

        expect(last_patient.id).to eq 2
        expect(last_patient.registration_number).to eq '321'
        expect(last_patient.name).to eq 'Paciente 2'
      end
    end
    context 'doctors' do
      it 'retorna o último médico da lista de médicos' do
        Doctor.create(name: 'Doutor 1', email: 'doutor@email.com', crm: 'ABC123', crm_state: 'teste')
        Doctor.create(name: 'Doutor 2', email: 'doutor2@email.com', crm: 'DEF456', crm_state: 'teste')

        last_doctor = Doctor.last

        expect(last_doctor.id).to eq 2
        expect(last_doctor.name).to eq 'Doutor 2'
      end
    end
  end
end
