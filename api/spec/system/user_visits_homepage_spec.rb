RSpec.describe "Home page", type: :system do
  describe 'Usuário visita página inicial' do
    it 'e vê tabela de exames' do
      Patient.create(name: 'Paciente de Teste', email: 'email@email.com', registration_number: '123.456',
                     birth_date: '2022-02-03', address: 'Rua teste', city: 'Cidade teste',
                     state: 'Estado teste')
      Doctor.create(name: 'Doutor de Teste', email: 'doutor@email.com', crm: 'ABC123', crm_state: 'TE')
      Test.create(patient_id: 1, doctor_id: 1, token: 'TOKEN123', date: '2022-01-03', type: 'hemácias',
                  type_limits: '97-102', type_result: '412')
      Test.create(patient_id: 1, doctor_id: 1, token: 'TOKEN123', date: '2022-01-03', type: 'leucócitos',
                  type_limits: '50-90', type_result: '65')

      visit '/'

      expect(page).to have_content 'Nome do Paciente'
      expect(page).to have_content 'CPF'
      expect(page).to have_content 'Email do Paciente'
      expect(page).to have_content 'Data de Nascimento'
      expect(page).to have_content 'Cidade'
      expect(page).to have_content 'Endereço'
      expect(page).to have_content 'Estado'
      expect(page).to have_content 'Nome do Médico'
      expect(page).to have_content 'Email do Médico'
      expect(page).to have_content 'CRM'
      expect(page).to have_content 'Estado do CRM'
      expect(page).to have_content 'Código do Exame'
      expect(page).to have_content 'Data do Exame'
      expect(page).to have_content 'Tipo de Exame'
      expect(page).to have_content 'Limites'
      expect(page).to have_content 'Resultado'

      expect(page).to have_content('Paciente de Teste').twice
      expect(page).to have_content('123.456').twice
      expect(page).to have_content('email@email.com').twice
      expect(page).to have_content('2022-02-03').twice
      expect(page).to have_content('Rua teste').twice
      expect(page).to have_content('Cidade teste').twice
      expect(page).to have_content('Estado teste').twice
      expect(page).to have_content('Doutor de Teste').twice
      expect(page).to have_content('doutor@email.com').twice
      expect(page).to have_content('ABC123').twice
      expect(page).to have_content('TE').twice
      expect(page).to have_content('TOKEN123').twice
      expect(page).to have_content('2022-01-03').twice
      expect(page).to have_content 'hemácias'
      expect(page).to have_content '97-102'
      expect(page).to have_content '412'
      expect(page).to have_content 'leucócitos'
      expect(page).to have_content '50-90'
      expect(page).to have_content '65'
    end

    it 'e deseja ver somente os pacientes cadastrados' do
      Patient.create(name: 'Paciente de Teste', email: 'email@email.com', registration_number: '123.456',
                     birth_date: '2022-02-03', address: 'Rua teste', city: 'Cidade teste',
                     state: 'Estado teste')
      Patient.create(name: 'Paciente 2', email: 'email2@email.com', registration_number: '678.912',
                     birth_date: '1980-07-09', address: 'Rua teste 2', city: 'Cidade teste 2',
                     state: 'Estado teste 2')
      Doctor.create(name: 'Doutor de Teste', email: 'doutor@email.com', crm: 'ABC123', crm_state: 'TE')
      Test.create(patient_id: 1, doctor_id: 1, token: 'TOKEN123', date: '2022-01-03', type: 'hemácias',
                  type_limits: '97-102', type_result: '412')

      visit '/'
      click_button 'Pacientes'

      expect(page).to have_content 'Paciente de Teste'
      expect(page).to have_content 'email@email.com'
      expect(page).to have_content '123.456'
      expect(page).to have_content '2022-02-03'
      expect(page).to have_content 'Rua teste'
      expect(page).to have_content 'Cidade teste'
      expect(page).to have_content 'Estado teste'
      expect(page).to have_content 'Paciente 2'

      expect(page).to_not have_content 'Doutor de Teste'
      expect(page).to_not have_content 'doutor@email.com'
      expect(page).to_not have_content 'TOKEN123'
      expect(page).to_not have_content 'TOKEN123'
    end

    it 'e deseja ver somente os médicos cadastrados' do
      Patient.create(name: 'Paciente de Teste', email: 'email@email.com', registration_number: '123.456',
                     birth_date: '2022-02-03', address: 'Rua teste', city: 'Cidade teste',
                     state: 'Estado teste')
      Doctor.create(name: 'Doutor de Teste', email: 'doutor@email.com', crm: 'ABC123', crm_state: 'TE')
      Doctor.create(name: 'Doutor de Teste 2', email: 'doutor2@email.com', crm: 'DEF456', crm_state: 'ET')
      Test.create(patient_id: 1, doctor_id: 1, token: 'TOKEN123', date: '2022-01-03', type: 'hemácias',
                  type_limits: '97-102', type_result: '412')

      visit '/'
      click_button 'Médicos'

      expect(page).to have_content 'Doutor de Teste'
      expect(page).to have_content 'doutor@email.com'
      expect(page).to have_content 'ABC123'
      expect(page).to have_content 'TE'
      expect(page).to have_content 'Doutor de Teste 2'
      expect(page).to_not have_content 'Paciente de Teste'
      expect(page).to_not have_content 'TOKEN123'
    end
  end
end
