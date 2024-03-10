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
  }
]
```

2. Busca de exames por token:

GET /tests/:token

exemplo: GET /tests/IQCZ17

```
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
