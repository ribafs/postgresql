Cenário atual:

Aproveitando o modelo de pessoa, vamos normalizar uma tabela de CEPs.

Tenho um arquivo CSV de ceps do tempo que os Correios distribiam gratuitamente em seu site, contendo
633.401 registros.
Agora vou usá-lo como exercício de normalização e tentar reaproveitar seus dados.

Esta tabela, ou melhor, após a normalização, serão algumas tabelas que poderão ser utilizadas
num cadastro de pessoas.

su - postgres

psql

create database cep encoding 'latin1'; 
Latin1 é para compatibilizar com conteúdo da tabela ceps.
Pois o recomendado atualmente é a codificação UNICODE. Em um banco com codificação
latin1 (iso-8859-1) tente representar por exemplo, o símbolo do euro (€).
Não consegue, pois é outra codificação, portanto sempre que possível devemos usar UTF-8.

Para comprovar crie essa tabela, num banco em latin1:
create table codificacao(c char(1))

Tente inserir este registro:
insert into codificacao values ('€')

E receberá a mensagem:
ERRO:  caracter 0xe282ac da codificação "UTF8" nÃ£o tem equivalente em "LATIN1"


Tabela de CEPs original:

create table ceps 
(
	cep char(8), 
	tipo char(72), 
	logradouro char(70),
	bairro char(72),
	municipio char(60), 
	uf char(2)
);

