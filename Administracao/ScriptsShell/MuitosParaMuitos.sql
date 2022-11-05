/*
  Exemplo de Relacionamento Muitos para Muitos

  Tabelas
         alunos = (id, nome) ;
         aulas = (id, materia) ;
         alunos_aulas = (id, fkaluno, fkaula) ;
*/
--
-- Tabela alunos
--
create table alunos(
                    id       serial           primary key ,
                    nome     varchar(30)
);
--
-- Tabela aulas
--
create table aulas(
                    id       serial           primary key ,
                    aula     varchar(30)
);
--
-- Tabela materias
--
create table alunos_aulas(
                             id         serial        primary key ,
                             fkaluno    int4 ,
                             fkaula     int4 ,
                             constraint alunos_alunos_aulas foreign key(fkaluno)
                                        references alunos(id)
                                        on delete restrict
                                        on update cascade,
                             constraint aulas_alunos_aulas foreign key(fkaula)
                                        references aulas(id)
                                        on delete restrict
                                        on update cascade
);
--
-- Inserindo alunos
--
insert into alunos(nome) values('Rodrigo Lopes de Oliveira');
insert into alunos(nome) values('Paulo Rogério de Oliveira');
insert into alunos(nome) values('Elisangela Almeida de Souza');
insert into alunos(nome) values('Melissa Oliveira Lopes');
insert into alunos(nome) values('Michela Tritapepe Mendes');
insert into alunos(nome) values('Mauro Fritz');
insert into alunos(nome) values('Valdir Cabral');
insert into alunos(nome) values('Alex Siqueira de Souza');
insert into alunos(nome) values('Andre Tritapepe de Souza');
insert into alunos(nome) values('Marcia Suzuki Sakura');
insert into alunos(nome) values('Magda Sakura Suzuki');
insert into alunos(nome) values('Nelson Mendes Siqueira');
insert into alunos(nome) values('Marta Almeida de Souza');
insert into alunos(nome) values('Regina Célia de Oliveira');
insert into alunos(nome) values('GilbertoBernardino');
insert into alunos(nome) values('Maria Silveira Castro');
insert into alunos(nome) values('Gerson Antunes Matos');
insert into alunos(nome) values('Fabio Ribeiro');
insert into alunos(nome) values('Marisa Monte');
insert into alunos(nome) values('Andrea Cristina Almodovar');
--
-- Inserindo aulas
--
insert into aulas(aula) values('Matemática');
insert into aulas(aula) values('Cálculo');
insert into aulas(aula) values('Estatística');
insert into aulas(aula) values('Lógica da Matemática');
insert into aulas(aula) values('Algebra Linear');
insert into aulas(aula) values('Linguagem de Programação');
insert into aulas(aula) values('Engenharia de Software');
insert into aulas(aula) values('Física');
insert into aulas(aula) values('Compiladores');
insert into aulas(aula) values('Banco de Dados');
--
-- Inserindo alunos_aulas
--
insert into alunos_aulas(fkaluno,fkaula) values(1,1);
insert into alunos_aulas(fkaluno,fkaula) values(1,2);
insert into alunos_aulas(fkaluno,fkaula) values(1,3);
insert into alunos_aulas(fkaluno,fkaula) values(1,4);
insert into alunos_aulas(fkaluno,fkaula) values(1,5);
insert into alunos_aulas(fkaluno,fkaula) values(1,6);
insert into alunos_aulas(fkaluno,fkaula) values(1,7);
insert into alunos_aulas(fkaluno,fkaula) values(1,8);
insert into alunos_aulas(fkaluno,fkaula) values(1,9);
insert into alunos_aulas(fkaluno,fkaula) values(1,10);

insert into alunos_aulas(fkaluno,fkaula) values(2,1);
insert into alunos_aulas(fkaluno,fkaula) values(2,2);
insert into alunos_aulas(fkaluno,fkaula) values(2,3);
insert into alunos_aulas(fkaluno,fkaula) values(2,4);
insert into alunos_aulas(fkaluno,fkaula) values(2,5);
insert into alunos_aulas(fkaluno,fkaula) values(2,6);
insert into alunos_aulas(fkaluno,fkaula) values(2,7);
insert into alunos_aulas(fkaluno,fkaula) values(2,8);
insert into alunos_aulas(fkaluno,fkaula) values(2,9);
insert into alunos_aulas(fkaluno,fkaula) values(2,10);

insert into alunos_aulas(fkaluno,fkaula) values(3,1);
insert into alunos_aulas(fkaluno,fkaula) values(3,2);
insert into alunos_aulas(fkaluno,fkaula) values(3,3);
insert into alunos_aulas(fkaluno,fkaula) values(3,4);
insert into alunos_aulas(fkaluno,fkaula) values(3,5);
insert into alunos_aulas(fkaluno,fkaula) values(3,6);
insert into alunos_aulas(fkaluno,fkaula) values(3,7);
insert into alunos_aulas(fkaluno,fkaula) values(3,8);
insert into alunos_aulas(fkaluno,fkaula) values(3,9);
insert into alunos_aulas(fkaluno,fkaula) values(3,10);

