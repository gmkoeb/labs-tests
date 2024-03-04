require_relative '../../models/test.rb'

RSpec.describe Test, type: :model do
  describe '#all' do
    it 'retorna todos os exames' do
      tests = Test.all

      expect(tests.length).to eq 3900
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
