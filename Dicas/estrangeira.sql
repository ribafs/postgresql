-- Execute esse script abaixo da seguinte forma:
--
-- createdb estrangeiradb
-- psql estrangeiradb < estrangeira.sql
--
-- abra o banco
-- psql estrangeiradb
--
-- as tabela clientes e pedidos serao criadas junto com seus registros
-- procures executar as querys que estao comentadas neste script
--
-- Criando a tabela clientes
create table clientes(
	id serial primary key not null,
	nome varchar(30)
	);
-- Criando a tabela pedidos
-- campo pedidos(fkcliente) se encontra relacionado com a tabela clientes(id)
create table pedidos(
	id serial primary key not null,
	fkcliente integer,
	produto varchar(30),
	constraint pedidos_clientes foreign key(fkcliente) references clientes(id)
	);
-- Inserindo 5 clientes
-- dessa tabela somente paulo,andre e joao farao pedidos
-- portanto robson e adriano nao farao pedidos
insert into clientes(nome) values('adriano');
insert into clientes(nome) values('andre');
insert into clientes(nome) values('robson');
insert into clientes(nome) values('joao');
insert into clientes(nome) values('paulo');
-- inserindo pedidos para 
-- paulo, andre e joao
insert into pedidos(fkcliente,produto) values(5,'cpu');
insert into pedidos(fkcliente,produto) values(2,'teclado');
insert into pedidos(fkcliente,produto) values(4,'mouse');
-- EMBORA NAO TENHA SENTIDO MAS SO PARA PROVAR QUE TEM COMO
-- INSERIR UM REGISTRO E DEIXAR O CAMPO FOREIGN KEY EM BRANCO OBSERVE
-- QUE A QUERY ABAIXO FUNCIONA!!
-- NESTE EXEMPLO TEREMOS 3 REGISTROS FILHOS SEM NENHUM PAI
insert into pedidos(produto) values('video');
insert into pedidos(produto) values('suporte');
insert into pedidos(produto) values('trackball');
/*
	Execute os select's abaixo:

	Select 01:
	
		select * from clientes;

	portanto mostrarah:

		id		nome
		--------------------
		1		adriano
		2		andre
		3		robson
		4		joao
		5		paulo

	Select 02:

		select * from pedidos;

	obs: 	aqui vc ja percebe que video, suporte e trackball nao possuem clientes
		PROVA IMPORTANTE DE QUE PODEMOS TER CHAVES ESTRANGERAS do tipo NULL
		DESDE DE QUE NAO TENHAM SIDO CRIADAS COM NOT NULL.	

	portanto mostrarah:
		id		fkcliente		produto
		-----------------------------------------------
		1		5			cpu
		2		2			teclado
		3		4			mouse
		4					video
		5					suporte
		6					trackball

			
	Execute os joins abaixo:
	
	Exemplo 01:

		Listar os clientes que fizeram pedidos (SOMENTE OS QUE SE RELACIONAM NA TABELA PAI E FILHO).

		select nome,produto from clientes inner join pedidos on clientes.id = pedidos.fkcliente;

		portanto o resultado serah

		nome		produto
		-----------------------
		andre		teclado
		joao		mouse
		aulo		cpu


	Exemplo 02:
	
		Listar TODOS os clientes e os pedidos que eles fizeram (CASO POSSUAM ALGUM PEDIDO).

		select nome,produto from clientes left join pedidos on clientes.id = pedidos.fkcliente;

		portanto o resultado serah

		nome		produto
		-----------------------
		adriano		
		andre		teclado
		robson		
		joao		mouse
		paulo		cpu


	Exemplo 03:
		
		Listar clientes que possuam pedidos inclusive pedidos que nao possuem clientes
	
		select nome,produto from clientes right join pedidos on clientes.id = pedidos.fkcliente;

		portanto o resultado serah

		nome		produto
		-----------------------
		andre		teclado
		joao		mouse
		paulo		cpu
				video
				suporte
				trackball

	Exemplo 04:

		Listar todos os clientes e todos os pedidos (INCLUINDO CLIENTES QUE NAO POSSUEM PEDIDOS E PEDIDOS QUE NAO POSSUEM CLIENTES)

		select nome,produto from clientes full join pedidos on clientes.id = pedidos.fkcliente;

		portanto o resultado serah

		nome		produto
		-----------------------
		adriano		
		andre		teclado
		robson		
		joao		mouse
		paulo		cpu
				video
				suporte
				trackball


		ESPERO QUE COM ISSO VOCE SAIBA ENTENDER E OUVIR AS PESSOAS QUE APENAS 
		QUEREM LHE EXPLICAR UM CONCEITO SIMPLES DE BANCO DE DADOS NA BOA EM 
		SEM RECENTIMENTOS DE QUEM EH MELHOR OU PIOR NO ASSUNTO.

		OBS 01: TESTEI TODOS OS COMANDO ACIMA

		OBS 02: SE EM ALGUM TOPICO DESTE SCRIPT.SQL EU ERREI ALGUMA COISA ACEITAREI
		MUITO BEM OUTRAS OPINIOES DESDE QUE SEJAM CONSTRUTIVAS E NAO ORGULHOSAS
*/
