-- Banco de teste para o curso de PostgreSQL do Evolução
-- 
/*
Controle de Estoque é o conjunto de atividades que tem como objetivo colocar na empresa a mercadoria
adequada, no tempo adequado e com custo adequado (mínimo).
Com isso a empresa pretende oferecer ao cliente um nível de satisfação ótimo com o menor custo possível.
Responder as perguntas:
- Que mercadorias manter em estoque?
- Em que quantidades?
- Quando adquiri-las?
*/
-- Banco - controle_estoque
-- 
--
create table empresas
(
	empresa int primary key,
	cnpj char(20) not null,
	razao_social char(45) not null,
	rua char(30),
	bairro char(30),
	numero char(4),
	cidade char(30),
	uf char(2),
	site char(50)
);
--
-- Tanto em empresas quanto em clientes, endereços, bairros, cidades e ufs devem ter seus cadstros separados e relacionar com estes
--
create table clientes
(
	cliente int primary key,
	cpf char(11), -- Caso os clientes sejam também empresas o campo deveria ser cpf_cnpj
	nome char(45) not null,
	credito_liberado char(1) not null check( credito_liberado='s' OR credito_liberado = 'n'),
	data_nasc date,
	email varchar(50)
);
--
create table funcionarios
(
	funcionario int primary key,
	cpf char(11),
	nome char(45) not null,
	senha char(32) not null,
	email varchar(50),
	data_nasc date not null,
	empresa int not null,
	constraint empresa_fk foreign key (empresa) references empresas(empresa)
);
--
create table fornecedores
(
	fornecedor int primary key,
	cnpj char(20),
	nome char(45) not null,
	site varchar(50),
	email char (50),
	contato char(50),
	telefone char(15)
);
--
create table produtos
(
	produto int primary key,
	descricao varchar(100) not null,
	unidade char(4) not null, 	-- aqui também é interessante um cadastro de unidades e relacionar com este campo
	data_cadastro timestamp without time zone not null
);
--
-- O estoque, em grandes empresas, também deve estar ligado ao cadastro de almoxarifados, onde localizam-se os produtos
--
create table compras
(
	compra int primary key,
	data_atualizacao timestamp without time zone not null,
	fornecedor int not null,
	constraint fornecedor_fk foreign key (fornecedor) references fornecedores(fornecedor)
);
--
create table compra_itens -- alimentada com dados de produtos quando cadastrando os pedidos. É a compra dos produtos
(
	item int primary key,
	compra int not null,
	produto int not null,
	quantidade int not null, -- Será somado ao estoque existente
	preco_unitario numeric(12,2), -- Preço de compra
	estoque_min int not null,
	constraint produto_fk foreign key (produto) references produtos(produto),
	constraint compra_fk foreign key (compra) references compras(compra)
);
-- 
create table armazens
(
	armazem int primary key,
	descricao varchar(100) not null,
	armario char(50) not null, -- Aqui merece um cadastro separado para os armarios e relacionar com este campo
	prateleira int not null	-- Este campo seria da tabela armarios e sairia daqui
);
-- 
create table estoque
(
	codigo int primary key, -- Cada compra e cada venda de produto atualizar o estoque. Na compra a atualização é manual e na venda automático
	quant_estoque int not null, -- Alterado em cada compra 
	estoque_max int not null, -- Alertará nas comprar
	estoque_min int not null, -- Alertará nas vendas (pedidos)
	preco_venda numeric(12,2) not null, -- Aqui o preço de venda já tem a margem de lucro em cima do preço de compra
	data_atualizacao timestamp without time zone not null,
	armazem int not null,
	compra_item int not null,
	constraint armazem_fk foreign key (armazem) references armazens(armazem),
	constraint compra_fk foreign key (compra_item) references compra_itens(item)
);
--
create table pedidos
(
	pedido int primary key,
	cliente int not null, -- A referência também poderia ser aqui no campo, assim: REFERENCES clientes(cliente)
	funcionario int not null,
	data_pedido date not null,
	data_confirmacao date not null, --data da baixa no estoque. Na compra alertar sobre o estoque_min
	constraint cliente_fk foreign key (cliente) references clientes(cliente),
	constraint funcionario_fk foreign key (funcionario) references funcionarios(funcionario)
);
--
create table bonus
(
	bonus int primary key,
	valor_bonus numeric(12,2) not null, -- em R$, 3% sobre o total do pedido
	pedido int not null,
	data_pedido timestamp without time zone not null,
	constraint pedido_fk foreign key (pedido) REFERENCES pedidos(pedido)
);
--
create table comissoes
(
	comissao int primary key,
	valor_comissao numeric(12,2) not null, -- em R$, 5% sobre o total do pedido
	data_pedido timestamp without time zone not null,
	pedido int not null,
	constraint pedido_fk foreign key(pedido) REFERENCES pedidos (pedido)
);
--
-- Aqui, ao cadastrar o pedido, uma trigger ou uma rule atualiza automaticamente a tabela de bonus e de comissoes
--
create table pedido_itens
(
	item int primary key,
	estoque int not null,
	quantidade int not null,
	preco_venda numeric(12,2) not null,
	pedido int not null,
	constraint estoque_fk foreign key (estoque) references estoque(codigo),
	constraint pedido_fk foreign key (pedido) references pedidos(pedido)
);

