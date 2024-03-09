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

Ou: 

1. Entrar na url web (com todos os containers rodando):

        http://localhost:3001

2. Realizar upload do arquivo csv através do formulário
## Testes
Para executar os testes, você deve:

1. Entrar no container do servidor:

       docker exec -it labs-tests bash

2. Dentro do container:

       rspec

Observação: Alguns testes que executam jobs dependem do sidekiq, então caso os containers do sidekiq/redis não estejam rodando esses testes falharão
## Endpoints

A URL base para os endpoints é http://localhost:3000

1. Lista de exames:

 GET /tests

```
[
  {
    "token": "IQCZ17",
    "date": "2021-08-05",
    "registration_number": "048.973.170-88",
    "name": "Emilly Batista Neto",
    "email": "gerald.crona@ebert-quigley.com",
    "birth_date": "2001-03-11",
    "doctor": {
      "crm": "B000BJ20J4",
      "crm_state": "PI",
      "name": "Maria Luiza Pires"
    },
    "tests": [
      {
        "type": "hemácias",
        "type_limits": "45-52",
        "type_result": "97"
      },
      {
        "type": "leucócitos",
        "type_limits": "9-61",
        "type_result": "89"
      }]
]
```

2. Busca de exames por token:

GET /tests/:token

exemplo: GET /tests/IQCZ17

```
[
  {
    "token": "IQCZ17",
    "date": "2021-08-05",
    "registration_number": "048.973.170-88",
    "name": "Emilly Batista Neto",
    "email": "gerald.crona@ebert-quigley.com",
    "birth_date": "2001-03-11",
    "doctor": {
      "crm": "B000BJ20J4",
      "crm_state": "PI",
      "name": "Maria Luiza Pires"
    },
    "tests": [
      {
        "type": "hemácias",
        "type_limits": "45-52",
        "type_result": "97"
      },
      {
        "type": "leucócitos",
        "type_limits": "9-61",
        "type_result": "89"
      }]
 }
]
```
3. Lista de pacientes:

 GET /patients

```
[
  {
    "id": 1,
    "registration_number": "048.973.170-88",
    "name": "Emilly Batista Neto",
    "email": "gerald.crona@ebert-quigley.com",
    "birth_date": "2001-03-11",
    "address": "165 Rua Rafaela",
    "city": "Ituverava",
    "state": "Alagoas"
  }
]
```

4. Lista de médicos:

 GET /doctors

```
[
  {
    "id": 1,
    "name": "Maria Luiza Pires",
    "email": "denna@wisozk.biz",
    "crm": "B000BJ20J4",
    "crm_state": "PI"
  }
]
```

5. Upload de arquivos:

 POST /import
