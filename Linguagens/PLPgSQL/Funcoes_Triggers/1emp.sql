-- ==========================================================================================================
-- Esquema postgres
--

--
-- Criando a tabela  empresas
--
CREATE TABLE  empresas(
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
-- Criando a tabela  clientes
--
CREATE TABLE  clientes(
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
							REFERENCES  empresas(id)
							ON DELETE RESTRICT
							ON UPDATE CASCADE
					
);
--
--
-- Criando a tabela  contas
--
CREATE TABLE  contas(
			id 		SERIAL 		PRIMARY KEY,
			fkcliente 	INTEGER,
			nome 		VARCHAR(50),
			dtabertura	DATE,
			saldo		NUMERIC(12,2)	DEFAULT 0,
			CONSTRAINT postgres_clientes_contas FOREIGN KEY(fkcliente)
							REFERENCES  clientes(id)
							ON DELETE RESTRICT
							ON UPDATE CASCADE
);
--
--
-- Criando a TABLE a  movimentos
--
CREATE TABLE  movimentos(
			id 		SERIAL 		PRIMARY KEY,
			fkconta 	INTEGER,
			historico 	VARCHAR(50),
			credito 	NUMERIC(11,2)	DEFAULT 0,
			debito 		NUMERIC(11,2)	DEFAULT 0,
			CONSTRAINT postgres_contas_movimentos FOREIGN KEY(fkconta)
							REFERENCES  contas(id)
							ON DELETE RESTRICT
							ON UPDATE CASCADE
);
--
--
-- Criando a tabela movempresas
--
CREATE TABLE  movempresas(
			id 		SERIAL 		PRIMARY KEY,
			fkempresa 	INTEGER,
			historico 	VARCHAR(50),
			credito 	NUMERIC(11,2)	DEFAULT 0,
			debito 		NUMERIC(11,2)	DEFAULT 0,
			CONSTRAINT postgres_empresas_movempresas FOREIGN KEY(fkempresa)
							REFERENCES  empresas(id)
							ON DELETE RESTRICT
							ON UPDATE CASCADE
);
--
--
-- Criando a tabela precos
--
CREATE TABLE  precos(
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
CREATE TABLE  precos_log_del(
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
-- Inserindo registros na tabela  empresas
--
INSERT INTO  empresas(nome,dtcadastro,telcom,site,email) VALUES('MundoByte Informatica',	'1995-11-11',	'222-0909',	'www.mundobyte.com.br',	'relacoes@mundobyte.com.br');
INSERT INTO  empresas(nome,dtcadastro,telcom,site,email) VALUES('TecTel - informatica',	'1995-01-09',	'333-0909',	'www.tectel.com.br',	'info@tectel.com.br');
INSERT INTO  empresas(nome,dtcadastro,telcom,site,email) VALUES('Vulcano S/A',		'2002-10-31',	'211-0909',	'www.vulcano.com.br',	'informacoes@vulcano.com.br');
INSERT INTO  empresas(nome,dtcadastro,telcom,site,email) VALUES('Softmax',		'2000-10-05',	'211-0909',	'www.vulcano.com.br',	'softmax@softmax.com.br');
--
--
-- Inserindo registros na tabela  clientes
--
INSERT INTO  clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(1,	'Rodrigo de Oliveira Silva',		'1973-12-12',	'3434-0909',	' ',			'rodrigo@ig.com.br');
INSERT INTO  clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(2,	'Melissa Pereira da Silva',		'1970-01-04',	'4444-0011',	'www.mwbrasil.com.br ',	'rose@ig.com.br');
INSERT INTO  clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(2,	'Elisangela Almeida de Oliveira',	'1973-10-31',	'3434-7879',	' ',			'eli@brfree.com.br');
INSERT INTO  clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(3,	'Andre Tritapepe de Matias',		'1973-12-31',	'3434-8596',	' ',			'andre@trita.com.br');
INSERT INTO  clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(3,	'Michela Almeida de Alcantara',		'1980-04-01',	'8888-0101',	' ',			'michela@psico.com.br');
INSERT INTO  clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(3,	'Paulo Rogerio de Oliveira',		'1973-10-11',	'7777-0405',	'www.proger.com',	'paulo@proger.com.br');
INSERT INTO  clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(4,	'Cristina Pereira Matos',		'1970-10-11',	'2222-7885',	'www.santista.com',	'cristina@uol.com.br');
INSERT INTO  clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(4,	'Fabia Castilho Almeida',		'1981-10-11',	'4545-4596',	'www.castilho.com',	'fabia@terra.com.br');
INSERT INTO  clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(4,	'postgres Cristovao Santos',		'1980-10-11',	'2202-7272',	'',			'postgres@terra.com.br');
INSERT INTO  clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(4,	'postgressa Santos Matias',		'1990-10-11',	'1010-1396',	'',			'postgressa@brfree.com.br');
--
--
-- Inserindo registros na tabela  contas
--
INSERT INTO  contas(fkcliente,nome,dtabertura) VALUES(1,'semana01','2002-10-01');
INSERT INTO  contas(fkcliente,nome,dtabertura) VALUES(2,'semana02','2002-10-20');
INSERT INTO  contas(fkcliente,nome,dtabertura) VALUES(2,'semana03','2002-09-10');
INSERT INTO  contas(fkcliente,nome,dtabertura) VALUES(3,'semana04','2002-09-03');
INSERT INTO  contas(fkcliente,nome,dtabertura) VALUES(3,'semana05','2002-01-01');
INSERT INTO  contas(fkcliente,nome,dtabertura) VALUES(3,'semana06','2002-02-15');
INSERT INTO  contas(fkcliente,nome,dtabertura) VALUES(4,'semana07','2002-05-01');
INSERT INTO  contas(fkcliente,nome,dtabertura) VALUES(4,'semana08','2002-06-09');
INSERT INTO  contas(fkcliente,nome,dtabertura) VALUES(4,'semana09','2002-07-01');
INSERT INTO  contas(fkcliente,nome,dtabertura) VALUES(4,'semana10','2002-10-11');
INSERT INTO  contas(fkcliente,nome,dtabertura) VALUES(5,'semana11','2002-10-10');
INSERT INTO  contas(fkcliente,nome,dtabertura) VALUES(5,'semana12','2002-10-01');
INSERT INTO  contas(fkcliente,nome,dtabertura) VALUES(5,'semana13','2002-07-20');
INSERT INTO  contas(fkcliente,nome,dtabertura) VALUES(5,'semana14','2002-06-01');
INSERT INTO  contas(fkcliente,nome,dtabertura) VALUES(5,'semana15','2002-05-07');
INSERT INTO  contas(fkcliente,nome,dtabertura) VALUES(6,'semana16','2002-02-01');
INSERT INTO  contas(fkcliente,nome,dtabertura) VALUES(6,'semana17','2002-01-08');
INSERT INTO  contas(fkcliente,nome,dtabertura) VALUES(6,'semana18','2002-09-01');
INSERT INTO  contas(fkcliente,nome,dtabertura) VALUES(6,'semana19','2002-09-04');
INSERT INTO  contas(fkcliente,nome,dtabertura) VALUES(6,'semana20','2002-10-28');
INSERT INTO  contas(fkcliente,nome,dtabertura) VALUES(6,'semana21','2002-10-28');
--
--
-- Inserindo registros na tabela  movimentos
--
--  movimentos da conta 1
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(1,'salario',2000,0);
--  movimentos da conta 2
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(2,'vendas',50000,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(2,'luz',0,200);
--  movimentos da conta 3
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(3,'vendas',0,2000);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(3,'combustivel',5000,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(3,'luz',0,200);
--  movimentos da conta 4
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(4,'combustivel',500,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(4,'luz',0,200);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(4,'vendas',0,2000);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(4,'combustivel',10,0);
--  movimentos da conta 5
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(5,'combustivel',100,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(5,'luz',0,200);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(5,'combustivel',50,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(5,'vendas',0,2000);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(5,'combustivel',30,0);
--  movimentos da conta 6
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(6,'luz',0,200);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(6,'vendas',0,3000);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(6,'combustivel',10,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(6,'vendas',0,200);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(6,'combustivel',10,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(6,'luz',0,200);
--  movimentos da conta 7
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(7,'combustivel',700,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(7,'vendas',0,10000);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(7,'combustivel',500,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(7,'combustivel',30,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(7,'vendas',0,20000);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(7,'combustivel',90,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(7,'luz',0,200);
--  movimentos da conta 8
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(8,'combustivel',900,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(8,'vendas',0,3000);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(8,'combustivel',300,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(8,'combustivel',300,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(8,'vendas',0,5000);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(8,'luz',0,200);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(8,'luz',0,200);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(8,'combustivel',10,0);
--  movimentos da conta 9
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(9,'combustivel',400,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(9,'vendas',0,7000);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(9,'combustivel',10,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(9,'combustivel',10,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(9,'combustivel',100,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(9,'vendas',0,6000);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(9,'vendas',0,4000);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(9,'combustivel',100,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(9,'luz',0,200);
--  movimentos da conta 10
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(10,'combustivel',300,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(10,'combustivel',40,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(10,'vendas',0,20);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(10,'combustivel',10,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(10,'combustivel',110,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(10,'luz',0,200);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(10,'combustivel',100,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(10,'combustivel',100,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(10,'vendas',0,2500);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(10,'vendas',0,2600);
--  movimentos da conta 11
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(11,'luz',0,50);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(11,'salario',5000,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(11,'manutencao',0,50000);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(11,'supermercado',0,3000);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(11,'manutencao',0,8000);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(11,'escritorio',0,5000);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(11,'carro',0,36000);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(11,'predio',0,60000);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(11,'vendas',7000,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(11,'luz',0,8000);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(11,'manutencao',0,4000);
--  movimentos da conta 12
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(12,'vendas',4000,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(12,'escritorio',0,50000);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(12,'manutencao',0,40000);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(12,'vendas',10000,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(12,'escritorio',0,70000);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(12,'manutencao',0,4000);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(12,'vendas',80000,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(12,'escritorio',0,20000);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(12,'manutencao',0,4000);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(12,'vendas',10000,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(12,'escritorio',0,5000);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(12,'manutencao',0,10000);
--  movimentos da conta 13
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
--  movimentos da conta 14
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',20000,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(14,'salario',8000,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',2000,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(14,'salario',5000,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',9000,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(14,'salario',6000,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',3000,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(14,'salario',9000,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',8000,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(14,'salario',7000,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',9000,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(14,'supermercado',0,5000);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',2000,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(14,'combustivel',9000,0);
--  movimentos da conta 15
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(15,'combustivel',0,2000);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(15,'combustivel',0,2000);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(15,'escritorio',0,2000);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(15,'escritorio',0,2000);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(15,'escritorio',0,2000);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
--  movimentos da conta 16
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas',5000,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas',5000,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas',5000,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas',5000,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas loja',5000,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas loja',5000,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas loja',5000,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(16,'suporte',5000,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(16,'suporte',5000,0);
--  movimentos da conta 17
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(17,'escritorio',0,500);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(17,'combustivel',0,500);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(17,'combustivel',0,500);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(17,'combustivel',0,500);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(17,'carro',0,500);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(17,'carro',0,500);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
--  movimentos da conta 18
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(18,'suporte',8000,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(18,'vendas loja',8000,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(18,'vendas loja',8000,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(18,'vendas loja',8000,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(18,'vendas loja',8000,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(18,'suporte',8000,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(18,'suporte',8000,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(18,'suporte',8000,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(18,'suporte',8000,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(18,'suporte',8000,0);
--  movimentos da conta 19
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(19,'caixa interno',0,500);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(19,'caixa interno',0,500);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(19,'caixa interno',0,500);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(19,'predio',0,500);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(19,'predio',0,500);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(19,'predio',0,500);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(19,'predio',0,500);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(19,'predio',0,500);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
--  movimentos da conta 20
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(20,'vendas',8000,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(20,'vendas',8000,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(20,'vendas',8000,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(20,'suporte ',8000,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(20,'suporte ',8000,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(20,'suporte ',8000,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(20,'suporte ',8000,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(20,'suporte ',8000,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(20,'vendas',8000,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(20,'vendas',8000,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(20,'vendas',8000,0);
--  movimentos da conta 21
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(21,'combustivel',0,50);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(21,'reforma',0,50);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(21,'manutencao',0,50);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(21,'combustivel',0,50);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(21,'salario',0,50);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(21,'salario',0,50);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(21,'reforma',0,50);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(21,'reforma',0,50);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO  movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);

