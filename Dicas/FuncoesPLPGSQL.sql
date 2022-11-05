/*
  Apropriado para o banco de dados emp.sql
  
  		empresas=(id,nome,dtcadastro,telcom,site,email,saldo,obs)	
		clientes=(id,fkempresa,nome,dtnascimento,telres,site,email,saldo,obs)
		contas=(id,fkcliente,nome,dtabertura)
		movimentos=(id,fkconta,historico,credito,debito)
		movempresas=(id,fkconta,historico,credito,debito)

                precos=(id,produto,valor,data_ins,user_ins,data_atu,user_atu);
                precos_log_del=(id,produto,valor,data_ins,user_ins,data_atu,user_atu,data_del,user_del);
*/

-- ================================================================================================================
-- Crie uma funcao onde passamos um valor inteiro e retorne ele mais 1

create function soma1(integer) returns integer as
'
       as select  $1 + 1
'
language 'sql';

-- ================================================================================================================
-- Monte uma função que mostre a quantidade de clientes em uma empresa
-- deverá ser passado o codigo da empresa como parametro.

create function qtd_clientes_empresas(integer) returns bigint as
'
       select count(*) from clientes where fkempresa = $1
'
language 'sql';

-- ================================================================================================================
-- Monte uma função que mostre a quantidade de contas por clientes

create or replace function Contas_Clientes(integer) returns bigint as
'
       select count(*) from contas where fkcliente = $1
'
language 'sql';

-- ================================================================================================================
-- Crie uma função para inserir ao mesmo tempo o  nome da empresa e o nome 	
-- de um cliente retornando o id da empresa e do cliente.

create or replace function novocliente(varchar,varchar) returns bigint as
'
       insert into empresas(nome) values($1);
       insert into clientes(fkempresa,nome) 	values(currval(''empresas_id_seq''),$2);
       select currval(''empresas_id_seq'') as id_empresa
'
language 'sql';

-- ================================================================================================================
-- Crie uma função que retorne quem deve

create function quemdeve() returns setof integer as
'
       select clientes.id from clientes inner join contas on clientes.id = 	contas.fkcliente
       inner join movimentos on contas.id=movimentos.fkconta
       group by clientes.id
       having sum(credito-debito)<0
' language 'sql';

select quemdeve();

select clientes.nome from clientes where clientes.id = (select quemdeve());

-- ================================================================================================================
-- Crie uma função que some 1 a um número passado

create or replace function soma1(integer) returns integer as
'
declare
       valor alias for $1;
       x integerw;
begin
     x:=1;
     x:=x+valor;
     return x;
end;
'
language 'plpgsql';

-- ================================================================================================================
-- Crie uma função onde passamos como parâmetro o id do cliente e seja retornado o seu nome

create or replace function id_nome_clientes(integer) returns text as
'
declare
	r record;
begin
     select into r * from clientes where id = $1;
     if not found then
        raise exception ''Cliente não existente !'';
     end if;
     return r.nome;
end;
'
language 'plpgsql';

-- ================================================================================================================
-- Crie uma função que retorne os nome de toda a tabela clientes concatenados em um só campo

create or replace function somaids() returns text as
'
declare
       x text;
       r record;
begin
     x:=''inicio:'';
     for r in select * from clientes loop
         x:= x||r.nome;
     end loop;
     return x;
end;
'
language 'plpgsql';

-- ================================================================================================================
-- Atualizando o saldo de uma conta devera ser passado o id da conta

create or replace function saldo_upd(integer) returns numeric(12,2) as 
'
       update contas set saldo = (
       select sum(movimentos.credito-movimentos.debito)
       from movimentos where movimentos.fkconta = $1) where id = $1;
       select sum(movimentos.credito-movimentos.debito) from movimentos where movimentos.fkconta = $1;
'
language 'sql'

-- ================================================================================================================
-- Atualizando o saldo de uma conta

create or replace function ajusta_saldo_conta(integer) returns numeric as
'
declare
	idconta alias for $1;
	vsaldo  numeric;
begin
	vsaldo = (select sum(movimentos.credito-movimentos.debito) from movimentos where movimentos.fkconta = idconta);

	if vsaldo is null then
		raise exception ''Conta % não cadastrada!'',idconta;
	else
		update contas set saldo = (vsaldo) where id = idconta;
		return vsaldo;
	end if;
end;
'
language 'plpgsql'

-- ================================================================================================================
-- Atualizando o saldo de todas as contas

create or replace function ajusta_saldos_contas() returns bigint as
'
declare
	vsaldo numeric;
	r record;
	cont bigint;
