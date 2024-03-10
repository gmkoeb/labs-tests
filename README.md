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

Observação: Alguns testes que executam jobs dependem do sidekiq, então, caso os containers do sidekiq/redis não estejam rodando esses testes falharão