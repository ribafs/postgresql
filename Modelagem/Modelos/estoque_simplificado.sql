-- Banco de teste para o curso de PostgreSQL do Evolução
-- 
-- Banco - controle_estoque0
-- Tabelas: clientes, produtos, estoque, pedidos e pedido-itens
--
create table clientes
(
	cpf char(11) primary key, -- Caso os clientes sejam também empresas o campo deveria ser cpf_cnpj
	nome char(45) not null,
	credito_liberado char(1) not null check( credito_liberado='s' OR credito_liberado = 'n'),
	data_nasc date,
	email varchar(50)
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
create table estoque
(
	codigo int primary key, -- Cada compra e cada venda de produto atualizar o estoque. Na compra a atualização é manual e na venda automático
	quant_estoque int not null, -- Alterado em cada compra 
	estoque_max int not null, -- Alertará nas comprar
	estoque_min int not null, -- Alertará nas vendas (pedidos)
	preco_venda numeric(12,2) not null, -- Aqui o preço de venda já tem a margem de lucro em cima do preço de compra
	data_atualizacao timestamp without time zone not null,
	produto int not null,
	constraint produto_fk foreign key (produto) references produtos(produto)
);
--
create table pedidos
(
	pedido char(10) primary key,
	cliente char(11) not null, -- A referência também poderia ser aqui no campo, assim: REFERENCES clientes(cpf)
	data_pedido date not null,
	data_confirmacao date not null, --data da baixa no estoque. Na compra alertar sobre o estoque_min
	constraint cliente_fk foreign key (cliente) references clientes(cpf)
);
--
create table pedido_itens
(
	pedido char(10),
	estoque int not null,
	quantidade int not null,
	preco_venda numeric(12,2) not null, -- preço de venda
	primary key (pedido, estoque),
	constraint pedido_fk foreign key (pedido) references pedidos(pedido),
	constraint estoque_fk foreign key (estoque) references estoque(codigo)
);

-- Após cada insert, update ou delete do pedido alterar a tabela reposicoes com os valores dos produtos
-- para alertar quando o valor do quant_estoque igualar o estoque_min, que seja feita a reposição do estoque
--
-- A compra já sugere itens e também notas fiscais e itens de notas fiscais
--
-- Obs.: Quando os estoques mínimos e máximo forem menores ou iguais aos mínimos, exibir os registros da tabela reposicao 
/* Para tabelas já existentes podemos adicionar relacionamento assim, alterando a tabela:
ALTER TABLE pedidos ADD CONSTRAINT pedidos_cli_fk FOREIGN KEY (cliente) REFERENCES clientes (cpf);
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
-- Observe que especificando os campos, podemos alterar a ordem de inserção
--
INSERT INTO clientes (cpf,nome,credito_liberado,email,data_nasc) VALUES 
('11111111111', 'Joao Pereira Brito', 's', 'joao@brito.com', '14/04/1976'),
('11111111112', 'Roberto Pereira Brito', 'n', 'roberto@brito.com', '14/04/1966'),
('11111111113', 'Antônio Pereira Brito', 'n', 'antonio@brito.com', '14/04/1986'),
('11111111114', 'Carlos Pereira Brito', 's', 'carlos@brito.com', '14/12/1976'),
('11111111115', 'Otoniel Pereira Brito', 's', 'otoniel@brito.com', '14/04/1976'),
('11111111116', 'Helena Pereira Brito', 's', 'helena@brito.com', '14/05/1976'),
('11111111117', 'Flávio Pereira Brito', 's', 'flavio@brito.com', '14/06/1976'),
('11111111118', 'Joana Pereira Brito', 'n', 'joana@brito.com', '14/07/1976'),
('11111111119', 'Francisco Pereira Brito', 'n', 'francisco@brito.com', '14/08/1976'),
('11111111110', 'Jorge Pereira Brito', 's', 'jorje@brito.com', '14/09/1976'),
('11111111121', 'Pedro Pereira Brito', 's', 'pedro@brito.com', '14/10/1976'),
('11111111131', 'Ribamar Pereira Brito', 's', 'ribamar@brito.com', '14/11/1976'),
('11111111141', 'Tiago Pereira Brito', 's', 'tiago@brito.com', '14/11/1976'),
('11111111151', 'Elias Pereira Brito', 'n', 'elias@brito.com', '14/12/1976'),
('11111111161', 'Marcos Pereira Brito', 's', 'marcos@brito.com', '14/04/1977'),
('11111111171', 'Ricardo Pereira Brito', 's', 'ricardo@brito.com', '14/04/1978'),
('11111111181', 'Rômulo Pereira Brito', 's', 'romulo@brito.com', '14/04/1979'),
('11111111191', 'Henrique Pereira Brito', 'n', 'henrique@brito.com', '14/04/1975'),
('11111111101', 'Francis Pereira Brito', 's', 'francis@brito.com', '14/04/1974'),
('11111111211', 'Otávio Pereira Brito', 's', 'otavio@brito.com', '14/04/1973'),
('11111111311', 'Rogério Pereira Brito', 's', 'rogerio@brito.com', '14/04/1972'),
('11111111411', 'Jurandir Pereira Brito', 's', 'jurandir@brito.com', '14/04/1971'),
('11111111511', 'Raquél Pereira Brito', 'n', 'raquel@brito.com', '14/04/1970');
--
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
--
INSERT INTO estoque (codigo,quant_estoque,estoque_max,estoque_min,preco_venda, data_atualizacao, produto) VALUES
(1, 53, 120, 3, 12.35, '15/06/2008', 1),
(2, 13, 20, 2, 265.00, '15/06/2008',2),
(3, 8, 20, 2, 1965.00, '15/06/2008',3),
(4, 15, 25, 2, 45.36, '15/06/2008',4),
(5, 18, 20, 5, 18.35, '16/06/2008',5),
(6, 14, 20, 2, 28.15, '16/06/2008',6),
(7, 8, 20, 2, 98.35, '16/06/2008',7),
(8, 6, 10, 3, 85.35, '17/06/2008',8),
(9, 13, 20, 2, 8.35, '17/06/2008',9),
(10, 13, 20, 2, 2.35, '17/06/2008',10),
(11, 9, 10, 2, 65.35, '17/06/2008',11),
(12, 53, 120, 3, 1.15, '18/06/2008',12),
(13, 13, 80, 3, 12.35, '18/06/2008',13),
(14, 13, 30, 2, 32.35, '18/06/2008',14),
(15, 18, 20, 2, 52.35, '19/06/2008',15),
(16, 11, 10, 2, 122.35, '19/06/2008',16);
--
--
INSERT INTO pedidos (pedido,cliente,data_pedido,data_confirmacao) VALUES
('1', '11111111111', '12/06/2008', '12/06/2008'),
('2', '11111111112', '12/07/2008', '12/06/2008'),
('3', '11111111111', '12/08/2008', '12/06/2008'),
('4', '11111111112', '12/09/2008', '12/06/2008'),
('5', '11111111112', '12/10/2008', '12/06/2008'),
('6', '11111111112', '14/06/2008', '14/06/2008'),
('7', '11111111112', '14/06/2008', '15/06/2008'),
('8', '11111111113', '14/06/2008', '15/06/2008'),
('9', '11111111113', '14/06/2008', '15/06/2008'),
('10', '11111111113', '14/06/2008', '14/06/2008'),
('11', '11111111113', '14/06/2008', '14/06/2008'),
('12', '11111111113', '15/06/2008', '15/06/2008'),
('13', '11111111113', '15/06/2008', '15/06/2008');
--
--
INSERT INTO pedido_itens (pedido,estoque,quantidade,preco_venda) VALUES
('1', 1, 2, 15.00),
('1', 9, 1, 10.20),
('1', 14, 1, 38.50),
('2', 9, 1, 10.20),
('2', 12, 5, 4.35),
('3', 9, 1, 10.20),
('3', 12, 5, 2.35),
('4', 9, 1, 10.20),
('4', 12, 5, 3.35),
('5', 9, 1, 10.20),
('5', 12, 5, 6.35);

select date_part('month',data_pedido) as mes, sum(preco_venda) as vendas from pedido_itens as i inner join pedidos as p on i.pedido=p.pedido group by data_pedido order by data_pedido


--
-- Consultas
