-- Criacao dos grupos
CREATE GROUP adm;
CREATE GROUP dba;
CREATE GROUP mkt;

CREATE USER paulo ENCRYPTED PASSWORD 'paulo' CREATEDB CREATEUSER;

-- Criacao dos Usuarios do Grupo adm
CREATE USER andre ENCRYPTED PASSWORD 'andre' CREATEDB IN GROUP adm;
CREATE USER michela ENCRYPTED PASSWORD 'michela' CREATEDB IN GROUP adm;

-- Criacao dos Usuarios do Grupo dba
CREATE USER roger ENCRYPTED PASSWORD 'roger' CREATEDB IN GROUP dba;
CREATE USER elisangela ENCRYPTED PASSWORD 'elisangela' CREATEDB IN GROUP dba;

-- Criacao dos Usuarios do Grupo mkt
CREATE USER rodrigo ENCRYPTED PASSWORD 'rodrigo' CREATEDB IN GROUP mkt;
CREATE USER melissa ENCRYPTED PASSWORD 'melissa' CREATEDB IN GROUP mkt;

-- Esquemas para Usuarios
CREATE SCHEMA postgres AUTHORIZATION postgres;
CREATE SCHEMA paulo AUTHORIZATION paulo;
CREATE SCHEMA roger AUTHORIZATION roger;
CREATE SCHEMA elisangela AUTHORIZATION elisangela;
CREATE SCHEMA rodrigo AUTHORIZATION rodrigo;
CREATE SCHEMA melissa AUTHORIZATION melissa;
CREATE SCHEMA andre AUTHORIZATION andre;
CREATE SCHEMA michela AUTHORIZATION michela;
-- ==========================================================================================================
-- Esquema postgres
--

