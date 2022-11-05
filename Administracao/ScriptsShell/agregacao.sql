/*
  Exemplo de Fun��es de Agrega��o
*/
--
-- Cria��o da Tabela Liga��es
--
create table ligacoes(
                        id              serial          primary key,
                        operador        varchar(30),
                        telefone        varchar(10),
                        custo           numeric(12,2),
                        status          varchar(20)
);
--
-- Inser��o de Registros
--
insert into ligacoes(operador,telefone,custo,status) values('Jo�o','2222-2222',10,'ok');
insert into ligacoes(operador,telefone,custo,status) values('Maria','3333-3333',4.3,'na');
insert into ligacoes(operador,telefone,custo,status) values('Jo�o','4444-4444',5,'ok');
insert into ligacoes(operador,telefone,custo,status) values('Jo�o','5555-5555',7,'na');
insert into ligacoes(operador,telefone,custo,status) values('Maria','3333-3333',7.5,'sc');
insert into ligacoes(operador,telefone,custo,status) values('Jos�','6666-6666',8,'fax');
insert into ligacoes(operador,telefone,custo,status) values('Jos�','3333-3333',6,'sc');
insert into ligacoes(operador,telefone,custo,status) values('Sandra','4444-4444',6.5,'fax');
insert into ligacoes(operador,telefone,custo,status) values('Jo�o','2222-2222',6.5,'ne');
insert into ligacoes(operador,telefone,custo,status) values('Sandra','3333-3333',6.5,'ne');
--
-- 1. Exibir a soma do total de custo de cada operador.
--
  select operador,sum(custo)
  from ligacoes
  group by operador;
/*
  +----------+------+
  | operador | sum  |
  +----------+------+
  | Jos�     |   14 |
  | Jo�o     | 28,5 |
  | Maria    | 11,8 |
  | Sandra   |   13 |
  +----------+------+
  Query OK, 4 rows in set (0,15 sec)
*/
--
-- 2. Listar em ordem alfab�tica pelo nome do operador
--
  select operador,telefone
  from ligacoes
  order by operador asc
/*
  +----------+-----------+
  | operador | telefone  |
  +----------+-----------+
  | Jos�     | 3333-3333 |
  | Jos�     | 6666-6666 |
  | Jo�o     | 5555-5555 |
  | Jo�o     | 2222-2222 |
  | Jo�o     | 4444-4444 |
  | Jo�o     | 2222-2222 |
  | Maria    | 3333-3333 |
  | Maria    | 3333-3333 |
  | Sandra   | 4444-4444 |
  | Sandra   | 3333-3333 |
  +----------+-----------+
  Query OK, 10 rows in set (1,11 sec)
*/
  select operador,telefone
  from ligacoes
  order by operador desc
/*
  +----------+-----------+
  | operador | telefone  |
  +----------+-----------+
  | Sandra   | 3333-3333 |
  | Sandra   | 4444-4444 |
  | Maria    | 3333-3333 |
  | Maria    | 3333-3333 |
  | Jo�o     | 2222-2222 |
  | Jo�o     | 4444-4444 |
  | Jo�o     | 5555-5555 |
  | Jo�o     | 2222-2222 |
  | Jos�     | 6666-6666 |
  | Jos�     | 3333-3333 |
  +----------+-----------+
  Query OK, 10 rows in set (1,14 sec)
*/
--
-- 3. Mostrar somente um dos telefones
--
select *
from ligacoes;
/*
  +----+----------+-----------+-------+--------+
  | id | operador | telefone  | custo | status |
  +----+----------+-----------+-------+--------+
  |  1 | Jo�o     | 2222-2222 |    10 | ok     |
  |  2 | Maria    | 3333-3333 |   4,3 | na     |
  |  3 | Jo�o     | 4444-4444 |     5 | ok     |
  |  4 | Jo�o     | 5555-5555 |     7 | na     |
  |  5 | Maria    | 3333-3333 |   7,5 | sc     |
  |  6 | Jos�     | 6666-6666 |     8 | fax    |
  |  7 | Jos�     | 3333-3333 |     6 | sc     |
  |  8 | Sandra   | 4444-4444 |   6,5 | fax    |
  |  9 | Jo�o     | 2222-2222 |   6,5 | ne     |
  | 10 | Sandra   | 3333-3333 |   6,5 | ne     |
  +----+----------+-----------+-------+--------+
  Query OK, 10 rows in set (1,84 sec)
*/
  select operador,max(telefone)
  from ligacoes
  group by operador;
