# README

* Instalação do banco de dados postgres, local no Linux Ubuntu

  - link para consulta: https://www.postgresql.org/download/linux/ubuntu/
    https://www.youtube.com/watch?v=q0r-4etqNf4&ab_channel=WagnerMachadodoAmaral

  * Comandos:


    sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
    
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
    
    sudo apt-get update
    
    sudo apt-get -y install postgresql
    
    sudo apt-get install postgresql-12
    
    sudo systemctl start postgresql
    
    sudo systemctl status postgresql
    
    sudo -u postgres psql
    
    ALTER USER postgres PASSWORD 'postgres';
    
    exit
    
    # Pode conectar no banco local

* Versão Ruby
    
        ruby '3.2.2'
 
* Instalar dependência

        bundle install

* Criação de banco de dados
        
        rails db:create

* Inicialização do banco de dados

        rails db:migrate
        rails db:seed

* Como executar o conjunto de testes

        rspec

    -   Ao final da execução do RSPEC poderar verificar a cobertura dos testes por meio da abertura do html INDEX do covarage:
           
                coverage/index.html

* Como executar o rubocop

        rubocop

* Collection para importa no POSTMAN

        ../crud_api/crud_api.postman_collection.json

# Projeto tem como incentivo  a solução do teste técnico: 

O objetivo deste teste é avaliar sua capacidade em criar um projeto de API do Rails com as funcionalidades básicas de CRUD, autenticação e associações entre modelos. Você deverá criar rotas para cada um dos CRUD's para cada modelo, incluindo uma rota de autenticação para permitir que os usuários se autentiquem antes de acessar as rotas protegidas.



Os modelos que você deverá implementar, bem como suas respectivas colunas, são:



    Usuário (id, nome, e-mail, senha)
    
    Post (id, título, texto, usuário[associação])
    
    Comentário (id, nome, comentário, post [associação])



Deve conter uma rota de autenticação, e a rota de criação/edição/exclusão de post e usuário devem estar bloqueadas.

Além disso, você deve preferencialmente escrever testes para as rotas criadas para garantir que a API esteja funcionando corretamente. É recomendado usar alguma biblioteca para padronizar as respostas, como o Jbuilder, que permite formatar as respostas em JSON de acordo com as especificações do projeto.

    As rotas de criação, edição e exclusão de usuários assim como o de posts devem estar bloqueadas por meio de autenticação.
    Somente as rotas de listagens e detalhamentos (usuários e posts) devem ser possíveis de acessar sem autenticação.
    O CRUD de comentário pode deixar livre mesmo. Idealmente não faz tanto sentido ser totalmente livre, 
    mas o objetivo do teste é validar padronização/organização de código e conhecimentos gerais do framework.

Para a entrega do teste, você deverá criar um repositório no GitHub e compartilhá-lo conosco.

Prazo para a entrega: até dia 26/04, sexta-feira.



Avaliaremos seu teste com base nos seguintes critérios:



- Qualidade do código

- Aderência aos requisitos

- Capacidade de resolução de problemas

- Escrita de testes eficazes

Se tiver alguma dúvida ou precisar de mais informações, não hesite em entrar em contato conosco.

## Explicação sobre as abordagem utilizada no desenvolvimento do projeto

#### - Linguagem ruby:

- Foi escolhido a versão 3.2.2 tendo em vista de uma das versões mais recente do ruby.

#### - Endpoint para gerar token a partir de um email e senha:

- Foi descido a implementação manual do método que gera o token, pensando em obter uma maior agilidade e controle da
  maneira que é gerado o token e na manutenibilidade do código, onde é retirado a dependência e complexidade da
  biblioteca de terceito.

#### - Organização do código:

- Foi configurado o **rubocop**, com o intuito de deixar o código mais organizado e obdecendo o padrão da comunidade ruby e
  **clean code**, deixando o código mais limpo possível;
- Foi configurado o **I18n** para deixar o projeto multi-linguagem;
- Foi configurado a gema **active_model_serializers** para padronizar as respostas.

#### - Testes:

- Foi configurado a gema **rspec** para montar os testes unitários;
- Foi configurado a gema **simplecov** para poder ter a visibilidade da cobertura dos testes unitários do projeto.

#### - Action de USER:

- Para a rota: **index**, **show** e **create_token**, pode ser acessado sem a necessidade de passar o **TOKEN**;
- Para a rota: **create**, **update** e **destroy**, é necessário passar o **TOKEN**;

#### - Action de POST:

- Para a rota: **index** e **show**, pode ser acessado sem a necessidade de passar o **TOKEN**;
- Para a rota: **create**, **update** e **destroy**, é necessário passar o **TOKEN**;

#### - Action de COMMENT:

- Para a rota: **index**, **show**, **create**, **update** e **destroy**, pode ser acessado sem a necessidade de passar o **TOKEN**;