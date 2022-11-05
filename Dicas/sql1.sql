-- mostrar a qtd de clientes
-- em uma determinada empresa
CREATE OR REPLACE FUNCTION qtd_clientes(INTEGER)
RETURNS BIGINT AS '
	SELECT COUNT(*) FROM clientes WHERE fkempresa = $1 ;
'LANGUAGE 'SQL';
