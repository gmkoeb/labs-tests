require_relative '../../models/doctor.rb'

RSpec.describe Doctor, type: :model do
  describe '#all' do
    it 'retorna todos os médicos' do
      doctors = Doctor.all

      expect(doctors).to be_a(Array)
      expect(doctors.first.id).to eq 1
      expect(doctors.first.name).to eq 'Maria Luiza Pires'
      expect(doctors.first.email).to eq 'denna@wisozk.biz'
      expect(doctors.first.crm).to eq 'B000BJ20J4'
      expect(doctors.first.crm_state).to eq 'PI'
      expect(doctors[1].name).to eq 'Maria Helena Ramalho'
      expect(doctors[1].email).to eq 'rayford@kemmer-kunze.info'
      expect(doctors[1].crm).to eq 'B0002IQM66'
      expect(doctors[1].crm_state).to eq 'SC'
    end
  end

  describe '#tests' do
    it 'retorna todos os exames do médico' do
      doctor_tests = Doctor.last.tests

      expect(doctor_tests).to be_a(Array)
      expect(doctor_tests.first.doctor_id).to eq Doctor.last.id
      expect(doctor_tests.first.doctor.name).to eq Doctor.last.name
      expect(doctor_tests.first.doctor.crm).to eq Doctor.last.crm
      expect(doctor_tests.last.doctor_id).to eq Doctor.last.id
      expect(doctor_tests.last.doctor.name).to eq Doctor.last.name
      expect(doctor_tests.last.doctor.crm).to eq Doctor.last.crm
    end
  end
end
