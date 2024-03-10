RSpec.describe JobStatus, type: :model do
  describe '#create' do
    it 'cria JobStatus com status padrão pendente' do
      job_status = JobStatus.create(token: 'ABC123')

      expect(job_status.status).to eq 'pending'
    end
  end

  describe '#done' do
    it 'atualiza status de uma instância de JobStatus para done' do
      job_status = JobStatus.create(token: 'ABC123')

      job_status.done

      expect(JobStatus.last.status).to eq 'done'
    end
  end

  describe '#find_by' do
    it 'encontra uma instância de JobStatus via token' do
      JobStatus.create(token: 'ABC123')
      JobStatus.create(token: 'DEF456')

      job_status = JobStatus.find_by(token: 'ABC123')

      expect(job_status.token).to eq 'ABC123'
    end
  end
end
