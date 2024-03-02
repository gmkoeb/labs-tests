# labs-tests

## Tabela de Conteúdos
- [Instalação e Execução](#instalação-e-execução)
- [Popular banco de dados](#popular-banco-de-dados)
- [Testes](#testes)

Para executar a aplicação você deve:

## Instalação e Execução
Para executar a aplicação você deve:
1. Clonar o repositório

2. No diretório: 

        cd labs-tests

3. Criar o network:

        docker network create rebase_labs

4. Inicializar container do servidor:
   
       docker run --rm --name labs-tests --network rebase_labs -w /app -v $(pwd):/app -p 3000:3000 -d ruby bash -c "gem install rspec rackup sinatra puma pg && ruby server.rb"

5. Inicializar container do postgres:

       docker run --rm --name postgres --network rebase_labs -v pgdata:/var/lib/postgresql/data -p 5432:5432 -e POSTGRES_PASSWORD=postgres -d postgres

6. A aplicação estará rodando no endereço:
       http://localhost:3000

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
