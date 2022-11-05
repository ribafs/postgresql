/*
  Teoria dos Conjuntos
  
  union
  union all
  intersect
  except
*/
--
-- Tabela clientes01
--
create table clientes01(
                                id              serial          primary key,
                                nome            varchar(30)
);
--
-- Inserção de registros em clientes01
--
insert into clientes01(nome) values('Paulo');
insert into clientes01(nome) values('Elisangela');
insert into clientes01(nome) values('Andre');
insert into clientes01(nome) values('Michela');
insert into clientes01(nome) values('Rodrigo');
insert into clientes01(nome) values('Melissa');
--
-- Tabela clientes02
--
create table clientes02(
                                id              serial          primary key,
                                nome            varchar(30)
);
--
-- Inserção de registros em clientes02
--
insert into clientes02(nome) values('Paulo');
insert into clientes02(nome) values('Elisangela');
insert into clientes02(nome) values('Andre');
insert into clientes02(nome) values('Regina');
insert into clientes02(nome) values('Gilberto');
insert into clientes02(nome) values('Marta');
--
-- union
--
select * from clientes01
union
select * from clientes02
/*
  +----+------------+
  | id | nome       |
  +----+------------+
  |  1 | Paulo      |
  |  2 | Elisangela |
  |  3 | Andre      |
  |  4 | Michela    |
  |  4 | Regina     |
  |  5 | Gilberto   |
  |  5 | Rodrigo    |
  |  6 | Marta      |
  |  6 | Melissa    |
  +----+------------+
  Query OK, 9 rows in set (0,08 sec)
*/
select * from clientes01
union all
select * from clientes02
/*
  +----+------------+
  | id | nome       |
  +----+------------+
  |  1 | Paulo      |
  |  2 | Elisangela |
  |  3 | Andre      |
  |  4 | Michela    |
  |  5 | Rodrigo    |
  |  6 | Melissa    |
  |  1 | Paulo      |
  |  2 | Elisangela |
  |  3 | Andre      |
  |  4 | Regina     |
  |  5 | Gilberto   |
  |  6 | Marta      |
  +----+------------+
  Query OK, 12 rows in set (0,19 sec)
*/
select * from clientes01
intersect
select * from clientes02
/*
  +----+------------+
  | id | nome       |
  +----+------------+
  |  1 | Paulo      |
  |  2 | Elisangela |
  |  3 | Andre      |
  +----+------------+
  Query OK, 3 rows in set (0,15 sec)
*/
select * from clientes01
except
select * from clientes02
/*
  +----+---------+
  | id | nome    |
  +----+---------+
  |  4 | Michela |
  |  5 | Rodrigo |
  |  6 | Melissa |
  +----+---------+
  Query OK, 3 rows in set (0,91 sec)
*/
select * from clientes02
except
select * from clientes01
/*
  +----+----------+
  | id | nome     |
  +----+----------+
  |  4 | Regina   |
  |  5 | Gilberto |
  |  6 | Marta    |
  +----+----------+
  Query OK, 3 rows in set (0,09 sec)
*/
