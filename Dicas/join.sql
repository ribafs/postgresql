/*
	1.1 Criar a tabela Empresas:
	
		empresas = (id,nome,endereco)

	1.2 Criar uma tabela de historicos que referencie empresas

		historicos = (id,fkempresa,historico,credito,debito)

	1.3 Criar uma tabela de funcionarios que referencie empresas

		funcionarios = (id,fkempresa,nome,cargo,salario)
*/
--
-- Solucao exercicios 1.1, 1.2 e 1.3
--
-- Tabela empresas
create table empresas(
	id serial primary key not null,
	nome varchar(30),
	endereco varchar(30));
--
-- Tabela historicos
create table historicos(
	id serial primary key not null,
	fkempresa integer, 
	historico varchar(30),
	credito numeric(12,2),
	debito numeric(12,2),
	constraint empresas_historicos foreign key(fkempresa) references empresas(id));
--
-- Tabela funcionarios
create table funcionarios(
	id serial primary key not null,
	fkempresa integer,
	nome varchar(30),
	cargo varchar(30),
	salario numeric(12,2),
	constraint empresas_funcionarios foreign key(fkempresa) references empresas(id));
--
-- Inserindo 3 empresas
insert into empresas(nome,endereco) values('abc','rua olivia,250');
insert into empresas(nome,endereco) values('dev','av pablo,300');
insert into empresas(nome,endereco) values('ghi','rua santo antonio,1000');
--
-- Inserindo 3 historicos para cada empresa
-- 3 para Empresa 1
insert into historicos(fkempresa,historico,credito,debito) values(1,'luz',0,200);
insert into historicos(fkempresa,historico,credito,debito) values(1,'vendas',2000,0);
insert into historicos(fkempresa,historico,credito,debito) values(1,'salario',0,1000);
-- 3 para Empresa 2
insert into historicos(fkempresa,historico,credito,debito) values(2,'supermercado',0,800);
insert into historicos(fkempresa,historico,credito,debito) values(2,'caixa',5000,0);
insert into historicos(fkempresa,historico,credito,debito) values(2,'funcionario',0,2000);
-- 3 para Empresa 3
insert into historicos(fkempresa,historico,credito,debito) values(3,'combustivel',0,800);
insert into historicos(fkempresa,historico,credito,debito) values(3,'fundo de caixa',5000,0);
insert into historicos(fkempresa,historico,credito,debito) values(3,'supermercado',0,3000);
--
-- Inserindo 3 funcionarios para cada empresa
-- 3 para Empresa 1
insert into funcionarios(fkempresa,nome,cargo,salario) values(1,'Elisangela Almeida','jornalista',2000);
insert into funcionarios(fkempresa,nome,cargo,salario) values(1,'Rodrigo de Oliveira','Diagramador',5000);
insert into funcionarios(fkempresa,nome,cargo,salario) values(1,'Melissa de Oliveira','Publicitaria',3000);
--
-- 3 para Empresa 2
insert into funcionarios(fkempresa,nome,cargo,salario) values(2,'Andre Tritapepe','Adm Rede',4000);
insert into funcionarios(fkempresa,nome,cargo,salario) values(2,'Michela Santos','Psicologa',3000);
insert into funcionarios(fkempresa,nome,cargo,salario) values(2,'Andre Thiago','Cientista Computacao',2000);
---
-- 3 para Empresa 3
insert into funcionarios(fkempresa,nome,cargo,salario) values(3,'Regina Celia de Oliveira','Administradora',2500);
insert into funcionarios(fkempresa,nome,cargo,salario) values(3,'Gilberto Matias Oliveira','Economista',1200);
insert into funcionarios(fkempresa,nome,cargo,salario) values(3,'Marcos Gusmao','Analista de Sistemas',4000);
/*
	1.4  Selecionar todas as empresas

		select * from empresas


	1.5  Selecionar todas as empresas e seus respectivos funcionarios

		select empresas.nome, funcionarios.nome
		from empresas
		inner join funcionarios on empresas.id = funcionarios.fkempresa;


	1.6  Selecionar todas as empresas e seus respectivos historicos

		select empresas.nome, historicos.historico
		from empresas
		inner join historicos on empresas.id = historicos.fkempresa;

	
	1.7  Selecionar o saldo de historicos de cada empresa

		select empresas.nome, sum(historicos.credito-historicos.debito) as saldo
		from empresas
		inner join historicos on empresas.id = historicos.fkempresa 
		group by empresas.nome;


	1.8  Selecionar o total de folha de pagamentos de cada empresa

		select empresas.nome, sum(funcionarios.salario) as saldo
		from empresas
		inner join funcionarios on empresas.id = funcionarios.fkempresa
		group by empresas.nome;


	1.9  Selecionar todos os funcionarios, com o nome da sua empresa, por ordem decrescente de salario

		select 
		funcionarios.nome as nome_funcionario,
		funcionarios.salario as salario_funcionario,
		empresas.nome as nome_empresa
		from empresas
		inner join funcionarios on empresas.id = funcionarios.fkempresa
		order by funcionarios.salario desc;		

	1.10 Selecionar, somente da Empresa 2,o nome do funcionario,seu salario,e quando ele 
	     representa percentualmente no total da folha de pagamento
	
		