--
-- Criando a tabela postgres.empresas
--
CREATE TABLE postgres.empresas(
			id 		SERIAL 		PRIMARY KEY,
			nome 		VARCHAR(50),
			dtcadastro 	DATE,
			telcom 		VARCHAR(20),
			site 		VARCHAR(40),
			email 		VARCHAR(40),
			saldo		NUMERIC(12,2)	DEFAULT 0,
			obs             TEXT
);
--
--
-- Criando a tabela postgres.clientes
--
CREATE TABLE postgres.clientes(
			id 		SERIAL 		PRIMARY KEY,
			fkempresa 	INTEGER,
			nome 		VARCHAR(50),
			dtnascimento 	DATE,
			telres 		VARCHAR(20),
			site 		VARCHAR(40),
			email 		VARCHAR(40),
			saldo		NUMERIC(12,2)	DEFAULT 0,
			obs             TEXT,
			CONSTRAINT postgres_empresas_clientes FOREIGN KEY(fkempresa)
							REFERENCES postgres.empresas(id)
							ON DELETE RESTRICT
							ON UPDATE CASCADE
					
);
--
--
-- Criando a tabela postgres.contas
--
CREATE TABLE postgres.contas(
			id 		SERIAL 		PRIMARY KEY,
			fkcliente 	INTEGER,
			nome 		VARCHAR(50),
			dtabertura	DATE,
			saldo		NUMERIC(12,2)	DEFAULT 0,
			CONSTRAINT postgres_clientes_contas FOREIGN KEY(fkcliente)
							REFERENCES postgres.clientes(id)
							ON DELETE RESTRICT
							ON UPDATE CASCADE
);
--
--
-- Criando a TABLE a postgres.movimentos
--
CREATE TABLE postgres.movimentos(
			id 		SERIAL 		PRIMARY KEY,
			fkconta 	INTEGER,
			historico 	VARCHAR(50),
			credito 	NUMERIC(11,2)	DEFAULT 0,
			debito 		NUMERIC(11,2)	DEFAULT 0,
			CONSTRAINT postgres_contas_movimentos FOREIGN KEY(fkconta)
							REFERENCES postgres.contas(id)
							ON DELETE RESTRICT
							ON UPDATE CASCADE
);
--
--
-- Criando a tabela movempresas
--
CREATE TABLE postgres.movempresas(
			id 		SERIAL 		PRIMARY KEY,
			fkempresa 	INTEGER,
			historico 	VARCHAR(50),
			credito 	NUMERIC(11,2)	DEFAULT 0,
			debito 		NUMERIC(11,2)	DEFAULT 0,
			CONSTRAINT postgres_empresas_movempresas FOREIGN KEY(fkempresa)
							REFERENCES postgres.empresas(id)
							ON DELETE RESTRICT
							ON UPDATE CASCADE
);
--
--
-- Criando a tabela precos
--
CREATE TABLE postgres.precos(
                        id           SERIAL PRIMARY KEY,
                        produto      VARCHAR(30),
                        valor        NUMERIC(11,2), 	
                        data_ins     TIMESTAMP,
                        user_ins     TEXT,
                        data_atu     TIMESTAMP,
                        user_atu     TEXT
);
--
--
-- Criando a tabela precos_log_del
--
CREATE TABLE postgres.precos_log_del(
                        id           INTEGER,
                        produto      VARCHAR(30),
                        valor        NUMERIC(11,2), 	
                        data_ins     TIMESTAMP,
                        user_ins     TEXT,
                        data_atu     TIMESTAMP,
                        user_atu     TEXT,
                        data_del     TIMESTAMP,
                        user_del     TEXT
);
--
--
-- Inserindo registros na tabela postgres.empresas
--
INSERT INTO postgres.empresas(nome,dtcadastro,telcom,site,email) VALUES('MundoByte Informatica',	'1995-11-11',	'222-0909',	'www.mundobyte.com.br',	'relacoes@mundobyte.com.br');
INSERT INTO postgres.empresas(nome,dtcadastro,telcom,site,email) VALUES('TecTel - informatica',	'1995-01-09',	'333-0909',	'www.tectel.com.br',	'info@tectel.com.br');
INSERT INTO postgres.empresas(nome,dtcadastro,telcom,site,email) VALUES('Vulcano S/A',		'2002-10-31',	'211-0909',	'www.vulcano.com.br',	'informacoes@vulcano.com.br');
INSERT INTO postgres.empresas(nome,dtcadastro,telcom,site,email) VALUES('Softmax',		'2000-10-05',	'211-0909',	'www.vulcano.com.br',	'softmax@softmax.com.br');
--
--
-- Inserindo registros na tabela postgres.clientes
--
INSERT INTO postgres.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(1,	'Rodrigo de Oliveira Silva',		'1973-12-12',	'3434-0909',	' ',			'rodrigo@ig.com.br');
INSERT INTO postgres.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(2,	'Melissa Pereira da Silva',		'1970-01-04',	'4444-0011',	'www.mwbrasil.com.br ',	'rose@ig.com.br');
INSERT INTO postgres.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(2,	'Elisangela Almeida de Oliveira',	'1973-10-31',	'3434-7879',	' ',			'eli@brfree.com.br');
INSERT INTO postgres.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(3,	'Andre Tritapepe de Matias',		'1973-12-31',	'3434-8596',	' ',			'andre@trita.com.br');
INSERT INTO postgres.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(3,	'Michela Almeida de Alcantara',		'1980-04-01',	'8888-0101',	' ',			'michela@psico.com.br');
INSERT INTO postgres.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(3,	'Paulo Rogerio de Oliveira',		'1973-10-11',	'7777-0405',	'www.proger.com',	'paulo@proger.com.br');
INSERT INTO postgres.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(4,	'Cristina Pereira Matos',		'1970-10-11',	'2222-7885',	'www.santista.com',	'cristina@uol.com.br');
INSERT INTO postgres.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(4,	'Fabia Castilho Almeida',		'1981-10-11',	'4545-4596',	'www.castilho.com',	'fabia@terra.com.br');
INSERT INTO postgres.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(4,	'postgres Cristovao Santos',		'1980-10-11',	'2202-7272',	'',			'postgres@terra.com.br');
INSERT INTO postgres.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(4,	'postgressa Santos Matias',		'1990-10-11',	'1010-1396',	'',			'postgressa@brfree.com.br');
--
--
-- Inserindo registros na tabela postgres.contas
--
INSERT INTO postgres.contas(fkcliente,nome,dtabertura) VALUES(1,'semana01','2002-10-01');
INSERT INTO postgres.contas(fkcliente,nome,dtabertura) VALUES(2,'semana02','2002-10-20');
INSERT INTO postgres.contas(fkcliente,nome,dtabertura) VALUES(2,'semana03','2002-09-10');
INSERT INTO postgres.contas(fkcliente,nome,dtabertura) VALUES(3,'semana04','2002-09-03');
INSERT INTO postgres.contas(fkcliente,nome,dtabertura) VALUES(3,'semana05','2002-01-01');
INSERT INTO postgres.contas(fkcliente,nome,dtabertura) VALUES(3,'semana06','2002-02-15');
INSERT INTO postgres.contas(fkcliente,nome,dtabertura) VALUES(4,'semana07','2002-05-01');
INSERT INTO postgres.contas(fkcliente,nome,dtabertura) VALUES(4,'semana08','2002-06-09');
INSERT INTO postgres.contas(fkcliente,nome,dtabertura) VALUES(4,'semana09','2002-07-01');
INSERT INTO postgres.contas(fkcliente,nome,dtabertura) VALUES(4,'semana10','2002-10-11');
INSERT INTO postgres.contas(fkcliente,nome,dtabertura) VALUES(5,'semana11','2002-10-10');
INSERT INTO postgres.contas(fkcliente,nome,dtabertura) VALUES(5,'semana12','2002-10-01');
INSERT INTO postgres.contas(fkcliente,nome,dtabertura) VALUES(5,'semana13','2002-07-20');
INSERT INTO postgres.contas(fkcliente,nome,dtabertura) VALUES(5,'semana14','2002-06-01');
INSERT INTO postgres.contas(fkcliente,nome,dtabertura) VALUES(5,'semana15','2002-05-07');
INSERT INTO postgres.contas(fkcliente,nome,dtabertura) VALUES(6,'semana16','2002-02-01');
INSERT INTO postgres.contas(fkcliente,nome,dtabertura) VALUES(6,'semana17','2002-01-08');
INSERT INTO postgres.contas(fkcliente,nome,dtabertura) VALUES(6,'semana18','2002-09-01');
INSERT INTO postgres.contas(fkcliente,nome,dtabertura) VALUES(6,'semana19','2002-09-04');
INSERT INTO postgres.contas(fkcliente,nome,dtabertura) VALUES(6,'semana20','2002-10-28');
INSERT INTO postgres.contas(fkcliente,nome,dtabertura) VALUES(6,'semana21','2002-10-28');
--
--
-- Inserindo registros na tabela postgres.movimentos
--
-- postgres.movimentos da conta 1
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(1,'salario',2000,0);
-- postgres.movimentos da conta 2
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(2,'vendas',50000,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(2,'luz',0,200);
-- postgres.movimentos da conta 3
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(3,'vendas',0,2000);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(3,'combustivel',5000,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(3,'luz',0,200);
-- postgres.movimentos da conta 4
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(4,'combustivel',500,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(4,'luz',0,200);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(4,'vendas',0,2000);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(4,'combustivel',10,0);
-- postgres.movimentos da conta 5
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(5,'combustivel',100,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(5,'luz',0,200);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(5,'combustivel',50,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(5,'vendas',0,2000);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(5,'combustivel',30,0);
-- postgres.movimentos da conta 6
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(6,'luz',0,200);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(6,'vendas',0,3000);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(6,'combustivel',10,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(6,'vendas',0,200);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(6,'combustivel',10,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(6,'luz',0,200);
-- postgres.movimentos da conta 7
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(7,'combustivel',700,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(7,'vendas',0,10000);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(7,'combustivel',500,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(7,'combustivel',30,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(7,'vendas',0,20000);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(7,'combustivel',90,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(7,'luz',0,200);
-- postgres.movimentos da conta 8
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(8,'combustivel',900,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(8,'vendas',0,3000);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(8,'combustivel',300,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(8,'combustivel',300,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(8,'vendas',0,5000);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(8,'luz',0,200);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(8,'luz',0,200);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(8,'combustivel',10,0);
-- postgres.movimentos da conta 9
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(9,'combustivel',400,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(9,'vendas',0,7000);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(9,'combustivel',10,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(9,'combustivel',10,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(9,'combustivel',100,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(9,'vendas',0,6000);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(9,'vendas',0,4000);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(9,'combustivel',100,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(9,'luz',0,200);
-- postgres.movimentos da conta 10
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(10,'combustivel',300,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(10,'combustivel',40,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(10,'vendas',0,20);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(10,'combustivel',10,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(10,'combustivel',110,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(10,'luz',0,200);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(10,'combustivel',100,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(10,'combustivel',100,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(10,'vendas',0,2500);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(10,'vendas',0,2600);
-- postgres.movimentos da conta 11
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(11,'luz',0,50);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(11,'salario',5000,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(11,'manutencao',0,50000);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(11,'supermercado',0,3000);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(11,'manutencao',0,8000);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(11,'escritorio',0,5000);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(11,'carro',0,36000);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(11,'predio',0,60000);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(11,'vendas',7000,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(11,'luz',0,8000);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(11,'manutencao',0,4000);
-- postgres.movimentos da conta 12
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(12,'vendas',4000,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(12,'escritorio',0,50000);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(12,'manutencao',0,40000);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(12,'vendas',10000,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(12,'escritorio',0,70000);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(12,'manutencao',0,4000);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(12,'vendas',80000,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(12,'escritorio',0,20000);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(12,'manutencao',0,4000);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(12,'vendas',10000,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(12,'escritorio',0,5000);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(12,'manutencao',0,10000);
-- postgres.movimentos da conta 13
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
-- postgres.movimentos da conta 14
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',20000,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(14,'salario',8000,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',2000,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(14,'salario',5000,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',9000,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(14,'salario',6000,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',3000,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(14,'salario',9000,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',8000,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(14,'salario',7000,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',9000,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(14,'supermercado',0,5000);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',2000,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(14,'combustivel',9000,0);
-- postgres.movimentos da conta 15
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(15,'combustivel',0,2000);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(15,'combustivel',0,2000);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(15,'escritorio',0,2000);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(15,'escritorio',0,2000);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(15,'escritorio',0,2000);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
-- postgres.movimentos da conta 16
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas',5000,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas',5000,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas',5000,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas',5000,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas loja',5000,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas loja',5000,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas loja',5000,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(16,'suporte',5000,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(16,'suporte',5000,0);
-- postgres.movimentos da conta 17
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(17,'escritorio',0,500);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(17,'combustivel',0,500);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(17,'combustivel',0,500);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(17,'combustivel',0,500);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(17,'carro',0,500);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(17,'carro',0,500);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
-- postgres.movimentos da conta 18
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(18,'suporte',8000,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(18,'vendas loja',8000,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(18,'vendas loja',8000,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(18,'vendas loja',8000,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(18,'vendas loja',8000,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(18,'suporte',8000,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(18,'suporte',8000,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(18,'suporte',8000,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(18,'suporte',8000,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(18,'suporte',8000,0);
-- postgres.movimentos da conta 19
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(19,'caixa interno',0,500);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(19,'caixa interno',0,500);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(19,'caixa interno',0,500);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(19,'predio',0,500);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(19,'predio',0,500);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(19,'predio',0,500);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(19,'predio',0,500);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(19,'predio',0,500);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
-- postgres.movimentos da conta 20
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(20,'vendas',8000,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(20,'vendas',8000,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(20,'vendas',8000,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(20,'suporte ',8000,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(20,'suporte ',8000,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(20,'suporte ',8000,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(20,'suporte ',8000,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(20,'suporte ',8000,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(20,'vendas',8000,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(20,'vendas',8000,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(20,'vendas',8000,0);
-- postgres.movimentos da conta 21
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(21,'combustivel',0,50);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(21,'reforma',0,50);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(21,'manutencao',0,50);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(21,'combustivel',0,50);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(21,'salario',0,50);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(21,'salario',0,50);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(21,'reforma',0,50);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(21,'reforma',0,50);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO postgres.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
--
--
-- Funcoes em SQL e PL/PGSQL
--
-- ================================================================================================================
-- Funcoes em SQL
--
-- Crie uma funcao onde passamos um valor inteiro e retorne ele mais 1
--
create function soma1sql(integer) returns integer as
'
       select  $1 + 1
'
language 'sql';
--
-- ================================================================================================================
-- Monte uma função que mostre a quantidade de clientes em uma empresa
-- deverá ser passado o codigo da empresa como parametro.
--
create function qtd_clientes_empresas(integer) returns bigint as
'
       select count(*) from clientes where fkempresa = $1
'
language 'sql';
--
-- ================================================================================================================
-- Monte uma função que mostre a quantidade de contas por clientes
--
create or replace function Contas_Clientes(integer) returns bigint as
'
       select count(*) from contas where fkcliente = $1
'
language 'sql';
--
-- ================================================================================================================
-- Crie uma função para inserir ao mesmo tempo o  nome da empresa e o nome 	
-- de um cliente retornando o id da empresa.
--
create or replace function empresa_cliente(varchar,varchar) returns bigint as
'
       insert into empresas(nome) values($1);
       insert into clientes(fkempresa,nome) 	values(currval(''empresas_id_seq''),$2);
       select currval(''empresas_id_seq'') as id_empresa
'
language 'sql';
--
-- ================================================================================================================
-- Crie uma função que retorne quem deve
--
create function quemdeve() returns setof integer as
'
       select clientes.id from clientes inner join contas on clientes.id = 	contas.fkcliente
       inner join movimentos on contas.id=movimentos.fkconta
       group by clientes.id
       having sum(credito-debito)<0
' language 'sql';
--
-- ================================================================================================================
-- Retornando uma query
--
create or replace function listaclientes() returns setof clientes as
'
select * from clientes
'
language 'sql';
--
-- ================================================================================================================
-- Retornando uma query
--
create or replace function ListaClientesID(integer) returns setof clientes as
'
select * from clientes where id = $1
'
language 'sql';
--
-- ================================================================================================================
--
-- Funcoes em PL/PGSQL
--
-- Crie uma função que some 1 a um número passado
--
create or replace function soma1(integer) returns integer as
'
declare
       valor alias for $1;
       x integer;
begin
     x:=1;
     x:=x+valor;
     return x;
end;
'
language 'plpgsql';
--
-- ================================================================================================================
-- Crie a mesma função que insira o nome da empresa e o nome do cliente retornando o id de ambos
--
create or replace function empresa_cliente_id(varchar,varchar) returns _int4 as
'
declare
	nempresa alias for $1;
	ncliente alias for $2;
	empresaid integer;
	clienteid integer;
begin
	insert into empresas(nome) values(nempresa);
	insert into clientes(fkempresa,nome) values(currval(''empresas_id_seq''),ncliente);

	empresaid := currval(''empresas_id_seq'');
	clienteid := currval(''clientes_id_seq'');

	return ''{''|| empresaid ||'',''|| clienteid ||''}'';
end;
'
language 'plpgsql';
--
-- ================================================================================================================
-- Crie uma função onde passamos como parâmetro o id do cliente e seja retornado o seu nome
--
create or replace function id_nome_cliente(integer) returns text as
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
--
create or replace function clientes_nomes() returns text as
'
declare
       x text;
       r record;
begin
     x:=''Inicio'';
     for r in select * from clientes order by id loop
         x:= x||'' : ''||r.nome;
     end loop;
     return x||'' : fim'';
end;
'
language 'plpgsql';
--
-- ================================================================================================================
-- Atualizando o saldo de uma conta devera ser passado o id da conta
--
create or replace function saldo_upd_conta(integer) returns numeric(12,2) as
'
       update contas set saldo = (
       select sum(movimentos.credito-movimentos.debito)
       from movimentos where movimentos.fkconta = $1) where id = $1;
       select sum(movimentos.credito-movimentos.debito) from movimentos where movimentos.fkconta = $1;
'
language 'sql';
--
-- ================================================================================================================
-- Atualizando o saldo de uma conta devera ser passado o id da conta
--
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
language 'plpgsql';
--
-- ================================================================================================================
-- Atualizando o saldo de todas as contas
--
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
--
-- ================================================================================================================
--
-- Trigger's
--
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Exemplo 1 - Log de Insert, Update e Delete da tabela precos
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--
--
-- Passo 01 - Criacao da function
--
--
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
--
-- Passo 02 - Criacao da trigger
-- Trigger para
-- before (antes de insert ou update)
--
create trigger precos_log_ins_upd
before insert or update
on precos
for each row
execute procedure precos_log();
--
-- Trigger para
-- after (apos ter deletado)
--
create trigger precos_log_del
after delete
on precos
for each row
execute procedure precos_log();
--
--
-- ================================================================================================================
-- ++++++++++++++++++++++++++++++++++++++++++++++++
-- Exemplo 1.2 - Utilizando o Exemplo 01 com view's
-- ++++++++++++++++++++++++++++++++++++++++++++++++
--
-- Passo 01 - Criar a view
--
create view v_precos as
select id, produto, valor from precos;
-- Passo 02 - Criar as regras para ins, upd e del
-- Regra para Insert
create rule rv_precos_ins as
on insert to v_precos
do instead
insert into precos(produto,valor) values(new.produto,new.valor);
--
-- Regra para Update
--
create rule rv_precos_upd as
on update to v_precos
do instead
update precos
set
   produto = new.produto,
   valor = new.valor
   where id = old.id;
--
-- Regra para Delete
--
create rule rv_precos_del as
on delete to v_precos
do instead
delete from precos
where id = old.id;
-- Passo 03 - Executar os comandos
-- insert, update ou delete
--
-- ================================================================================================================
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
--
-- Fim do usuario PostgreSQL
-- ================================================================================================================
\connect pgteste paulo
-- Esquema paulo
--

--
-- Criando a tabela paulo.empresas
--
CREATE TABLE paulo.empresas(
			id 		SERIAL 		PRIMARY KEY,
			nome 		VARCHAR(50),
			dtcadastro 	DATE,
			telcom 		VARCHAR(20),
			site 		VARCHAR(40),
			email 		VARCHAR(40),
			saldo		NUMERIC(12,2)	DEFAULT 0,
			obs             TEXT
);
--
--
-- Criando a tabela paulo.clientes
--
CREATE TABLE paulo.clientes(
			id 		SERIAL 		PRIMARY KEY,
			fkempresa 	INTEGER,
			nome 		VARCHAR(50),
			dtnascimento 	DATE,
			telres 		VARCHAR(20),
			site 		VARCHAR(40),
			email 		VARCHAR(40),
			saldo		NUMERIC(12,2)	DEFAULT 0,
			obs             TEXT,
			CONSTRAINT paulo_empresas_clientes FOREIGN KEY(fkempresa)
							REFERENCES paulo.empresas(id)
							ON DELETE RESTRICT
							ON UPDATE CASCADE
					
);
--
--
-- Criando a tabela paulo.contas
--
CREATE TABLE paulo.contas(
			id 		SERIAL 		PRIMARY KEY,
			fkcliente 	INTEGER,
			nome 		VARCHAR(50),
			dtabertura	DATE,
			saldo		NUMERIC(12,2)	DEFAULT 0,
			CONSTRAINT paulo_clientes_contas FOREIGN KEY(fkcliente)
							REFERENCES paulo.clientes(id)
							ON DELETE RESTRICT
							ON UPDATE CASCADE
);
--
--
-- Criando a TABLE a paulo.movimentos
--
CREATE TABLE paulo.movimentos(
			id 		SERIAL 		PRIMARY KEY,
			fkconta 	INTEGER,
			historico 	VARCHAR(50),
			credito 	NUMERIC(11,2)	DEFAULT 0,
			debito 		NUMERIC(11,2)	DEFAULT 0,
			CONSTRAINT paulo_contas_movimentos FOREIGN KEY(fkconta)
							REFERENCES paulo.contas(id)
							ON DELETE RESTRICT
							ON UPDATE CASCADE
);
--
--
-- Criando a tabela movempresas
--
CREATE TABLE paulo.movempresas(
			id 		SERIAL 		PRIMARY KEY,
			fkempresa 	INTEGER,
			historico 	VARCHAR(50),
			credito 	NUMERIC(11,2)	DEFAULT 0,
			debito 		NUMERIC(11,2)	DEFAULT 0,
			CONSTRAINT paulo_empresas_movempresas FOREIGN KEY(fkempresa)
							REFERENCES paulo.empresas(id)
							ON DELETE RESTRICT
							ON UPDATE CASCADE
);
--
--
-- Criando a tabela precos
--
CREATE TABLE paulo.precos(
                        id           SERIAL PRIMARY KEY,
                        produto      VARCHAR(30),
                        valor        NUMERIC(11,2), 	
                        data_ins     TIMESTAMP,
                        user_ins     TEXT,
                        data_atu     TIMESTAMP,
                        user_atu     TEXT
);
--
--
-- Criando a tabela precos_log_del
--
CREATE TABLE paulo.precos_log_del(
                        id           INTEGER,
                        produto      VARCHAR(30),
                        valor        NUMERIC(11,2), 	
                        data_ins     TIMESTAMP,
                        user_ins     TEXT,
                        data_atu     TIMESTAMP,
                        user_atu     TEXT,
                        data_del     TIMESTAMP,
                        user_del     TEXT
);
--
--
-- Inserindo registros na tabela paulo.empresas
--
INSERT INTO paulo.empresas(nome,dtcadastro,telcom,site,email) VALUES('MundoByte Informatica',	'1995-11-11',	'222-0909',	'www.mundobyte.com.br',	'relacoes@mundobyte.com.br');
INSERT INTO paulo.empresas(nome,dtcadastro,telcom,site,email) VALUES('TecTel - informatica',	'1995-01-09',	'333-0909',	'www.tectel.com.br',	'info@tectel.com.br');
INSERT INTO paulo.empresas(nome,dtcadastro,telcom,site,email) VALUES('Vulcano S/A',		'2002-10-31',	'211-0909',	'www.vulcano.com.br',	'informacoes@vulcano.com.br');
INSERT INTO paulo.empresas(nome,dtcadastro,telcom,site,email) VALUES('Softmax',		'2000-10-05',	'211-0909',	'www.vulcano.com.br',	'softmax@softmax.com.br');
--
--
-- Inserindo registros na tabela paulo.clientes
--
INSERT INTO paulo.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(1,	'Rodrigo de Oliveira Silva',		'1973-12-12',	'3434-0909',	' ',			'rodrigo@ig.com.br');
INSERT INTO paulo.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(2,	'Melissa Pereira da Silva',		'1970-01-04',	'4444-0011',	'www.mwbrasil.com.br ',	'rose@ig.com.br');
INSERT INTO paulo.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(2,	'Elisangela Almeida de Oliveira',	'1973-10-31',	'3434-7879',	' ',			'eli@brfree.com.br');
INSERT INTO paulo.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(3,	'Andre Tritapepe de Matias',		'1973-12-31',	'3434-8596',	' ',			'andre@trita.com.br');
INSERT INTO paulo.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(3,	'Michela Almeida de Alcantara',		'1980-04-01',	'8888-0101',	' ',			'michela@psico.com.br');
INSERT INTO paulo.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(3,	'Paulo Rogerio de Oliveira',		'1973-10-11',	'7777-0405',	'www.proger.com',	'paulo@proger.com.br');
INSERT INTO paulo.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(4,	'Cristina Pereira Matos',		'1970-10-11',	'2222-7885',	'www.santista.com',	'cristina@uol.com.br');
INSERT INTO paulo.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(4,	'Fabia Castilho Almeida',		'1981-10-11',	'4545-4596',	'www.castilho.com',	'fabia@terra.com.br');
INSERT INTO paulo.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(4,	'paulo Cristovao Santos',		'1980-10-11',	'2202-7272',	'',			'paulo@terra.com.br');
INSERT INTO paulo.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(4,	'paulosa Santos Matias',		'1990-10-11',	'1010-1396',	'',			'paulosa@brfree.com.br');
--
--
-- Inserindo registros na tabela paulo.contas
--
INSERT INTO paulo.contas(fkcliente,nome,dtabertura) VALUES(1,'semana01','2002-10-01');
INSERT INTO paulo.contas(fkcliente,nome,dtabertura) VALUES(2,'semana02','2002-10-20');
INSERT INTO paulo.contas(fkcliente,nome,dtabertura) VALUES(2,'semana03','2002-09-10');
INSERT INTO paulo.contas(fkcliente,nome,dtabertura) VALUES(3,'semana04','2002-09-03');
INSERT INTO paulo.contas(fkcliente,nome,dtabertura) VALUES(3,'semana05','2002-01-01');
INSERT INTO paulo.contas(fkcliente,nome,dtabertura) VALUES(3,'semana06','2002-02-15');
INSERT INTO paulo.contas(fkcliente,nome,dtabertura) VALUES(4,'semana07','2002-05-01');
INSERT INTO paulo.contas(fkcliente,nome,dtabertura) VALUES(4,'semana08','2002-06-09');
INSERT INTO paulo.contas(fkcliente,nome,dtabertura) VALUES(4,'semana09','2002-07-01');
INSERT INTO paulo.contas(fkcliente,nome,dtabertura) VALUES(4,'semana10','2002-10-11');
INSERT INTO paulo.contas(fkcliente,nome,dtabertura) VALUES(5,'semana11','2002-10-10');
INSERT INTO paulo.contas(fkcliente,nome,dtabertura) VALUES(5,'semana12','2002-10-01');
INSERT INTO paulo.contas(fkcliente,nome,dtabertura) VALUES(5,'semana13','2002-07-20');
INSERT INTO paulo.contas(fkcliente,nome,dtabertura) VALUES(5,'semana14','2002-06-01');
INSERT INTO paulo.contas(fkcliente,nome,dtabertura) VALUES(5,'semana15','2002-05-07');
INSERT INTO paulo.contas(fkcliente,nome,dtabertura) VALUES(6,'semana16','2002-02-01');
INSERT INTO paulo.contas(fkcliente,nome,dtabertura) VALUES(6,'semana17','2002-01-08');
INSERT INTO paulo.contas(fkcliente,nome,dtabertura) VALUES(6,'semana18','2002-09-01');
INSERT INTO paulo.contas(fkcliente,nome,dtabertura) VALUES(6,'semana19','2002-09-04');
INSERT INTO paulo.contas(fkcliente,nome,dtabertura) VALUES(6,'semana20','2002-10-28');
INSERT INTO paulo.contas(fkcliente,nome,dtabertura) VALUES(6,'semana21','2002-10-28');
--
--
-- Inserindo registros na tabela paulo.movimentos
--
-- paulo.movimentos da conta 1
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(1,'salario',2000,0);
-- paulo.movimentos da conta 2
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(2,'vendas',50000,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(2,'luz',0,200);
-- paulo.movimentos da conta 3
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(3,'vendas',0,2000);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(3,'combustivel',5000,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(3,'luz',0,200);
-- paulo.movimentos da conta 4
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(4,'combustivel',500,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(4,'luz',0,200);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(4,'vendas',0,2000);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(4,'combustivel',10,0);
-- paulo.movimentos da conta 5
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(5,'combustivel',100,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(5,'luz',0,200);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(5,'combustivel',50,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(5,'vendas',0,2000);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(5,'combustivel',30,0);
-- paulo.movimentos da conta 6
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(6,'luz',0,200);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(6,'vendas',0,3000);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(6,'combustivel',10,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(6,'vendas',0,200);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(6,'combustivel',10,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(6,'luz',0,200);
-- paulo.movimentos da conta 7
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(7,'combustivel',700,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(7,'vendas',0,10000);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(7,'combustivel',500,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(7,'combustivel',30,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(7,'vendas',0,20000);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(7,'combustivel',90,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(7,'luz',0,200);
-- paulo.movimentos da conta 8
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(8,'combustivel',900,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(8,'vendas',0,3000);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(8,'combustivel',300,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(8,'combustivel',300,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(8,'vendas',0,5000);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(8,'luz',0,200);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(8,'luz',0,200);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(8,'combustivel',10,0);
-- paulo.movimentos da conta 9
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(9,'combustivel',400,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(9,'vendas',0,7000);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(9,'combustivel',10,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(9,'combustivel',10,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(9,'combustivel',100,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(9,'vendas',0,6000);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(9,'vendas',0,4000);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(9,'combustivel',100,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(9,'luz',0,200);
-- paulo.movimentos da conta 10
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(10,'combustivel',300,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(10,'combustivel',40,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(10,'vendas',0,20);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(10,'combustivel',10,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(10,'combustivel',110,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(10,'luz',0,200);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(10,'combustivel',100,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(10,'combustivel',100,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(10,'vendas',0,2500);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(10,'vendas',0,2600);
-- paulo.movimentos da conta 11
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(11,'luz',0,50);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(11,'salario',5000,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(11,'manutencao',0,50000);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(11,'supermercado',0,3000);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(11,'manutencao',0,8000);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(11,'escritorio',0,5000);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(11,'carro',0,36000);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(11,'predio',0,60000);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(11,'vendas',7000,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(11,'luz',0,8000);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(11,'manutencao',0,4000);
-- paulo.movimentos da conta 12
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(12,'vendas',4000,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(12,'escritorio',0,50000);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(12,'manutencao',0,40000);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(12,'vendas',10000,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(12,'escritorio',0,70000);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(12,'manutencao',0,4000);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(12,'vendas',80000,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(12,'escritorio',0,20000);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(12,'manutencao',0,4000);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(12,'vendas',10000,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(12,'escritorio',0,5000);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(12,'manutencao',0,10000);
-- paulo.movimentos da conta 13
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
-- paulo.movimentos da conta 14
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',20000,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(14,'salario',8000,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',2000,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(14,'salario',5000,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',9000,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(14,'salario',6000,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',3000,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(14,'salario',9000,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',8000,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(14,'salario',7000,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',9000,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(14,'supermercado',0,5000);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',2000,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(14,'combustivel',9000,0);
-- paulo.movimentos da conta 15
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(15,'combustivel',0,2000);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(15,'combustivel',0,2000);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(15,'escritorio',0,2000);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(15,'escritorio',0,2000);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(15,'escritorio',0,2000);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
-- paulo.movimentos da conta 16
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas',5000,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas',5000,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas',5000,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas',5000,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas loja',5000,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas loja',5000,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas loja',5000,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(16,'suporte',5000,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(16,'suporte',5000,0);
-- paulo.movimentos da conta 17
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(17,'escritorio',0,500);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(17,'combustivel',0,500);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(17,'combustivel',0,500);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(17,'combustivel',0,500);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(17,'carro',0,500);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(17,'carro',0,500);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
-- paulo.movimentos da conta 18
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(18,'suporte',8000,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(18,'vendas loja',8000,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(18,'vendas loja',8000,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(18,'vendas loja',8000,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(18,'vendas loja',8000,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(18,'suporte',8000,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(18,'suporte',8000,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(18,'suporte',8000,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(18,'suporte',8000,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(18,'suporte',8000,0);
-- paulo.movimentos da conta 19
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(19,'caixa interno',0,500);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(19,'caixa interno',0,500);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(19,'caixa interno',0,500);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(19,'predio',0,500);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(19,'predio',0,500);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(19,'predio',0,500);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(19,'predio',0,500);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(19,'predio',0,500);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
-- paulo.movimentos da conta 20
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(20,'vendas',8000,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(20,'vendas',8000,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(20,'vendas',8000,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(20,'suporte ',8000,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(20,'suporte ',8000,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(20,'suporte ',8000,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(20,'suporte ',8000,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(20,'suporte ',8000,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(20,'vendas',8000,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(20,'vendas',8000,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(20,'vendas',8000,0);
-- paulo.movimentos da conta 21
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(21,'combustivel',0,50);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(21,'reforma',0,50);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(21,'manutencao',0,50);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(21,'combustivel',0,50);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(21,'salario',0,50);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(21,'salario',0,50);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(21,'reforma',0,50);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(21,'reforma',0,50);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO paulo.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
--
--
-- Funcoes em SQL e PL/PGSQL
--
-- ================================================================================================================
-- Funcoes em SQL
--
-- Crie uma funcao onde passamos um valor inteiro e retorne ele mais 1
--
create function soma1sql(integer) returns integer as
'
       select  $1 + 1
'
language 'sql';
--
-- ================================================================================================================
-- Monte uma função que mostre a quantidade de clientes em uma empresa
-- deverá ser passado o codigo da empresa como parametro.
--
create function qtd_clientes_empresas(integer) returns bigint as
'
       select count(*) from clientes where fkempresa = $1
'
language 'sql';
--
-- ================================================================================================================
-- Monte uma função que mostre a quantidade de contas por clientes
--
create or replace function Contas_Clientes(integer) returns bigint as
'
       select count(*) from contas where fkcliente = $1
'
language 'sql';
--
-- ================================================================================================================
-- Crie uma função para inserir ao mesmo tempo o  nome da empresa e o nome 	
-- de um cliente retornando o id da empresa.
--
create or replace function empresa_cliente(varchar,varchar) returns bigint as
'
       insert into empresas(nome) values($1);
       insert into clientes(fkempresa,nome) 	values(currval(''empresas_id_seq''),$2);
       select currval(''empresas_id_seq'') as id_empresa
'
language 'sql';
--
-- ================================================================================================================
-- Crie uma função que retorne quem deve
--
create function quemdeve() returns setof integer as
'
       select clientes.id from clientes inner join contas on clientes.id = 	contas.fkcliente
       inner join movimentos on contas.id=movimentos.fkconta
       group by clientes.id
       having sum(credito-debito)<0
' language 'sql';
--
-- ================================================================================================================
-- Retornando uma query
--
create or replace function listaclientes() returns setof clientes as
'
select * from clientes
'
language 'sql';
--
-- ================================================================================================================
-- Retornando uma query
--
create or replace function ListaClientesID(integer) returns setof clientes as
'
select * from clientes where id = $1
'
language 'sql';
--
-- ================================================================================================================
--
-- Funcoes em PL/PGSQL
--
-- Crie uma função que some 1 a um número passado
--
create or replace function soma1(integer) returns integer as
'
declare
       valor alias for $1;
       x integer;
begin
     x:=1;
     x:=x+valor;
     return x;
end;
'
language 'plpgsql';
--
-- ================================================================================================================
-- Crie a mesma função que insira o nome da empresa e o nome do cliente retornando o id de ambos
--
create or replace function empresa_cliente_id(varchar,varchar) returns _int4 as
'
declare
	nempresa alias for $1;
	ncliente alias for $2;
	empresaid integer;
	clienteid integer;
begin
	insert into empresas(nome) values(nempresa);
	insert into clientes(fkempresa,nome) values(currval(''empresas_id_seq''),ncliente);

	empresaid := currval(''empresas_id_seq'');
	clienteid := currval(''clientes_id_seq'');

	return ''{''|| empresaid ||'',''|| clienteid ||''}'';
end;
'
language 'plpgsql';
--
-- ================================================================================================================
-- Crie uma função onde passamos como parâmetro o id do cliente e seja retornado o seu nome
--
create or replace function id_nome_cliente(integer) returns text as
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
--
create or replace function clientes_nomes() returns text as
'
declare
       x text;
       r record;
begin
     x:=''Inicio'';
     for r in select * from clientes order by id loop
         x:= x||'' : ''||r.nome;
     end loop;
     return x||'' : fim'';
end;
'
language 'plpgsql';
--
-- ================================================================================================================
-- Atualizando o saldo de uma conta devera ser passado o id da conta
--
create or replace function saldo_upd_conta(integer) returns numeric(12,2) as
'
       update contas set saldo = (
       select sum(movimentos.credito-movimentos.debito)
       from movimentos where movimentos.fkconta = $1) where id = $1;
       select sum(movimentos.credito-movimentos.debito) from movimentos where movimentos.fkconta = $1;
'
language 'sql';
--
-- ================================================================================================================
-- Atualizando o saldo de uma conta devera ser passado o id da conta
--
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
language 'plpgsql';
--
-- ================================================================================================================
-- Atualizando o saldo de todas as contas
--
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
--
-- ================================================================================================================
--
-- Trigger's
--
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Exemplo 1 - Log de Insert, Update e Delete da tabela precos
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--
--
-- Passo 01 - Criacao da function
--
--
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
--
-- Passo 02 - Criacao da trigger
-- Trigger para
-- before (antes de insert ou update)
--
create trigger precos_log_ins_upd
before insert or update
on precos
for each row
execute procedure precos_log();
--
-- Trigger para
-- after (apos ter deletado)
--
create trigger precos_log_del
after delete
on precos
for each row
execute procedure precos_log();
--
--
-- ================================================================================================================
-- ++++++++++++++++++++++++++++++++++++++++++++++++
-- Exemplo 1.2 - Utilizando o Exemplo 01 com view's
-- ++++++++++++++++++++++++++++++++++++++++++++++++
--
-- Passo 01 - Criar a view
--
create view v_precos as
select id, produto, valor from precos;
-- Passo 02 - Criar as regras para ins, upd e del
-- Regra para Insert
create rule rv_precos_ins as
on insert to v_precos
do instead
insert into precos(produto,valor) values(new.produto,new.valor);
--
-- Regra para Update
--
create rule rv_precos_upd as
on update to v_precos
do instead
update precos
set
   produto = new.produto,
   valor = new.valor
   where id = old.id;
--
-- Regra para Delete
--
create rule rv_precos_del as
on delete to v_precos
do instead
delete from precos
where id = old.id;
-- Passo 03 - Executar os comandos
-- insert, update ou delete
--
-- ================================================================================================================
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
--
-- Fim do schema do usuario paulo
-- ================================================================================================================
\connect pgteste elisangela
-- Esquema elisangela
--

--
-- Criando a tabela elisangela.empresas
--
CREATE TABLE elisangela.empresas(
			id 		SERIAL 		PRIMARY KEY,
			nome 		VARCHAR(50),
			dtcadastro 	DATE,
			telcom 		VARCHAR(20),
			site 		VARCHAR(40),
			email 		VARCHAR(40),
			saldo		NUMERIC(12,2)	DEFAULT 0,
			obs             TEXT
);
--
--
-- Criando a tabela elisangela.clientes
--
CREATE TABLE elisangela.clientes(
			id 		SERIAL 		PRIMARY KEY,
			fkempresa 	INTEGER,
			nome 		VARCHAR(50),
			dtnascimento 	DATE,
			telres 		VARCHAR(20),
			site 		VARCHAR(40),
			email 		VARCHAR(40),
			saldo		NUMERIC(12,2)	DEFAULT 0,
			obs             TEXT,
			CONSTRAINT elisangela_empresas_clientes FOREIGN KEY(fkempresa)
							REFERENCES elisangela.empresas(id)
							ON DELETE RESTRICT
							ON UPDATE CASCADE
					
);
--
--
-- Criando a tabela elisangela.contas
--
CREATE TABLE elisangela.contas(
			id 		SERIAL 		PRIMARY KEY,
			fkcliente 	INTEGER,
			nome 		VARCHAR(50),
			dtabertura	DATE,
			saldo		NUMERIC(12,2)	DEFAULT 0,
			CONSTRAINT elisangela_clientes_contas FOREIGN KEY(fkcliente)
							REFERENCES elisangela.clientes(id)
							ON DELETE RESTRICT
							ON UPDATE CASCADE
);
--
--
-- Criando a TABLE a elisangela.movimentos
--
CREATE TABLE elisangela.movimentos(
			id 		SERIAL 		PRIMARY KEY,
			fkconta 	INTEGER,
			historico 	VARCHAR(50),
			credito 	NUMERIC(11,2)	DEFAULT 0,
			debito 		NUMERIC(11,2)	DEFAULT 0,
			CONSTRAINT elisangela_contas_movimentos FOREIGN KEY(fkconta)
							REFERENCES elisangela.contas(id)
							ON DELETE RESTRICT
							ON UPDATE CASCADE
);
--
--
-- Criando a tabela movempresas
--
CREATE TABLE elisangela.movempresas(
			id 		SERIAL 		PRIMARY KEY,
			fkempresa 	INTEGER,
			historico 	VARCHAR(50),
			credito 	NUMERIC(11,2)	DEFAULT 0,
			debito 		NUMERIC(11,2)	DEFAULT 0,
			CONSTRAINT elisangela_empresas_movempresas FOREIGN KEY(fkempresa)
							REFERENCES elisangela.empresas(id)
							ON DELETE RESTRICT
							ON UPDATE CASCADE
);
--
--
-- Criando a tabela precos
--
CREATE TABLE elisangela.precos(
                        id           SERIAL PRIMARY KEY,
                        produto      VARCHAR(30),
                        valor        NUMERIC(11,2), 	
                        data_ins     TIMESTAMP,
                        user_ins     TEXT,
                        data_atu     TIMESTAMP,
                        user_atu     TEXT
);
--
--
-- Criando a tabela precos_log_del
--
CREATE TABLE elisangela.precos_log_del(
                        id           INTEGER,
                        produto      VARCHAR(30),
                        valor        NUMERIC(11,2), 	
                        data_ins     TIMESTAMP,
                        user_ins     TEXT,
                        data_atu     TIMESTAMP,
                        user_atu     TEXT,
                        data_del     TIMESTAMP,
                        user_del     TEXT
);
--
--
-- Inserindo registros na tabela elisangela.empresas
--
INSERT INTO elisangela.empresas(nome,dtcadastro,telcom,site,email) VALUES('MundoByte Informatica',	'1995-11-11',	'222-0909',	'www.mundobyte.com.br',	'relacoes@mundobyte.com.br');
INSERT INTO elisangela.empresas(nome,dtcadastro,telcom,site,email) VALUES('TecTel - informatica',	'1995-01-09',	'333-0909',	'www.tectel.com.br',	'info@tectel.com.br');
INSERT INTO elisangela.empresas(nome,dtcadastro,telcom,site,email) VALUES('Vulcano S/A',		'2002-10-31',	'211-0909',	'www.vulcano.com.br',	'informacoes@vulcano.com.br');
INSERT INTO elisangela.empresas(nome,dtcadastro,telcom,site,email) VALUES('Softmax',		'2000-10-05',	'211-0909',	'www.vulcano.com.br',	'softmax@softmax.com.br');
--
--
-- Inserindo registros na tabela elisangela.clientes
--
INSERT INTO elisangela.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(1,	'Rodrigo de Oliveira Silva',		'1973-12-12',	'3434-0909',	' ',			'rodrigo@ig.com.br');
INSERT INTO elisangela.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(2,	'Melissa Pereira da Silva',		'1970-01-04',	'4444-0011',	'www.mwbrasil.com.br ',	'rose@ig.com.br');
INSERT INTO elisangela.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(2,	'Elisangela Almeida de Oliveira',	'1973-10-31',	'3434-7879',	' ',			'eli@brfree.com.br');
INSERT INTO elisangela.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(3,	'Andre Tritapepe de Matias',		'1973-12-31',	'3434-8596',	' ',			'andre@trita.com.br');
INSERT INTO elisangela.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(3,	'Michela Almeida de Alcantara',		'1980-04-01',	'8888-0101',	' ',			'michela@psico.com.br');
INSERT INTO elisangela.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(3,	'Paulo Rogerio de Oliveira',		'1973-10-11',	'7777-0405',	'www.proger.com',	'paulo@proger.com.br');
INSERT INTO elisangela.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(4,	'Cristina Pereira Matos',		'1970-10-11',	'2222-7885',	'www.santista.com',	'cristina@uol.com.br');
INSERT INTO elisangela.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(4,	'Fabia Castilho Almeida',		'1981-10-11',	'4545-4596',	'www.castilho.com',	'fabia@terra.com.br');
INSERT INTO elisangela.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(4,	'elisangela Cristovao Santos',		'1980-10-11',	'2202-7272',	'',			'elisangela@terra.com.br');
INSERT INTO elisangela.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(4,	'elisangelasa Santos Matias',		'1990-10-11',	'1010-1396',	'',			'elisangelasa@brfree.com.br');
--
--
-- Inserindo registros na tabela elisangela.contas
--
INSERT INTO elisangela.contas(fkcliente,nome,dtabertura) VALUES(1,'semana01','2002-10-01');
INSERT INTO elisangela.contas(fkcliente,nome,dtabertura) VALUES(2,'semana02','2002-10-20');
INSERT INTO elisangela.contas(fkcliente,nome,dtabertura) VALUES(2,'semana03','2002-09-10');
INSERT INTO elisangela.contas(fkcliente,nome,dtabertura) VALUES(3,'semana04','2002-09-03');
INSERT INTO elisangela.contas(fkcliente,nome,dtabertura) VALUES(3,'semana05','2002-01-01');
INSERT INTO elisangela.contas(fkcliente,nome,dtabertura) VALUES(3,'semana06','2002-02-15');
INSERT INTO elisangela.contas(fkcliente,nome,dtabertura) VALUES(4,'semana07','2002-05-01');
INSERT INTO elisangela.contas(fkcliente,nome,dtabertura) VALUES(4,'semana08','2002-06-09');
INSERT INTO elisangela.contas(fkcliente,nome,dtabertura) VALUES(4,'semana09','2002-07-01');
INSERT INTO elisangela.contas(fkcliente,nome,dtabertura) VALUES(4,'semana10','2002-10-11');
INSERT INTO elisangela.contas(fkcliente,nome,dtabertura) VALUES(5,'semana11','2002-10-10');
INSERT INTO elisangela.contas(fkcliente,nome,dtabertura) VALUES(5,'semana12','2002-10-01');
INSERT INTO elisangela.contas(fkcliente,nome,dtabertura) VALUES(5,'semana13','2002-07-20');
INSERT INTO elisangela.contas(fkcliente,nome,dtabertura) VALUES(5,'semana14','2002-06-01');
INSERT INTO elisangela.contas(fkcliente,nome,dtabertura) VALUES(5,'semana15','2002-05-07');
INSERT INTO elisangela.contas(fkcliente,nome,dtabertura) VALUES(6,'semana16','2002-02-01');
INSERT INTO elisangela.contas(fkcliente,nome,dtabertura) VALUES(6,'semana17','2002-01-08');
INSERT INTO elisangela.contas(fkcliente,nome,dtabertura) VALUES(6,'semana18','2002-09-01');
INSERT INTO elisangela.contas(fkcliente,nome,dtabertura) VALUES(6,'semana19','2002-09-04');
INSERT INTO elisangela.contas(fkcliente,nome,dtabertura) VALUES(6,'semana20','2002-10-28');
INSERT INTO elisangela.contas(fkcliente,nome,dtabertura) VALUES(6,'semana21','2002-10-28');
--
--
-- Inserindo registros na tabela elisangela.movimentos
--
-- elisangela.movimentos da conta 1
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(1,'salario',2000,0);
-- elisangela.movimentos da conta 2
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(2,'vendas',50000,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(2,'luz',0,200);
-- elisangela.movimentos da conta 3
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(3,'vendas',0,2000);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(3,'combustivel',5000,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(3,'luz',0,200);
-- elisangela.movimentos da conta 4
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(4,'combustivel',500,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(4,'luz',0,200);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(4,'vendas',0,2000);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(4,'combustivel',10,0);
-- elisangela.movimentos da conta 5
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(5,'combustivel',100,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(5,'luz',0,200);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(5,'combustivel',50,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(5,'vendas',0,2000);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(5,'combustivel',30,0);
-- elisangela.movimentos da conta 6
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(6,'luz',0,200);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(6,'vendas',0,3000);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(6,'combustivel',10,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(6,'vendas',0,200);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(6,'combustivel',10,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(6,'luz',0,200);
-- elisangela.movimentos da conta 7
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(7,'combustivel',700,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(7,'vendas',0,10000);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(7,'combustivel',500,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(7,'combustivel',30,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(7,'vendas',0,20000);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(7,'combustivel',90,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(7,'luz',0,200);
-- elisangela.movimentos da conta 8
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(8,'combustivel',900,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(8,'vendas',0,3000);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(8,'combustivel',300,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(8,'combustivel',300,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(8,'vendas',0,5000);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(8,'luz',0,200);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(8,'luz',0,200);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(8,'combustivel',10,0);
-- elisangela.movimentos da conta 9
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(9,'combustivel',400,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(9,'vendas',0,7000);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(9,'combustivel',10,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(9,'combustivel',10,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(9,'combustivel',100,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(9,'vendas',0,6000);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(9,'vendas',0,4000);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(9,'combustivel',100,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(9,'luz',0,200);
-- elisangela.movimentos da conta 10
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(10,'combustivel',300,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(10,'combustivel',40,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(10,'vendas',0,20);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(10,'combustivel',10,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(10,'combustivel',110,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(10,'luz',0,200);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(10,'combustivel',100,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(10,'combustivel',100,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(10,'vendas',0,2500);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(10,'vendas',0,2600);
-- elisangela.movimentos da conta 11
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(11,'luz',0,50);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(11,'salario',5000,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(11,'manutencao',0,50000);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(11,'supermercado',0,3000);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(11,'manutencao',0,8000);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(11,'escritorio',0,5000);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(11,'carro',0,36000);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(11,'predio',0,60000);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(11,'vendas',7000,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(11,'luz',0,8000);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(11,'manutencao',0,4000);
-- elisangela.movimentos da conta 12
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(12,'vendas',4000,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(12,'escritorio',0,50000);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(12,'manutencao',0,40000);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(12,'vendas',10000,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(12,'escritorio',0,70000);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(12,'manutencao',0,4000);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(12,'vendas',80000,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(12,'escritorio',0,20000);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(12,'manutencao',0,4000);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(12,'vendas',10000,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(12,'escritorio',0,5000);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(12,'manutencao',0,10000);
-- elisangela.movimentos da conta 13
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
-- elisangela.movimentos da conta 14
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',20000,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(14,'salario',8000,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',2000,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(14,'salario',5000,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',9000,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(14,'salario',6000,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',3000,0);
INSERT INTO elisangdla.movimentos(fkconta,historico,credito,debito) VALUES(14,'salario',9000,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',8000,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(14,'salario',7000,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',9000,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(14,'supermercado',0,5000);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',2000,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(14,'combustivel',9000,0);
-- elisangela.movimentos da conta 15
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(15,'combustivel',0,2000);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(15,'combustivel',0,2000);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(15,'escritorio',0,2000);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(15,'escritorio',0,2000);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(15,'escritorio',0,2000);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
-- elisangela.movimentos da conta 16
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas',5000,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas',5000,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas',5000,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas',5000,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas loja',5000,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas loja',5000,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas loja',5000,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(16,'suporte',5000,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(16,'suporte',5000,0);
-- elisangela.movimentos da conta 17
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(17,'escritorio',0,500);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(17,'combustivel',0,500);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(17,'combustivel',0,500);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(17,'combustivel',0,500);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(17,'carro',0,500);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(17,'carro',0,500);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
-- elisangela.movimentos da conta 18
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(18,'suporte',8000,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(18,'vendas loja',8000,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(18,'vendas loja',8000,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(18,'vendas loja',8000,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(18,'vendas loja',8000,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(18,'suporte',8000,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(18,'suporte',8000,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(18,'suporte',8000,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(18,'suporte',8000,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(18,'suporte',8000,0);
-- elisangela.movimentos da conta 19
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(19,'caixa interno',0,500);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(19,'caixa interno',0,500);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(19,'caixa interno',0,500);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(19,'predio',0,500);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(19,'predio',0,500);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(19,'predio',0,500);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(19,'predio',0,500);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(19,'predio',0,500);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
-- elisangela.movimentos da conta 20
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(20,'vendas',8000,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(20,'vendas',8000,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(20,'vendas',8000,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(20,'suporte ',8000,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(20,'suporte ',8000,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(20,'suporte ',8000,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(20,'suporte ',8000,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(20,'suporte ',8000,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(20,'vendas',8000,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(20,'vendas',8000,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(20,'vendas',8000,0);
-- elisangela.movimentos da conta 21
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(21,'combustivel',0,50);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(21,'reforma',0,50);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(21,'manutencao',0,50);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(21,'combustivel',0,50);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(21,'salario',0,50);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(21,'salario',0,50);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(21,'reforma',0,50);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(21,'reforma',0,50);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO elisangela.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);

--
--
-- Funcoes em SQL e PL/PGSQL
--
-- ================================================================================================================
-- Funcoes em SQL
--
-- Crie uma funcao onde passamos um valor inteiro e retorne ele mais 1
--
create function soma1sql(integer) returns integer as
'
       select  $1 + 1
'
language 'sql';
--
-- ================================================================================================================
-- Monte uma função que mostre a quantidade de clientes em uma empresa
-- deverá ser passado o codigo da empresa como parametro.
--
create function qtd_clientes_empresas(integer) returns bigint as
'
       select count(*) from clientes where fkempresa = $1
'
language 'sql';
--
-- ================================================================================================================
-- Monte uma função que mostre a quantidade de contas por clientes
--
create or replace function Contas_Clientes(integer) returns bigint as
'
       select count(*) from contas where fkcliente = $1
'
language 'sql';
--
-- ================================================================================================================
-- Crie uma função para inserir ao mesmo tempo o  nome da empresa e o nome 	
-- de um cliente retornando o id da empresa.
--
create or replace function empresa_cliente(varchar,varchar) returns bigint as
'
       insert into empresas(nome) values($1);
       insert into clientes(fkempresa,nome) 	values(currval(''empresas_id_seq''),$2);
       select currval(''empresas_id_seq'') as id_empresa
'
language 'sql';
--
-- ================================================================================================================
-- Crie uma função que retorne quem deve
--
create function quemdeve() returns setof integer as
'
       select clientes.id from clientes inner join contas on clientes.id = 	contas.fkcliente
       inner join movimentos on contas.id=movimentos.fkconta
       group by clientes.id
       having sum(credito-debito)<0
' language 'sql';
--
-- ================================================================================================================
-- Retornando uma query
--
create or replace function listaclientes() returns setof clientes as
'
select * from clientes
'
language 'sql';
--
-- ================================================================================================================
-- Retornando uma query
--
create or replace function ListaClientesID(integer) returns setof clientes as
'
select * from clientes where id = $1
'
language 'sql';
--
-- ================================================================================================================
--
-- Funcoes em PL/PGSQL
--
-- Crie uma função que some 1 a um número passado
--
create or replace function soma1(integer) returns integer as
'
declare
       valor alias for $1;
       x integer;
begin
     x:=1;
     x:=x+valor;
     return x;
end;
'
language 'plpgsql';
--
-- ================================================================================================================
-- Crie a mesma função que insira o nome da empresa e o nome do cliente retornando o id de ambos
--
create or replace function empresa_cliente_id(varchar,varchar) returns _int4 as
'
declare
	nempresa alias for $1;
	ncliente alias for $2;
	empresaid integer;
	clienteid integer;
begin
	insert into empresas(nome) values(nempresa);
	insert into clientes(fkempresa,nome) values(currval(''empresas_id_seq''),ncliente);

	empresaid := currval(''empresas_id_seq'');
	clienteid := currval(''clientes_id_seq'');

	return ''{''|| empresaid ||'',''|| clienteid ||''}'';
end;
'
language 'plpgsql';
--
-- ================================================================================================================
-- Crie uma função onde passamos como parâmetro o id do cliente e seja retornado o seu nome
--
create or replace function id_nome_cliente(integer) returns text as
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
--
create or replace function clientes_nomes() returns text as
'
declare
       x text;
       r record;
begin
     x:=''Inicio'';
     for r in select * from clientes order by id loop
         x:= x||'' : ''||r.nome;
     end loop;
     return x||'' : fim'';
end;
'
language 'plpgsql';
--
-- ================================================================================================================
-- Atualizando o saldo de uma conta devera ser passado o id da conta
--
create or replace function saldo_upd_conta(integer) returns numeric(12,2) as
'
       update contas set saldo = (
       select sum(movimentos.credito-movimentos.debito)
       from movimentos where movimentos.fkconta = $1) where id = $1;
       select sum(movimentos.credito-movimentos.debito) from movimentos where movimentos.fkconta = $1;
'
language 'sql';
--
-- ================================================================================================================
-- Atualizando o saldo de uma conta devera ser passado o id da conta
--
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
language 'plpgsql';
--
-- ================================================================================================================
-- Atualizando o saldo de todas as contas
--
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
--
-- ================================================================================================================
--
-- Trigger's
--
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Exemplo 1 - Log de Insert, Update e Delete da tabela precos
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--
--
-- Passo 01 - Criacao da function
--
--
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
--
-- Passo 02 - Criacao da trigger
-- Trigger para
-- before (antes de insert ou update)
--
create trigger precos_log_ins_upd
before insert or update
on precos
for each row
execute procedure precos_log();
--
-- Trigger para
-- after (apos ter deletado)
--
create trigger precos_log_del
after delete
on precos
for each row
execute procedure precos_log();
--
--
-- ================================================================================================================
-- ++++++++++++++++++++++++++++++++++++++++++++++++
-- Exemplo 1.2 - Utilizando o Exemplo 01 com view's
-- ++++++++++++++++++++++++++++++++++++++++++++++++
--
-- Passo 01 - Criar a view
--
create view v_precos as
select id, produto, valor from precos;
-- Passo 02 - Criar as regras para ins, upd e del
-- Regra para Insert
create rule rv_precos_ins as
on insert to v_precos
do instead
insert into precos(produto,valor) values(new.produto,new.valor);
--
-- Regra para Update
--
create rule rv_precos_upd as
on update to v_precos
do instead
update precos
set
   produto = new.produto,
   valor = new.valor
   where id = old.id;
--
-- Regra para Delete
--
create rule rv_precos_del as
on delete to v_precos
do instead
delete from precos
where id = old.id;
-- Passo 03 - Executar os comandos
-- insert, update ou delete
--
-- ================================================================================================================
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
--
-- Fim do schema da elisangela
-- ================================================================================================================
\connect pgteste andre
-- Esquema andre
--
--
-- Criando a tabela andre.empresas
--
CREATE TABLE andre.empresas(
			id 		SERIAL 		PRIMARY KEY,
			nome 		VARCHAR(50),
			dtcadastro 	DATE,
			telcom 		VARCHAR(20),
			site 		VARCHAR(40),
			email 		VARCHAR(40),
			saldo		NUMERIC(12,2)	DEFAULT 0,
			obs             TEXT
);
--
--
-- Criando a tabela andre.clientes
--
CREATE TABLE andre.clientes(
			id 		SERIAL 		PRIMARY KEY,
			fkempresa 	INTEGER,
			nome 		VARCHAR(50),
			dtnascimento 	DATE,
			telres 		VARCHAR(20),
			site 		VARCHAR(40),
			email 		VARCHAR(40),
			saldo		NUMERIC(12,2)	DEFAULT 0,
			obs             TEXT,
			CONSTRAINT andre_empresas_clientes FOREIGN KEY(fkempresa)
							REFERENCES andre.empresas(id)
							ON DELETE RESTRICT
							ON UPDATE CASCADE
					
);
--
--
-- Criando a tabela andre.contas
--
CREATE TABLE andre.contas(
			id 		SERIAL 		PRIMARY KEY,
			fkcliente 	INTEGER,
			nome 		VARCHAR(50),
			dtabertura	DATE,
			saldo		NUMERIC(12,2)	DEFAULT 0,
			CONSTRAINT andre_clientes_contas FOREIGN KEY(fkcliente)
							REFERENCES andre.clientes(id)
							ON DELETE RESTRICT
							ON UPDATE CASCADE
);
--
--
-- Criando a TABLE a andre.movimentos
--
CREATE TABLE andre.movimentos(
			id 		SERIAL 		PRIMARY KEY,
			fkconta 	INTEGER,
			historico 	VARCHAR(50),
			credito 	NUMERIC(11,2)	DEFAULT 0,
			debito 		NUMERIC(11,2)	DEFAULT 0,
			CONSTRAINT andre_contas_movimentos FOREIGN KEY(fkconta)
							REFERENCES andre.contas(id)
							ON DELETE RESTRICT
							ON UPDATE CASCADE
);
--
--
-- Criando a tabela movempresas
--
CREATE TABLE andre.movempresas(
			id 		SERIAL 		PRIMARY KEY,
			fkempresa 	INTEGER,
			historico 	VARCHAR(50),
			credito 	NUMERIC(11,2)	DEFAULT 0,
			debito 		NUMERIC(11,2)	DEFAULT 0,
			CONSTRAINT andre_empresas_movempresas FOREIGN KEY(fkempresa)
							REFERENCES andre.empresas(id)
							ON DELETE RESTRICT
							ON UPDATE CASCADE
);
--
--
-- Criando a tabela precos
--
CREATE TABLE andre.precos(
                        id           SERIAL PRIMARY KEY,
                        produto      VARCHAR(30),
                        valor        NUMERIC(11,2), 	
                        data_ins     TIMESTAMP,
                        user_ins     TEXT,
                        data_atu     TIMESTAMP,
                        user_atu     TEXT
);
--
--
-- Criando a tabela precos_log_del
--
CREATE TABLE andre.precos_log_del(
                        id           INTEGER,
                        produto      VARCHAR(30),
                        valor        NUMERIC(11,2), 	
                        data_ins     TIMESTAMP,
                        user_ins     TEXT,
                        data_atu     TIMESTAMP,
                        user_atu     TEXT,
                        data_del     TIMESTAMP,
                        user_del     TEXT
);
--
--
-- Inserindo registros na tabela andre.empresas
--
INSERT INTO andre.empresas(nome,dtcadastro,telcom,site,email) VALUES('MundoByte Informatica',	'1995-11-11',	'222-0909',	'www.mundobyte.com.br',	'relacoes@mundobyte.com.br');
INSERT INTO andre.empresas(nome,dtcadastro,telcom,site,email) VALUES('TecTel - informatica',	'1995-01-09',	'333-0909',	'www.tectel.com.br',	'info@tectel.com.br');
INSERT INTO andre.empresas(nome,dtcadastro,telcom,site,email) VALUES('Vulcano S/A',		'2002-10-31',	'211-0909',	'www.vulcano.com.br',	'informacoes@vulcano.com.br');
INSERT INTO andre.empresas(nome,dtcadastro,telcom,site,email) VALUES('Softmax',		'2000-10-05',	'211-0909',	'www.vulcano.com.br',	'softmax@softmax.com.br');
--
--
-- Inserindo registros na tabela andre.clientes
--
INSERT INTO andre.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(1,	'Rodrigo de Oliveira Silva',		'1973-12-12',	'3434-0909',	' ',			'rodrigo@ig.com.br');
INSERT INTO andre.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(2,	'Melissa Pereira da Silva',		'1970-01-04',	'4444-0011',	'www.mwbrasil.com.br ',	'rose@ig.com.br');
INSERT INTO andre.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(2,	'Elisangela Almeida de Oliveira',	'1973-10-31',	'3434-7879',	' ',			'eli@brfree.com.br');
INSERT INTO andre.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(3,	'Andre Tritapepe de Matias',		'1973-12-31',	'3434-8596',	' ',			'andre@trita.com.br');
INSERT INTO andre.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(3,	'Michela Almeida de Alcantara',		'1980-04-01',	'8888-0101',	' ',			'michela@psico.com.br');
INSERT INTO andre.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(3,	'Paulo Rogerio de Oliveira',		'1973-10-11',	'7777-0405',	'www.proger.com',	'paulo@proger.com.br');
INSERT INTO andre.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(4,	'Cristina Pereira Matos',		'1970-10-11',	'2222-7885',	'www.santista.com',	'cristina@uol.com.br');
INSERT INTO andre.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(4,	'Fabia Castilho Almeida',		'1981-10-11',	'4545-4596',	'www.castilho.com',	'fabia@terra.com.br');
INSERT INTO andre.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(4,	'andre Cristovao Santos',		'1980-10-11',	'2202-7272',	'',			'andre@terra.com.br');
INSERT INTO andre.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(4,	'andresa Santos Matias',		'1990-10-11',	'1010-1396',	'',			'andresa@brfree.com.br');
--
--
-- Inserindo registros na tabela andre.contas
--
INSERT INTO andre.contas(fkcliente,nome,dtabertura) VALUES(1,'semana01','2002-10-01');
INSERT INTO andre.contas(fkcliente,nome,dtabertura) VALUES(2,'semana02','2002-10-20');
INSERT INTO andre.contas(fkcliente,nome,dtabertura) VALUES(2,'semana03','2002-09-10');
INSERT INTO andre.contas(fkcliente,nome,dtabertura) VALUES(3,'semana04','2002-09-03');
INSERT INTO andre.contas(fkcliente,nome,dtabertura) VALUES(3,'semana05','2002-01-01');
INSERT INTO andre.contas(fkcliente,nome,dtabertura) VALUES(3,'semana06','2002-02-15');
INSERT INTO andre.contas(fkcliente,nome,dtabertura) VALUES(4,'semana07','2002-05-01');
INSERT INTO andre.contas(fkcliente,nome,dtabertura) VALUES(4,'semana08','2002-06-09');
INSERT INTO andre.contas(fkcliente,nome,dtabertura) VALUES(4,'semana09','2002-07-01');
INSERT INTO andre.contas(fkcliente,nome,dtabertura) VALUES(4,'semana10','2002-10-11');
INSERT INTO andre.contas(fkcliente,nome,dtabertura) VALUES(5,'semana11','2002-10-10');
INSERT INTO andre.contas(fkcliente,nome,dtabertura) VALUES(5,'semana12','2002-10-01');
INSERT INTO andre.contas(fkcliente,nome,dtabertura) VALUES(5,'semana13','2002-07-20');
INSERT INTO andre.contas(fkcliente,nome,dtabertura) VALUES(5,'semana14','2002-06-01');
INSERT INTO andre.contas(fkcliente,nome,dtabertura) VALUES(5,'semana15','2002-05-07');
INSERT INTO andre.contas(fkcliente,nome,dtabertura) VALUES(6,'semana16','2002-02-01');
INSERT INTO andre.contas(fkcliente,nome,dtabertura) VALUES(6,'semana17','2002-01-08');
INSERT INTO andre.contas(fkcliente,nome,dtabertura) VALUES(6,'semana18','2002-09-01');
INSERT INTO andre.contas(fkcliente,nome,dtabertura) VALUES(6,'semana19','2002-09-04');
INSERT INTO andre.contas(fkcliente,nome,dtabertura) VALUES(6,'semana20','2002-10-28');
INSERT INTO andre.contas(fkcliente,nome,dtabertura) VALUES(6,'semana21','2002-10-28');
--
--
-- Inserindo registros na tabela andre.movimentos
--
-- andre.movimentos da conta 1
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(1,'salario',2000,0);
-- andre.movimentos da conta 2
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(2,'vendas',50000,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(2,'luz',0,200);
-- andre.movimentos da conta 3
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(3,'vendas',0,2000);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(3,'combustivel',5000,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(3,'luz',0,200);
-- andre.movimentos da conta 4
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(4,'combustivel',500,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(4,'luz',0,200);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(4,'vendas',0,2000);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(4,'combustivel',10,0);
-- andre.movimentos da conta 5
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(5,'combustivel',100,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(5,'luz',0,200);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(5,'combustivel',50,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(5,'vendas',0,2000);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(5,'combustivel',30,0);
-- andre.movimentos da conta 6
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(6,'luz',0,200);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(6,'vendas',0,3000);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(6,'combustivel',10,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(6,'vendas',0,200);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(6,'combustivel',10,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(6,'luz',0,200);
-- andre.movimentos da conta 7
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(7,'combustivel',700,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(7,'vendas',0,10000);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(7,'combustivel',500,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(7,'combustivel',30,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(7,'vendas',0,20000);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(7,'combustivel',90,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(7,'luz',0,200);
-- andre.movimentos da conta 8
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(8,'combustivel',900,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(8,'vendas',0,3000);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(8,'combustivel',300,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(8,'combustivel',300,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(8,'vendas',0,5000);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(8,'luz',0,200);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(8,'luz',0,200);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(8,'combustivel',10,0);
-- andre.movimentos da conta 9
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(9,'combustivel',400,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(9,'vendas',0,7000);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(9,'combustivel',10,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(9,'combustivel',10,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(9,'combustivel',100,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(9,'vendas',0,6000);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(9,'vendas',0,4000);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(9,'combustivel',100,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(9,'luz',0,200);
-- andre.movimentos da conta 10
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(10,'combustivel',300,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(10,'combustivel',40,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(10,'vendas',0,20);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(10,'combustivel',10,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(10,'combustivel',110,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(10,'luz',0,200);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(10,'combustivel',100,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(10,'combustivel',100,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(10,'vendas',0,2500);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(10,'vendas',0,2600);
-- andre.movimentos da conta 11
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(11,'luz',0,50);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(11,'salario',5000,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(11,'manutencao',0,50000);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(11,'supermercado',0,3000);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(11,'manutencao',0,8000);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(11,'escritorio',0,5000);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(11,'carro',0,36000);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(11,'predio',0,60000);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(11,'vendas',7000,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(11,'luz',0,8000);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(11,'manutencao',0,4000);
-- andre.movimentos da conta 12
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(12,'vendas',4000,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(12,'escritorio',0,50000);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(12,'manutencao',0,40000);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(12,'vendas',10000,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(12,'escritorio',0,70000);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(12,'manutencao',0,4000);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(12,'vendas',80000,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(12,'escritorio',0,20000);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(12,'manutencao',0,4000);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(12,'vendas',10000,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(12,'escritorio',0,5000);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(12,'manutencao',0,10000);
-- andre.movimentos da conta 13
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
-- andre.movimentos da conta 14
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',20000,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(14,'salario',8000,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',2000,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(14,'salario',5000,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',9000,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(14,'salario',6000,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',3000,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(14,'salario',9000,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',8000,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(14,'salario',7000,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',9000,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(14,'supermercado',0,5000);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',2000,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(14,'combustivel',9000,0);
-- andre.movimentos da conta 15
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(15,'combustivel',0,2000);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(15,'combustivel',0,2000);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(15,'escritorio',0,2000);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(15,'escritorio',0,2000);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(15,'escritorio',0,2000);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
-- andre.movimentos da conta 16
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas',5000,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas',5000,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas',5000,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas',5000,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas loja',5000,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas loja',5000,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas loja',5000,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(16,'suporte',5000,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(16,'suporte',5000,0);
-- andre.movimentos da conta 17
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(17,'escritorio',0,500);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(17,'combustivel',0,500);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(17,'combustivel',0,500);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(17,'combustivel',0,500);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(17,'carro',0,500);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(17,'carro',0,500);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
-- andre.movimentos da conta 18
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(18,'suporte',8000,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(18,'vendas loja',8000,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(18,'vendas loja',8000,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(18,'vendas loja',8000,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(18,'vendas loja',8000,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(18,'suporte',8000,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(18,'suporte',8000,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(18,'suporte',8000,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(18,'suporte',8000,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(18,'suporte',8000,0);
-- andre.movimentos da conta 19
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(19,'caixa interno',0,500);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(19,'caixa interno',0,500);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(19,'caixa interno',0,500);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(19,'predio',0,500);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(19,'predio',0,500);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(19,'predio',0,500);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(19,'predio',0,500);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(19,'predio',0,500);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
-- andre.movimentos da conta 20
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(20,'vendas',8000,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(20,'vendas',8000,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(20,'vendas',8000,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(20,'suporte ',8000,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(20,'suporte ',8000,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(20,'suporte ',8000,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(20,'suporte ',8000,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(20,'suporte ',8000,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(20,'vendas',8000,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(20,'vendas',8000,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(20,'vendas',8000,0);
-- andre.movimentos da conta 21
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(21,'combustivel',0,50);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(21,'reforma',0,50);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(21,'manutencao',0,50);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(21,'combustivel',0,50);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(21,'salario',0,50);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(21,'salario',0,50);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(21,'reforma',0,50);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(21,'reforma',0,50);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO andre.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);

--
--
-- Funcoes em SQL e PL/PGSQL
--
-- ================================================================================================================
-- Funcoes em SQL
--
-- Crie uma funcao onde passamos um valor inteiro e retorne ele mais 1
--
create function soma1sql(integer) returns integer as
'
       select  $1 + 1
'
language 'sql';
--
-- ================================================================================================================
-- Monte uma função que mostre a quantidade de clientes em uma empresa
-- deverá ser passado o codigo da empresa como parametro.
--
create function qtd_clientes_empresas(integer) returns bigint as
'
       select count(*) from clientes where fkempresa = $1
'
language 'sql';
--
-- ================================================================================================================
-- Monte uma função que mostre a quantidade de contas por clientes
--
create or replace function Contas_Clientes(integer) returns bigint as
'
       select count(*) from contas where fkcliente = $1
'
language 'sql';
--
-- ================================================================================================================
-- Crie uma função para inserir ao mesmo tempo o  nome da empresa e o nome 	
-- de um cliente retornando o id da empresa.
--
create or replace function empresa_cliente(varchar,varchar) returns bigint as
'
       insert into empresas(nome) values($1);
       insert into clientes(fkempresa,nome) 	values(currval(''empresas_id_seq''),$2);
       select currval(''empresas_id_seq'') as id_empresa
'
language 'sql';
--
-- ================================================================================================================
-- Crie uma função que retorne quem deve
--
create function quemdeve() returns setof integer as
'
       select clientes.id from clientes inner join contas on clientes.id = 	contas.fkcliente
       inner join movimentos on contas.id=movimentos.fkconta
       group by clientes.id
       having sum(credito-debito)<0
' language 'sql';
--
-- ================================================================================================================
-- Retornando uma query
--
create or replace function listaclientes() returns setof clientes as
'
select * from clientes
'
language 'sql';
--
-- ================================================================================================================
-- Retornando uma query
--
create or replace function ListaClientesID(integer) returns setof clientes as
'
select * from clientes where id = $1
'
language 'sql';
--
-- ================================================================================================================
--
-- Funcoes em PL/PGSQL
--
-- Crie uma função que some 1 a um número passado
--
create or replace function soma1(integer) returns integer as
'
declare
       valor alias for $1;
       x integer;
begin
     x:=1;
     x:=x+valor;
     return x;
end;
'
language 'plpgsql';
--
-- ================================================================================================================
-- Crie a mesma função que insira o nome da empresa e o nome do cliente retornando o id de ambos
--
create or replace function empresa_cliente_id(varchar,varchar) returns _int4 as
'
declare
	nempresa alias for $1;
	ncliente alias for $2;
	empresaid integer;
	clienteid integer;
begin
	insert into empresas(nome) values(nempresa);
	insert into clientes(fkempresa,nome) values(currval(''empresas_id_seq''),ncliente);

	empresaid := currval(''empresas_id_seq'');
	clienteid := currval(''clientes_id_seq'');

	return ''{''|| empresaid ||'',''|| clienteid ||''}'';
end;
'
language 'plpgsql';
--
-- ================================================================================================================
-- Crie uma função onde passamos como parâmetro o id do cliente e seja retornado o seu nome
--
create or replace function id_nome_cliente(integer) returns text as
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
--
create or replace function clientes_nomes() returns text as
'
declare
       x text;
       r record;
begin
     x:=''Inicio'';
     for r in select * from clientes order by id loop
         x:= x||'' : ''||r.nome;
     end loop;
     return x||'' : fim'';
end;
'
language 'plpgsql';
--
-- ================================================================================================================
-- Atualizando o saldo de uma conta devera ser passado o id da conta
--
create or replace function saldo_upd_conta(integer) returns numeric(12,2) as
'
       update contas set saldo = (
       select sum(movimentos.credito-movimentos.debito)
       from movimentos where movimentos.fkconta = $1) where id = $1;
       select sum(movimentos.credito-movimentos.debito) from movimentos where movimentos.fkconta = $1;
'
language 'sql';
--
-- ================================================================================================================
-- Atualizando o saldo de uma conta devera ser passado o id da conta
--
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
language 'plpgsql';
--
-- ================================================================================================================
-- Atualizando o saldo de todas as contas
--
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
--
-- ================================================================================================================
--
-- Trigger's
--
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Exemplo 1 - Log de Insert, Update e Delete da tabela precos
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--
--
-- Passo 01 - Criacao da function
--
--
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
--
-- Passo 02 - Criacao da trigger
-- Trigger para
-- before (antes de insert ou update)
--
create trigger precos_log_ins_upd
before insert or update
on precos
for each row
execute procedure precos_log();
--
-- Trigger para
-- after (apos ter deletado)
--
create trigger precos_log_del
after delete
on precos
for each row
execute procedure precos_log();
--
--
-- ================================================================================================================
-- ++++++++++++++++++++++++++++++++++++++++++++++++
-- Exemplo 1.2 - Utilizando o Exemplo 01 com view's
-- ++++++++++++++++++++++++++++++++++++++++++++++++
--
-- Passo 01 - Criar a view
--
create view v_precos as
select id, produto, valor from precos;
-- Passo 02 - Criar as regras para ins, upd e del
-- Regra para Insert
create rule rv_precos_ins as
on insert to v_precos
do instead
insert into precos(produto,valor) values(new.produto,new.valor);
--
-- Regra para Update
--
create rule rv_precos_upd as
on update to v_precos
do instead
update precos
set
   produto = new.produto,
   valor = new.valor
   where id = old.id;
--
-- Regra para Delete
--
create rule rv_precos_del as
on delete to v_precos
do instead
delete from precos
where id = old.id;
-- Passo 03 - Executar os comandos
-- insert, update ou delete
--
-- ================================================================================================================
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
-- ================================================================================================================
\connect pgteste michela

-- ==========================================================================================================
-- Esquema michela
--

--
-- Criando a tabela michela.empresas
--
CREATE TABLE michela.empresas(
			id 		SERIAL 		PRIMARY KEY,
			nome 		VARCHAR(50),
			dtcadastro 	DATE,
			telcom 		VARCHAR(20),
			site 		VARCHAR(40),
			email 		VARCHAR(40),
			saldo		NUMERIC(12,2)	DEFAULT 0,
			obs             TEXT
);
--
--
-- Criando a tabela michela.clientes
--
CREATE TABLE michela.clientes(
			id 		SERIAL 		PRIMARY KEY,
			fkempresa 	INTEGER,
			nome 		VARCHAR(50),
			dtnascimento 	DATE,
			telres 		VARCHAR(20),
			site 		VARCHAR(40),
			email 		VARCHAR(40),
			saldo		NUMERIC(12,2)	DEFAULT 0,
			obs             TEXT,
			CONSTRAINT michela_empresas_clientes FOREIGN KEY(fkempresa)
							REFERENCES michela.empresas(id)
							ON DELETE RESTRICT
							ON UPDATE CASCADE
					
);
--
--
-- Criando a tabela michela.contas
--
CREATE TABLE michela.contas(
			id 		SERIAL 		PRIMARY KEY,
			fkcliente 	INTEGER,
			nome 		VARCHAR(50),
			dtabertura	DATE,
			saldo		NUMERIC(12,2)	DEFAULT 0,
			CONSTRAINT michela_clientes_contas FOREIGN KEY(fkcliente)
							REFERENCES michela.clientes(id)
							ON DELETE RESTRICT
							ON UPDATE CASCADE
);
--
--
-- Criando a TABLE a michela.movimentos
--
CREATE TABLE michela.movimentos(
			id 		SERIAL 		PRIMARY KEY,
			fkconta 	INTEGER,
			historico 	VARCHAR(50),
			credito 	NUMERIC(11,2)	DEFAULT 0,
			debito 		NUMERIC(11,2)	DEFAULT 0,
			CONSTRAINT michela_contas_movimentos FOREIGN KEY(fkconta)
							REFERENCES michela.contas(id)
							ON DELETE RESTRICT
							ON UPDATE CASCADE
);
--
--
-- Criando a tabela movempresas
--
CREATE TABLE michela.movempresas(
			id 		SERIAL 		PRIMARY KEY,
			fkempresa 	INTEGER,
			historico 	VARCHAR(50),
			credito 	NUMERIC(11,2)	DEFAULT 0,
			debito 		NUMERIC(11,2)	DEFAULT 0,
			CONSTRAINT michela_empresas_movempresas FOREIGN KEY(fkempresa)
							REFERENCES michela.empresas(id)
							ON DELETE RESTRICT
							ON UPDATE CASCADE
);
--
--
-- Criando a tabela precos
--
CREATE TABLE michela.precos(
                        id           SERIAL PRIMARY KEY,
                        produto      VARCHAR(30),
                        valor        NUMERIC(11,2), 	
                        data_ins     TIMESTAMP,
                        user_ins     TEXT,
                        data_atu     TIMESTAMP,
                        user_atu     TEXT
);
--
--
-- Criando a tabela precos_log_del
--
CREATE TABLE michela.precos_log_del(
                        id           INTEGER,
                        produto      VARCHAR(30),
                        valor        NUMERIC(11,2), 	
                        data_ins     TIMESTAMP,
                        user_ins     TEXT,
                        data_atu     TIMESTAMP,
                        user_atu     TEXT,
                        data_del     TIMESTAMP,
                        user_del     TEXT
);
--
--
-- Inserindo registros na tabela michela.empresas
--
INSERT INTO michela.empresas(nome,dtcadastro,telcom,site,email) VALUES('MundoByte Informatica',	'1995-11-11',	'222-0909',	'www.mundobyte.com.br',	'relacoes@mundobyte.com.br');
INSERT INTO michela.empresas(nome,dtcadastro,telcom,site,email) VALUES('TecTel - informatica',	'1995-01-09',	'333-0909',	'www.tectel.com.br',	'info@tectel.com.br');
INSERT INTO michela.empresas(nome,dtcadastro,telcom,site,email) VALUES('Vulcano S/A',		'2002-10-31',	'211-0909',	'www.vulcano.com.br',	'informacoes@vulcano.com.br');
INSERT INTO michela.empresas(nome,dtcadastro,telcom,site,email) VALUES('Softmax',		'2000-10-05',	'211-0909',	'www.vulcano.com.br',	'softmax@softmax.com.br');
--
--
-- Inserindo registros na tabela michela.clientes
--
INSERT INTO michela.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(1,	'Rodrigo de Oliveira Silva',		'1973-12-12',	'3434-0909',	' ',			'rodrigo@ig.com.br');
INSERT INTO michela.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(2,	'Melissa Pereira da Silva',		'1970-01-04',	'4444-0011',	'www.mwbrasil.com.br ',	'rose@ig.com.br');
INSERT INTO michela.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(2,	'Elisangela Almeida de Oliveira',	'1973-10-31',	'3434-7879',	' ',			'eli@brfree.com.br');
INSERT INTO michela.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(3,	'Andre Tritapepe de Matias',		'1973-12-31',	'3434-8596',	' ',			'andre@trita.com.br');
INSERT INTO michela.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(3,	'Michela Almeida de Alcantara',		'1980-04-01',	'8888-0101',	' ',			'michela@psico.com.br');
INSERT INTO michela.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(3,	'Paulo Rogerio de Oliveira',		'1973-10-11',	'7777-0405',	'www.proger.com',	'paulo@proger.com.br');
INSERT INTO michela.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(4,	'Cristina Pereira Matos',		'1970-10-11',	'2222-7885',	'www.santista.com',	'cristina@uol.com.br');
INSERT INTO michela.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(4,	'Fabia Castilho Almeida',		'1981-10-11',	'4545-4596',	'www.castilho.com',	'fabia@terra.com.br');
INSERT INTO michela.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(4,	'michela Cristovao Santos',		'1980-10-11',	'2202-7272',	'',			'michela@terra.com.br');
INSERT INTO michela.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(4,	'michelasa Santos Matias',		'1990-10-11',	'1010-1396',	'',			'michelasa@brfree.com.br');
--
--
-- Inserindo registros na tabela michela.contas
--
INSERT INTO michela.contas(fkcliente,nome,dtabertura) VALUES(1,'semana01','2002-10-01');
INSERT INTO michela.contas(fkcliente,nome,dtabertura) VALUES(2,'semana02','2002-10-20');
INSERT INTO michela.contas(fkcliente,nome,dtabertura) VALUES(2,'semana03','2002-09-10');
INSERT INTO michela.contas(fkcliente,nome,dtabertura) VALUES(3,'semana04','2002-09-03');
INSERT INTO michela.contas(fkcliente,nome,dtabertura) VALUES(3,'semana05','2002-01-01');
INSERT INTO michela.contas(fkcliente,nome,dtabertura) VALUES(3,'semana06','2002-02-15');
INSERT INTO michela.contas(fkcliente,nome,dtabertura) VALUES(4,'semana07','2002-05-01');
INSERT INTO michela.contas(fkcliente,nome,dtabertura) VALUES(4,'semana08','2002-06-09');
INSERT INTO michela.contas(fkcliente,nome,dtabertura) VALUES(4,'semana09','2002-07-01');
INSERT INTO michela.contas(fkcliente,nome,dtabertura) VALUES(4,'semana10','2002-10-11');
INSERT INTO michela.contas(fkcliente,nome,dtabertura) VALUES(5,'semana11','2002-10-10');
INSERT INTO michela.contas(fkcliente,nome,dtabertura) VALUES(5,'semana12','2002-10-01');
INSERT INTO michela.contas(fkcliente,nome,dtabertura) VALUES(5,'semana13','2002-07-20');
INSERT INTO michela.contas(fkcliente,nome,dtabertura) VALUES(5,'semana14','2002-06-01');
INSERT INTO michela.contas(fkcliente,nome,dtabertura) VALUES(5,'semana15','2002-05-07');
INSERT INTO michela.contas(fkcliente,nome,dtabertura) VALUES(6,'semana16','2002-02-01');
INSERT INTO michela.contas(fkcliente,nome,dtabertura) VALUES(6,'semana17','2002-01-08');
INSERT INTO michela.contas(fkcliente,nome,dtabertura) VALUES(6,'semana18','2002-09-01');
INSERT INTO michela.contas(fkcliente,nome,dtabertura) VALUES(6,'semana19','2002-09-04');
INSERT INTO michela.contas(fkcliente,nome,dtabertura) VALUES(6,'semana20','2002-10-28');
INSERT INTO michela.contas(fkcliente,nome,dtabertura) VALUES(6,'semana21','2002-10-28');
--
--
-- Inserindo registros na tabela michela.movimentos
--
-- michela.movimentos da conta 1
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(1,'salario',2000,0);
-- michela.movimentos da conta 2
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(2,'vendas',50000,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(2,'luz',0,200);
-- michela.movimentos da conta 3
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(3,'vendas',0,2000);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(3,'combustivel',5000,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(3,'luz',0,200);
-- michela.movimentos da conta 4
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(4,'combustivel',500,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(4,'luz',0,200);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(4,'vendas',0,2000);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(4,'combustivel',10,0);
-- michela.movimentos da conta 5
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(5,'combustivel',100,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(5,'luz',0,200);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(5,'combustivel',50,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(5,'vendas',0,2000);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(5,'combustivel',30,0);
-- michela.movimentos da conta 6
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(6,'luz',0,200);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(6,'vendas',0,3000);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(6,'combustivel',10,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(6,'vendas',0,200);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(6,'combustivel',10,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(6,'luz',0,200);
-- michela.movimentos da conta 7
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(7,'combustivel',700,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(7,'vendas',0,10000);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(7,'combustivel',500,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(7,'combustivel',30,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(7,'vendas',0,20000);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(7,'combustivel',90,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(7,'luz',0,200);
-- michela.movimentos da conta 8
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(8,'combustivel',900,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(8,'vendas',0,3000);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(8,'combustivel',300,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(8,'combustivel',300,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(8,'vendas',0,5000);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(8,'luz',0,200);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(8,'luz',0,200);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(8,'combustivel',10,0);
-- michela.movimentos da conta 9
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(9,'combustivel',400,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(9,'vendas',0,7000);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(9,'combustivel',10,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(9,'combustivel',10,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(9,'combustivel',100,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(9,'vendas',0,6000);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(9,'vendas',0,4000);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(9,'combustivel',100,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(9,'luz',0,200);
-- michela.movimentos da conta 10
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(10,'combustivel',300,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(10,'combustivel',40,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(10,'vendas',0,20);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(10,'combustivel',10,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(10,'combustivel',110,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(10,'luz',0,200);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(10,'combustivel',100,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(10,'combustivel',100,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(10,'vendas',0,2500);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(10,'vendas',0,2600);
-- michela.movimentos da conta 11
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(11,'luz',0,50);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(11,'salario',5000,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(11,'manutencao',0,50000);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(11,'supermercado',0,3000);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(11,'manutencao',0,8000);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(11,'escritorio',0,5000);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(11,'carro',0,36000);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(11,'predio',0,60000);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(11,'vendas',7000,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(11,'luz',0,8000);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(11,'manutencao',0,4000);
-- michela.movimentos da conta 12
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(12,'vendas',4000,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(12,'escritorio',0,50000);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(12,'manutencao',0,40000);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(12,'vendas',10000,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(12,'escritorio',0,70000);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(12,'manutencao',0,4000);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(12,'vendas',80000,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(12,'escritorio',0,20000);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(12,'manutencao',0,4000);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(12,'vendas',10000,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(12,'escritorio',0,5000);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(12,'manutencao',0,10000);
-- michela.movimentos da conta 13
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
-- michela.movimentos da conta 14
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',20000,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(14,'salario',8000,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',2000,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(14,'salario',5000,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',9000,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(14,'salario',6000,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',3000,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(14,'salario',9000,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',8000,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(14,'salario',7000,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',9000,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(14,'supermercado',0,5000);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',2000,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(14,'combustivel',9000,0);
-- michela.movimentos da conta 15
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(15,'combustivel',0,2000);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(15,'combustivel',0,2000);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(15,'escritorio',0,2000);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(15,'escritorio',0,2000);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(15,'escritorio',0,2000);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
-- michela.movimentos da conta 16
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas',5000,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas',5000,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas',5000,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas',5000,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas loja',5000,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas loja',5000,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas loja',5000,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(16,'suporte',5000,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(16,'suporte',5000,0);
-- michela.movimentos da conta 17
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(17,'escritorio',0,500);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(17,'combustivel',0,500);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(17,'combustivel',0,500);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(17,'combustivel',0,500);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(17,'carro',0,500);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(17,'carro',0,500);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
-- michela.movimentos da conta 18
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(18,'suporte',8000,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(18,'vendas loja',8000,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(18,'vendas loja',8000,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(18,'vendas loja',8000,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(18,'vendas loja',8000,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(18,'suporte',8000,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(18,'suporte',8000,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(18,'suporte',8000,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(18,'suporte',8000,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(18,'suporte',8000,0);
-- michela.movimentos da conta 19
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(19,'caixa interno',0,500);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(19,'caixa interno',0,500);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(19,'caixa interno',0,500);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(19,'predio',0,500);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(19,'predio',0,500);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(19,'predio',0,500);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(19,'predio',0,500);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(19,'predio',0,500);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
-- michela.movimentos da conta 20
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(20,'vendas',8000,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(20,'vendas',8000,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(20,'vendas',8000,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(20,'suporte ',8000,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(20,'suporte ',8000,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(20,'suporte ',8000,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(20,'suporte ',8000,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(20,'suporte ',8000,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(20,'vendas',8000,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(20,'vendas',8000,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(20,'vendas',8000,0);
-- michela.movimentos da conta 21
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(21,'combustivel',0,50);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(21,'reforma',0,50);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(21,'manutencao',0,50);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(21,'combustivel',0,50);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(21,'salario',0,50);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(21,'salario',0,50);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(21,'reforma',0,50);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(21,'reforma',0,50);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO michela.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);

--
--
-- Funcoes em SQL e PL/PGSQL
--
-- ================================================================================================================
-- Funcoes em SQL
--
-- Crie uma funcao onde passamos um valor inteiro e retorne ele mais 1
--
create function soma1sql(integer) returns integer as
'
       select  $1 + 1
'
language 'sql';
--
-- ================================================================================================================
-- Monte uma função que mostre a quantidade de clientes em uma empresa
-- deverá ser passado o codigo da empresa como parametro.
--
create function qtd_clientes_empresas(integer) returns bigint as
'
       select count(*) from clientes where fkempresa = $1
'
language 'sql';
--
-- ================================================================================================================
-- Monte uma função que mostre a quantidade de contas por clientes
--
create or replace function Contas_Clientes(integer) returns bigint as
'
       select count(*) from contas where fkcliente = $1
'
language 'sql';
--
-- ================================================================================================================
-- Crie uma função para inserir ao mesmo tempo o  nome da empresa e o nome 	
-- de um cliente retornando o id da empresa.
--
create or replace function empresa_cliente(varchar,varchar) returns bigint as
'
       insert into empresas(nome) values($1);
       insert into clientes(fkempresa,nome) 	values(currval(''empresas_id_seq''),$2);
       select currval(''empresas_id_seq'') as id_empresa
'
language 'sql';
--
-- ================================================================================================================
-- Crie uma função que retorne quem deve
--
create function quemdeve() returns setof integer as
'
       select clientes.id from clientes inner join contas on clientes.id = 	contas.fkcliente
       inner join movimentos on contas.id=movimentos.fkconta
       group by clientes.id
       having sum(credito-debito)<0
' language 'sql';
--
-- ================================================================================================================
-- Retornando uma query
--
create or replace function listaclientes() returns setof clientes as
'
select * from clientes
'
language 'sql';
--
-- ================================================================================================================
-- Retornando uma query
--
create or replace function ListaClientesID(integer) returns setof clientes as
'
select * from clientes where id = $1
'
language 'sql';
--
-- ================================================================================================================
--
-- Funcoes em PL/PGSQL
--
-- Crie uma função que some 1 a um número passado
--
create or replace function soma1(integer) returns integer as
'
declare
       valor alias for $1;
       x integer;
begin
     x:=1;
     x:=x+valor;
     return x;
end;
'
language 'plpgsql';
--
-- ================================================================================================================
-- Crie a mesma função que insira o nome da empresa e o nome do cliente retornando o id de ambos
--
create or replace function empresa_cliente_id(varchar,varchar) returns _int4 as
'
declare
	nempresa alias for $1;
	ncliente alias for $2;
	empresaid integer;
	clienteid integer;
begin
	insert into empresas(nome) values(nempresa);
	insert into clientes(fkempresa,nome) values(currval(''empresas_id_seq''),ncliente);

	empresaid := currval(''empresas_id_seq'');
	clienteid := currval(''clientes_id_seq'');

	return ''{''|| empresaid ||'',''|| clienteid ||''}'';
end;
'
language 'plpgsql';
--
-- ================================================================================================================
-- Crie uma função onde passamos como parâmetro o id do cliente e seja retornado o seu nome
--
create or replace function id_nome_cliente(integer) returns text as
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
--
create or replace function clientes_nomes() returns text as
'
declare
       x text;
       r record;
begin
     x:=''Inicio'';
     for r in select * from clientes order by id loop
         x:= x||'' : ''||r.nome;
     end loop;
     return x||'' : fim'';
end;
'
language 'plpgsql';
--
-- ================================================================================================================
-- Atualizando o saldo de uma conta devera ser passado o id da conta
--
create or replace function saldo_upd_conta(integer) returns numeric(12,2) as
'
       update contas set saldo = (
       select sum(movimentos.credito-movimentos.debito)
       from movimentos where movimentos.fkconta = $1) where id = $1;
       select sum(movimentos.credito-movimentos.debito) from movimentos where movimentos.fkconta = $1;
'
language 'sql';
--
-- ================================================================================================================
-- Atualizando o saldo de uma conta devera ser passado o id da conta
--
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
language 'plpgsql';
--
-- ================================================================================================================
-- Atualizando o saldo de todas as contas
--
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
--
-- ================================================================================================================
--
-- Trigger's
--
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Exemplo 1 - Log de Insert, Update e Delete da tabela precos
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--
--
-- Passo 01 - Criacao da function
--
--
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
--
-- Passo 02 - Criacao da trigger
-- Trigger para
-- before (antes de insert ou update)
--
create trigger precos_log_ins_upd
before insert or update
on precos
for each row
execute procedure precos_log();
--
-- Trigger para
-- after (apos ter deletado)
--
create trigger precos_log_del
after delete
on precos
for each row
execute procedure precos_log();
--
--
-- ================================================================================================================
-- ++++++++++++++++++++++++++++++++++++++++++++++++
-- Exemplo 1.2 - Utilizando o Exemplo 01 com view's
-- ++++++++++++++++++++++++++++++++++++++++++++++++
--
-- Passo 01 - Criar a view
--
create view v_precos as
select id, produto, valor from precos;
-- Passo 02 - Criar as regras para ins, upd e del
-- Regra para Insert
create rule rv_precos_ins as
on insert to v_precos
do instead
insert into precos(produto,valor) values(new.produto,new.valor);
--
-- Regra para Update
--
create rule rv_precos_upd as
on update to v_precos
do instead
update precos
set
   produto = new.produto,
   valor = new.valor
   where id = old.id;
--
-- Regra para Delete
--
create rule rv_precos_del as
on delete to v_precos
do instead
delete from precos
where id = old.id;
-- Passo 03 - Executar os comandos
-- insert, update ou delete
--
-- ================================================================================================================
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
--==============================================================================================
\connect pgteste roger

-- ==========================================================================================================
-- Esquema roger
--

--
-- Criando a tabela roger.empresas
--
CREATE TABLE roger.empresas(
			id 		SERIAL 		PRIMARY KEY,
			nome 		VARCHAR(50),
			dtcadastro 	DATE,
			telcom 		VARCHAR(20),
			site 		VARCHAR(40),
			email 		VARCHAR(40),
			saldo		NUMERIC(12,2)	DEFAULT 0,
			obs             TEXT
);
--
--
-- Criando a tabela roger.clientes
--
CREATE TABLE roger.clientes(
			id 		SERIAL 		PRIMARY KEY,
			fkempresa 	INTEGER,
			nome 		VARCHAR(50),
			dtnascimento 	DATE,
			telres 		VARCHAR(20),
			site 		VARCHAR(40),
			email 		VARCHAR(40),
			saldo		NUMERIC(12,2)	DEFAULT 0,
			obs             TEXT,
			CONSTRAINT roger_empresas_clientes FOREIGN KEY(fkempresa)
							REFERENCES roger.empresas(id)
							ON DELETE RESTRICT
							ON UPDATE CASCADE
					
);
--
--
-- Criando a tabela roger.contas
--
CREATE TABLE roger.contas(
			id 		SERIAL 		PRIMARY KEY,
			fkcliente 	INTEGER,
			nome 		VARCHAR(50),
			dtabertura	DATE,
			saldo		NUMERIC(12,2)	DEFAULT 0,
			CONSTRAINT roger_clientes_contas FOREIGN KEY(fkcliente)
							REFERENCES roger.clientes(id)
							ON DELETE RESTRICT
							ON UPDATE CASCADE
);
--
--
-- Criando a TABLE a roger.movimentos
--
CREATE TABLE roger.movimentos(
			id 		SERIAL 		PRIMARY KEY,
			fkconta 	INTEGER,
			historico 	VARCHAR(50),
			credito 	NUMERIC(11,2)	DEFAULT 0,
			debito 		NUMERIC(11,2)	DEFAULT 0,
			CONSTRAINT roger_contas_movimentos FOREIGN KEY(fkconta)
							REFERENCES roger.contas(id)
							ON DELETE RESTRICT
							ON UPDATE CASCADE
);
--
--
-- Criando a tabela movempresas
--
CREATE TABLE roger.movempresas(
			id 		SERIAL 		PRIMARY KEY,
			fkempresa 	INTEGER,
			historico 	VARCHAR(50),
			credito 	NUMERIC(11,2)	DEFAULT 0,
			debito 		NUMERIC(11,2)	DEFAULT 0,
			CONSTRAINT roger_empresas_movempresas FOREIGN KEY(fkempresa)
							REFERENCES roger.empresas(id)
							ON DELETE RESTRICT
							ON UPDATE CASCADE
);
--
--
-- Criando a tabela precos
--
CREATE TABLE roger.precos(
                        id           SERIAL PRIMARY KEY,
                        produto      VARCHAR(30),
                        valor        NUMERIC(11,2), 	
                        data_ins     TIMESTAMP,
                        user_ins     TEXT,
                        data_atu     TIMESTAMP,
                        user_atu     TEXT
);
--
--
-- Criando a tabela precos_log_del
--
CREATE TABLE roger.precos_log_del(
                        id           INTEGER,
                        produto      VARCHAR(30),
                        valor        NUMERIC(11,2), 	
                        data_ins     TIMESTAMP,
                        user_ins     TEXT,
                        data_atu     TIMESTAMP,
                        user_atu     TEXT,
                        data_del     TIMESTAMP,
                        user_del     TEXT
);
--
--
-- Inserindo registros na tabela roger.empresas
--
INSERT INTO roger.empresas(nome,dtcadastro,telcom,site,email) VALUES('MundoByte Informatica',	'1995-11-11',	'222-0909',	'www.mundobyte.com.br',	'relacoes@mundobyte.com.br');
INSERT INTO roger.empresas(nome,dtcadastro,telcom,site,email) VALUES('TecTel - informatica',	'1995-01-09',	'333-0909',	'www.tectel.com.br',	'info@tectel.com.br');
INSERT INTO roger.empresas(nome,dtcadastro,telcom,site,email) VALUES('Vulcano S/A',		'2002-10-31',	'211-0909',	'www.vulcano.com.br',	'informacoes@vulcano.com.br');
INSERT INTO roger.empresas(nome,dtcadastro,telcom,site,email) VALUES('Softmax',		'2000-10-05',	'211-0909',	'www.vulcano.com.br',	'softmax@softmax.com.br');
--
--
-- Inserindo registros na tabela roger.clientes
--
INSERT INTO roger.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(1,	'Rodrigo de Oliveira Silva',		'1973-12-12',	'3434-0909',	' ',			'rodrigo@ig.com.br');
INSERT INTO roger.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(2,	'Melissa Pereira da Silva',		'1970-01-04',	'4444-0011',	'www.mwbrasil.com.br ',	'rose@ig.com.br');
INSERT INTO roger.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(2,	'Elisangela Almeida de Oliveira',	'1973-10-31',	'3434-7879',	' ',			'eli@brfree.com.br');
INSERT INTO roger.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(3,	'Andre Tritapepe de Matias',		'1973-12-31',	'3434-8596',	' ',			'andre@trita.com.br');
INSERT INTO roger.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(3,	'Michela Almeida de Alcantara',		'1980-04-01',	'8888-0101',	' ',			'michela@psico.com.br');
INSERT INTO roger.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(3,	'Paulo Rogerio de Oliveira',		'1973-10-11',	'7777-0405',	'www.proger.com',	'paulo@proger.com.br');
INSERT INTO roger.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(4,	'Cristina Pereira Matos',		'1970-10-11',	'2222-7885',	'www.santista.com',	'cristina@uol.com.br');
INSERT INTO roger.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(4,	'Fabia Castilho Almeida',		'1981-10-11',	'4545-4596',	'www.castilho.com',	'fabia@terra.com.br');
INSERT INTO roger.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(4,	'roger Cristovao Santos',		'1980-10-11',	'2202-7272',	'',			'roger@terra.com.br');
INSERT INTO roger.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(4,	'rogersa Santos Matias',		'1990-10-11',	'1010-1396',	'',			'rogersa@brfree.com.br');
--
--
-- Inserindo registros na tabela roger.contas
--
INSERT INTO roger.contas(fkcliente,nome,dtabertura) VALUES(1,'semana01','2002-10-01');
INSERT INTO roger.contas(fkcliente,nome,dtabertura) VALUES(2,'semana02','2002-10-20');
INSERT INTO roger.contas(fkcliente,nome,dtabertura) VALUES(2,'semana03','2002-09-10');
INSERT INTO roger.contas(fkcliente,nome,dtabertura) VALUES(3,'semana04','2002-09-03');
INSERT INTO roger.contas(fkcliente,nome,dtabertura) VALUES(3,'semana05','2002-01-01');
INSERT INTO roger.contas(fkcliente,nome,dtabertura) VALUES(3,'semana06','2002-02-15');
INSERT INTO roger.contas(fkcliente,nome,dtabertura) VALUES(4,'semana07','2002-05-01');
INSERT INTO roger.contas(fkcliente,nome,dtabertura) VALUES(4,'semana08','2002-06-09');
INSERT INTO roger.contas(fkcliente,nome,dtabertura) VALUES(4,'semana09','2002-07-01');
INSERT INTO roger.contas(fkcliente,nome,dtabertura) VALUES(4,'semana10','2002-10-11');
INSERT INTO roger.contas(fkcliente,nome,dtabertura) VALUES(5,'semana11','2002-10-10');
INSERT INTO roger.contas(fkcliente,nome,dtabertura) VALUES(5,'semana12','2002-10-01');
INSERT INTO roger.contas(fkcliente,nome,dtabertura) VALUES(5,'semana13','2002-07-20');
INSERT INTO roger.contas(fkcliente,nome,dtabertura) VALUES(5,'semana14','2002-06-01');
INSERT INTO roger.contas(fkcliente,nome,dtabertura) VALUES(5,'semana15','2002-05-07');
INSERT INTO roger.contas(fkcliente,nome,dtabertura) VALUES(6,'semana16','2002-02-01');
INSERT INTO roger.contas(fkcliente,nome,dtabertura) VALUES(6,'semana17','2002-01-08');
INSERT INTO roger.contas(fkcliente,nome,dtabertura) VALUES(6,'semana18','2002-09-01');
INSERT INTO roger.contas(fkcliente,nome,dtabertura) VALUES(6,'semana19','2002-09-04');
INSERT INTO roger.contas(fkcliente,nome,dtabertura) VALUES(6,'semana20','2002-10-28');
INSERT INTO roger.contas(fkcliente,nome,dtabertura) VALUES(6,'semana21','2002-10-28');
--
--
-- Inserindo registros na tabela roger.movimentos
--
-- roger.movimentos da conta 1
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(1,'salario',2000,0);
-- roger.movimentos da conta 2
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(2,'vendas',50000,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(2,'luz',0,200);
-- roger.movimentos da conta 3
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(3,'vendas',0,2000);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(3,'combustivel',5000,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(3,'luz',0,200);
-- roger.movimentos da conta 4
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(4,'combustivel',500,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(4,'luz',0,200);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(4,'vendas',0,2000);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(4,'combustivel',10,0);
-- roger.movimentos da conta 5
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(5,'combustivel',100,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(5,'luz',0,200);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(5,'combustivel',50,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(5,'vendas',0,2000);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(5,'combustivel',30,0);
-- roger.movimentos da conta 6
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(6,'luz',0,200);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(6,'vendas',0,3000);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(6,'combustivel',10,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(6,'vendas',0,200);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(6,'combustivel',10,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(6,'luz',0,200);
-- roger.movimentos da conta 7
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(7,'combustivel',700,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(7,'vendas',0,10000);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(7,'combustivel',500,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(7,'combustivel',30,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(7,'vendas',0,20000);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(7,'combustivel',90,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(7,'luz',0,200);
-- roger.movimentos da conta 8
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(8,'combustivel',900,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(8,'vendas',0,3000);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(8,'combustivel',300,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(8,'combustivel',300,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(8,'vendas',0,5000);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(8,'luz',0,200);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(8,'luz',0,200);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(8,'combustivel',10,0);
-- roger.movimentos da conta 9
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(9,'combustivel',400,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(9,'vendas',0,7000);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(9,'combustivel',10,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(9,'combustivel',10,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(9,'combustivel',100,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(9,'vendas',0,6000);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(9,'vendas',0,4000);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(9,'combustivel',100,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(9,'luz',0,200);
-- roger.movimentos da conta 10
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(10,'combustivel',300,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(10,'combustivel',40,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(10,'vendas',0,20);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(10,'combustivel',10,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(10,'combustivel',110,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(10,'luz',0,200);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(10,'combustivel',100,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(10,'combustivel',100,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(10,'vendas',0,2500);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(10,'vendas',0,2600);
-- roger.movimentos da conta 11
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(11,'luz',0,50);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(11,'salario',5000,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(11,'manutencao',0,50000);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(11,'supermercado',0,3000);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(11,'manutencao',0,8000);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(11,'escritorio',0,5000);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(11,'carro',0,36000);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(11,'predio',0,60000);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(11,'vendas',7000,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(11,'luz',0,8000);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(11,'manutencao',0,4000);
-- roger.movimentos da conta 12
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(12,'vendas',4000,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(12,'escritorio',0,50000);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(12,'manutencao',0,40000);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(12,'vendas',10000,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(12,'escritorio',0,70000);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(12,'manutencao',0,4000);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(12,'vendas',80000,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(12,'escritorio',0,20000);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(12,'manutencao',0,4000);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(12,'vendas',10000,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(12,'escritorio',0,5000);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(12,'manutencao',0,10000);
-- roger.movimentos da conta 13
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
-- roger.movimentos da conta 14
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',20000,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(14,'salario',8000,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',2000,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(14,'salario',5000,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',9000,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(14,'salario',6000,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',3000,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(14,'salario',9000,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',8000,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(14,'salario',7000,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',9000,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(14,'supermercado',0,5000);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',2000,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(14,'combustivel',9000,0);
-- roger.movimentos da conta 15
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(15,'combustivel',0,2000);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(15,'combustivel',0,2000);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(15,'escritorio',0,2000);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(15,'escritorio',0,2000);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(15,'escritorio',0,2000);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
-- roger.movimentos da conta 16
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas',5000,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas',5000,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas',5000,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas',5000,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas loja',5000,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas loja',5000,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas loja',5000,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(16,'suporte',5000,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(16,'suporte',5000,0);
-- roger.movimentos da conta 17
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(17,'escritorio',0,500);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(17,'combustivel',0,500);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(17,'combustivel',0,500);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(17,'combustivel',0,500);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(17,'carro',0,500);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(17,'carro',0,500);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
-- roger.movimentos da conta 18
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(18,'suporte',8000,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(18,'vendas loja',8000,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(18,'vendas loja',8000,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(18,'vendas loja',8000,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(18,'vendas loja',8000,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(18,'suporte',8000,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(18,'suporte',8000,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(18,'suporte',8000,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(18,'suporte',8000,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(18,'suporte',8000,0);
-- roger.movimentos da conta 19
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(19,'caixa interno',0,500);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(19,'caixa interno',0,500);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(19,'caixa interno',0,500);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(19,'predio',0,500);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(19,'predio',0,500);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(19,'predio',0,500);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(19,'predio',0,500);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(19,'predio',0,500);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
-- roger.movimentos da conta 20
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(20,'vendas',8000,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(20,'vendas',8000,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(20,'vendas',8000,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(20,'suporte ',8000,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(20,'suporte ',8000,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(20,'suporte ',8000,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(20,'suporte ',8000,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(20,'suporte ',8000,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(20,'vendas',8000,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(20,'vendas',8000,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(20,'vendas',8000,0);
-- roger.movimentos da conta 21
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(21,'combustivel',0,50);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(21,'reforma',0,50);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(21,'manutencao',0,50);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(21,'combustivel',0,50);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(21,'salario',0,50);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(21,'salario',0,50);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(21,'reforma',0,50);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(21,'reforma',0,50);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO roger.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);

--
--
-- Funcoes em SQL e PL/PGSQL
--
-- ================================================================================================================
-- Funcoes em SQL
--
-- Crie uma funcao onde passamos um valor inteiro e retorne ele mais 1
--
create function soma1sql(integer) returns integer as
'
       select  $1 + 1
'
language 'sql';
--
-- ================================================================================================================
-- Monte uma função que mostre a quantidade de clientes em uma empresa
-- deverá ser passado o codigo da empresa como parametro.
--
create function qtd_clientes_empresas(integer) returns bigint as
'
       select count(*) from clientes where fkempresa = $1
'
language 'sql';
--
-- ================================================================================================================
-- Monte uma função que mostre a quantidade de contas por clientes
--
create or replace function Contas_Clientes(integer) returns bigint as
'
       select count(*) from contas where fkcliente = $1
'
language 'sql';
--
-- ================================================================================================================
-- Crie uma função para inserir ao mesmo tempo o  nome da empresa e o nome 	
-- de um cliente retornando o id da empresa.
--
create or replace function empresa_cliente(varchar,varchar) returns bigint as
'
       insert into empresas(nome) values($1);
       insert into clientes(fkempresa,nome) 	values(currval(''empresas_id_seq''),$2);
       select currval(''empresas_id_seq'') as id_empresa
'
language 'sql';
--
-- ================================================================================================================
-- Crie uma função que retorne quem deve
--
create function quemdeve() returns setof integer as
'
       select clientes.id from clientes inner join contas on clientes.id = 	contas.fkcliente
       inner join movimentos on contas.id=movimentos.fkconta
       group by clientes.id
       having sum(credito-debito)<0
' language 'sql';
--
-- ================================================================================================================
-- Retornando uma query
--
create or replace function listaclientes() returns setof clientes as
'
select * from clientes
'
language 'sql';
--
-- ================================================================================================================
-- Retornando uma query
--
create or replace function ListaClientesID(integer) returns setof clientes as
'
select * from clientes where id = $1
'
language 'sql';
--
-- ================================================================================================================
--
-- Funcoes em PL/PGSQL
--
-- Crie uma função que some 1 a um número passado
--
create or replace function soma1(integer) returns integer as
'
declare
       valor alias for $1;
       x integer;
begin
     x:=1;
     x:=x+valor;
     return x;
end;
'
language 'plpgsql';
--
-- ================================================================================================================
-- Crie a mesma função que insira o nome da empresa e o nome do cliente retornando o id de ambos
--
create or replace function empresa_cliente_id(varchar,varchar) returns _int4 as
'
declare
	nempresa alias for $1;
	ncliente alias for $2;
	empresaid integer;
	clienteid integer;
begin
	insert into empresas(nome) values(nempresa);
	insert into clientes(fkempresa,nome) values(currval(''empresas_id_seq''),ncliente);

	empresaid := currval(''empresas_id_seq'');
	clienteid := currval(''clientes_id_seq'');

	return ''{''|| empresaid ||'',''|| clienteid ||''}'';
end;
'
language 'plpgsql';
--
-- ================================================================================================================
-- Crie uma função onde passamos como parâmetro o id do cliente e seja retornado o seu nome
--
create or replace function id_nome_cliente(integer) returns text as
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
--
create or replace function clientes_nomes() returns text as
'
declare
       x text;
       r record;
begin
     x:=''Inicio'';
     for r in select * from clientes order by id loop
         x:= x||'' : ''||r.nome;
     end loop;
     return x||'' : fim'';
end;
'
language 'plpgsql';
--
-- ================================================================================================================
-- Atualizando o saldo de uma conta devera ser passado o id da conta
--
create or replace function saldo_upd_conta(integer) returns numeric(12,2) as
'
       update contas set saldo = (
       select sum(movimentos.credito-movimentos.debito)
       from movimentos where movimentos.fkconta = $1) where id = $1;
       select sum(movimentos.credito-movimentos.debito) from movimentos where movimentos.fkconta = $1;
'
language 'sql';
--
-- ================================================================================================================
-- Atualizando o saldo de uma conta devera ser passado o id da conta
--
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
language 'plpgsql';
--
-- ================================================================================================================
-- Atualizando o saldo de todas as contas
--
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
--
-- ================================================================================================================
--
-- Trigger's
--
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Exemplo 1 - Log de Insert, Update e Delete da tabela precos
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--
--
-- Passo 01 - Criacao da function
--
--
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
--
-- Passo 02 - Criacao da trigger
-- Trigger para
-- before (antes de insert ou update)
--
create trigger precos_log_ins_upd
before insert or update
on precos
for each row
execute procedure precos_log();
--
-- Trigger para
-- after (apos ter deletado)
--
create trigger precos_log_del
after delete
on precos
for each row
execute procedure precos_log();
--
--
-- ================================================================================================================
-- ++++++++++++++++++++++++++++++++++++++++++++++++
-- Exemplo 1.2 - Utilizando o Exemplo 01 com view's
-- ++++++++++++++++++++++++++++++++++++++++++++++++
--
-- Passo 01 - Criar a view
--
create view v_precos as
select id, produto, valor from precos;
-- Passo 02 - Criar as regras para ins, upd e del
-- Regra para Insert
create rule rv_precos_ins as
on insert to v_precos
do instead
insert into precos(produto,valor) values(new.produto,new.valor);
--
-- Regra para Update
--
create rule rv_precos_upd as
on update to v_precos
do instead
update precos
set
   produto = new.produto,
   valor = new.valor
   where id = old.id;
--
-- Regra para Delete
--
create rule rv_precos_del as
on delete to v_precos
do instead
delete from precos
where id = old.id;
-- Passo 03 - Executar os comandos
-- insert, update ou delete
--
-- ================================================================================================================
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
-- ================================================================================================================
\connect pgteste rodrigo

-- ==========================================================================================================
-- Esquema rodrigo
--

--
-- Criando a tabela rodrigo.empresas
--
CREATE TABLE rodrigo.empresas(
			id 		SERIAL 		PRIMARY KEY,
			nome 		VARCHAR(50),
			dtcadastro 	DATE,
			telcom 		VARCHAR(20),
			site 		VARCHAR(40),
			email 		VARCHAR(40),
			saldo		NUMERIC(12,2)	DEFAULT 0,
			obs             TEXT
);
--
--
-- Criando a tabela rodrigo.clientes
--
CREATE TABLE rodrigo.clientes(
			id 		SERIAL 		PRIMARY KEY,
			fkempresa 	INTEGER,
			nome 		VARCHAR(50),
			dtnascimento 	DATE,
			telres 		VARCHAR(20),
			site 		VARCHAR(40),
			email 		VARCHAR(40),
			saldo		NUMERIC(12,2)	DEFAULT 0,
			obs             TEXT,
			CONSTRAINT rodrigo_empresas_clientes FOREIGN KEY(fkempresa)
							REFERENCES rodrigo.empresas(id)
							ON DELETE RESTRICT
							ON UPDATE CASCADE
					
);
--
--
-- Criando a tabela rodrigo.contas
--
CREATE TABLE rodrigo.contas(
			id 		SERIAL 		PRIMARY KEY,
			fkcliente 	INTEGER,
			nome 		VARCHAR(50),
			dtabertura	DATE,
			saldo		NUMERIC(12,2)	DEFAULT 0,
			CONSTRAINT rodrigo_clientes_contas FOREIGN KEY(fkcliente)
							REFERENCES rodrigo.clientes(id)
							ON DELETE RESTRICT
							ON UPDATE CASCADE
);
--
--
-- Criando a TABLE a rodrigo.movimentos
--
CREATE TABLE rodrigo.movimentos(
			id 		SERIAL 		PRIMARY KEY,
			fkconta 	INTEGER,
			historico 	VARCHAR(50),
			credito 	NUMERIC(11,2)	DEFAULT 0,
			debito 		NUMERIC(11,2)	DEFAULT 0,
			CONSTRAINT rodrigo_contas_movimentos FOREIGN KEY(fkconta)
							REFERENCES rodrigo.contas(id)
							ON DELETE RESTRICT
							ON UPDATE CASCADE
);
--
--
-- Criando a tabela movempresas
--
CREATE TABLE rodrigo.movempresas(
			id 		SERIAL 		PRIMARY KEY,
			fkempresa 	INTEGER,
			historico 	VARCHAR(50),
			credito 	NUMERIC(11,2)	DEFAULT 0,
			debito 		NUMERIC(11,2)	DEFAULT 0,
			CONSTRAINT rodrigo_empresas_movempresas FOREIGN KEY(fkempresa)
							REFERENCES rodrigo.empresas(id)
							ON DELETE RESTRICT
							ON UPDATE CASCADE
);
--
--
-- Criando a tabela precos
--
CREATE TABLE rodrigo.precos(
                        id           SERIAL PRIMARY KEY,
                        produto      VARCHAR(30),
                        valor        NUMERIC(11,2), 	
                        data_ins     TIMESTAMP,
                        user_ins     TEXT,
                        data_atu     TIMESTAMP,
                        user_atu     TEXT
);
--
--
-- Criando a tabela precos_log_del
--
CREATE TABLE rodrigo.precos_log_del(
                        id           INTEGER,
                        produto      VARCHAR(30),
                        valor        NUMERIC(11,2), 	
                        data_ins     TIMESTAMP,
                        user_ins     TEXT,
                        data_atu     TIMESTAMP,
                        user_atu     TEXT,
                        data_del     TIMESTAMP,
                        user_del     TEXT
);
--
--
-- Inserindo registros na tabela rodrigo.empresas
--
INSERT INTO rodrigo.empresas(nome,dtcadastro,telcom,site,email) VALUES('MundoByte Informatica',	'1995-11-11',	'222-0909',	'www.mundobyte.com.br',	'relacoes@mundobyte.com.br');
INSERT INTO rodrigo.empresas(nome,dtcadastro,telcom,site,email) VALUES('TecTel - informatica',	'1995-01-09',	'333-0909',	'www.tectel.com.br',	'info@tectel.com.br');
INSERT INTO rodrigo.empresas(nome,dtcadastro,telcom,site,email) VALUES('Vulcano S/A',		'2002-10-31',	'211-0909',	'www.vulcano.com.br',	'informacoes@vulcano.com.br');
INSERT INTO rodrigo.empresas(nome,dtcadastro,telcom,site,email) VALUES('Softmax',		'2000-10-05',	'211-0909',	'www.vulcano.com.br',	'softmax@softmax.com.br');
--
--
-- Inserindo registros na tabela rodrigo.clientes
--
INSERT INTO rodrigo.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(1,	'Rodrigo de Oliveira Silva',		'1973-12-12',	'3434-0909',	' ',			'rodrigo@ig.com.br');
INSERT INTO rodrigo.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(2,	'Melissa Pereira da Silva',		'1970-01-04',	'4444-0011',	'www.mwbrasil.com.br ',	'rose@ig.com.br');
INSERT INTO rodrigo.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(2,	'Elisangela Almeida de Oliveira',	'1973-10-31',	'3434-7879',	' ',			'eli@brfree.com.br');
INSERT INTO rodrigo.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(3,	'Andre Tritapepe de Matias',		'1973-12-31',	'3434-8596',	' ',			'andre@trita.com.br');
INSERT INTO rodrigo.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(3,	'Michela Almeida de Alcantara',		'1980-04-01',	'8888-0101',	' ',			'michela@psico.com.br');
INSERT INTO rodrigo.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(3,	'Paulo Rogerio de Oliveira',		'1973-10-11',	'7777-0405',	'www.proger.com',	'paulo@proger.com.br');
INSERT INTO rodrigo.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(4,	'Cristina Pereira Matos',		'1970-10-11',	'2222-7885',	'www.santista.com',	'cristina@uol.com.br');
INSERT INTO rodrigo.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(4,	'Fabia Castilho Almeida',		'1981-10-11',	'4545-4596',	'www.castilho.com',	'fabia@terra.com.br');
INSERT INTO rodrigo.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(4,	'rodrigo Cristovao Santos',		'1980-10-11',	'2202-7272',	'',			'rodrigo@terra.com.br');
INSERT INTO rodrigo.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(4,	'rodrigosa Santos Matias',		'1990-10-11',	'1010-1396',	'',			'rodrigosa@brfree.com.br');
--
--
-- Inserindo registros na tabela rodrigo.contas
--
INSERT INTO rodrigo.contas(fkcliente,nome,dtabertura) VALUES(1,'semana01','2002-10-01');
INSERT INTO rodrigo.contas(fkcliente,nome,dtabertura) VALUES(2,'semana02','2002-10-20');
INSERT INTO rodrigo.contas(fkcliente,nome,dtabertura) VALUES(2,'semana03','2002-09-10');
INSERT INTO rodrigo.contas(fkcliente,nome,dtabertura) VALUES(3,'semana04','2002-09-03');
INSERT INTO rodrigo.contas(fkcliente,nome,dtabertura) VALUES(3,'semana05','2002-01-01');
INSERT INTO rodrigo.contas(fkcliente,nome,dtabertura) VALUES(3,'semana06','2002-02-15');
INSERT INTO rodrigo.contas(fkcliente,nome,dtabertura) VALUES(4,'semana07','2002-05-01');
INSERT INTO rodrigo.contas(fkcliente,nome,dtabertura) VALUES(4,'semana08','2002-06-09');
INSERT INTO rodrigo.contas(fkcliente,nome,dtabertura) VALUES(4,'semana09','2002-07-01');
INSERT INTO rodrigo.contas(fkcliente,nome,dtabertura) VALUES(4,'semana10','2002-10-11');
INSERT INTO rodrigo.contas(fkcliente,nome,dtabertura) VALUES(5,'semana11','2002-10-10');
INSERT INTO rodrigo.contas(fkcliente,nome,dtabertura) VALUES(5,'semana12','2002-10-01');
INSERT INTO rodrigo.contas(fkcliente,nome,dtabertura) VALUES(5,'semana13','2002-07-20');
INSERT INTO rodrigo.contas(fkcliente,nome,dtabertura) VALUES(5,'semana14','2002-06-01');
INSERT INTO rodrigo.contas(fkcliente,nome,dtabertura) VALUES(5,'semana15','2002-05-07');
INSERT INTO rodrigo.contas(fkcliente,nome,dtabertura) VALUES(6,'semana16','2002-02-01');
INSERT INTO rodrigo.contas(fkcliente,nome,dtabertura) VALUES(6,'semana17','2002-01-08');
INSERT INTO rodrigo.contas(fkcliente,nome,dtabertura) VALUES(6,'semana18','2002-09-01');
INSERT INTO rodrigo.contas(fkcliente,nome,dtabertura) VALUES(6,'semana19','2002-09-04');
INSERT INTO rodrigo.contas(fkcliente,nome,dtabertura) VALUES(6,'semana20','2002-10-28');
INSERT INTO rodrigo.contas(fkcliente,nome,dtabertura) VALUES(6,'semana21','2002-10-28');
--
--
-- Inserindo registros na tabela rodrigo.movimentos
--
-- rodrigo.movimentos da conta 1
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(1,'salario',2000,0);
-- rodrigo.movimentos da conta 2
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(2,'vendas',50000,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(2,'luz',0,200);
-- rodrigo.movimentos da conta 3
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(3,'vendas',0,2000);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(3,'combustivel',5000,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(3,'luz',0,200);
-- rodrigo.movimentos da conta 4
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(4,'combustivel',500,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(4,'luz',0,200);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(4,'vendas',0,2000);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(4,'combustivel',10,0);
-- rodrigo.movimentos da conta 5
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(5,'combustivel',100,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(5,'luz',0,200);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(5,'combustivel',50,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(5,'vendas',0,2000);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(5,'combustivel',30,0);
-- rodrigo.movimentos da conta 6
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(6,'luz',0,200);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(6,'vendas',0,3000);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(6,'combustivel',10,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(6,'vendas',0,200);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(6,'combustivel',10,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(6,'luz',0,200);
-- rodrigo.movimentos da conta 7
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(7,'combustivel',700,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(7,'vendas',0,10000);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(7,'combustivel',500,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(7,'combustivel',30,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(7,'vendas',0,20000);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(7,'combustivel',90,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(7,'luz',0,200);
-- rodrigo.movimentos da conta 8
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(8,'combustivel',900,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(8,'vendas',0,3000);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(8,'combustivel',300,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(8,'combustivel',300,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(8,'vendas',0,5000);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(8,'luz',0,200);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(8,'luz',0,200);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(8,'combustivel',10,0);
-- rodrigo.movimentos da conta 9
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(9,'combustivel',400,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(9,'vendas',0,7000);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(9,'combustivel',10,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(9,'combustivel',10,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(9,'combustivel',100,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(9,'vendas',0,6000);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(9,'vendas',0,4000);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(9,'combustivel',100,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(9,'luz',0,200);
-- rodrigo.movimentos da conta 10
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(10,'combustivel',300,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(10,'combustivel',40,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(10,'vendas',0,20);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(10,'combustivel',10,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(10,'combustivel',110,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(10,'luz',0,200);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(10,'combustivel',100,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(10,'combustivel',100,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(10,'vendas',0,2500);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(10,'vendas',0,2600);
-- rodrigo.movimentos da conta 11
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(11,'luz',0,50);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(11,'salario',5000,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(11,'manutencao',0,50000);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(11,'supermercado',0,3000);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(11,'manutencao',0,8000);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(11,'escritorio',0,5000);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(11,'carro',0,36000);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(11,'predio',0,60000);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(11,'vendas',7000,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(11,'luz',0,8000);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(11,'manutencao',0,4000);
-- rodrigo.movimentos da conta 12
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(12,'vendas',4000,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(12,'escritorio',0,50000);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(12,'manutencao',0,40000);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(12,'vendas',10000,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(12,'escritorio',0,70000);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(12,'manutencao',0,4000);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(12,'vendas',80000,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(12,'escritorio',0,20000);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(12,'manutencao',0,4000);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(12,'vendas',10000,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(12,'escritorio',0,5000);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(12,'manutencao',0,10000);
-- rodrigo.movimentos da conta 13
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
-- rodrigo.movimentos da conta 14
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',20000,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(14,'salario',8000,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',2000,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(14,'salario',5000,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',9000,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(14,'salario',6000,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',3000,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(14,'salario',9000,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',8000,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(14,'salario',7000,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',9000,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(14,'supermercado',0,5000);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',2000,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(14,'combustivel',9000,0);
-- rodrigo.movimentos da conta 15
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(15,'combustivel',0,2000);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(15,'combustivel',0,2000);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(15,'escritorio',0,2000);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(15,'escritorio',0,2000);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(15,'escritorio',0,2000);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
-- rodrigo.movimentos da conta 16
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas',5000,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas',5000,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas',5000,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas',5000,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas loja',5000,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas loja',5000,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas loja',5000,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(16,'suporte',5000,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(16,'suporte',5000,0);
-- rodrigo.movimentos da conta 17
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(17,'escritorio',0,500);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(17,'combustivel',0,500);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(17,'combustivel',0,500);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(17,'combustivel',0,500);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(17,'carro',0,500);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(17,'carro',0,500);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
-- rodrigo.movimentos da conta 18
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(18,'suporte',8000,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(18,'vendas loja',8000,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(18,'vendas loja',8000,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(18,'vendas loja',8000,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(18,'vendas loja',8000,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(18,'suporte',8000,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(18,'suporte',8000,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(18,'suporte',8000,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(18,'suporte',8000,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(18,'suporte',8000,0);
-- rodrigo.movimentos da conta 19
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(19,'caixa interno',0,500);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(19,'caixa interno',0,500);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(19,'caixa interno',0,500);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(19,'predio',0,500);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(19,'predio',0,500);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(19,'predio',0,500);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(19,'predio',0,500);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(19,'predio',0,500);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
-- rodrigo.movimentos da conta 20
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(20,'vendas',8000,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(20,'vendas',8000,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(20,'vendas',8000,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(20,'suporte ',8000,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(20,'suporte ',8000,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(20,'suporte ',8000,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(20,'suporte ',8000,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(20,'suporte ',8000,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(20,'vendas',8000,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(20,'vendas',8000,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(20,'vendas',8000,0);
-- rodrigo.movimentos da conta 21
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(21,'combustivel',0,50);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(21,'reforma',0,50);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(21,'manutencao',0,50);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(21,'combustivel',0,50);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(21,'salario',0,50);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(21,'salario',0,50);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(21,'reforma',0,50);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(21,'reforma',0,50);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO rodrigo.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);

--
--
-- Funcoes em SQL e PL/PGSQL
--
-- ================================================================================================================
-- Funcoes em SQL
--
-- Crie uma funcao onde passamos um valor inteiro e retorne ele mais 1
--
create function soma1sql(integer) returns integer as
'
       select  $1 + 1
'
language 'sql';
--
-- ================================================================================================================
-- Monte uma função que mostre a quantidade de clientes em uma empresa
-- deverá ser passado o codigo da empresa como parametro.
--
create function qtd_clientes_empresas(integer) returns bigint as
'
       select count(*) from clientes where fkempresa = $1
'
language 'sql';
--
-- ================================================================================================================
-- Monte uma função que mostre a quantidade de contas por clientes
--
create or replace function Contas_Clientes(integer) returns bigint as
'
       select count(*) from contas where fkcliente = $1
'
language 'sql';
--
-- ================================================================================================================
-- Crie uma função para inserir ao mesmo tempo o  nome da empresa e o nome 	
-- de um cliente retornando o id da empresa.
--
create or replace function empresa_cliente(varchar,varchar) returns bigint as
'
       insert into empresas(nome) values($1);
       insert into clientes(fkempresa,nome) 	values(currval(''empresas_id_seq''),$2);
       select currval(''empresas_id_seq'') as id_empresa
'
language 'sql';
--
-- ================================================================================================================
-- Crie uma função que retorne quem deve
--
create function quemdeve() returns setof integer as
'
       select clientes.id from clientes inner join contas on clientes.id = 	contas.fkcliente
       inner join movimentos on contas.id=movimentos.fkconta
       group by clientes.id
       having sum(credito-debito)<0
' language 'sql';
--
-- ================================================================================================================
-- Retornando uma query
--
create or replace function listaclientes() returns setof clientes as
'
select * from clientes
'
language 'sql';
--
-- ================================================================================================================
-- Retornando uma query
--
create or replace function ListaClientesID(integer) returns setof clientes as
'
select * from clientes where id = $1
'
language 'sql';
--
-- ================================================================================================================
--
-- Funcoes em PL/PGSQL
--
-- Crie uma função que some 1 a um número passado
--
create or replace function soma1(integer) returns integer as
'
declare
       valor alias for $1;
       x integer;
begin
     x:=1;
     x:=x+valor;
     return x;
end;
'
language 'plpgsql';
--
-- ================================================================================================================
-- Crie a mesma função que insira o nome da empresa e o nome do cliente retornando o id de ambos
--
create or replace function empresa_cliente_id(varchar,varchar) returns _int4 as
'
declare
	nempresa alias for $1;
	ncliente alias for $2;
	empresaid integer;
	clienteid integer;
begin
	insert into empresas(nome) values(nempresa);
	insert into clientes(fkempresa,nome) values(currval(''empresas_id_seq''),ncliente);

	empresaid := currval(''empresas_id_seq'');
	clienteid := currval(''clientes_id_seq'');

	return ''{''|| empresaid ||'',''|| clienteid ||''}'';
end;
'
language 'plpgsql';
--
-- ================================================================================================================
-- Crie uma função onde passamos como parâmetro o id do cliente e seja retornado o seu nome
--
create or replace function id_nome_cliente(integer) returns text as
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
--
create or replace function clientes_nomes() returns text as
'
declare
       x text;
       r record;
begin
     x:=''Inicio'';
     for r in select * from clientes order by id loop
         x:= x||'' : ''||r.nome;
     end loop;
     return x||'' : fim'';
end;
'
language 'plpgsql';
--
-- ================================================================================================================
-- Atualizando o saldo de uma conta devera ser passado o id da conta
--
create or replace function saldo_upd_conta(integer) returns numeric(12,2) as
'
       update contas set saldo = (
       select sum(movimentos.credito-movimentos.debito)
       from movimentos where movimentos.fkconta = $1) where id = $1;
       select sum(movimentos.credito-movimentos.debito) from movimentos where movimentos.fkconta = $1;
'
language 'sql';
--
-- ================================================================================================================
-- Atualizando o saldo de uma conta devera ser passado o id da conta
--
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
language 'plpgsql';
--
-- ================================================================================================================
-- Atualizando o saldo de todas as contas
--
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
--
-- ================================================================================================================
--
-- Trigger's
--
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Exemplo 1 - Log de Insert, Update e Delete da tabela precos
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--
--
-- Passo 01 - Criacao da function
--
--
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
--
-- Passo 02 - Criacao da trigger
-- Trigger para
-- before (antes de insert ou update)
--
create trigger precos_log_ins_upd
before insert or update
on precos
for each row
execute procedure precos_log();
--
-- Trigger para
-- after (apos ter deletado)
--
create trigger precos_log_del
after delete
on precos
for each row
execute procedure precos_log();
--
--
-- ================================================================================================================
-- ++++++++++++++++++++++++++++++++++++++++++++++++
-- Exemplo 1.2 - Utilizando o Exemplo 01 com view's
-- ++++++++++++++++++++++++++++++++++++++++++++++++
--
-- Passo 01 - Criar a view
--
create view v_precos as
select id, produto, valor from precos;
-- Passo 02 - Criar as regras para ins, upd e del
-- Regra para Insert
create rule rv_precos_ins as
on insert to v_precos
do instead
insert into precos(produto,valor) values(new.produto,new.valor);
--
-- Regra para Update
--
create rule rv_precos_upd as
on update to v_precos
do instead
update precos
set
   produto = new.produto,
   valor = new.valor
   where id = old.id;
--
-- Regra para Delete
--
create rule rv_precos_del as
on delete to v_precos
do instead
delete from precos
where id = old.id;
-- Passo 03 - Executar os comandos
-- insert, update ou delete
--
-- ================================================================================================================
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
-- ==========================================================================================
\connect pgteste melissa

-- ==========================================================================================================
-- Esquema melissa
--

--
-- Criando a tabela melissa.empresas
--
CREATE TABLE melissa.empresas(
			id 		SERIAL 		PRIMARY KEY,
			nome 		VARCHAR(50),
			dtcadastro 	DATE,
			telcom 		VARCHAR(20),
			site 		VARCHAR(40),
			email 		VARCHAR(40),
			saldo		NUMERIC(12,2)	DEFAULT 0,
			obs             TEXT
);
--
--
-- Criando a tabela melissa.clientes
--
CREATE TABLE melissa.clientes(
			id 		SERIAL 		PRIMARY KEY,
			fkempresa 	INTEGER,
			nome 		VARCHAR(50),
			dtnascimento 	DATE,
			telres 		VARCHAR(20),
			site 		VARCHAR(40),
			email 		VARCHAR(40),
			saldo		NUMERIC(12,2)	DEFAULT 0,
			obs             TEXT,
			CONSTRAINT melissa_empresas_clientes FOREIGN KEY(fkempresa)
							REFERENCES melissa.empresas(id)
							ON DELETE RESTRICT
							ON UPDATE CASCADE
					
);
--
--
-- Criando a tabela melissa.contas
--
CREATE TABLE melissa.contas(
			id 		SERIAL 		PRIMARY KEY,
			fkcliente 	INTEGER,
			nome 		VARCHAR(50),
			dtabertura	DATE,
			saldo		NUMERIC(12,2)	DEFAULT 0,
			CONSTRAINT melissa_clientes_contas FOREIGN KEY(fkcliente)
							REFERENCES melissa.clientes(id)
							ON DELETE RESTRICT
							ON UPDATE CASCADE
);
--
--
-- Criando a TABLE a melissa.movimentos
--
CREATE TABLE melissa.movimentos(
			id 		SERIAL 		PRIMARY KEY,
			fkconta 	INTEGER,
			historico 	VARCHAR(50),
			credito 	NUMERIC(11,2)	DEFAULT 0,
			debito 		NUMERIC(11,2)	DEFAULT 0,
			CONSTRAINT melissa_contas_movimentos FOREIGN KEY(fkconta)
							REFERENCES melissa.contas(id)
							ON DELETE RESTRICT
							ON UPDATE CASCADE
);
--
--
-- Criando a tabela movempresas
--
CREATE TABLE melissa.movempresas(
			id 		SERIAL 		PRIMARY KEY,
			fkempresa 	INTEGER,
			historico 	VARCHAR(50),
			credito 	NUMERIC(11,2)	DEFAULT 0,
			debito 		NUMERIC(11,2)	DEFAULT 0,
			CONSTRAINT melissa_empresas_movempresas FOREIGN KEY(fkempresa)
							REFERENCES melissa.empresas(id)
							ON DELETE RESTRICT
							ON UPDATE CASCADE
);
--
--
-- Criando a tabela precos
--
CREATE TABLE melissa.precos(
                        id           SERIAL PRIMARY KEY,
                        produto      VARCHAR(30),
                        valor        NUMERIC(11,2), 	
                        data_ins     TIMESTAMP,
                        user_ins     TEXT,
                        data_atu     TIMESTAMP,
                        user_atu     TEXT
);
--
--
-- Criando a tabela precos_log_del
--
CREATE TABLE melissa.precos_log_del(
                        id           INTEGER,
                        produto      VARCHAR(30),
                        valor        NUMERIC(11,2), 	
                        data_ins     TIMESTAMP,
                        user_ins     TEXT,
                        data_atu     TIMESTAMP,
                        user_atu     TEXT,
                        data_del     TIMESTAMP,
                        user_del     TEXT
);
--
--
-- Inserindo registros na tabela melissa.empresas
--
INSERT INTO melissa.empresas(nome,dtcadastro,telcom,site,email) VALUES('MundoByte Informatica',	'1995-11-11',	'222-0909',	'www.mundobyte.com.br',	'relacoes@mundobyte.com.br');
INSERT INTO melissa.empresas(nome,dtcadastro,telcom,site,email) VALUES('TecTel - informatica',	'1995-01-09',	'333-0909',	'www.tectel.com.br',	'info@tectel.com.br');
INSERT INTO melissa.empresas(nome,dtcadastro,telcom,site,email) VALUES('Vulcano S/A',		'2002-10-31',	'211-0909',	'www.vulcano.com.br',	'informacoes@vulcano.com.br');
INSERT INTO melissa.empresas(nome,dtcadastro,telcom,site,email) VALUES('Softmax',		'2000-10-05',	'211-0909',	'www.vulcano.com.br',	'softmax@softmax.com.br');
--
--
-- Inserindo registros na tabela melissa.clientes
--
INSERT INTO melissa.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(1,	'Rodrigo de Oliveira Silva',		'1973-12-12',	'3434-0909',	' ',			'rodrigo@ig.com.br');
INSERT INTO melissa.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(2,	'Melissa Pereira da Silva',		'1970-01-04',	'4444-0011',	'www.mwbrasil.com.br ',	'rose@ig.com.br');
INSERT INTO melissa.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(2,	'Elisangela Almeida de Oliveira',	'1973-10-31',	'3434-7879',	' ',			'eli@brfree.com.br');
INSERT INTO melissa.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(3,	'Andre Tritapepe de Matias',		'1973-12-31',	'3434-8596',	' ',			'andre@trita.com.br');
INSERT INTO melissa.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(3,	'Michela Almeida de Alcantara',		'1980-04-01',	'8888-0101',	' ',			'michela@psico.com.br');
INSERT INTO melissa.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(3,	'Paulo Rogerio de Oliveira',		'1973-10-11',	'7777-0405',	'www.proger.com',	'paulo@proger.com.br');
INSERT INTO melissa.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(4,	'Cristina Pereira Matos',		'1970-10-11',	'2222-7885',	'www.santista.com',	'cristina@uol.com.br');
INSERT INTO melissa.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(4,	'Fabia Castilho Almeida',		'1981-10-11',	'4545-4596',	'www.castilho.com',	'fabia@terra.com.br');
INSERT INTO melissa.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(4,	'melissa Cristovao Santos',		'1980-10-11',	'2202-7272',	'',			'melissa@terra.com.br');
INSERT INTO melissa.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(4,	'melissasa Santos Matias',		'1990-10-11',	'1010-1396',	'',			'melissasa@brfree.com.br');
--
--
-- Inserindo registros na tabela melissa.contas
--
INSERT INTO melissa.contas(fkcliente,nome,dtabertura) VALUES(1,'semana01','2002-10-01');
INSERT INTO melissa.contas(fkcliente,nome,dtabertura) VALUES(2,'semana02','2002-10-20');
INSERT INTO melissa.contas(fkcliente,nome,dtabertura) VALUES(2,'semana03','2002-09-10');
INSERT INTO melissa.contas(fkcliente,nome,dtabertura) VALUES(3,'semana04','2002-09-03');
INSERT INTO melissa.contas(fkcliente,nome,dtabertura) VALUES(3,'semana05','2002-01-01');
INSERT INTO melissa.contas(fkcliente,nome,dtabertura) VALUES(3,'semana06','2002-02-15');
INSERT INTO melissa.contas(fkcliente,nome,dtabertura) VALUES(4,'semana07','2002-05-01');
INSERT INTO melissa.contas(fkcliente,nome,dtabertura) VALUES(4,'semana08','2002-06-09');
INSERT INTO melissa.contas(fkcliente,nome,dtabertura) VALUES(4,'semana09','2002-07-01');
INSERT INTO melissa.contas(fkcliente,nome,dtabertura) VALUES(4,'semana10','2002-10-11');
INSERT INTO melissa.contas(fkcliente,nome,dtabertura) VALUES(5,'semana11','2002-10-10');
INSERT INTO melissa.contas(fkcliente,nome,dtabertura) VALUES(5,'semana12','2002-10-01');
INSERT INTO melissa.contas(fkcliente,nome,dtabertura) VALUES(5,'semana13','2002-07-20');
INSERT INTO melissa.contas(fkcliente,nome,dtabertura) VALUES(5,'semana14','2002-06-01');
INSERT INTO melissa.contas(fkcliente,nome,dtabertura) VALUES(5,'semana15','2002-05-07');
INSERT INTO melissa.contas(fkcliente,nome,dtabertura) VALUES(6,'semana16','2002-02-01');
INSERT INTO melissa.contas(fkcliente,nome,dtabertura) VALUES(6,'semana17','2002-01-08');
INSERT INTO melissa.contas(fkcliente,nome,dtabertura) VALUES(6,'semana18','2002-09-01');
INSERT INTO melissa.contas(fkcliente,nome,dtabertura) VALUES(6,'semana19','2002-09-04');
INSERT INTO melissa.contas(fkcliente,nome,dtabertura) VALUES(6,'semana20','2002-10-28');
INSERT INTO melissa.contas(fkcliente,nome,dtabertura) VALUES(6,'semana21','2002-10-28');
--
--
-- Inserindo registros na tabela melissa.movimentos
--
-- melissa.movimentos da conta 1
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(1,'salario',2000,0);
-- melissa.movimentos da conta 2
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(2,'vendas',50000,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(2,'luz',0,200);
-- melissa.movimentos da conta 3
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(3,'vendas',0,2000);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(3,'combustivel',5000,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(3,'luz',0,200);
-- melissa.movimentos da conta 4
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(4,'combustivel',500,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(4,'luz',0,200);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(4,'vendas',0,2000);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(4,'combustivel',10,0);
-- melissa.movimentos da conta 5
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(5,'combustivel',100,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(5,'luz',0,200);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(5,'combustivel',50,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(5,'vendas',0,2000);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(5,'combustivel',30,0);
-- melissa.movimentos da conta 6
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(6,'luz',0,200);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(6,'vendas',0,3000);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(6,'combustivel',10,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(6,'vendas',0,200);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(6,'combustivel',10,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(6,'luz',0,200);
-- melissa.movimentos da conta 7
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(7,'combustivel',700,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(7,'vendas',0,10000);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(7,'combustivel',500,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(7,'combustivel',30,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(7,'vendas',0,20000);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(7,'combustivel',90,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(7,'luz',0,200);
-- melissa.movimentos da conta 8
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(8,'combustivel',900,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(8,'vendas',0,3000);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(8,'combustivel',300,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(8,'combustivel',300,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(8,'vendas',0,5000);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(8,'luz',0,200);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(8,'luz',0,200);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(8,'combustivel',10,0);
-- melissa.movimentos da conta 9
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(9,'combustivel',400,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(9,'vendas',0,7000);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(9,'combustivel',10,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(9,'combustivel',10,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(9,'combustivel',100,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(9,'vendas',0,6000);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(9,'vendas',0,4000);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(9,'combustivel',100,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(9,'luz',0,200);
-- melissa.movimentos da conta 10
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(10,'combustivel',300,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(10,'combustivel',40,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(10,'vendas',0,20);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(10,'combustivel',10,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(10,'combustivel',110,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(10,'luz',0,200);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(10,'combustivel',100,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(10,'combustivel',100,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(10,'vendas',0,2500);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(10,'vendas',0,2600);
-- melissa.movimentos da conta 11
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(11,'luz',0,50);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(11,'salario',5000,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(11,'manutencao',0,50000);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(11,'supermercado',0,3000);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(11,'manutencao',0,8000);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(11,'escritorio',0,5000);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(11,'carro',0,36000);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(11,'predio',0,60000);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(11,'vendas',7000,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(11,'luz',0,8000);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(11,'manutencao',0,4000);
-- melissa.movimentos da conta 12
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(12,'vendas',4000,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(12,'escritorio',0,50000);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(12,'manutencao',0,40000);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(12,'vendas',10000,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(12,'escritorio',0,70000);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(12,'manutencao',0,4000);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(12,'vendas',80000,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(12,'escritorio',0,20000);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(12,'manutencao',0,4000);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(12,'vendas',10000,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(12,'escritorio',0,5000);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(12,'manutencao',0,10000);
-- melissa.movimentos da conta 13
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
-- melissa.movimentos da conta 14
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',20000,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(14,'salario',8000,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',2000,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(14,'salario',5000,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',9000,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(14,'salario',6000,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',3000,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(14,'salario',9000,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',8000,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(14,'salario',7000,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',9000,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(14,'supermercado',0,5000);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',2000,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(14,'combustivel',9000,0);
-- melissa.movimentos da conta 15
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(15,'combustivel',0,2000);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(15,'combustivel',0,2000);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(15,'escritorio',0,2000);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(15,'escritorio',0,2000);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(15,'escritorio',0,2000);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
-- melissa.movimentos da conta 16
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas',5000,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas',5000,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas',5000,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas',5000,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas loja',5000,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas loja',5000,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas loja',5000,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(16,'suporte',5000,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(16,'suporte',5000,0);
-- melissa.movimentos da conta 17
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(17,'escritorio',0,500);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(17,'combustivel',0,500);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(17,'combustivel',0,500);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(17,'combustivel',0,500);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(17,'carro',0,500);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(17,'carro',0,500);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
-- melissa.movimentos da conta 18
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(18,'suporte',8000,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(18,'vendas loja',8000,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(18,'vendas loja',8000,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(18,'vendas loja',8000,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(18,'vendas loja',8000,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(18,'suporte',8000,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(18,'suporte',8000,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(18,'suporte',8000,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(18,'suporte',8000,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(18,'suporte',8000,0);
-- melissa.movimentos da conta 19
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(19,'caixa interno',0,500);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(19,'caixa interno',0,500);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(19,'caixa interno',0,500);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(19,'predio',0,500);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(19,'predio',0,500);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(19,'predio',0,500);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(19,'predio',0,500);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(19,'predio',0,500);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
-- melissa.movimentos da conta 20
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(20,'vendas',8000,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(20,'vendas',8000,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(20,'vendas',8000,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(20,'suporte ',8000,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(20,'suporte ',8000,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(20,'suporte ',8000,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(20,'suporte ',8000,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(20,'suporte ',8000,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(20,'vendas',8000,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(20,'vendas',8000,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(20,'vendas',8000,0);
-- melissa.movimentos da conta 21
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(21,'combustivel',0,50);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(21,'reforma',0,50);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(21,'manutencao',0,50);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(21,'combustivel',0,50);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(21,'salario',0,50);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(21,'salario',0,50);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(21,'reforma',0,50);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(21,'reforma',0,50);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO melissa.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);

--
--
-- Funcoes em SQL e PL/PGSQL
--
-- ================================================================================================================
-- Funcoes em SQL
--
-- Crie uma funcao onde passamos um valor inteiro e retorne ele mais 1
--
create function soma1sql(integer) returns integer as
'
       select  $1 + 1
'
language 'sql';
--
-- ================================================================================================================
-- Monte uma função que mostre a quantidade de clientes em uma empresa
-- deverá ser passado o codigo da empresa como parametro.
--
create function qtd_clientes_empresas(integer) returns bigint as
'
       select count(*) from clientes where fkempresa = $1
'
language 'sql';
--
-- ================================================================================================================
-- Monte uma função que mostre a quantidade de contas por clientes
--
create or replace function Contas_Clientes(integer) returns bigint as
'
       select count(*) from contas where fkcliente = $1
'
language 'sql';
--
-- ================================================================================================================
-- Crie uma função para inserir ao mesmo tempo o  nome da empresa e o nome 	
-- de um cliente retornando o id da empresa.
--
create or replace function empresa_cliente(varchar,varchar) returns bigint as
'
       insert into empresas(nome) values($1);
       insert into clientes(fkempresa,nome) 	values(currval(''empresas_id_seq''),$2);
       select currval(''empresas_id_seq'') as id_empresa
'
language 'sql';
--
-- ================================================================================================================
-- Crie uma função que retorne quem deve
--
create function quemdeve() returns setof integer as
'
       select clientes.id from clientes inner join contas on clientes.id = 	contas.fkcliente
       inner join movimentos on contas.id=movimentos.fkconta
       group by clientes.id
       having sum(credito-debito)<0
' language 'sql';
--
-- ================================================================================================================
-- Retornando uma query
--
create or replace function listaclientes() returns setof clientes as
'
select * from clientes
'
language 'sql';
--
-- ================================================================================================================
-- Retornando uma query
--
create or replace function ListaClientesID(integer) returns setof clientes as
'
select * from clientes where id = $1
'
language 'sql';
--
-- ================================================================================================================
--
-- Funcoes em PL/PGSQL
--
-- Crie uma função que some 1 a um número passado
--
create or replace function soma1(integer) returns integer as
'
declare
       valor alias for $1;
       x integer;
begin
     x:=1;
     x:=x+valor;
     return x;
end;
'
language 'plpgsql';
--
-- ================================================================================================================
-- Crie a mesma função que insira o nome da empresa e o nome do cliente retornando o id de ambos
--
create or replace function empresa_cliente_id(varchar,varchar) returns _int4 as
'
declare
	nempresa alias for $1;
	ncliente alias for $2;
	empresaid integer;
	clienteid integer;
begin
	insert into empresas(nome) values(nempresa);
	insert into clientes(fkempresa,nome) values(currval(''empresas_id_seq''),ncliente);

	empresaid := currval(''empresas_id_seq'');
	clienteid := currval(''clientes_id_seq'');

	return ''{''|| empresaid ||'',''|| clienteid ||''}'';
end;
'
language 'plpgsql';
--
-- ================================================================================================================
-- Crie uma função onde passamos como parâmetro o id do cliente e seja retornado o seu nome
--
create or replace function id_nome_cliente(integer) returns text as
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
--
create or replace function clientes_nomes() returns text as
'
declare
       x text;
       r record;
begin
     x:=''Inicio'';
     for r in select * from clientes order by id loop
         x:= x||'' : ''||r.nome;
     end loop;
     return x||'' : fim'';
end;
'
language 'plpgsql';
--
-- ================================================================================================================
-- Atualizando o saldo de uma conta devera ser passado o id da conta
--
create or replace function saldo_upd_conta(integer) returns numeric(12,2) as
'
       update contas set saldo = (
       select sum(movimentos.credito-movimentos.debito)
       from movimentos where movimentos.fkconta = $1) where id = $1;
       select sum(movimentos.credito-movimentos.debito) from movimentos where movimentos.fkconta = $1;
'
language 'sql';
--
-- ================================================================================================================
-- Atualizando o saldo de uma conta devera ser passado o id da conta
--
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
language 'plpgsql';
--
-- ================================================================================================================
-- Atualizando o saldo de todas as contas
--
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
--
-- ================================================================================================================
--
-- Trigger's
--
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
-- Exemplo 1 - Log de Insert, Update e Delete da tabela precos
-- +++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
--
--
-- Passo 01 - Criacao da function
--
--
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
--
-- Passo 02 - Criacao da trigger
-- Trigger para
-- before (antes de insert ou update)
--
create trigger precos_log_ins_upd
before insert or update
on precos
for each row
execute procedure precos_log();
--
-- Trigger para
-- after (apos ter deletado)
--
create trigger precos_log_del
after delete
on precos
for each row
execute procedure precos_log();
--
--
-- ================================================================================================================
-- ++++++++++++++++++++++++++++++++++++++++++++++++
-- Exemplo 1.2 - Utilizando o Exemplo 01 com view's
-- ++++++++++++++++++++++++++++++++++++++++++++++++
--
-- Passo 01 - Criar a view
--
create view v_precos as
select id, produto, valor from precos;
-- Passo 02 - Criar as regras para ins, upd e del
-- Regra para Insert
create rule rv_precos_ins as
on insert to v_precos
do instead
insert into precos(produto,valor) values(new.produto,new.valor);
--
-- Regra para Update
--
create rule rv_precos_upd as
on update to v_precos
do instead
update precos
set
   produto = new.produto,
   valor = new.valor
   where id = old.id;
--
-- Regra para Delete
--
create rule rv_precos_del as
on delete to v_precos
do instead
delete from precos
where id = old.id;
-- Passo 03 - Executar os comandos
-- insert, update ou delete
--
-- ================================================================================================================
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
