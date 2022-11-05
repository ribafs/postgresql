-- Tabelas primarias: clientes, users, produtos
-- Secundária: pedidos

-- Relacionamentos: pedidos com clientes, users e produtos

CREATE TABLE IF NOT EXISTS `users` (
  `id` int(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `username` char(45) NOT NULL,
  `password` char(255) NOT NULL,
  `role` char(20) NOT NULL,
  created DATETIME,
  modified DATETIME
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `clientes` (
  `id` int(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `cpf` char(11) DEFAULT NULL,
  `user_id` int(11) not null,
  `nome` char(45) NOT NULL,
  `credito_liberado` char(1) NOT NULL,
  `data_nasc` date DEFAULT NULL,
  `email` varchar(50) DEFAULT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `produtos` (
  `id` int(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `descricao` varchar(100) NOT NULL,
  `unidade` char(4) NOT NULL,
  `user_id` int(11) DEFAULT NULL,
  `data_cadastro` datetime NOT NULL,
  FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE RESTRICT
) ENGINE=InnoDB;

CREATE TABLE IF NOT EXISTS `pedidos` (
  `id` int(11) NOT NULL PRIMARY KEY AUTO_INCREMENT,
  `quantidade` int(11) NOT NULL,
  `preco_venda` decimal(12,2) NOT NULL,
  `data_pedido` date NOT NULL,
  `data_confirmacao` date NOT NULL,
  `cliente_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `produto_id` int(11) NOT NULL,
   FOREIGN KEY (cliente_id) REFERENCES clientes(id) ON DELETE RESTRICT,
   FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE RESTRICT,
   FOREIGN KEY (produto_id) REFERENCES produtos(id) ON DELETE RESTRICT
) ENGINE=InnoDB;

