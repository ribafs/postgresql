/*
	Script do Banco de Dados Empresa

	Tabelas do Sistema

		empresas=(id,nome,dtcadastro,telcom,site,email,saldo,obs)	
		clientes=(id,fkempresa,nome,dtnascimento,telres,site,email,saldo,obs)
		contas=(id,fkcliente,nome,dtabertura)
		movimentos=(id,fkconta,historico,credito,debito)
		movempresas=(id,fkconta,historico,credito,debito)

                precos=(id,produto,valor,data_ins,user_ins,data_atu,user_atu);
                precos_log_del=(id,produto,valor,data_ins,user_ins,data_atu,user_atu,data_del,user_del);
                
         Todos sobre os seguintes Schemas:
         	
         	public
         	desenvolvimento
         	producao

*/
-- ==========================================================================================================
-- Esquema Public
--
--
-- Criando a tabela empresas
--
CREATE TABLE empresas(
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
-- Criando a tabela clientes
--
CREATE TABLE clientes(
			id 		SERIAL 		PRIMARY KEY,
			fkempresa 	INTEGER,
			nome 		VARCHAR(50),
			dtnascimento 	DATE,
			telres 		VARCHAR(20),
			site 		VARCHAR(40),
			email 		VARCHAR(40),
			saldo		NUMERIC(12,2)	DEFAULT 0,
			foto		LO,
			obs             TEXT,
			CONSTRAINT empresas_clientes FOREIGN KEY(fkempresa)
							REFERENCES empresas(id)
							ON DELETE RESTRICT
							ON UPDATE CASCADE
					
);
--
--
-- Criando a tabela contas
--
CREATE TABLE contas(
			id 		SERIAL 		PRIMARY KEY,
			fkcliente 	INTEGER,
			nome 		VARCHAR(50),
			dtabertura	DATE,
			saldo		NUMERIC(12,2)	DEFAULT 0,
			CONSTRAINT clientes_contas FOREIGN KEY(fkcliente)
							REFERENCES clientes(id)
							ON DELETE RESTRICT
							ON UPDATE CASCADE
);
--
--
-- Criando a TABLE a movimentos
--
CREATE TABLE movimentos(
			id 		SERIAL 		PRIMARY KEY,
			fkconta 	INTEGER,
			historico 	VARCHAR(50),
			credito 	NUMERIC(11,2)	DEFAULT 0,
			debito 		NUMERIC(11,2)	DEFAULT 0,
			CONSTRAINT contas_movimentos FOREIGN KEY(fkconta)
							REFERENCES contas(id)
							ON DELETE RESTRICT
							ON UPDATE CASCADE
);
--
--
-- Criando a tabela movempresas
--
CREATE TABLE movempresas(
			id 		SERIAL 		PRIMARY KEY,
			fkempresa 	INTEGER,
			historico 	VARCHAR(50),
			credito 	NUMERIC(11,2)	DEFAULT 0,
			debito 		NUMERIC(11,2)	DEFAULT 0,
			CONSTRAINT empresas_movempresas FOREIGN KEY(fkempresa)
							REFERENCES empresas(id)
							ON DELETE RESTRICT
							ON UPDATE CASCADE
);
--
--
-- Criando a tabela precos
--
CREATE TABLE precos(
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
CREATE TABLE precos_log_del(
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
-- Inserindo registros na tabela empresas
--
INSERT INTO empresas(nome,dtcadastro,telcom,site,email) VALUES('MundoByte Informatica',	'1995-11-11',	'222-0909',	'www.mundobyte.com.br',	'relacoes@mundobyte.com.br');
INSERT INTO empresas(nome,dtcadastro,telcom,site,email) VALUES('TecTel - informatica',	'1995-01-09',	'333-0909',	'www.tectel.com.br',	'info@tectel.com.br');
INSERT INTO empresas(nome,dtcadastro,telcom,site,email) VALUES('Vulcano S/A',		'2002-10-31',	'211-0909',	'www.vulcano.com.br',	'informacoes@vulcano.com.br');
INSERT INTO empresas(nome,dtcadastro,telcom,site,email) VALUES('Softmax',		'2000-10-05',	'211-0909',	'www.vulcano.com.br',	'softmax@softmax.com.br');
--
--
-- Inserindo registros na tabela clientes
--
INSERT INTO clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(1,	'Rodrigo de Oliveira Silva',		'1973-12-12',	'3434-0909',	' ',			'rodrigo@ig.com.br');
INSERT INTO clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(2,	'Melissa Pereira da Silva',		'1970-01-04',	'4444-0011',	'www.mwbrasil.com.br ',	'rose@ig.com.br');
INSERT INTO clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(2,	'Elisangela Almeida de Oliveira',	'1973-10-31',	'3434-7879',	' ',			'eli@brfree.com.br');
INSERT INTO clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(3,	'Andre Tritapepe de Matias',		'1973-12-31',	'3434-8596',	' ',			'andre@trita.com.br');
INSERT INTO clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(3,	'Michela Almeida de Alcantara',		'1980-04-01',	'8888-0101',	' ',			'michela@psico.com.br');
INSERT INTO clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(3,	'Paulo Rogerio de Oliveira',		'1973-10-11',	'7777-0405',	'www.proger.com',	'paulo@proger.com.br');
INSERT INTO clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(4,	'Cristina Pereira Matos',		'1970-10-11',	'2222-7885',	'www.santista.com',	'cristina@uol.com.br');
INSERT INTO clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(4,	'Fabia Castilho Almeida',		'1981-10-11',	'4545-4596',	'www.castilho.com',	'fabia@terra.com.br');
INSERT INTO clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(4,	'Andre Cristovao Santos',		'1980-10-11',	'2202-7272',	'',			'andre@terra.com.br');
INSERT INTO clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(4,	'Andresa Santos Matias',		'1990-10-11',	'1010-1396',	'',			'andresa@brfree.com.br');
--
--
-- Inserindo registros na tabela contas
--
INSERT INTO contas(fkcliente,nome,dtabertura) VALUES(1,'semana01','2002-10-01');
INSERT INTO contas(fkcliente,nome,dtabertura) VALUES(2,'semana02','2002-10-20');
INSERT INTO contas(fkcliente,nome,dtabertura) VALUES(2,'semana03','2002-09-10');
INSERT INTO contas(fkcliente,nome,dtabertura) VALUES(3,'semana04','2002-09-03');
INSERT INTO contas(fkcliente,nome,dtabertura) VALUES(3,'semana05','2002-01-01');
INSERT INTO contas(fkcliente,nome,dtabertura) VALUES(3,'semana06','2002-02-15');
INSERT INTO contas(fkcliente,nome,dtabertura) VALUES(4,'semana07','2002-05-01');
INSERT INTO contas(fkcliente,nome,dtabertura) VALUES(4,'semana08','2002-06-09');
INSERT INTO contas(fkcliente,nome,dtabertura) VALUES(4,'semana09','2002-07-01');
INSERT INTO contas(fkcliente,nome,dtabertura) VALUES(4,'semana10','2002-10-11');
INSERT INTO contas(fkcliente,nome,dtabertura) VALUES(5,'semana11','2002-10-10');
INSERT INTO contas(fkcliente,nome,dtabertura) VALUES(5,'semana12','2002-10-01');
INSERT INTO contas(fkcliente,nome,dtabertura) VALUES(5,'semana13','2002-07-20');
INSERT INTO contas(fkcliente,nome,dtabertura) VALUES(5,'semana14','2002-06-01');
INSERT INTO contas(fkcliente,nome,dtabertura) VALUES(5,'semana15','2002-05-07');
INSERT INTO contas(fkcliente,nome,dtabertura) VALUES(6,'semana16','2002-02-01');
INSERT INTO contas(fkcliente,nome,dtabertura) VALUES(6,'semana17','2002-01-08');
INSERT INTO contas(fkcliente,nome,dtabertura) VALUES(6,'semana18','2002-09-01');
INSERT INTO contas(fkcliente,nome,dtabertura) VALUES(6,'semana19','2002-09-04');
INSERT INTO contas(fkcliente,nome,dtabertura) VALUES(6,'semana20','2002-10-28');
INSERT INTO contas(fkcliente,nome,dtabertura) VALUES(6,'semana21','2002-10-28');
--
--
-- Inserindo registros na tabela movimentos
--
-- movimentos da conta 1
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(1,'salario',2000,0);
-- movimentos da conta 2
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(2,'vendas',50000,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(2,'luz',0,200);
-- movimentos da conta 3
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(3,'vendas',0,2000);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(3,'combustivel',5000,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(3,'luz',0,200);
-- movimentos da conta 4
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(4,'combustivel',500,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(4,'luz',0,200);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(4,'vendas',0,2000);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(4,'combustivel',10,0);
-- movimentos da conta 5
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(5,'combustivel',100,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(5,'luz',0,200);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(5,'combustivel',50,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(5,'vendas',0,2000);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(5,'combustivel',30,0);
-- movimentos da conta 6
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(6,'luz',0,200);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(6,'vendas',0,3000);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(6,'combustivel',10,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(6,'vendas',0,200);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(6,'combustivel',10,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(6,'luz',0,200);
-- movimentos da conta 7
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(7,'combustivel',700,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(7,'vendas',0,10000);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(7,'combustivel',500,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(7,'combustivel',30,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(7,'vendas',0,20000);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(7,'combustivel',90,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(7,'luz',0,200);
-- movimentos da conta 8
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(8,'combustivel',900,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(8,'vendas',0,3000);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(8,'combustivel',300,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(8,'combustivel',300,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(8,'vendas',0,5000);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(8,'luz',0,200);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(8,'luz',0,200);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(8,'combustivel',10,0);
-- movimentos da conta 9
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(9,'combustivel',400,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(9,'vendas',0,7000);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(9,'combustivel',10,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(9,'combustivel',10,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(9,'combustivel',100,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(9,'vendas',0,6000);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(9,'vendas',0,4000);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(9,'combustivel',100,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(9,'luz',0,200);
-- movimentos da conta 10
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(10,'combustivel',300,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(10,'combustivel',40,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(10,'vendas',0,20);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(10,'combustivel',10,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(10,'combustivel',110,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(10,'luz',0,200);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(10,'combustivel',100,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(10,'combustivel',100,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(10,'vendas',0,2500);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(10,'vendas',0,2600);
-- movimentos da conta 11
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(11,'luz',0,50);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(11,'salario',5000,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(11,'manutencao',0,50000);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(11,'supermercado',0,3000);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(11,'manutencao',0,8000);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(11,'escritorio',0,5000);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(11,'carro',0,36000);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(11,'predio',0,60000);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(11,'vendas',7000,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(11,'luz',0,8000);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(11,'manutencao',0,4000);
-- movimentos da conta 12
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(12,'vendas',4000,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(12,'escritorio',0,50000);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(12,'manutencao',0,40000);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(12,'vendas',10000,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(12,'escritorio',0,70000);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(12,'manutencao',0,4000);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(12,'vendas',80000,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(12,'escritorio',0,20000);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(12,'manutencao',0,4000);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(12,'vendas',10000,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(12,'escritorio',0,5000);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(12,'manutencao',0,10000);
-- movimentos da conta 13
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
-- movimentos da conta 14
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',20000,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(14,'salario',8000,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',2000,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(14,'salario',5000,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',9000,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(14,'salario',6000,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',3000,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(14,'salario',9000,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',8000,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(14,'salario',7000,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',9000,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(14,'supermercado',0,5000);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',2000,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(14,'combustivel',9000,0);
-- movimentos da conta 15 
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(15,'combustivel',0,2000);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(15,'combustivel',0,2000);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(15,'escritorio',0,2000);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(15,'escritorio',0,2000);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(15,'escritorio',0,2000);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
-- movimentos da conta 16
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas',5000,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas',5000,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas',5000,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas',5000,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas loja',5000,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas loja',5000,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas loja',5000,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(16,'suporte',5000,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(16,'suporte',5000,0);
-- movimentos da conta 17
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(17,'escritorio',0,500);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(17,'combustivel',0,500);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(17,'combustivel',0,500);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(17,'combustivel',0,500);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(17,'carro',0,500);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(17,'carro',0,500);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
-- movimentos da conta 18
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(18,'suporte',8000,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(18,'vendas loja',8000,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(18,'vendas loja',8000,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(18,'vendas loja',8000,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(18,'vendas loja',8000,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(18,'suporte',8000,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(18,'suporte',8000,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(18,'suporte',8000,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(18,'suporte',8000,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(18,'suporte',8000,0);
-- movimentos da conta 19
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(19,'caixa interno',0,500);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(19,'caixa interno',0,500);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(19,'caixa interno',0,500);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(19,'predio',0,500);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(19,'predio',0,500);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(19,'predio',0,500);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(19,'predio',0,500);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(19,'predio',0,500);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
-- movimentos da conta 20
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(20,'vendas',8000,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(20,'vendas',8000,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(20,'vendas',8000,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(20,'suporte ',8000,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(20,'suporte ',8000,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(20,'suporte ',8000,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(20,'suporte ',8000,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(20,'suporte ',8000,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(20,'vendas',8000,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(20,'vendas',8000,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(20,'vendas',8000,0);
-- movimentos da conta 21
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(21,'combustivel',0,50);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(21,'reforma',0,50);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(21,'manutencao',0,50);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(21,'combustivel',0,50);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(21,'salario',0,50);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(21,'salario',0,50);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(21,'reforma',0,50);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(21,'reforma',0,50);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
-- ==========================================================================================================
-- Esquema desenvolvimento
--
CREATE SCHEMA desenvolvimento;
--
-- Criando a tabela desenvolvimento.empresas
--
CREATE TABLE desenvolvimento.empresas(
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
-- Criando a tabela desenvolvimento.clientes
--
CREATE TABLE desenvolvimento.clientes(
			id 		SERIAL 		PRIMARY KEY,
			fkempresa 	INTEGER,
			nome 		VARCHAR(50),
			dtnascimento 	DATE,
			telres 		VARCHAR(20),
			site 		VARCHAR(40),
			email 		VARCHAR(40),
			saldo		NUMERIC(12,2)	DEFAULT 0,
			obs             TEXT,
			CONSTRAINT desenvolvimento_empresas_clientes FOREIGN KEY(fkempresa)
							REFERENCES desenvolvimento.empresas(id)
							ON DELETE RESTRICT
							ON UPDATE CASCADE
					
);
--
--
-- Criando a tabela desenvolvimento.contas
--
CREATE TABLE desenvolvimento.contas(
			id 		SERIAL 		PRIMARY KEY,
			fkcliente 	INTEGER,
			nome 		VARCHAR(50),
			dtabertura	DATE,
			saldo		NUMERIC(12,2)	DEFAULT 0,
			CONSTRAINT desenvolvimento_clientes_contas FOREIGN KEY(fkcliente)
							REFERENCES desenvolvimento.clientes(id)
							ON DELETE RESTRICT
							ON UPDATE CASCADE
);
--
--
-- Criando a TABLE a desenvolvimento.movimentos
--
CREATE TABLE desenvolvimento.movimentos(
			id 		SERIAL 		PRIMARY KEY,
			fkconta 	INTEGER,
			historico 	VARCHAR(50),
			credito 	NUMERIC(11,2)	DEFAULT 0,
			debito 		NUMERIC(11,2)	DEFAULT 0,
			CONSTRAINT desenvolvimento_contas_movimentos FOREIGN KEY(fkconta)
							REFERENCES desenvolvimento.contas(id)
							ON DELETE RESTRICT
							ON UPDATE CASCADE
);
--
--
-- Criando a tabela movempresas
--
CREATE TABLE desenvolvimento.movempresas(
			id 		SERIAL 		PRIMARY KEY,
			fkempresa 	INTEGER,
			historico 	VARCHAR(50),
			credito 	NUMERIC(11,2)	DEFAULT 0,
			debito 		NUMERIC(11,2)	DEFAULT 0,
			CONSTRAINT desenvolvimento_empresas_movempresas FOREIGN KEY(fkempresa)
							REFERENCES desenvolvimento.empresas(id)
							ON DELETE RESTRICT
							ON UPDATE CASCADE
);
--
--
-- Criando a tabela precos
--
CREATE TABLE desenvolvimento.precos(
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
CREATE TABLE desenvolvimento.precos_log_del(
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
-- Inserindo registros na tabela desenvolvimento.empresas
--
INSERT INTO desenvolvimento.empresas(nome,dtcadastro,telcom,site,email) VALUES('MundoByte Informatica',	'1995-11-11',	'222-0909',	'www.mundobyte.com.br',	'relacoes@mundobyte.com.br');
INSERT INTO desenvolvimento.empresas(nome,dtcadastro,telcom,site,email) VALUES('TecTel - informatica',	'1995-01-09',	'333-0909',	'www.tectel.com.br',	'info@tectel.com.br');
INSERT INTO desenvolvimento.empresas(nome,dtcadastro,telcom,site,email) VALUES('Vulcano S/A',		'2002-10-31',	'211-0909',	'www.vulcano.com.br',	'informacoes@vulcano.com.br');
INSERT INTO desenvolvimento.empresas(nome,dtcadastro,telcom,site,email) VALUES('Softmax',		'2000-10-05',	'211-0909',	'www.vulcano.com.br',	'softmax@softmax.com.br');
--
--
-- Inserindo registros na tabela desenvolvimento.clientes
--
INSERT INTO desenvolvimento.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(1,	'Rodrigo de Oliveira Silva',		'1973-12-12',	'3434-0909',	' ',			'rodrigo@ig.com.br');
INSERT INTO desenvolvimento.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(2,	'Melissa Pereira da Silva',		'1970-01-04',	'4444-0011',	'www.mwbrasil.com.br ',	'rose@ig.com.br');
INSERT INTO desenvolvimento.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(2,	'Elisangela Almeida de Oliveira',	'1973-10-31',	'3434-7879',	' ',			'eli@brfree.com.br');
INSERT INTO desenvolvimento.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(3,	'Andre Tritapepe de Matias',		'1973-12-31',	'3434-8596',	' ',			'andre@trita.com.br');
INSERT INTO desenvolvimento.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(3,	'Michela Almeida de Alcantara',		'1980-04-01',	'8888-0101',	' ',			'michela@psico.com.br');
INSERT INTO desenvolvimento.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(3,	'Paulo Rogerio de Oliveira',		'1973-10-11',	'7777-0405',	'www.proger.com',	'paulo@proger.com.br');
INSERT INTO desenvolvimento.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(4,	'Cristina Pereira Matos',		'1970-10-11',	'2222-7885',	'www.santista.com',	'cristina@uol.com.br');
INSERT INTO desenvolvimento.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(4,	'Fabia Castilho Almeida',		'1981-10-11',	'4545-4596',	'www.castilho.com',	'fabia@terra.com.br');
INSERT INTO desenvolvimento.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(4,	'Andre Cristovao Santos',		'1980-10-11',	'2202-7272',	'',			'andre@terra.com.br');
INSERT INTO desenvolvimento.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(4,	'Andresa Santos Matias',		'1990-10-11',	'1010-1396',	'',			'andresa@brfree.com.br');
--
--
-- Inserindo registros na tabela desenvolvimento.contas
--
INSERT INTO desenvolvimento.contas(fkcliente,nome,dtabertura) VALUES(1,'semana01','2002-10-01');
INSERT INTO desenvolvimento.contas(fkcliente,nome,dtabertura) VALUES(2,'semana02','2002-10-20');
INSERT INTO desenvolvimento.contas(fkcliente,nome,dtabertura) VALUES(2,'semana03','2002-09-10');
INSERT INTO desenvolvimento.contas(fkcliente,nome,dtabertura) VALUES(3,'semana04','2002-09-03');
INSERT INTO desenvolvimento.contas(fkcliente,nome,dtabertura) VALUES(3,'semana05','2002-01-01');
INSERT INTO desenvolvimento.contas(fkcliente,nome,dtabertura) VALUES(3,'semana06','2002-02-15');
INSERT INTO desenvolvimento.contas(fkcliente,nome,dtabertura) VALUES(4,'semana07','2002-05-01');
INSERT INTO desenvolvimento.contas(fkcliente,nome,dtabertura) VALUES(4,'semana08','2002-06-09');
INSERT INTO desenvolvimento.contas(fkcliente,nome,dtabertura) VALUES(4,'semana09','2002-07-01');
INSERT INTO desenvolvimento.contas(fkcliente,nome,dtabertura) VALUES(4,'semana10','2002-10-11');
INSERT INTO desenvolvimento.contas(fkcliente,nome,dtabertura) VALUES(5,'semana11','2002-10-10');
INSERT INTO desenvolvimento.contas(fkcliente,nome,dtabertura) VALUES(5,'semana12','2002-10-01');
INSERT INTO desenvolvimento.contas(fkcliente,nome,dtabertura) VALUES(5,'semana13','2002-07-20');
INSERT INTO desenvolvimento.contas(fkcliente,nome,dtabertura) VALUES(5,'semana14','2002-06-01');
INSERT INTO desenvolvimento.contas(fkcliente,nome,dtabertura) VALUES(5,'semana15','2002-05-07');
INSERT INTO desenvolvimento.contas(fkcliente,nome,dtabertura) VALUES(6,'semana16','2002-02-01');
INSERT INTO desenvolvimento.contas(fkcliente,nome,dtabertura) VALUES(6,'semana17','2002-01-08');
INSERT INTO desenvolvimento.contas(fkcliente,nome,dtabertura) VALUES(6,'semana18','2002-09-01');
INSERT INTO desenvolvimento.contas(fkcliente,nome,dtabertura) VALUES(6,'semana19','2002-09-04');
INSERT INTO desenvolvimento.contas(fkcliente,nome,dtabertura) VALUES(6,'semana20','2002-10-28');
INSERT INTO desenvolvimento.contas(fkcliente,nome,dtabertura) VALUES(6,'semana21','2002-10-28');
--
--
-- Inserindo registros na tabela desenvolvimento.movimentos
--
-- desenvolvimento.movimentos da conta 1
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(1,'salario',2000,0);
-- desenvolvimento.movimentos da conta 2
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(2,'vendas',50000,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(2,'luz',0,200);
-- desenvolvimento.movimentos da conta 3
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(3,'vendas',0,2000);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(3,'combustivel',5000,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(3,'luz',0,200);
-- desenvolvimento.movimentos da conta 4
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(4,'combustivel',500,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(4,'luz',0,200);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(4,'vendas',0,2000);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(4,'combustivel',10,0);
-- desenvolvimento.movimentos da conta 5
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(5,'combustivel',100,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(5,'luz',0,200);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(5,'combustivel',50,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(5,'vendas',0,2000);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(5,'combustivel',30,0);
-- desenvolvimento.movimentos da conta 6
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(6,'luz',0,200);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(6,'vendas',0,3000);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(6,'combustivel',10,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(6,'vendas',0,200);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(6,'combustivel',10,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(6,'luz',0,200);
-- desenvolvimento.movimentos da conta 7
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(7,'combustivel',700,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(7,'vendas',0,10000);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(7,'combustivel',500,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(7,'combustivel',30,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(7,'vendas',0,20000);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(7,'combustivel',90,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(7,'luz',0,200);
-- desenvolvimento.movimentos da conta 8
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(8,'combustivel',900,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(8,'vendas',0,3000);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(8,'combustivel',300,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(8,'combustivel',300,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(8,'vendas',0,5000);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(8,'luz',0,200);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(8,'luz',0,200);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(8,'combustivel',10,0);
-- desenvolvimento.movimentos da conta 9
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(9,'combustivel',400,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(9,'vendas',0,7000);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(9,'combustivel',10,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(9,'combustivel',10,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(9,'combustivel',100,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(9,'vendas',0,6000);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(9,'vendas',0,4000);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(9,'combustivel',100,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(9,'luz',0,200);
-- desenvolvimento.movimentos da conta 10
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(10,'combustivel',300,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(10,'combustivel',40,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(10,'vendas',0,20);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(10,'combustivel',10,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(10,'combustivel',110,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(10,'luz',0,200);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(10,'combustivel',100,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(10,'combustivel',100,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(10,'vendas',0,2500);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(10,'vendas',0,2600);
-- desenvolvimento.movimentos da conta 11
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(11,'luz',0,50);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(11,'salario',5000,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(11,'manutencao',0,50000);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(11,'supermercado',0,3000);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(11,'manutencao',0,8000);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(11,'escritorio',0,5000);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(11,'carro',0,36000);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(11,'predio',0,60000);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(11,'vendas',7000,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(11,'luz',0,8000);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(11,'manutencao',0,4000);
-- desenvolvimento.movimentos da conta 12
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(12,'vendas',4000,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(12,'escritorio',0,50000);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(12,'manutencao',0,40000);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(12,'vendas',10000,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(12,'escritorio',0,70000);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(12,'manutencao',0,4000);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(12,'vendas',80000,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(12,'escritorio',0,20000);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(12,'manutencao',0,4000);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(12,'vendas',10000,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(12,'escritorio',0,5000);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(12,'manutencao',0,10000);
-- desenvolvimento.movimentos da conta 13
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
-- desenvolvimento.movimentos da conta 14
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',20000,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(14,'salario',8000,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',2000,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(14,'salario',5000,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',9000,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(14,'salario',6000,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',3000,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(14,'salario',9000,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',8000,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(14,'salario',7000,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',9000,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(14,'supermercado',0,5000);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',2000,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(14,'combustivel',9000,0);
-- desenvolvimento.movimentos da conta 15 
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(15,'combustivel',0,2000);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(15,'combustivel',0,2000);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(15,'escritorio',0,2000);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(15,'escritorio',0,2000);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(15,'escritorio',0,2000);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
-- desenvolvimento.movimentos da conta 16
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas',5000,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas',5000,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas',5000,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas',5000,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas loja',5000,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas loja',5000,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas loja',5000,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(16,'suporte',5000,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(16,'suporte',5000,0);
-- desenvolvimento.movimentos da conta 17
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(17,'escritorio',0,500);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(17,'combustivel',0,500);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(17,'combustivel',0,500);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(17,'combustivel',0,500);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(17,'carro',0,500);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(17,'carro',0,500);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
-- desenvolvimento.movimentos da conta 18
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(18,'suporte',8000,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(18,'vendas loja',8000,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(18,'vendas loja',8000,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(18,'vendas loja',8000,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(18,'vendas loja',8000,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(18,'suporte',8000,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(18,'suporte',8000,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(18,'suporte',8000,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(18,'suporte',8000,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(18,'suporte',8000,0);
-- desenvolvimento.movimentos da conta 19
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(19,'caixa interno',0,500);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(19,'caixa interno',0,500);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(19,'caixa interno',0,500);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(19,'predio',0,500);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(19,'predio',0,500);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(19,'predio',0,500);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(19,'predio',0,500);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(19,'predio',0,500);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
-- desenvolvimento.movimentos da conta 20
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(20,'vendas',8000,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(20,'vendas',8000,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(20,'vendas',8000,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(20,'suporte ',8000,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(20,'suporte ',8000,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(20,'suporte ',8000,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(20,'suporte ',8000,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(20,'suporte ',8000,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(20,'vendas',8000,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(20,'vendas',8000,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(20,'vendas',8000,0);
-- desenvolvimento.movimentos da conta 21
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(21,'combustivel',0,50);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(21,'reforma',0,50);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(21,'manutencao',0,50);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(21,'combustivel',0,50);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(21,'salario',0,50);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(21,'salario',0,50);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(21,'reforma',0,50);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(21,'reforma',0,50);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO desenvolvimento.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
-- ==========================================================================================================
-- Esquema producao
--
CREATE SCHEMA producao;
--
-- Criando a tabela producao.empresas
--
CREATE TABLE producao.empresas(
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
-- Criando a tabela producao.clientes
--
CREATE TABLE producao.clientes(
			id 		SERIAL 		PRIMARY KEY,
			fkempresa 	INTEGER,
			nome 		VARCHAR(50),
			dtnascimento 	DATE,
			telres 		VARCHAR(20),
			site 		VARCHAR(40),
			email 		VARCHAR(40),
			saldo		NUMERIC(12,2)	DEFAULT 0,
			obs             TEXT,
			CONSTRAINT producao_empresas_clientes FOREIGN KEY(fkempresa)
							REFERENCES producao.empresas(id)
							ON DELETE RESTRICT
							ON UPDATE CASCADE
					
);
--
--
-- Criando a tabela producao.contas
--
CREATE TABLE producao.contas(
			id 		SERIAL 		PRIMARY KEY,
			fkcliente 	INTEGER,
			nome 		VARCHAR(50),
			dtabertura	DATE,
			saldo		NUMERIC(12,2)	DEFAULT 0,
			CONSTRAINT producao_clientes_contas FOREIGN KEY(fkcliente)
							REFERENCES producao.clientes(id)
							ON DELETE RESTRICT
							ON UPDATE CASCADE
);
--
--
-- Criando a TABLE a producao.movimentos
--
CREATE TABLE producao.movimentos(
			id 		SERIAL 		PRIMARY KEY,
			fkconta 	INTEGER,
			historico 	VARCHAR(50),
			credito 	NUMERIC(11,2)	DEFAULT 0,
			debito 		NUMERIC(11,2)	DEFAULT 0,
			CONSTRAINT producao_contas_movimentos FOREIGN KEY(fkconta)
							REFERENCES producao.contas(id)
							ON DELETE RESTRICT
							ON UPDATE CASCADE
);
--
--
-- Criando a tabela movempresas
--
CREATE TABLE producao.movempresas(
			id 		SERIAL 		PRIMARY KEY,
			fkempresa 	INTEGER,
			historico 	VARCHAR(50),
			credito 	NUMERIC(11,2)	DEFAULT 0,
			debito 		NUMERIC(11,2)	DEFAULT 0,
			CONSTRAINT producao_empresas_movempresas FOREIGN KEY(fkempresa)
							REFERENCES producao.empresas(id)
							ON DELETE RESTRICT
							ON UPDATE CASCADE
);
--
--
-- Criando a tabela precos
--
CREATE TABLE producao.precos(
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
CREATE TABLE producao.precos_log_del(
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
-- Inserindo registros na tabela producao.empresas
--
INSERT INTO producao.empresas(nome,dtcadastro,telcom,site,email) VALUES('MundoByte Informatica',	'1995-11-11',	'222-0909',	'www.mundobyte.com.br',	'relacoes@mundobyte.com.br');
INSERT INTO producao.empresas(nome,dtcadastro,telcom,site,email) VALUES('TecTel - informatica',	'1995-01-09',	'333-0909',	'www.tectel.com.br',	'info@tectel.com.br');
INSERT INTO producao.empresas(nome,dtcadastro,telcom,site,email) VALUES('Vulcano S/A',		'2002-10-31',	'211-0909',	'www.vulcano.com.br',	'informacoes@vulcano.com.br');
INSERT INTO producao.empresas(nome,dtcadastro,telcom,site,email) VALUES('Softmax',		'2000-10-05',	'211-0909',	'www.vulcano.com.br',	'softmax@softmax.com.br');
--
--
-- Inserindo registros na tabela producao.clientes
--
INSERT INTO producao.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(1,	'Rodrigo de Oliveira Silva',		'1973-12-12',	'3434-0909',	' ',			'rodrigo@ig.com.br');
INSERT INTO producao.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(2,	'Melissa Pereira da Silva',		'1970-01-04',	'4444-0011',	'www.mwbrasil.com.br ',	'rose@ig.com.br');
INSERT INTO producao.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(2,	'Elisangela Almeida de Oliveira',	'1973-10-31',	'3434-7879',	' ',			'eli@brfree.com.br');
INSERT INTO producao.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(3,	'Andre Tritapepe de Matias',		'1973-12-31',	'3434-8596',	' ',			'andre@trita.com.br');
INSERT INTO producao.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(3,	'Michela Almeida de Alcantara',		'1980-04-01',	'8888-0101',	' ',			'michela@psico.com.br');
INSERT INTO producao.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(3,	'Paulo Rogerio de Oliveira',		'1973-10-11',	'7777-0405',	'www.proger.com',	'paulo@proger.com.br');
INSERT INTO producao.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(4,	'Cristina Pereira Matos',		'1970-10-11',	'2222-7885',	'www.santista.com',	'cristina@uol.com.br');
INSERT INTO producao.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(4,	'Fabia Castilho Almeida',		'1981-10-11',	'4545-4596',	'www.castilho.com',	'fabia@terra.com.br');
INSERT INTO producao.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(4,	'Andre Cristovao Santos',		'1980-10-11',	'2202-7272',	'',			'andre@terra.com.br');
INSERT INTO producao.clientes(fkempresa,nome,dtnascimento,telres,site,email) VALUES(4,	'Andresa Santos Matias',		'1990-10-11',	'1010-1396',	'',			'andresa@brfree.com.br');
--
--
-- Inserindo registros na tabela producao.contas
--
INSERT INTO producao.contas(fkcliente,nome,dtabertura) VALUES(1,'semana01','2002-10-01');
INSERT INTO producao.contas(fkcliente,nome,dtabertura) VALUES(2,'semana02','2002-10-20');
INSERT INTO producao.contas(fkcliente,nome,dtabertura) VALUES(2,'semana03','2002-09-10');
INSERT INTO producao.contas(fkcliente,nome,dtabertura) VALUES(3,'semana04','2002-09-03');
INSERT INTO producao.contas(fkcliente,nome,dtabertura) VALUES(3,'semana05','2002-01-01');
INSERT INTO producao.contas(fkcliente,nome,dtabertura) VALUES(3,'semana06','2002-02-15');
INSERT INTO producao.contas(fkcliente,nome,dtabertura) VALUES(4,'semana07','2002-05-01');
INSERT INTO producao.contas(fkcliente,nome,dtabertura) VALUES(4,'semana08','2002-06-09');
INSERT INTO producao.contas(fkcliente,nome,dtabertura) VALUES(4,'semana09','2002-07-01');
INSERT INTO producao.contas(fkcliente,nome,dtabertura) VALUES(4,'semana10','2002-10-11');
INSERT INTO producao.contas(fkcliente,nome,dtabertura) VALUES(5,'semana11','2002-10-10');
INSERT INTO producao.contas(fkcliente,nome,dtabertura) VALUES(5,'semana12','2002-10-01');
INSERT INTO producao.contas(fkcliente,nome,dtabertura) VALUES(5,'semana13','2002-07-20');
INSERT INTO producao.contas(fkcliente,nome,dtabertura) VALUES(5,'semana14','2002-06-01');
INSERT INTO producao.contas(fkcliente,nome,dtabertura) VALUES(5,'semana15','2002-05-07');
INSERT INTO producao.contas(fkcliente,nome,dtabertura) VALUES(6,'semana16','2002-02-01');
INSERT INTO producao.contas(fkcliente,nome,dtabertura) VALUES(6,'semana17','2002-01-08');
INSERT INTO producao.contas(fkcliente,nome,dtabertura) VALUES(6,'semana18','2002-09-01');
INSERT INTO producao.contas(fkcliente,nome,dtabertura) VALUES(6,'semana19','2002-09-04');
INSERT INTO producao.contas(fkcliente,nome,dtabertura) VALUES(6,'semana20','2002-10-28');
INSERT INTO producao.contas(fkcliente,nome,dtabertura) VALUES(6,'semana21','2002-10-28');
--
--
-- Inserindo registros na tabela producao.movimentos
--
-- producao.movimentos da conta 1
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(1,'salario',2000,0);
-- producao.movimentos da conta 2
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(2,'vendas',50000,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(2,'luz',0,200);
-- producao.movimentos da conta 3
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(3,'vendas',0,2000);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(3,'combustivel',5000,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(3,'luz',0,200);
-- producao.movimentos da conta 4
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(4,'combustivel',500,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(4,'luz',0,200);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(4,'vendas',0,2000);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(4,'combustivel',10,0);
-- producao.movimentos da conta 5
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(5,'combustivel',100,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(5,'luz',0,200);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(5,'combustivel',50,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(5,'vendas',0,2000);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(5,'combustivel',30,0);
-- producao.movimentos da conta 6
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(6,'luz',0,200);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(6,'vendas',0,3000);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(6,'combustivel',10,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(6,'vendas',0,200);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(6,'combustivel',10,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(6,'luz',0,200);
-- producao.movimentos da conta 7
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(7,'combustivel',700,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(7,'vendas',0,10000);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(7,'combustivel',500,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(7,'combustivel',30,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(7,'vendas',0,20000);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(7,'combustivel',90,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(7,'luz',0,200);
-- producao.movimentos da conta 8
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(8,'combustivel',900,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(8,'vendas',0,3000);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(8,'combustivel',300,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(8,'combustivel',300,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(8,'vendas',0,5000);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(8,'luz',0,200);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(8,'luz',0,200);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(8,'combustivel',10,0);
-- producao.movimentos da conta 9
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(9,'combustivel',400,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(9,'vendas',0,7000);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(9,'combustivel',10,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(9,'combustivel',10,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(9,'combustivel',100,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(9,'vendas',0,6000);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(9,'vendas',0,4000);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(9,'combustivel',100,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(9,'luz',0,200);
-- producao.movimentos da conta 10
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(10,'combustivel',300,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(10,'combustivel',40,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(10,'vendas',0,20);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(10,'combustivel',10,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(10,'combustivel',110,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(10,'luz',0,200);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(10,'combustivel',100,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(10,'combustivel',100,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(10,'vendas',0,2500);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(10,'vendas',0,2600);
-- producao.movimentos da conta 11
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(11,'luz',0,50);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(11,'salario',5000,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(11,'manutencao',0,50000);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(11,'supermercado',0,3000);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(11,'manutencao',0,8000);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(11,'escritorio',0,5000);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(11,'carro',0,36000);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(11,'predio',0,60000);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(11,'vendas',7000,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(11,'luz',0,8000);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(11,'manutencao',0,4000);
-- producao.movimentos da conta 12
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(12,'vendas',4000,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(12,'escritorio',0,50000);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(12,'manutencao',0,40000);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(12,'vendas',10000,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(12,'escritorio',0,70000);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(12,'manutencao',0,4000);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(12,'vendas',80000,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(12,'escritorio',0,20000);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(12,'manutencao',0,4000);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(12,'vendas',10000,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(12,'escritorio',0,5000);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(12,'manutencao',0,10000);
-- producao.movimentos da conta 13
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(13,'manutencao',0,10000);
-- producao.movimentos da conta 14
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',20000,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(14,'salario',8000,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',2000,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(14,'salario',5000,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',9000,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(14,'salario',6000,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',3000,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(14,'salario',9000,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',8000,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(14,'salario',7000,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',9000,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(14,'supermercado',0,5000);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(14,'vendas',2000,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(14,'combustivel',9000,0);
-- producao.movimentos da conta 15 
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(15,'combustivel',0,2000);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(15,'combustivel',0,2000);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(15,'escritorio',0,2000);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(15,'escritorio',0,2000);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(15,'escritorio',0,2000);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(15,'supermercado',0,2000);
-- producao.movimentos da conta 16
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas',5000,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas',5000,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas',5000,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas',5000,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas loja',5000,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas loja',5000,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(16,'vendas loja',5000,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(16,'suporte',5000,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(16,'salario',5000,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(16,'suporte',5000,0);
-- producao.movimentos da conta 17
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(17,'escritorio',0,500);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(17,'combustivel',0,500);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(17,'combustivel',0,500);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(17,'combustivel',0,500);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(17,'carro',0,500);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(17,'carro',0,500);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(17,'supermercado',0,500);
-- producao.movimentos da conta 18
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(18,'suporte',8000,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(18,'vendas loja',8000,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(18,'vendas loja',8000,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(18,'vendas loja',8000,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(18,'vendas loja',8000,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(18,'suporte',8000,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(18,'suporte',8000,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(18,'suporte',8000,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(18,'suporte',8000,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(18,'salario',8000,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(18,'suporte',8000,0);
-- producao.movimentos da conta 19
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(19,'caixa interno',0,500);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(19,'caixa interno',0,500);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(19,'caixa interno',0,500);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(19,'predio',0,500);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(19,'predio',0,500);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(19,'predio',0,500);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(19,'predio',0,500);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(19,'predio',0,500);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(19,'supermercado',0,500);
-- producao.movimentos da conta 20
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(20,'vendas',8000,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(20,'vendas',8000,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(20,'vendas',8000,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(20,'suporte ',8000,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(20,'suporte ',8000,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(20,'suporte ',8000,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(20,'suporte ',8000,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(20,'suporte ',8000,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(20,'vendas',8000,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(20,'vendas',8000,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(20,'salario',8000,0);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(20,'vendas',8000,0);
-- producao.movimentos da conta 21
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(21,'combustivel',0,50);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(21,'reforma',0,50);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(21,'manutencao',0,50);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(21,'combustivel',0,50);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(21,'salario',0,50);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(21,'salario',0,50);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(21,'reforma',0,50);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(21,'reforma',0,50);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
INSERT INTO producao.movimentos(fkconta,historico,credito,debito) VALUES(21,'supermercado',0,50);
--
--
-- Funcoes em SQL e PL/PGSQL
-- Somente para esquema Public
-- Funcoes para o esquema Public
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
create or replace function saldo_upd(integer) returns numeric(12,2) as 
'
       update contas set saldo = (
       select sum(movimentos.credito-movimentos.debito)
       from movimentos where movimentos.fkconta = $1) where id = $1;
       select sum(movimentos.credito-movimentos.debito) from movimentos where movimentos.fkconta = $1;
'
language 'sql'
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
language 'plpgsql'
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
