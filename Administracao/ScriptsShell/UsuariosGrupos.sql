CREATE GROUP adm;
CREATE GROUP dba;
CREATE GROUP mkt;

-- Criacao dos Usuarios do Grupo adm
CREATE USER andre ENCRYPTED PASSWORD 'andre' CREATEDB IN GROUP adm;
CREATE USER michela ENCRYPTED PASSWORD 'michela' CREATEDB IN GROUP adm;

-- Criacao dos Usuarios do Grupo dba
CREATE USER paulo ENCRYPTED PASSWORD 'paulo' CREATEDB IN GROUP dba;
CREATE USER elisangela ENCRYPTED PASSWORD 'elisangela' CREATEDB IN GROUP dba;

-- Criacao dos Usuarios do Grupo mkt
CREATE USER rodrigo ENCRYPTED PASSWORD 'rodrigo' CREATEDB IN GROUP mkt;
CREATE USER melissa ENCRYPTED PASSWORD 'melissa' CREATEDB IN GROUP mkt;

-- Esquemas para Usuarios
CREATE SCHEMA paulo AUTHORIZATION paulo;
CREATE SCHEMA elisangela AUTHORIZATION elisangela;
CREATE SCHEMA rodrigo AUTHORIZATION rodrigo;
CREATE SCHEMA melissa AUTHORIZATION melissa;
CREATE SCHEMA andre AUTHORIZATION andre;
CREATE SCHEMA michela AUTHORIZATION michela;
