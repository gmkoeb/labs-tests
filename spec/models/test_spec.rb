require_relative '../../models/test.rb'

RSpec.describe Test, type: :model do
  describe '#all' do
    it 'retorna todos os exames' do
      tests = Test.all

      expect(tests).to be_a(Array)
      expect(tests.first.id).to eq 1
      expect(tests.first.patient_id).to eq 1
      expect(tests.first.doctor_id).to eq 1
      expect(tests.first.date).to eq '2021-08-05'
      expect(tests.first.token).to eq 'IQCZ17'
      expect(tests.first.type).to eq 'hemácias'
      expect(tests.first.type_limits).to eq '45-52'
      expect(tests.first.type_result).to eq '97'
      expect(tests[1].id).to eq 2
      expect(tests[1].patient_id).to eq 1
      expect(tests[1].doctor_id).to eq 1
      expect(tests[1].token).to eq 'IQCZ17'
    end
  end

  describe '#patient' do
    it 'retorna paciente relacionado ao exame' do
      patient = Test.first.patient

      expect(patient.id).to eq 1
      expect(patient.name).to eq 'Emilly Batista Neto'
      expect(patient.registration_number).to eq '048.973.170-88'
      expect(patient.email).to eq 'gerald.crona@ebert-quigley.com'
      expect(patient.birth_date).to eq '2001-03-11'
      expect(patient.address).to eq '165 Rua Rafaela'
      expect(patient.city).to eq 'Ituverava'
      expect(patient.state).to eq 'Alagoas'
    end
  end

  describe '#doctor' do
    it 'retorna médico relacionado ao exame' do
      doctor = Test.first.doctor

      expect(doctor.id).to eq 1
      expect(doctor.name).to eq 'Maria Luiza Pires'
      expect(doctor.email).to eq 'denna@wisozk.biz'
      expect(doctor.crm).to eq 'B000BJ20J4'
      expect(doctor.crm_state).to eq 'PI'
    end
  end

  describe '#as_json' do
    it 'retorna todos os exames formatados em JSON' do
      result = Test.all.as_json

      tests = JSON.parse(result)
      expect(tests.first).to be_a(Hash)
      expect(tests.first['id']).to eq 1
      expect(tests.first['doctor_id']).to eq 1
      expect(tests.first['patient_id']).to eq 1
      expect(tests.first['token']).to eq 'IQCZ17'
    end
  end
end