-- Após cada insert, update ou delete do pedido alterar a tabela reposicoes com os valores dos produtos
-- para alertar quando o valor do quant_estoque igualar o estoque_min, que seja feita a reposição do estoque
--
-- A compra já sugere itens e também notas fiscais e itens de notas fiscais
--
-- Obs.: Quando os estoques mínimos e máximo forem menores ou iguais aos mínimos, exibir os registros da tabela reposicao 
/* Para tabelas já existentes podemos adicionar relacionamento assim, alterando a tabela:
ALTER TABLE pedidos ADD CONSTRAINT pedidos_cli_fk FOREIGN KEY (cliente) REFERENCES clientes (cliente);
*/

-- Mais algumas boas restrições que tornarão este banco mais robusto assim como aliviará o trabalho dos desenvolvedores
-- de aplicativos. Analise cada uma e após a criação teste seu funcionamento, tentando violar as restrições, por exemplo:
-- digitando um e-mail do cliente sem o @

ALTER TABLE clientes ADD CHECK (length(cpf)=11);
ALTER TABLE clientes ADD CHECK (data_nasc >'1900-01-01' AND data_nasc < CURRENT_DATE);
ALTER TABLE clientes ADD CHECK (POSITION('@' IN email)>0);
--
ALTER TABLE estoque ADD CHECK (quant_estoque > 0);
ALTER TABLE estoque ALTER COLUMN data_atualizacao SET DEFAULT CURRENT_DATE;
--
--
INSERT INTO empresas (empresa,cnpj,razao_social, rua,bairro,numero,cidade,uf,site) VALUES 
(1,'11.111/0001-12', 'TI Consultoria', 'Dos Anzóis', 'Benfica', '1234','Fortaleza', 'CE', 'http://www.ticonsultoria.com.br');
--
-- Observe que especificando os campos, podemos alterar a ordem de inserção
--
INSERT INTO clientes (cliente,cpf,nome,credito_liberado,email,data_nasc) VALUES 
(1,'11111111111', 'Joao Pereira Brito', 's', 'joao@brito.com', '14/04/1976'),
(2,'11111111112', 'Roberto Pereira Brito', 'n', 'roberto@brito.com', '14/04/1966'),
(3,'11111111113', 'Antônio Pereira Brito', 'n', 'antonio@brito.com', '14/04/1986'),
(4,'11111111114', 'Carlos Pereira Brito', 's', 'carlos@brito.com', '14/12/1976'),
(5,'11111111115', 'Otoniel Pereira Brito', 's', 'otoniel@brito.com', '14/04/1976'),
(6,'11111111116', 'Helena Pereira Brito', 's', 'helena@brito.com', '14/05/1976'),
(7,'11111111117', 'Flávio Pereira Brito', 's', 'flavio@brito.com', '14/06/1976'),
(8,'11111111118', 'Joana Pereira Brito', 'n', 'joana@brito.com', '14/07/1976'),
(9,'11111111119', 'Francisco Pereira Brito', 'n', 'francisco@brito.com', '14/08/1976'),
(10,'11111111110', 'Jorge Pereira Brito', 's', 'jorje@brito.com', '14/09/1976'),
(11,'11111111121', 'Pedro Pereira Brito', 's', 'pedro@brito.com', '14/10/1976'),
(12,'11111111131', 'Ribamar Pereira Brito', 's', 'ribamar@brito.com', '14/11/1976'),
(13,'11111111141', 'Tiago Pereira Brito', 's', 'tiago@brito.com', '14/11/1976'),
(14,'11111111151', 'Elias Pereira Brito', 'n', 'elias@brito.com', '14/12/1976'),
(15,'11111111161', 'Marcos Pereira Brito', 's', 'marcos@brito.com', '14/04/1977'),
(16,'11111111171', 'Ricardo Pereira Brito', 's', 'ricardo@brito.com', '14/04/1978'),
(17,'11111111181', 'Rômulo Pereira Brito', 's', 'romulo@brito.com', '14/04/1979'),
(18,'11111111191', 'Henrique Pereira Brito', 'n', 'henrique@brito.com', '14/04/1975'),
(19,'11111111101', 'Francis Pereira Brito', 's', 'francis@brito.com', '14/04/1974'),
(20,'11111111211', 'Otávio Pereira Brito', 's', 'otavio@brito.com', '14/04/1973'),
(21,'11111111311', 'Rogério Pereira Brito', 's', 'rogerio@brito.com', '14/04/1972'),
(22,'11111111411', 'Jurandir Pereira Brito', 's', 'jurandir@brito.com', '14/04/1971'),
(23,'11111111511', 'Raquél Pereira Brito', 'n', 'raquel@brito.com', '14/04/1970');
--
--
INSERT INTO funcionarios (funcionario,cpf,nome,senha,email,data_nasc, empresa) VALUES 
(1,'11111111111', 'Joao Pereira Brito', '12345678', 'joao@brito.com', '14/04/1976', 1),
(2,'11111111112', 'Roberto Pereira Brito', '33345678', 'roberto@brito.com', '14/04/1966', 1),
(3,'11111111113', 'Antônio Pereira Brito', 'gg345678', 'antonio@brito.com', '14/04/1986', 1),
(4,'11111111114', 'Carlos Pereira Brito', 's345678', 'carlos@brito.com', '14/12/1976', 1),
(5,'11111111115', 'Otoniel Pereira Brito', 's34567844', 'otoniel@brito.com', '14/04/1976', 1),
(6,'11111111116', 'Helena Pereira Brito', '345678s', 'helena@brito.com', '14/05/1976', 1),
(7,'11111111117', 'Flávio Pereira Brito', '66345678s', 'flavio@brito.com', '14/06/1976', 1),
(8,'11111111118', 'Joana Pereira Brito', 'jjj345678n', 'joana@brito.com', '14/07/1976', 1),
(9,'11111111119', 'Francisco Pereira Brito', 'nn345678n', 'francisco@brito.com', '14/08/1976', 1),
(10,'11111111110', 'Jorge Pereira Brito', '88345678s', 'jorje@brito.com', '14/09/1976', 1),
(11,'11111111121', 'Pedro Pereira Brito', '99345678s', 'pedro@brito.com', '14/10/1976', 1),
(12,'11111111131', 'Ribamar Pereira Brito', '44345678s', 'ribamar@brito.com', '14/11/1976', 1),
(13,'11111111141', 'Tiago Pereira Brito', 's66345678', 'tiago@brito.com', '14/11/1976', 1),
(14,'11111111151', 'Elias Pereira Brito', 'n77345678', 'elias@brito.com', '14/12/1976', 1),
(15,'11111111161', 'Marcos Pereira Brito', 's44345678', 'marcos@brito.com', '14/04/1977', 1),
(16,'11111111171', 'Ricardo Pereira Brito', 's33345678', 'ricardo@brito.com', '14/04/1978', 1),
(17,'11111111181', 'Rômulo Pereira Brito', 's22345678', 'romulo@brito.com', '14/04/1979', 1),
(18,'11111111191', 'Henrique Pereira Brito', '44345678n', 'henrique@brito.com', '14/04/1975', 1),
(19,'11111111101', 'Francis Pereira Brito', '34567888', 'francis@brito.com', '14/04/1974', 1),
(20,'11111111211', 'Otávio Pereira Brito', 's34567899', 'otavio@brito.com', '14/04/1973', 1),
(21,'11111111311', 'Rogério Pereira Brito', 's345678666', 'rogerio@brito.com', '14/04/1972', 1),
(22,'11111111411', 'Jurandir Pereira Brito', '34567877s', 'jurandir@brito.com', '14/04/1971', 1),
(23,'11111111511', 'Raquél Pereira Brito', '345678676', 'raquel@brito.com', '14/04/1970', 1);
--
--
INSERT INTO fornecedores (fornecedor,cnpj,nome,site,email,contato, telefone) VALUES 
(1, '41.604.777/0001-42','ForJoao Pereira Brito', 'http://www.fornecedor1.com.br', 'forjoao@brito.com', 'Pedro','32885175'),
(2, NULL,'ForRoberto Pereira Brito', 'http://www.fornecedor2.com.br', 'forroberto@brito.com','Manoel', '32885176'),
(3, NULL,'ForAntônio Pereira Brito', 'http://www.fornecedor3.com.br', 'forantonio@brito.com','João', '32885177'),
(4, NULL,'ForCarlos Pereira Brito', 'http://www.fornecedor4.com.br', 'forcarlos@brito.com', 'Chico','32885178'),
(5, NULL,'ForOtoniel Pereira Brito', 'http://www.fornecedor5.com.br', 'forotoniel@brito.com', 'Antônio','32885179'),
(6, NULL,'ForHelena Pereira Brito', 'http://www.fornecedor6.com.br', 'forhelena@brito.com', 'João Pedro','32885180'),
(7, NULL,'ForFlávio Pereira Brito', 'http://www.fornecedor7.com.br', 'forflavio@brito.com', 'Jorge','32885181'),
(8, NULL,'ForJoana Pereira Brito', 'http://www.fornecedor8.com.br', 'forjoana@brito.com', 'Rogério','32885182'),
(9, NULL,'ForFrancisco Pereira Brito', 'http://www.fornecedor9.com.br', 'forfrancisco@brito.com','Ricardo', '32885183'),
(10, NULL,'ForJorge Pereira Brito', 'http://www.fornecedor10.com.br', 'forjorje@brito.com', 'Cardoso','32885184'),
(11, NULL,'ForPedro Pereira Brito', 'http://www.fornecedor11.com.br', 'forpedro@brito.com', 'Golias','32885185');
--
INSERT INTO armazens (armazem,descricao,armario,prateleira) VALUES
(1, 'Armazem 1', 'Armario1', 1),
(2, 'Armazem 1', 'Armario1', 2),
(3, 'Armazem 1', 'Armario1', 3),
(4, 'Armazem 1', 'Armario2', 1);
--
INSERT INTO produtos (produto,descricao,unidade,data_cadastro) VALUES
(1, 'Mouse ótico preto Clone', 'un', '14/06/2008'),
(2, 'Impressora HP multifuncional Branca', 'un', '14/06/2008'),
(3, 'Notebook Acer Aspire 5610', 'un', '14/06/2008'),
(4, 'Bolsa para notebook Leadership', 'un', '14/06/2008'),
(5, 'Teclado sem fio preto Clone', 'un', '14/06/2008'),
(6, 'Web Câmera Leadership preta', 'un', '14/06/2008'),
(7, 'Roteador D-Link D-500', 'un', '14/06/2008'),
(8, 'Modem D-Link D-340', 'un', '14/06/2008'),
(9, 'Mouse comun USB branco', 'un', '14/06/2008'),
(10, 'Pad Mouse branco', 'un',  '14/06/2008'),
(11, 'Gravadora de DVD Sony', 'un', '14/06/2008'),
(12, 'DVD-R Maxell', 'un',  '14/06/2008'),
(13, 'DVD-RW Maxell 8X', 'un', '14/06/2008'),
(14, 'Pendrive Kingston 2GB branco', 'un', '14/06/2008'),
(15, 'Pendrive Kingston 4GB lilás', 'un', '14/06/2008'),
(16, 'Pendrive Kingston 8GB verde', 'un', '14/06/2008');
-- Em compras o produto terá o preço de compra. 
-- Este preço de compra deve ser levado para o estoque, onde receberá a margem de lucro. 
-- O estoque recebe os produtos de reposicoes e automaticamente adiciona a margem de lucro
-- O produto chegará em itens de pedidos já com a margem de lucro.
--
--
INSERT INTO compras (compra, data_atualizacao, fornecedor) VALUES
(1, '14/06/2008', 1);
--
INSERT INTO compra_itens (item, compra, produto,quantidade,preco_unitario,estoque_min) VALUES
(1,1,1, 5, 12.35, 2),
(2,1,2, 12, 265.00, 2),
(3,1,3, 8, 1965.00, 1),
(4,1,4, 15, 45.36, 3),
(5,1,5, 15, 18.35, 2),
(6,1,6, 5, 28.15, 2),
(7,1,7, 6, 98.35, 2),
(8,1,8, 4, 85.35, 2),
(9,1,9, 12, 8.35, 4),
(10,1,10, 26, 2.35, 5),
(11,1,11, 7, 65.35, 5),
(12,1,12, 30, 1.15, 4),
(13,1,13, 25, 12.35, 3),
(14,1,14, 12, 32.35, 2),
(15,1,15, 8, 52.35, 3),
(16,1,16, 6, 122.35, 1);
--
--
INSERT INTO estoque (codigo,quant_estoque,estoque_max,estoque_min,preco_venda, data_atualizacao,armazem, compra_item) VALUES
(1, 53, 120, 3, 12.35, '15/06/2008',1,1),
(2, 13, 20, 2, 265.00, '15/06/2008',1,1),
(3, 8, 20, 2, 1965.00, '15/06/2008',1,1),
(4, 15, 25, 2, 45.36, '15/06/2008',1,1),
(5, 18, 20, 5, 18.35, '16/06/2008',1,1),
(6, 14, 20, 2, 28.15, '16/06/2008',1,1),
(7, 8, 20, 2, 98.35, '16/06/2008',1,1),
(8, 6, 10, 3, 85.35, '17/06/2008',1,1),
(9, 13, 20, 2, 8.35, '17/06/2008',1,1),
(10, 13, 20, 2, 2.35, '17/06/2008',1,1),
(11, 9, 10, 2, 65.35, '17/06/2008',1,1),
(12, 53, 120, 3, 1.15, '18/06/2008',1,1),
(13, 13, 80, 3, 12.35, '18/06/2008',1,1),
(14, 13, 30, 2, 32.35, '18/06/2008',1,1),
(15, 18, 20, 2, 52.35, '19/06/2008',1,1),
(16, 11, 10, 2, 122.35, '19/06/2008',1,1);
--
--
INSERT INTO pedidos (pedido,cliente,funcionario,data_pedido,data_confirmacao) VALUES
(1, 1,1, '12/06/2008', '12/06/2008'),
(2, 1,1, '12/06/2008', '12/06/2008'),
(3, 2,2, '12/06/2008', '12/06/2008'),
(4, 2,1, '12/06/2008', '12/06/2008'),
(5, 2,1, '12/06/2008', '12/06/2008'),
(6, 1,2, '14/06/2008', '14/06/2008'),
(7, 3,1, '14/06/2008', '15/06/2008'),
(8, 3,2, '14/06/2008', '15/06/2008'),
(9, 4,1, '14/06/2008', '15/06/2008'),
(10, 4,2, '14/06/2008', '14/06/2008'),
(11, 4,2, '14/06/2008', '14/06/2008'),
(12, 4,3, '15/06/2008', '15/06/2008'),
(13, 5,3, '15/06/2008', '15/06/2008');
--
--
INSERT INTO pedido_itens (item,estoque,quantidade,preco_venda,pedido) VALUES
(1, 1, 2, 15.00,1),
(2, 9, 1, 10.20,1),
(3, 14, 1, 38.50,1),
(4, 9, 1, 10.20,2),
(5, 12, 5, 1.35,2);
--
--
INSERT INTO bonus (bonus,valor_bonus,pedido,data_pedido) VALUES
(1, 1.91, 1, '12/06/2008'), -- Exemplo para este bônus: 3% de (15 + 10.20 + 38.50)
(2, 0.35, 2, '12/06/2008');
--
--
INSERT INTO comissoes (comissao,valor_comissao,data_pedido,pedido) VALUES
(1, 3.19, '12/06/2008', 1), -- 5% de (15 + 10.20 + 38.50)
(2, 0.57, '12/06/2008', 2);
--
-- Consultas
--
-- Trazendo a soma de bônus de cada cliente:
-- select cliente, sum(valor_bonus) from bonus, pedidos where bonus.pedido = pedidos.pedido group by cliente;
/*
Sugestões para amplicação do modelo:

Adicionar as tabelas para notas fiscais:

- notas_fiscais(nota, cliente, emissao) --> detalhes_nota_fiscal (nota, item_compra, quantidade, valor_unitario)


*/
