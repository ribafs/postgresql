===========================================================================
-- SELECT
CREATE OR REPLACE FUNCTION lista(integer)
RETURNS SETOF movimentos AS '
	
	SELECT * FROM movimentos WHERE debito = $1 ;
'
LANGUAGE 'SQL'

===========================================================================
-- SELECT
-- obs: sempre trazer com *
CREATE OR REPLACE FUNCTION lista2(varchar)
RETURNS SETOF movimentos AS '
SELECT * FROM movimentos WHERE historico = $1 ;
'
LANGUAGE 'SQL';

===========================================================================
-- INSERT
			fkempresa 	INTEGER,
			nome 		VARCHAR(50),
			dtnascimento 	DATE,
			telres 		VARCHAR(20),
			site 		VARCHAR(40),
			email 		VARCHAR(40),
			saldo		NUMERIC(12,2)	DEFAULT 0,

CREATE OR REPLACE FUNCTION clientes_ins(varchar(50),date,varchar(50),varchar(40),varchar(40))
RETURNS INT8 AS '
INSERT INTO clientes (nome, dtnascimento, telres, site, email) VALUES($1,$2,$3,$4,$5);
SELECT currval(''clientes_id_seq'');
' LANGUAGE 'SQL';

executando 
select ins_clientes('xxxxxxxxxxxx','2003-06-06','2222','www','pp@pp');

===========================================================================
-- DELETE
CREATE OR REPLACE FUNCTION clientes_del(integer)
RETURNS INT4 AS '
	DELETE FROM clientes WHERE id = $1 ;
	SELECT 1;
' LANGUAGE 'SQL';

===========================================================================

-- UPDATE
CREATE OR REPLACE FUNCTION clientes_upd(int4,varchar(50))
RETURNS INT4 AS '
	UPDATE clientes SET nome = $2 WHERE id = $1 ;
	SELECT 1;
' LANGUAGE 'SQL';

===========================================================================

CREATE OR REPLACE FUNCTION listagem() 
RETURNS SETOF clientes AS '
SELECT * FROM clientes;
' LANGUAGE 'SQL';
