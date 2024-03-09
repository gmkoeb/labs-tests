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

      expect(page).to have_button 'Exames'
      expect(page).to have_button 'Médicos'
      expect(page).to have_button 'Pacientes'
      expect(page).to have_content 'Nome do Paciente'
      expect(page).to have_content 'CPF'
      expect(page).to have_content 'Email do Paciente'
      expect(page).to have_content 'Data de Nascimento'
      expect(page).to have_content 'Nome do Médico'
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
      expect(page).to have_content('Doutor de Teste').twice
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

    it 'e realiza busca por nome de paciente' do
      Patient.create(name: 'Paciente de Teste', email: 'email@email.com', registration_number: '123.456',
                     birth_date: '2022-02-03', address: 'Rua teste', city: 'Cidade teste',
                     state: 'Estado teste')
      Patient.create(name: 'Paciente 2', email: 'email2@email.com', registration_number: '678.912',
                     birth_date: '1980-07-09', address: 'Rua teste 2', city: 'Cidade teste 2',
                     state: 'Estado teste 2')
      Doctor.create(name: 'Doutor de Teste', email: 'doutor@email.com', crm: 'ABC123', crm_state: 'TE')
      Test.create(patient_id: 1, doctor_id: 1, token: 'TOKEN123', date: '2022-01-03', type: 'hemácias',
                  type_limits: '97-102', type_result: '412')
      Test.create(patient_id: 2, doctor_id: 1, token: 'TOKEN49JB13', date: '2022-01-03', type: 'hemácias',
                  type_limits: '97-102', type_result: '412')

      visit '/'

      fill_in 'Pesquisa por Nome', with: 'Paciente de'

      expect(page).to have_content 'Paciente de Teste'
      expect(page).to have_content 'TOKEN123'
      expect(page).to_not have_content 'Paciente 2'
      expect(page).to_not have_content 'TOKEN49JB13'
    end

    it 'e realiza busca por nome de médico' do
      Patient.create(name: 'Paciente de Teste', email: 'email@email.com', registration_number: '123.456',
                     birth_date: '2022-02-03', address: 'Rua teste', city: 'Cidade teste',
                     state: 'Estado teste')
      Doctor.create(name: 'Doutor 1', email: 'doutor1@email.com', crm: 'ABC123', crm_state: 'TE')
      Doctor.create(name: 'Doutor de Teste', email: 'doutor@email.com', crm: 'DEF456', crm_state: 'TE')
      Test.create(patient_id: 1, doctor_id: 1, token: 'TOKEN123', date: '2022-01-03', type: 'hemácias',
                  type_limits: '97-102', type_result: '412')
      Test.create(patient_id: 1, doctor_id: 2, token: 'TOKEN49JB13', date: '2022-01-03', type: 'hemácias',
                  type_limits: '97-102', type_result: '412')

      visit '/'

      fill_in 'Pesquisa por Nome', with: 'Doutor de'

      expect(page).to have_content 'Doutor de Teste'
      expect(page).to have_content 'DEF456'
      expect(page).to have_content 'TOKEN49JB13'
      expect(page).to_not have_content 'Doutor 1'
      expect(page).to_not have_content 'ABC123'
    end

    it 'e realiza busca de exame por token' do
      Patient.create(name: 'Paciente de Teste', email: 'email@email.com', registration_number: '123.456',
                     birth_date: '2022-02-03', address: 'Rua teste', city: 'Cidade teste',
                     state: 'Estado teste')
      Doctor.create(name: 'Doutor 1', email: 'doutor1@email.com', crm: 'ABC123', crm_state: 'TE')
      Doctor.create(name: 'Doutor de Teste', email: 'doutor@email.com', crm: 'DEF456', crm_state: 'TE')
      Test.create(patient_id: 1, doctor_id: 1, token: 'TOKEN123', date: '2022-01-03', type: 'hemácias',
                  type_limits: '97-102', type_result: '412')
      Test.create(patient_id: 1, doctor_id: 2, token: 'TOKEN49JB13', date: '2022-01-03', type: 'hemácias',
                  type_limits: '97-102', type_result: '412')

      visit '/'

      fill_in 'Pesquisa por Código', with: 'TOKEN123'
      click_on 'Pesquisar'

      expect(page).to have_content 'TOKEN123'
      expect(page).to have_content 'ABC123'
      expect(page).to have_content 'Doutor 1'
      expect(page).to_not have_content 'TOKEN49JB13'
      expect(page).to_not have_content 'Doutor de Teste'
      expect(page).to_not have_content 'DEF456'
    end

    it 'e realiza busca de exame por token inexistente' do
      Patient.create(name: 'Paciente de Teste', email: 'email@email.com', registration_number: '123.456',
                     birth_date: '2022-02-03', address: 'Rua teste', city: 'Cidade teste',
                     state: 'Estado teste')
      Doctor.create(name: 'Doutor 1', email: 'doutor1@email.com', crm: 'ABC123', crm_state: 'TE')
      Doctor.create(name: 'Doutor de Teste', email: 'doutor@email.com', crm: 'DEF456', crm_state: 'TE')
      Test.create(patient_id: 1, doctor_id: 1, token: 'TOKEN123', date: '2022-01-03', type: 'hemácias',
                  type_limits: '97-102', type_result: '412')

      visit '/'

      fill_in 'Pesquisa por Código', with: 'TOKENQUENAOEXISTE'
      click_on 'Pesquisar'

      expect(page).to have_content 'Nenhum exame com código TOKENQUENAOEXISTE encontrado'
    end

    it 'e realiza upload de arquivo csv' do
      csv_file_path = '/app/spec/support/csv/test.csv'
      visit '/'

      attach_file('file', csv_file_path)

      click_button('Enviar')

      expect(page).to have_content('Conversão de dados iniciada')
    end

    it 'e realiza upload de arquivo não suportado' do
      pdf_file_path = '/app/spec/support/pdf/dummy.pdf'
      visit '/'

      attach_file('file', pdf_file_path)

      click_button('Enviar')

      expect(page).to have_content('Extensão não suportada')
    end
  end
end