/*
  +----------+-----------+
  | operador | max       |
  +----------+-----------+
  | Jos�     | 6666-6666 |
  | Jo�o     | 5555-5555 |
  | Maria    | 3333-3333 |
  | Sandra   | 4444-4444 |
  +----------+-----------+
  Query OK, 4 rows in set (0,70 sec
*/
--
-- 4. Mostrar o total de liga��es
--
  select count(*)
  from ligacoes;
/*
  +-------+
  | count |
  +-------+
  | 10    |
  +-------+
  Query OK, 1 rows in set (0,75 sec)
*/
--
-- 5. Mostrar custo_minimo, custo_maximo,custo_contagem, custo_soma e custo_media
--
  select
  min(custo) as custo_minimo,
  max(custo) as custo_maximo,
  count(custo) as custo_contagem,
  sum(custo) as custo_soma,
  avg(custo) as custo_media
  from ligacoes;
/*
  +--------------+--------------+----------------+------------+-------------+
  | custo_minimo | custo_maximo | custo_contagem | custo_soma | custo_media |
  +--------------+--------------+----------------+------------+-------------+
  |          4,3 |           10 | 10             |       67,3 |        6,73 |
  +--------------+--------------+----------------+------------+-------------+
  Query OK, 1 rows in set (0,77 sec)
*/
--
-- 6. Mostrar o registro completo do custo maior
--
  select *
  from ligacoes
  where custo = (select max(custo) from ligacoes);
/*
  +----+----------+-----------+-------+--------+
  | id | operador | telefone  | custo | status |
  +----+----------+-----------+-------+--------+
  |  1 | Jo�o     | 2222-2222 |    10 | ok     |
  +----+----------+-----------+-------+--------+
  Query OK, 1 rows in set (0,26 sec)
*/
--
-- 7. Exibir o registro inteiro de pessoas com custo
-- entre 6 e 8
   select *
   from ligacoes
   where id in (select id from ligacoes where custo between 6 and 8);
/*
  +----+----------+-----------+-------+--------+
  | id | operador | telefone  | custo | status |
  +----+----------+-----------+-------+--------+
  |  4 | Jo�o     | 5555-5555 |     7 | na     |
  |  5 | Maria    | 3333-3333 |   7,5 | sc     |
  |  6 | Jos�     | 6666-6666 |     8 | fax    |
  |  7 | Jos�     | 3333-3333 |     6 | sc     |
  |  8 | Sandra   | 4444-4444 |   6,5 | fax    |
  |  9 | Jo�o     | 2222-2222 |   6,5 | ne     |
  | 10 | Sandra   | 3333-3333 |   6,5 | ne     |
  +----+----------+-----------+-------+--------+
  Query OK, 7 rows in set (0,25 sec)
*/
--
-- 8. Exibir status, porcentagem
--
/*
  x = CountGrupo * 100
      ----------------
      CountTotalLinhas
*/
select status, count(*)*100/(select count(*) from ligacoes) as porcentagem
from ligacoes
group by status;
/*
  +--------+-------------+
  | status | porcentagem |
  +--------+-------------+
  | fax    | 20          |
  | na     | 20          |
  | ne     | 20          |
  | ok     | 20          |
  | sc     | 20          |
  +--------+-------------+
  Query OK, 5 rows in set (0,12 sec)
*/

