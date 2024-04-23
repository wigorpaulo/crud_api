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



# Projeto tem como incentivo  a solução do teste técnico: 

