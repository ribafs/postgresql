CREATE TABLE producoes (
	producao int, 
	quantidade int, 
	produto int, 
	mes char(2), 
	ano char(2), 
	tipo int, 
	lote int, 
	PRIMARY KEY(producao),
	FOREIGN KEY(produto) REFERENCES produtos (produto));

CREATE TABLE produtos (
	produto int, 
	descricao varchar(45), 
	tipo int, 
	PRIMARY KEY(produto));

CREATE TABLE tipos (
	tipo int, 
	descricao varchar(45), 
	subtipo int, 
	PRIMARY KEY(tipo),
	FOREIGN KEY(tipo) REFERENCES produtos (tipo));

CREATE TABLE subtipos (
	subtipo int, 
	descricao varchar(45), 
	PRIMARY KEY(subtipo),
	FOREIGN KEY(subtipo) REFERENCES tipos (subtipo));

CREATE TABLE lotes (
	lote int, 
	projeto int, 
	tipo-area int, 
	PRIMARY KEY(lote),
	FOREIGN KEY(projeto) REFERENCES projetos (projeto),
	FOREIGN KEY(lote) REFERENCES producoes (lote));

CREATE TABLE tipos-area (
	tipo int, 
	descricao varchar(50), 
	PRIMARY KEY(tipo),
	FOREIGN KEY(tipo) REFERENCES lotes (tipo-area));

CREATE TABLE projetos (
	projeto int, 
	descricao varchar(50), 
	tipo int, 
	PRIMARY KEY(projeto));

CREATE TABLE tipos-projeto (
	tipo int, 
	descricao varchar(50), 
	PRIMARY KEY(tipo),
	FOREIGN KEY(tipo) REFERENCES projetos (tipo));

CREATE TABLE producao_animal (
	producao int, 
	descricao varchar(50), 
	PRIMARY KEY(producao),
	FOREIGN KEY(producao) REFERENCES producoes (tipo));

CREATE TABLE producao_vegetal (
	producao int, 
	descricao varchar(50), 
	PRIMARY KEY(producao),
	FOREIGN KEY(producao) REFERENCES producoes (tipo));

