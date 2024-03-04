require_relative '../../models/patient.rb'

RSpec.describe Patient, type: :model do
  describe '#all' do
    it 'retorna todos os pacientes' do
      patients = Patient.all

      expect(patients.length).to eq 50
      expect(patients.first.id).to eq 1
      expect(patients.first.registration_number).to eq '048.973.170-88'
      expect(patients.first.name).to eq 'Emilly Batista Neto'
      expect(patients.first.email).to eq 'gerald.crona@ebert-quigley.com'
      expect(patients.first.birth_date).to eq '2001-03-11'
      expect(patients.first.address).to eq '165 Rua Rafaela'
      expect(patients.first.city).to eq 'Ituverava'
      expect(patients.first.state).to eq 'Alagoas'
      expect(patients[1].id).to eq 2
      expect(patients[1].name).to eq 'Juliana dos Reis Filho'
      expect(patients[1].email).to eq 'mariana_crist@kutch-torp.com'
      expect(patients[1].birth_date).to eq '1995-07-03'
    end
  end

  describe '#tests' do
    it 'retorna todos os exames do paciente' do
      patient_tests = Patient.last.tests

      expect(patient_tests.first.patient.id).to eq Patient.last.id
      expect(patient_tests.first.patient.registration_number).to eq Patient.last.registration_number
      expect(patient_tests.last.patient.registration_number).to eq Patient.last.registration_number
      expect(patient_tests.last.patient.id).to eq Patient.last.id
    end
  end
end