Importar dados (script em: http://pg.ribafs.net/down/scripts//cep.sql.zip)
\copy ceps from /home/ribafs/cep_brasil.csv


Adicionar PK
alter table ceps add constraint cep_pk primary key(cep);


Tabela municipios

create sequence municipio_seq;
create table municipios as select distinct(municipio), uf from ceps order by uf;
alter table municipios rename column municipio to descricao;
alter table municipios add column municipio int;
update municipios set municipio=nextval('municipio_seq');
alter table municipios add constraint municipio_pk primary key(municipio);
alter table municipios add constraint municipio_unk unique(descricao);

municipios(descricao, uf, municipio)


Tabela bairros

create sequence bairro_seq;
create table bairros as select distinct(bairro) from ceps order by bairro;
alter table bairros rename column bairro to descricao;
alter table bairros add column bairro int;
update bairros set bairro=nextval('bairro_seq');
alter table bairros add constraint bairro_pk primary key(bairro);
alter table bairros add constraint bairro_unk unique(descricao);

bairros(descricao, bairro)


Tabela logradouros

create sequence logradouro_seq;
create table logradouros as select distinct(logradouro) from ceps order by logradouro;
alter table logradouros rename column logradouro to descricao;
alter table logradouros add column logradouro int;
update logradouros set logradouro=nextval('logradouro_seq');
alter table logradouros add constraint logradouro_pk primary key(logradouro);
alter table logradouros add constraint logradouro_unk unique(descricao);

logradouros(descricao, logradouro)


Tabela tipos

create sequence tipo_seq;
create table tipos as select distinct(tipo) from ceps order by tipo;
alter table tipos rename column tipo to descricao;
alter table tipos add column tipo int;
update tipos set tipo=nextval('tipo_seq');
alter table tipos add constraint tipo_pk primary key(tipo);
alter table tipos add constraint tipo_unk unique(descricao);

tipos(descricao, tipo)


Tabela ceps normalizada

create table cepsn
(
	cep char(8) not null,
	tipo int, 
	logradouro int,
	bairro int,
	municipio int,
	primary key(cep, logradour), 
	constraint tipo_fk foreign key (tipo) references tipos(tipo),
	constraint logradouro_fk foreign key (logradouro) references logradouros(logradouro),
	constraint bairro_fk foreign key (bairro) references bairros(bairro),
	constraint municipio_fk foreign key (municipio) references municipios(municipio)
);

-- Como atualmente podem existir mais de um CEP por logradouro, então CEP não pode ser a PK, 
-- portanto teremos uma chave natural formada pelo CEP e pelo logradouro

Criar assim:

create table cepsn as select distinct(cep) from ceps
alter table cepsn add column tipo int;
alter table cepsn add column logradouro int;
alter table cepsn add column bairro int;
alter table cepsn add column municipio int;
alter table cepsn add constraint tipo_fk foreign key (tipo) references tipos(tipo);
alter table cepsn add constraint logradouro_fk foreign key (logradouro) references logradouros(logradouro);
alter table cepsn add constraint bairro_fk foreign key (bairro) references bairros(bairro);
alter table cepsn add constraint municipio_fk foreign key (municipio) references municipios(municipio);


Agora vamos popular a tabela cepsn com os registros da tabela ceps.
Veja que não é somente importar todos os tipos da tabela tipos para o campo tipo de cepsn.
Temos que trazer os tipos corretos de todos os 644 mil registros. Cada um com seu tipo correspondente.
Postanto não será uma tarefa simples nem direta. Exigirá um pouco de conhecimento da linguagem SQL.

Quando não temos ceerteza se a nossa consulta é coerente e que poderá demorar muito, então ajuda muito
consultar o PostgreSQL como ele faria essa consulta.
Execute a consulta com o EXPLAIN que ele vai dar uma dica, em espacial os valores do custo final e rows.

CEPs - 633401
Tipos - 189
Logradouros - 316499
Bairros - 16766
Municípios - 346

Atualizar tipo em cepsn com o valor tipo de tipos, mas correspondentes aos de ceps

Agora para receber os valores do campo tipo tenho que pensar assim:
tomar de cepsn o cep e testar se igual ao cep de ceps
Ainda pegar neste cep o valor do tipo em ceps e testar se é igual ao valor da descricao em tipos.
Então trazer o resultado. A consulta abaixo faz isso:

update cepsn cn set tipo = (select t.tipo from ceps c,tipos t where cn.cep = c.cep and c.tipo = t.descricao);

update cepsn cn set logradouro = (select l.logradouro from ceps c,logradouros l where cn.cep = c.cep and c.logradouro = l.descricao);
	Esta demora exageradamente.

Usei apenas:
update cepsn cn set logradouro = (select l.logradouro from ceps c,logradouros l where cn.cep = c.cep 
	and c.logradouro = l.descricao and l.logradouro >= 305372 and l.logradouro <=305375);

Custo total: 10.609.291,16 Tempo: 41.419 ms

update cepsn cn set bairro = (select b.bairro from ceps c,bairros b where cn.cep = c.cep and c.bairro = b.descricao);
Usei somente:
update cepsn cn set bairro = (select b.bairro from ceps c,bairros b where cn.cep = c.cep and c.bairro = b.descricao
	and b.bairro < 9110 and b.bairro >9101);

update cepsn cn set municipio = (select m.municipio from ceps c,municipios m where cn.cep = c.cep and c.municipio = m.descricao);
Usei somente:
update cepsn cn set municipio = (select m.municipio from ceps c,municipios m where cn.cep = c.cep 
	and c.municipio = m.descricao and m.uf='CE');

Obs.: só para ter uma idéia, o tempo desta consulta foi de 133.330ms e o curto total acusado pelo Explain era de 14.417.399.32 e 
rows 633401 (total)

Agora, finalmente uma consulta de CEP na tabela normalizada
select cep, t.descricao, l.descricao, b.descricao, m.descricao, m.uf from cepsn c, tipos t, 
	logradouros l, bairros b, municipios m where c.cep='60420440' and t.tipo=c.tipo and l.logradouro=c.logradouro
	and b.bairro=c.bairro and m.municipio=c.municipio;

Alterei a tabela cepsn adicionando índice único nos campos: tipo, bairro, logradouro e municipio:
CREATE UNIQUE INDEX unq_tipo ON pepsn (tipo);

Consultas úteis:
select * from municipios group by uf,municipio,descricao having count(municipio) = 1 order by uf,descricao;
select count(municipio) from municipios group by uf having count(municipio)>1 and uf='CE';

Cuidado com operadores boolean:
select * from municipios where uf='SP' and uf='DF' order by descricao;  -- Nada retorna
select * from municipios where uf='SP' or uf='DF' order by descricao; -- esta retorna