begin
	for r in select id from contas loop
		vsaldo = (select sum(movimentos.credito-movimentos.debito) from movimentos where movimentos.fkconta = r.id);
		update contas set saldo = (vsaldo) where id = r.id;
	end loop;	
	cont := (select count(id) from contas);
	return cont;
end;
'
language 'plpgsql';

-- ================================================================================================================
--
-- Trigger´s
--
--
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Exemplo 01 - Sistema de log de registros de uma tabela
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++
--
-- Log para insert, update e delete
--
-- Criar um trigger para atualizar os campos apos ter feito INSERT ou UPDATE na tabela salarios
--                       data_ins
--                       user_ins
--                       data_atu
--                       user_atu
--
-- Tabela que possui os dados a serem logados
--
create table precos(
                        id           serial primary key,
                        produto      varchar(30),
                        valor        numeric(11,2), 	
                        data_ins     timestamp,
                        user_ins     text,
                        data_atu     timestamp,
                        user_atu     text
);
--
--
-- Tabela de log
create table precos_log_del(
                        id           integer,
                        produto      varchar(30),
                        valor        numeric(11,2), 	
                        data_ins     timestamp,
                        user_ins     text,
                        data_atu     timestamp,
                        user_atu     text,
                        data_del     timestamp,
                        user_del     text
);
--

-- Passo 01 - Criacao da function

create or replace function precos_log() returns opaque as
'
begin

     if tg_op = ''INSERT'' then
        new.data_ins := now();
        new.user_ins := current_user;
        new.data_atu := now();
        new.user_atu := current_user;
     end if;

     if tg_op = ''UPDATE'' then
        new.data_ins := old.data_ins;
        new.user_ins := old.user_ins;
        new.data_atu := now();
        new.user_atu := current_user;
     end if;

     if tg_op=''DELETE'' then
	insert into precos_log_del(id,
                                     produto,
                                     valor,
                                     data_ins,
                                     user_ins,
                                     data_atu,
                                     user_atu,
                                     data_del,
                                     user_del)

                              values(old.id,
                                     old.produto,
                                     old.valor,
                                     old.data_ins,
                                     old.user_ins,
                                     old.data_atu,
                                     old.user_atu,
                                     now(),
                                     current_user);
     end if;

     return new;

end;
'
language 'plpgsql';

-- Passo 02 - Criacao da trigger
-- Trigger para
-- before (antes de insert ou update)

create trigger precos_log_ins_upd
before insert or update
on precos
for each row
execute procedure precos_log();

-- Trigger para
-- after (apos ter deletado)

create trigger precos_log_del
after delete
on precos
for each row
execute procedure precos_log();

-- +++++++++++++++++++++++++++++++++++++++++++++++
-- Exemplo 02 - Utilizando o Exemplo 01 com view's
-- +++++++++++++++++++++++++++++++++++++++++++++++

-- Passo 01 - Criar a view

create view v_precos as
select id, produto, valor from precos;

-- Passo 02 - Criar as regras para ins, upd e del
-- Regra para Insert

create rule rv_precos_ins as
on insert to v_precos
do instead
insert into precos(produto,valor) values(new.produto,new.valor);

-- Regra para Update

create rule rv_precos_upd as
on update to v_precos
do instead
update precos
set
   produto = new.produto,
   valor = new.valor
   where id = old.id;
   
-- Regra para Delete

create rule rv_precos_del as
on delete to v_precos
do instead
delete from precos
where id = old.id;

-- Passo 03 - Executar os comandos
-- insert, update ou delete


-- +++++++++++++++++++++++++++++++
-- Exemplo 03 - Atualizando Saldos
-- +++++++++++++++++++++++++++++++
--
--
-- Passo 01 - Criar a function
--
create function saldo_upd() returns opaque as
'
begin
     if tg_op = ''INSERT'' then
        update empresas
        set saldo = (saldo + (new.credito - new.debito))
        where id = new.fkempresa;
        return new;
     end if;

     if tg_op = ''DELETE'' then
        update empresas
        set saldo = (saldo - (old.credito - old.debito)) where id = old.fkempresa;
        return old;
        end if;

     if tg_op = ''UPDATE'' then
        update empresas
        set saldo =
        (saldo - (old.credito – old.debito)+
        (new.credito - new.debito))
        where id = old.fkempresa;
        return new;
        end if;
end;
'
language 'plpgsql';
--
--
-- Passo 02 - Criar a trigger

create trigger atualiza_saldo
after insert or update or delete
on movempresas
for each row
execute procedure saldo_upd();



