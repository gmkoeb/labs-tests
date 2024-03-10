## Endpoints

A URL base para os endpoints é http://localhost:3000

### Lista de exames:

<details>
<summary>GET /tests</summary>

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

</details>

### Busca de exames por token:
<details>
<summary>GET /tests/:token</summary>

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

Caso nenhum exame seja encontrado: 

Exemplo: GET /tests/token-inexistente

```
{
  "test_not_found": "Nenhum exame com código token-inexistente encontrado"
}
```
</details>

### Lista de pacientes:

<details>
<summary>GET /patients</summary>

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
</details>

### Lista de médicos:

<details>
<summary>GET /doctors</summary>

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
</details>

### Upload de arquivos:
<details>
<summary>POST /import</summary>
Retorna como resposta uma token para checar status do job que processará o csv:

```
{
	"token": "KQSNYXGN"
}
```

</details>

### Checar status de um job:
Com a token recebida ao realizar um POST com um arquivo .csv na rota import, você pode checar o status de um job através da rota:
<details>
<summary>GET /job_status/:token</summary>

Exemplo: GET /job_status/KQSNYXGN

```
{
  "job_status": "pending"
}
```

Caso o job tenha terminado o processamento dos dados:

```
{
  "job_status": "done"
}
```

</details>