insert into alunos_aulas(fkaluno,fkaula) values(4,1);
insert into alunos_aulas(fkaluno,fkaula) values(4,2);
insert into alunos_aulas(fkaluno,fkaula) values(4,3);
insert into alunos_aulas(fkaluno,fkaula) values(4,4);
insert into alunos_aulas(fkaluno,fkaula) values(4,5);
insert into alunos_aulas(fkaluno,fkaula) values(4,6);
insert into alunos_aulas(fkaluno,fkaula) values(4,7);
insert into alunos_aulas(fkaluno,fkaula) values(4,8);
insert into alunos_aulas(fkaluno,fkaula) values(4,9);
insert into alunos_aulas(fkaluno,fkaula) values(4,10);

insert into alunos_aulas(fkaluno,fkaula) values(5,1);
insert into alunos_aulas(fkaluno,fkaula) values(5,2);
insert into alunos_aulas(fkaluno,fkaula) values(5,3);
insert into alunos_aulas(fkaluno,fkaula) values(5,4);
insert into alunos_aulas(fkaluno,fkaula) values(5,5);
insert into alunos_aulas(fkaluno,fkaula) values(5,6);
insert into alunos_aulas(fkaluno,fkaula) values(5,7);
insert into alunos_aulas(fkaluno,fkaula) values(5,8);
insert into alunos_aulas(fkaluno,fkaula) values(5,9);
insert into alunos_aulas(fkaluno,fkaula) values(5,10);

insert into alunos_aulas(fkaluno,fkaula) values(6,1);
insert into alunos_aulas(fkaluno,fkaula) values(6,2);
insert into alunos_aulas(fkaluno,fkaula) values(6,3);
insert into alunos_aulas(fkaluno,fkaula) values(6,4);
insert into alunos_aulas(fkaluno,fkaula) values(6,5);
insert into alunos_aulas(fkaluno,fkaula) values(6,6);
insert into alunos_aulas(fkaluno,fkaula) values(6,7);
insert into alunos_aulas(fkaluno,fkaula) values(6,8);
insert into alunos_aulas(fkaluno,fkaula) values(6,9);
insert into alunos_aulas(fkaluno,fkaula) values(6,10);

insert into alunos_aulas(fkaluno,fkaula) values(7,1);
insert into alunos_aulas(fkaluno,fkaula) values(7,2);
insert into alunos_aulas(fkaluno,fkaula) values(7,3);
insert into alunos_aulas(fkaluno,fkaula) values(7,4);
insert into alunos_aulas(fkaluno,fkaula) values(7,5);
insert into alunos_aulas(fkaluno,fkaula) values(7,6);
insert into alunos_aulas(fkaluno,fkaula) values(7,7);
insert into alunos_aulas(fkaluno,fkaula) values(7,8);
insert into alunos_aulas(fkaluno,fkaula) values(7,9);
insert into alunos_aulas(fkaluno,fkaula) values(7,10);

insert into alunos_aulas(fkaluno,fkaula) values(8,1);
insert into alunos_aulas(fkaluno,fkaula) values(8,2);
insert into alunos_aulas(fkaluno,fkaula) values(8,3);
insert into alunos_aulas(fkaluno,fkaula) values(8,4);
insert into alunos_aulas(fkaluno,fkaula) values(8,5);
insert into alunos_aulas(fkaluno,fkaula) values(8,6);
insert into alunos_aulas(fkaluno,fkaula) values(8,7);
insert into alunos_aulas(fkaluno,fkaula) values(8,8);
insert into alunos_aulas(fkaluno,fkaula) values(8,9);
insert into alunos_aulas(fkaluno,fkaula) values(8,10);

insert into alunos_aulas(fkaluno,fkaula) values(9,1);
insert into alunos_aulas(fkaluno,fkaula) values(9,2);
insert into alunos_aulas(fkaluno,fkaula) values(9,3);
insert into alunos_aulas(fkaluno,fkaula) values(9,4);
insert into alunos_aulas(fkaluno,fkaula) values(9,5);
insert into alunos_aulas(fkaluno,fkaula) values(9,6);
insert into alunos_aulas(fkaluno,fkaula) values(9,7);
insert into alunos_aulas(fkaluno,fkaula) values(9,8);
insert into alunos_aulas(fkaluno,fkaula) values(9,9);
insert into alunos_aulas(fkaluno,fkaula) values(9,10);

