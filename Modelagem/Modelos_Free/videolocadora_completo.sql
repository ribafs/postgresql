-- Locadora de Vídeos
-- banco: locadora com encoding latin1

create table cep_brasil (
	cep char(8) primary key, 
	tipo char(72), 
	logradouro char(70),
	bairro char(72),
	municipio char(60), 
	uf char(2)
);
-- script com registros do CEP encontra-se em: http://pg.ribafs.net/down/scripts//cep.sql.zip

create table empresas
(
	cnpj varchar(14) primary key,
	razao_social varchar(45) not null,
	cep varchar(8) not null,
	site varchar(50),
	email varchar(40),
	constraint cep_fk foreign key (cep) references cep_brasil (cep)
);

create table telefones -- fixos ou celulares
(
	telefone int primary key,
	pessoa int not null, -- cliente, funcionário ou representante
	prefixo varchar(4) not null,
	numero varchar(10) not null
);

create table funcionarios
(
	funcionario int primary key, --- cpf
	nome varchar(45) not null,
	rg varchar(30) not null,
	data_admissao date not null,
	cep varchar(8) not null,
	telefone varchar(15),
	foto varchar(50) not null,
	administrador boolean not null,		-- para controlar o acesso à algumas seções
	constraint cep_fk foreign key (cep) references cep_brasil (cep),
	constraint telefone_fk foreign key (telefone) references telefones (telefone)
);

create table clientes
(
	cliente int primary key, -- cpf
	nome varchar(45) not null,
	rg varchar(30) not null,
	foto varchar(50), -- para carteira de sócio
	data_cadastro date not null,
	taxa_inscricao numeric(12,2) not null,
	cep varchar(8) not null,
	telefone int not null,
	email varchar(50),
	referencias text not null,
	receber_novidades_email boolean default true not null,
	liberado boolean default TRUE not null, -- boolean -liberado para alugar ou não (bloqueado)
	aprovado_por int not null, -- funcionário que aprovou
	constraint cep_fk foreign key (cep) references cep_brasil (cep),
	constraint telefone_fk foreign key (telefone) references telefones (telefone),
	constraint aprovado_fk foreign key (aprovado_por) references funcionarios (funcionario)
);

create table dependentes
(
	dependente int primary key, -- cpf
	nome varchar(45) not null,
	cliente int not null,
	foto varchar(50), -- para carteira de sócio
	data_cadastro date not null,
	liberado boolean default TRUE not null, -- boolean -liberado para alugar ou não (bloqueado)
	aprovado_por int not null, -- funcionário que aprovou
	constraint cliente_fk foreign key (cliente) references clientes (cliente)
);

create table fornecedores
(
	fornecedor int primary key,
	razao_social varchar(59) not null,
	cpf varchar(11),
	cnpj varchar(14),
	inscricao_estadual varchar(30),
	cep varchar(8) not null,
	telefone int not null,
	site varchar(50),
	contato varchar(45) not null,
	contato_fone varchar(15),
	fax varchar(15),
	observacao text,
	constraint cep_fk foreign key (cep) references cep_brasil (cep),
	constraint telefone_fk foreign key (telefone) references telefones (telefone)
);

create table cheques
(
	cheque varchar(15) primary key, -- número
	cliente int not null,
	banco varchar(10) not null,
	agencia varchar(10) not null,
	data date not null,
	valor numeric(12,2) not null,
	cpf_emitente varchar(11) not null,
	avista boolean default TRUE not null
);

create table formas_pagamento
(
	forma_pagamento int primary key,
	descricao varchar(50)	-- a vista, cheque a vista, cheque predatado, cartão a vista, cartão prazo
);

create table generos
(
	genero int primary key,
	descricao varchar(50) -- romântico, épico, ação, artes marciais, educativos, infantil, ficção científica, documentário, ...
);

create table distribuidoras
(
	distribuidora int primary key,
	nome varchar(45) not null
);

create table filmes
(
	filme int primary key,
	diretor varchar(45) not null, -- poderia ter um cadastro
	duracao varchar(30) not null,
	sinopse text not null,
	foto_cena varchar(50), -- cena principal do filme
	ano varchar(4) not null,
	ator_principal varchar(45) not null, -- poderia ter um cadastro
	ator_coadjuvante varchar(45) not null, -- poderia ter um cadastro
	genero int not null,
	distribuidora int not null,
	titulo varchar(45) not null,
	constraint genero_fk foreign key (genero) references generos (genero),
	constraint distribuidora_fk foreign key (distribuidora) references distribuidoras (distribuidora)
);

