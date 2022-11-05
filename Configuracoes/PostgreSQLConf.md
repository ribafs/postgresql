# Usando o PostgreSQL

Estou usando a versão 11 do PostgreSQL.

Vou mostrar os passos no Linux.

Após a instalação

sudo apt install postgresql

Acessar o terminal

sudo su

Acessar como postgres, usuário inicial padrão

su - postgres

Acessar a console do postgresql

psql

Atribuir a senha 'postgres' para o usuário 'postgres'

alter role postgres password 'postgres';

Sair da console

\q

Ajustar no pg_hba.conf.

Sair do usuário postgres

exit

cd /etc/postgresql/11/main

nano pg_hba.conf

Role a tela até chegar na linha

local   all             postgres                                peer

Precisamos alterar apenas o método de autenticação de peer para trust

Salvar com Ctrl+O e sair com Ctrl+X

Reiniciar o serviço

service postgresql restart

exit

Pronto. Já podemos acessar o PostgreSQL localmente usando

user - postgres

senha - postgres

Agora já podemos acessar usando o PGAdmin, adminer.org ou outro.


