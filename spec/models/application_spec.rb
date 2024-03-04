require_relative '../../models/patient.rb'
require_relative '../../models/test.rb'
require_relative '../../models/application.rb'

RSpec.describe Application, type: :model do
  describe '#first' do
    context 'tests' do
      it 'retorna o primeiro exame da lista de exames' do
        first_test = Test.first

        expect(first_test.id).to eq Test.all[0].id
        expect(first_test.token).to eq Test.all[0].token
      end
    end
    context 'patients' do
      it 'retorna o primeiro paciente da lista de pacientes' do
        first_patient = Patient.first

        expect(first_patient.id).to eq Patient.all[0].id
        expect(first_patient.registration_number).to eq Patient.all[0].registration_number
      end
    end
  end

  describe '#last' do
    context 'tests' do
      it 'retorna o último exame da lista de exames' do
        last_test = Test.last

        expect(last_test.id).to eq Test.all[Test.all.length - 1].id
      end
    end
    context 'patients' do
      it 'retorna o último paciente da lista de pacientes' do
        last_patient = Patient.last

        expect(last_patient.id).to eq Patient.all[Patient.all.length - 1].id
      end
    end
  end
end