create table midia_tipos
(
	tipo int primary key,
	descricao varchar(50) -- fitas VHS, cds ou dvds
);

create table cotacoes
(
	cotacao char(1) primary key, 	-- A, B ou C
	filme int not null,
	valor numeric(12,2)
);

create table compras
(
	compra int primary key,
	data date not null,
	fornecedor int not null,
	constraint fornecedor_fk foreign key (fornecedor) references fornecedores(fornecedor)	
);

create table compra_itens -- alimentada com dados de produtos quando cadastrando os pedidos. É a compra dos produtos
(
	item int primary key,
	compra int not null,
	filme int not null,
	quantidade int not null, -- Será somado ao estoque existente
	preco_unitario numeric(12,2), -- Preço de compra
	estoque_min int not null,
	constraint filme_fk foreign key (filme) references filmes(filme),
	constraint compra_fk foreign key (compra) references compras(compra)
);

create table estoque
(
	estoque int primary key,	-- atenção: mesmo nome da tabela
	fornecedor int not null,
	tipo int not null,
	filme int not null,
	cotacao int not null,  
	custo_aquisicao numeric(12,2) not null,
	data_aquisicao date not null,
	quantidade_copias int not null, -- somar quando receber e subtrair quando alugar
	dub_leg varchar(9) not null, -- dublado ou legendado
	lancamento boolean default FALSE not null,
	observacao text,
	constraint tipo_fk foreign key (tipo) references midia_tipos (tipo),
	constraint filme_fk foreign key (filme) references filmes (filme),
	constraint cotacao_fk foreign key (cotacao) references cotacoes (cotacao),
	constraint fornecedor_fk foreign key (fornecedor) references fornecedores (fornecedor)
);

create table locacoes -- vendas
(
	locacao int primary key,
	estoque int not null,
	cliente int not null,
	data_locacao date not null,
	data_devolucao date not null,
	cheque varchar(15) not null, --numero do cheque
	forma_pagamento int not null,
	multa_atrazo numeric(12,2),
	valor_total numeric(12,2) not null,
	constraint cliente_fk foreign key (cliente) references clientes (cliente),
	constraint estoque_fk foreign key (estoque) references estoque (estoque),
	constraint cheque_fk foreign key (cheque) references cheques (cheque),
	constraint forma_pagamento_fk foreign key (forma_pagamento) references formas_pagamento (forma_pagamento)
);

/*

Sugestões de Relatórios:
Relatorios dos melhores clientes; -- que mais alugaram
Relatório filmes mais locados;
Relatório mais lucrativos;
Relatório filmes em atraso;
Relatorio de clientes que mais locaram no mes;
Relatorio de clientes que mais locaram por periodo;
Relatorio de clientes cadastrados no mes;
Relatorio de filmes cadastrados no mes;
Relatorio de filmes adquiridos no mes com valor;
Relatorio de filmes ausentes da locadora;
Relatório de filmes tipo lançamento;
Relatório de Locações de Devoluções
Relatório de Locações de Devoluções por Período
Relatório de Aniversariantes
Gráficos de alguns relatórios-

Sugestões:
- Implementar sistema de autenticação tendo como base a tabela de funcionários e controlando
quem tem acesso a que áreas do sistema. Exemplo: o atendendo não teria acesso ao estoque, somente
os usuários administradores.
- Rotina para backup automático (cron ou agendador de tarefas ou ainda o pgagent) e restauração.
- Computador para consulta de filmes pelos clientes.
- Site contendo imagens dos filmes para aluguél via telefone ou e-mail.
Aqui terá pelo menos os filmes existentes, endereço, telefone e e-mail de contato que consulte 
seus e-mails com boa frequência. Outras informações consideradas úteis.
Como também poderá oferrecer uma loja completa pela internet.
- Validar CPF e CNPJ com função em plpgsql.

Ribamar FS - http://pg.ribafs.net

Adaptação de esquema encontrado em:
http://bechelli.org/files/access/videolocadora_2005.pdf
Dos professores Carlos, Vivian e Rodrigo
*/