insert into alunos_aulas(fkaluno,fkaula) values(10,1);
insert into alunos_aulas(fkaluno,fkaula) values(10,2);
insert into alunos_aulas(fkaluno,fkaula) values(10,3);
insert into alunos_aulas(fkaluno,fkaula) values(10,4);
insert into alunos_aulas(fkaluno,fkaula) values(10,5);
insert into alunos_aulas(fkaluno,fkaula) values(10,6);
insert into alunos_aulas(fkaluno,fkaula) values(10,7);
insert into alunos_aulas(fkaluno,fkaula) values(10,8);
insert into alunos_aulas(fkaluno,fkaula) values(10,9);
insert into alunos_aulas(fkaluno,fkaula) values(10,10);

insert into alunos_aulas(fkaluno,fkaula) values(11,1);
insert into alunos_aulas(fkaluno,fkaula) values(11,2);
insert into alunos_aulas(fkaluno,fkaula) values(11,3);
insert into alunos_aulas(fkaluno,fkaula) values(11,4);
insert into alunos_aulas(fkaluno,fkaula) values(11,5);
insert into alunos_aulas(fkaluno,fkaula) values(11,6);
insert into alunos_aulas(fkaluno,fkaula) values(11,7);
insert into alunos_aulas(fkaluno,fkaula) values(11,8);
insert into alunos_aulas(fkaluno,fkaula) values(11,9);
insert into alunos_aulas(fkaluno,fkaula) values(11,10);

insert into alunos_aulas(fkaluno,fkaula) values(12,1);
insert into alunos_aulas(fkaluno,fkaula) values(12,2);
insert into alunos_aulas(fkaluno,fkaula) values(12,3);
insert into alunos_aulas(fkaluno,fkaula) values(12,4);
insert into alunos_aulas(fkaluno,fkaula) values(12,5);
insert into alunos_aulas(fkaluno,fkaula) values(12,6);
insert into alunos_aulas(fkaluno,fkaula) values(12,7);
insert into alunos_aulas(fkaluno,fkaula) values(12,8);
insert into alunos_aulas(fkaluno,fkaula) values(12,9);
insert into alunos_aulas(fkaluno,fkaula) values(12,10);

insert into alunos_aulas(fkaluno,fkaula) values(13,1);
insert into alunos_aulas(fkaluno,fkaula) values(13,2);
insert into alunos_aulas(fkaluno,fkaula) values(13,3);
insert into alunos_aulas(fkaluno,fkaula) values(13,4);
insert into alunos_aulas(fkaluno,fkaula) values(13,5);
insert into alunos_aulas(fkaluno,fkaula) values(13,6);
insert into alunos_aulas(fkaluno,fkaula) values(13,7);
insert into alunos_aulas(fkaluno,fkaula) values(13,8);
insert into alunos_aulas(fkaluno,fkaula) values(13,9);
insert into alunos_aulas(fkaluno,fkaula) values(13,10);

insert into alunos_aulas(fkaluno,fkaula) values(14,1);
insert into alunos_aulas(fkaluno,fkaula) values(14,2);
insert into alunos_aulas(fkaluno,fkaula) values(14,3);
insert into alunos_aulas(fkaluno,fkaula) values(14,4);
insert into alunos_aulas(fkaluno,fkaula) values(14,5);
insert into alunos_aulas(fkaluno,fkaula) values(14,6);
insert into alunos_aulas(fkaluno,fkaula) values(14,7);
insert into alunos_aulas(fkaluno,fkaula) values(14,8);
insert into alunos_aulas(fkaluno,fkaula) values(14,9);
insert into alunos_aulas(fkaluno,fkaula) values(14,10);

insert into alunos_aulas(fkaluno,fkaula) values(15,1);
insert into alunos_aulas(fkaluno,fkaula) values(15,2);
insert into alunos_aulas(fkaluno,fkaula) values(15,3);
insert into alunos_aulas(fkaluno,fkaula) values(15,4);
insert into alunos_aulas(fkaluno,fkaula) values(15,5);
insert into alunos_aulas(fkaluno,fkaula) values(15,6);
insert into alunos_aulas(fkaluno,fkaula) values(15,7);
insert into alunos_aulas(fkaluno,fkaula) values(15,8);
insert into alunos_aulas(fkaluno,fkaula) values(15,9);
insert into alunos_aulas(fkaluno,fkaula) values(15,10);

insert into alunos_aulas(fkaluno,fkaula) values(16,1);
insert into alunos_aulas(fkaluno,fkaula) values(16,2);
insert into alunos_aulas(fkaluno,fkaula) values(16,3);
insert into alunos_aulas(fkaluno,fkaula) values(16,4);
insert into alunos_aulas(fkaluno,fkaula) values(16,5);
insert into alunos_aulas(fkaluno,fkaula) values(16,6);
insert into alunos_aulas(fkaluno,fkaula) values(16,7);
insert into alunos_aulas(fkaluno,fkaula) values(16,8);
insert into alunos_aulas(fkaluno,fkaula) values(16,9);
insert into alunos_aulas(fkaluno,fkaula) values(16,10);

