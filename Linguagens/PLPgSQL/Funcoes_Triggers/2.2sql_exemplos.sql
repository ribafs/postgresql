-- mostrar a qtd de clientes
-- em uma determinada empresa
CREATE OR REPLACE FUNCTION qtd_clientes(INTEGER)
RETURNS BIGINT AS '
	SELECT COUNT(*) FROM clientes WHERE fkempresa = $1 ;
'LANGUAGE 'SQL';


--------
--------

-- montar uma funcao que
-- insira o nome da empresa
-- e do cliente
CREATE OR REPLACE FUNCTION empresa_cliente(VARCHAR(30),VARCHAR(30))
RETURNS BIGINT AS '
	INSERT INTO empresas(nome) VALUES( $1 );
	INSERT INTO clientes(nome,fkempresa) VALUES( $2 , CURRVAL(''empresas_id_seq''));
	SELECT CURRVAL(''empresas_id_seq'');
'LANGUAGE 'SQL';


--------
--------

-- retornar o id 
-- de clientes devedores
CREATE OR REPLACE FUNCTION devedores01()
RETURNS SETOF INTEGER AS '
	SELECT clientes.id
	FROM clientes
	INNER JOIN contas ON clientes.id = contas.fkcliente
	INNER JOIN movimentos ON contas.id = movimentos.fkconta
	GROUP BY clientes.id
	HAVING SUM(movimentos.credito - movimentos.debito)<0
	ORDER BY clientes.id;
'LANGUAGE 'SQL';



--------
--------

-- retornar o registro 
-- completo dos devedores
CREATE OR REPLACE FUNCTION devedores02()
RETURNS SETOF clientes AS '
	SELECT * FROM clientes WHERE id IN(SELECT devedores01());	
'LANGUAGE 'SQL';
