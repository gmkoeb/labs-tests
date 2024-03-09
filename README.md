# labs-tests

## Tabela de Conteúdos
- [Instalação e Execução](#instalação-e-execução)
- [Popular banco de dados](#popular-banco-de-dados)
- [Testes](#testes)
- [Endpoints](#endpoints)

## Instalação e Execução
Para executar a aplicação você deve:
1. Clonar o repositório

2. No diretório: 

        cd labs-tests

3. Criar o network:

        docker network create rebase_labs

4. Inicializar containers:
   
        make run_containers

6. A API estará rodando no endereço:

       http://localhost:3000

7. A aplicação web (front-end) estará rodando no endereço:

        http://localhost:3001

## Popular banco de dados   
Para transferir os dados do arquivo csv para o postgres, você deve:

1. Entrar no container do servidor:

       docker exec -it labs-tests bash

2. Dentro do container:

       ruby import_from_csv.rb

## Testes
Para executar os testes, você deve:

1. Entrar no container do servidor:

       docker exec -it labs-tests bash

2. Dentro do container:

       rspec

## Endpoints

A URL base para os endpoints é http://localhost:3000

1. Lista de exames:

GET /tests

```
[
  {
    "id": "1",
    "patient_name": "Emilly Batista Neto",
    "registration_number": "048.973.170-88",
    "patient_email": "gerald.crona@ebert-quigley.com",
    "birth_date": "2001-03-11",
    "address": "165 Rua Rafaela",
    "city": "Ituverava",
    "state": "Alagoas",
    "doctor_name": "Maria Luiza Pires",
    "doctor_email": "denna@wisozk.biz",
    "crm": "B000BJ20J4",
    "crm_state": "PI",
    "date": "2021-08-05",
    "token": "IQCZ17",
    "type": "hemácias",
    "type_limits": "45-52",
    "type_result": "97"
  }
]
```