insert into alunos_aulas(fkaluno,fkaula) values(17,1);
insert into alunos_aulas(fkaluno,fkaula) values(17,2);
insert into alunos_aulas(fkaluno,fkaula) values(17,3);
insert into alunos_aulas(fkaluno,fkaula) values(17,4);
insert into alunos_aulas(fkaluno,fkaula) values(17,5);
insert into alunos_aulas(fkaluno,fkaula) values(17,6);
insert into alunos_aulas(fkaluno,fkaula) values(17,7);
insert into alunos_aulas(fkaluno,fkaula) values(17,8);
insert into alunos_aulas(fkaluno,fkaula) values(17,9);
insert into alunos_aulas(fkaluno,fkaula) values(17,10);

insert into alunos_aulas(fkaluno,fkaula) values(18,1);
insert into alunos_aulas(fkaluno,fkaula) values(18,2);
insert into alunos_aulas(fkaluno,fkaula) values(18,3);
insert into alunos_aulas(fkaluno,fkaula) values(18,4);
insert into alunos_aulas(fkaluno,fkaula) values(18,5);
insert into alunos_aulas(fkaluno,fkaula) values(18,6);
insert into alunos_aulas(fkaluno,fkaula) values(18,7);
insert into alunos_aulas(fkaluno,fkaula) values(18,8);
insert into alunos_aulas(fkaluno,fkaula) values(18,9);
insert into alunos_aulas(fkaluno,fkaula) values(18,10);

insert into alunos_aulas(fkaluno,fkaula) values(19,1);
insert into alunos_aulas(fkaluno,fkaula) values(19,2);
insert into alunos_aulas(fkaluno,fkaula) values(19,3);
insert into alunos_aulas(fkaluno,fkaula) values(19,4);
insert into alunos_aulas(fkaluno,fkaula) values(19,5);
insert into alunos_aulas(fkaluno,fkaula) values(19,6);
insert into alunos_aulas(fkaluno,fkaula) values(19,7);
insert into alunos_aulas(fkaluno,fkaula) values(19,8);
insert into alunos_aulas(fkaluno,fkaula) values(19,9);
insert into alunos_aulas(fkaluno,fkaula) values(19,10);

insert into alunos_aulas(fkaluno,fkaula) values(20,1);
insert into alunos_aulas(fkaluno,fkaula) values(20,2);
insert into alunos_aulas(fkaluno,fkaula) values(20,3);
insert into alunos_aulas(fkaluno,fkaula) values(20,4);
insert into alunos_aulas(fkaluno,fkaula) values(20,5);
insert into alunos_aulas(fkaluno,fkaula) values(20,6);
insert into alunos_aulas(fkaluno,fkaula) values(20,7);
insert into alunos_aulas(fkaluno,fkaula) values(20,8);
insert into alunos_aulas(fkaluno,fkaula) values(20,9);
insert into alunos_aulas(fkaluno,fkaula) values(20,10);
--
-- 1. Selecionar os nomes dos alunos
--    e as aulas que eles frequentam
--
  select
  (select alunos.nome from alunos where alunos.id = alunos_aulas.fkaluno),
  (select aulas.aula from aulas where aulas.id = alunos_aulas.fkaula)
  from alunos_aulas;
/*
  Tempo decorrido em um Pentium III de 1 ghz
  Memória RAM 392 = 23,29  seg
*/
  select alunos.nome,aulas.aula
  from alunos
  inner join alunos_aulas on alunos.id = alunos_aulas.fkaluno
  inner join aulas on aulas.id = alunos_aulas.fkaula;
/*
  Tempo decorrido em um Pentium III de 1 ghz
  Memória RAM 392 = 18,56 seg
*/
--
-- 2. Selecionar todas as aulas e quantos
--    alunos as frequentam
--
select aulas.aula,count(alunos_aulas.fkaluno)
from aulas
inner join alunos_aulas on aulas.id = alunos_aulas.fkaula
group by aulas.aula;
/*
  +--------------------------+-------+
  | aula                     | count |
  +--------------------------+-------+
  | Algebra Linear           | 20    |
  | Banco de Dados           | 20    |
  | Compiladores             | 20    |
  | Cálculo                  | 20    |
  | Engenharia de Software   | 20    |
  | Estatística              | 20    |
  | Física                   | 20    |
  | Linguagem de Programação | 20    |
  | Lógica da Matemática     | 20    |
  | Matemática               | 20    |
  +--------------------------+-------+
  Query OK, 10 rows in set (0,14 sec)
*/
