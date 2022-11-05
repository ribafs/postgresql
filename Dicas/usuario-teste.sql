------------------------------------------------------------------------------
-- Testes do controle de usu�rios
--
-- Obs: efetua-los logado como supervisor
--

------------------------------------------------------------------------------
-- 1 - Testes da tabela "grupo"

-- 1.1 - Testes de inser��o (grupo_inserir())

INSERT INTO grupo (grp_nome,grp_serial)
  VALUES ('teste1',1);

/* E13401: Informe o nome do grupo
INSERT INTO grupo (grp_nome,grp_serial)
  VALUES ('',1);
*/

/* E13402: Grupo j� cadastrado sob c�digo 5
INSERT INTO grupo (grp_nome,grp_serial)
  VALUES ('teste1',1);
*/

/* E13403: C�digo j� existente: 5
INSERT INTO grupo (grp_cod,grp_nome,grp_serial)
  VALUES (5,'teste2',1);
*/

/* parser: parse error at or near "group"
INSERT INTO grupo (grp_nome,grp_serial)
  VALUES ('group',1);
*/

-- 1.2 - Teste de inser��o (campo grp_serial)

/* null value in column "grp_serial" violates not-null constraint
INSERT INTO grupo (grp_nome,grp_serial)
  VALUES ('teste2',NULL);
*/

-- 1.3 - Testes de altera��o (grupo_alterar())

/* E13501: Informe o nome do grupo
UPDATE grupo
  SET grp_nome = ''
  WHERE grp_nome = 'teste1';
*/

/* E13502: Grupo j� cadastrado sob c�digo 1
UPDATE grupo
  SET grp_nome = 'supervisor'
  WHERE grp_nome = 'teste1';
*/

/* E13503: C�digo inv�lido: <NULL>
UPDATE grupo
  SET grp_cod = NULL
  WHERE grp_nome = 'teste1';
*/

/* E13503: C�digo inv�lido: 0
UPDATE grupo
  SET grp_cod = 0
  WHERE grp_nome = 'teste1';
*/

/* E13504: C�digo j� existente: 1
UPDATE grupo
  SET grp_cod = 1
  WHERE grp_nome = 'teste1';
*/

-- 1.4 - Teste de mudan�a de c�digo

UPDATE grupo
  SET grp_cod = 6
  WHERE grp_nome = 'teste1';

-- 1.5 - Teste de mudan�a de nome

UPDATE grupo
  SET grp_nome = 'teste2'
  WHERE grp_nome = 'teste1';

-- Obs: O nome do grupo deve ser alterado tambem na tabela "pg_group"

-- 1.6 - Teste de exclus�o (grupo_excluir())

DELETE FROM grupo
  WHERE grp_nome = 'teste2';

-- Obs: O grupo deve ser exclu�do tambem da tabela "pg_group"

-- 1.7 - Consultas para conferir as mudan�as dos testes anteriores

SELECT *
  FROM grupo
  LEFT JOIN pg_group ON groname = cast( grp_nome AS NAME )
  ORDER BY grp_nome;

SELECT *
  FROM pg_group
  LEFT JOIN grupo ON grp_nome = cast( groname AS VARCHAR )
  ORDER BY groname;

-- 1.8 - Acerto do seq�encial do c�digo

SELECT currval('grupo_grp_cod_seq');
-- Resulta: 7

SELECT setval('grupo_grp_cod_seq',5,false);

------------------------------------------------------------------------------
-- 2 - Testes da tabela "usuario"

-- 2.1 - Testes de valida��o (usuario_validar())

/* E13001: Informe o login do usu�rio
INSERT INTO usuario (usu_login,usu_nome,usu_estado,usu_dtestado,usu_dtcad)
  VALUES ('','','',NULL,NULL);
*/

/* E13002: Informe o nome do usu�rio
INSERT INTO usuario (usu_login,usu_nome,usu_estado,usu_dtestado,usu_dtcad)
  VALUES ('teste1','','',NULL,NULL);
*/

/* E13003: Informe o estado do usu�rio
INSERT INTO usuario (usu_login,usu_nome,usu_estado,usu_dtestado,usu_dtcad)
  VALUES ('teste1','Primeiro Teste','',NULL,NULL);
*/

/* E13004: Estado inv�lido: X
INSERT INTO usuario (usu_login,usu_nome,usu_estado,usu_dtestado,usu_dtcad)
  VALUES ('teste1','Primeiro Teste','x',NULL,NULL);
*/

/* E13005: Caixa inexistente: 2
INSERT INTO usuario (usu_login,usu_nome,usu_estado,usu_dtestado,usu_dtcad,usu_usucx)
  VALUES ('teste1','Primeiro Teste','a',NULL,NULL,2);
*/

/* E13006: O usu�rio marcio n�o est� autorizado para manter um caixa
INSERT INTO usuario (usu_login,usu_nome,usu_estado,usu_dtestado,usu_dtcad,usu_usucx)
  VALUES ('teste1','Primeiro Teste','a',NULL,NULL,1);
*/

-- 2.2 - Testes de inser��o (usuario_inserir())

INSERT INTO usuario (usu_login,usu_nome,usu_estado,usu_dtestado,usu_dtcad)
  VALUES ('teste1','Primeiro Teste','a',NULL,NULL);

/* E13101: Login j� cadastrado sob c�digo 2
INSERT INTO usuario (usu_login,usu_nome,usu_estado,usu_dtestado,usu_dtcad)
  VALUES ('teste1','Primeiro Teste','i',NULL,NULL);
*/

/* E13102: Nome j� cadastrado sob c�digo 2
INSERT INTO usuario (usu_login,usu_nome,usu_estado,usu_dtestado,usu_dtcad)
  VALUES ('teste2','Primeiro Teste','i',NULL,NULL);
*/

/* E13103: C�digo j� existente: 2
INSERT INTO usuario (usu_cod,usu_login,usu_nome,usu_estado)
  VALUES (2,'teste2','Segundo Teste','i');
*/

-- 2.3 - Testes de atualiza��o (usuario_atualizar())

CREATE USER teste2;

INSERT INTO usuario (usu_cod,usu_login,usu_nome,usu_estado,usu_dtestado,usu_dtcad)
  VALUES (10,'teste2','Segundo Teste','a','2004-7-2','2004-7-1');

-- Obs: o usu�rio "teste2" deve ser mantido na tabela "pg_shadow"

CREATE USER teste3;

INSERT INTO usuario (usu_login,usu_nome,usu_estado)
  VALUES ('teste3','Terceiro Teste','i');

-- Obs: o usu�rio "teste3" deve ser REMOVIDO da tabela "pg_shadow"

-- 2.4 - Testes de altera��o (usuario_alterar())

/* E13201: Login j� cadastrado sob c�digo 10
UPDATE usuario
  SET usu_login = 'teste2'
  WHERE usu_login = 'teste1';
*/

/* E13202: Nome j� cadastrado sob c�digo 10
UPDATE usuario
  SET usu_nome = 'Segundo Teste'
  WHERE usu_login = 'teste1';
*/

/* E13203: C�digo inv�lido: <NULL>
UPDATE usuario
  SET usu_cod = NULL
  WHERE usu_login = 'teste1';
*/

/* E13203: C�digo inv�lido: 0
UPDATE usuario
  SET usu_cod = 0
  WHERE usu_login = 'teste1';
*/

/* E13204: C�digo j� existente: 3
UPDATE usuario
  SET usu_cod = 3
  WHERE usu_login = 'teste1';
*/

-- 2.5 - Teste de mudan�a de c�digo e login

UPDATE usuario
  SET usu_cod = 4,
      usu_login = 'teste4'
  WHERE usu_login = 'teste2';

-- Obs: o usu�rio "teste2" ser� removido da tabela "pg_shadow"
--      Na vers�o 7.2 o PostgreSQL n�o permite alte��o direta de login
--      (comando ALTER USER RENAME)

-- 2.6 - Teste de desativa��o de usu�rio

CREATE USER teste1;

UPDATE usuario
  SET usu_estado = 'b'
  WHERE usu_login = 'teste1';

-- Obs: o usu�rio "teste1" dever� ser REMOVIDO da tabela "pg_shadow"

-- 2.7 - Teste de mudan�a de login para usu�rio inativo e cadastrado no SGBD

CREATE USER teste3;

UPDATE usuario
  SET usu_login = 'teste5'
  WHERE usu_login = 'teste3';

-- Obs: o usu�rio "teste3" dever� ser REMOVIDO da tabela "pg_shadow"

-- 2.8 - Testes de exclus�o (usuario_excluir())

CREATE USER teste4;

DELETE FROM usuario
  WHERE usu_login = 'teste4';

-- Obs: o usu�rio "teste4" dever� ser REMOVIDO da tabela "pg_shadow"

DELETE FROM usuario
  WHERE usu_login = 'teste5';

DELETE FROM usuario
  WHERE usu_login = 'teste1';

-- 2.9 - Consultas para conferir as mudan�as dos testes anteriores

SELECT usu_cod, usu_login, usu_nome, usu_estado, usu_dtestado,
    usu_dtcad, usu_dtatual, usename, usesysid, usecreatedb, usesuper,
    passwd, valuntil
  FROM usuario
  LEFT JOIN pg_shadow ON usename = cast( usu_login AS NAME )
  ORDER BY usu_login;

SELECT usename, usesysid, usecreatedb, usesuper, passwd, valuntil, usu_cod,
    usu_login, usu_nome, usu_estado, usu_dtestado, usu_dtcad,
    usu_dtatual
  FROM pg_shadow
  LEFT JOIN usuario ON usu_login = cast( usename AS VARCHAR )
  ORDER BY usename;

-- 2.10 - Acerto do seq�encial do c�digo

SELECT currval('usuario_usu_cod_seq');
-- Resulta: 3

SELECT setval('usuario_usu_cod_seq',2,false);

------------------------------------------------------------------------------
-- 3 - Testes da tabela "usu_shadow"

INSERT INTO usuario (usu_login,usu_nome,usu_estado)
  VALUES ('teste1','Primeiro Teste','i');

INSERT INTO usuario (usu_login,usu_nome,usu_estado)
  VALUES ('teste2','Segundo Teste','a');

-- 3.1 - Teste de valida��o (usu_shadow_validar())

/* E131005: Informe a senha do usu�rio
INSERT INTO usu_shadow (pwr_usucod,pwr_shadow,pwr_serial)
  VALUES (2,'',1);
*/

-- 3.2 - Testes de atualiza��o (usu_shadow_atualizar())

/* E131006: O usu�rio teste1 n�o est� ativo
INSERT INTO usu_shadow (pwr_usucod,pwr_shadow,pwr_serial)
  VALUES (2,'123teste',1);
*/

UPDATE usuario
  SET usu_estado = 'a'
  WHERE usu_login = 'teste1';

INSERT INTO usu_shadow (pwr_usucod,pwr_shadow,pwr_serial)
  VALUES (2,'123teste1',1);

INSERT INTO usu_shadow (pwr_usucod,pwr_shadow,pwr_serial)
  VALUES (3,'123teste2',1);

-- Obs: os usu�rios "teste1" e "teste2" dever�o estar inclu�dos em "pg_shadow"

-- 3.3 - Teste de mudan�a de login

UPDATE usuario
  SET usu_login = 'teste3'
  WHERE usu_login = 'teste1';

-- Obs: o usu�rio "teste1" dever� ser renomeado para "teste3" em "pg_shadow"

-- 3.4 - Teste de bloqueio de usu�rio

UPDATE usuario
  SET usu_estado = 'b'
  WHERE usu_login = 'teste3';

-- Obs: o usu�rio "teste3" dever� ser removido de "pg_shadow"

-- 3.5 - Teste de inclus�o de senha de usu�rio j� cadastrado no SGBD

UPDATE usuario
  SET usu_estado = 'a'
  WHERE usu_login = 'teste3';

CREATE USER teste3;

INSERT INTO usu_shadow (pwr_usucod,pwr_shadow,pwr_serial)
  VALUES (2,'123teste3',1);

-- 3.6 - Teste de mudan�a de senha

/* E131005: Informe a senha do usu�rio
UPDATE usu_shadow
  SET pwr_shadow = ''
  WHERE pwr_usucod = 2;
*/

UPDATE usu_shadow
  SET pwr_shadow = '123teste4'
  WHERE pwr_usucod = 2;

INSERT INTO grupo_usuario (gru_usucod,gru_grpnome)
  VALUES (2,'usuario');

-- 3.7 - Teste com o usu�rio "postgres"

/* E131001: Acesso negado: usu�rio postgres n�o cadastrado no sistema
UPDATE usu_shadow
  SET pwr_shadow = '123teste5'
  WHERE pwr_usucod = 3;
*/

-- 3.8 - Testes com o usu�rio "teste3" (senha "123teste4")

/* permission denied for relation usu_shadow
UPDATE usu_shadow
  SET pwr_shadow = '123teste5'
  WHERE pwr_usucod = 3;
*/

-- Obs: este teste n�o funciona, por algum o banco requer o acesso de leitura.
--      Na verdade s� seria necess�rio acesso para altera��o, de modo que o
--      usu�rio atual pudesse alterar a sua pr�ria senha.

/* Executar logado como supervisor para continuar os testes:
GRANT SELECT,UPDATE ON usu_shadow      TO teste3;
*/

/* E131003: Usu�rio n�o autorizado para alterar senha de outro usu�rio
UPDATE usu_shadow
  SET pwr_shadow = '123teste5'
  WHERE pwr_usucod = 3;
*/

/* E131004: Usu�rio n�o autorizado para alterar prazo de senha
UPDATE usu_shadow
  SET pwr_prazo = '9999-12-31'
  WHERE pwr_usucod = 2;
*/

UPDATE usu_shadow
  SET pwr_shadow = '123teste5'
  WHERE pwr_usucod = 2;

-- 3.9 - Testes de exclus�o (usu_shadow_excluir())

DELETE FROM usu_shadow
  WHERE pwr_usucod = 2;

-- Obs: o usu�rio "teste3" dever� ser removido de "pg_shadow"

DELETE FROM usuario
  WHERE usu_login = 'teste3';

DELETE FROM usuario
  WHERE usu_login = 'teste2';

-- Obs: o usu�rio "teste2" dever� ser removido de "pg_shadow"

-- 3.10 - Consultas para conferir as mudan�as dos testes anteriores

SELECT usu_cod, usu_login, usu_estado, usu_dtestado, usu_dtatual,
    pwr_shadow, pwr_prazo, pwr_dtatual, pwr_serial,
    usename, usesysid, usecreatedb, usesuper, passwd, valuntil
  FROM usuario
  LEFT JOIN usu_shadow ON pwr_usucod = usu_cod
  LEFT JOIN pg_shadow ON usename = cast( usu_login AS NAME )
  ORDER BY usu_login;

SELECT usename, usesysid, usecreatedb, usesuper, passwd, valuntil,
    usu_cod, usu_login, usu_estado, usu_dtestado, usu_dtatual,
    pwr_shadow, pwr_prazo, pwr_dtatual, pwr_serial
  FROM pg_shadow
  LEFT JOIN usuario ON usu_login = cast( usename AS VARCHAR )
  LEFT JOIN usu_shadow ON pwr_usucod = usu_cod
  ORDER BY usename;

-- 3.11 - Acerto do seq�encial do c�digo

SELECT setval('usuario_usu_cod_seq',2,false);

------------------------------------------------------------------------------
-- 4 - Testes da tabela "grupo_usuario"

INSERT INTO usuario (usu_login,usu_nome,usu_estado)
  VALUES ('teste1','Primeiro Teste','A');

INSERT INTO usu_shadow (pwr_usucod,pwr_shadow,pwr_serial)
  VALUES (2,'123teste',1);

INSERT INTO grupo (grp_nome,grp_serial)
  VALUES ('grupo1',1);

-- 4.1 - Teste de inser��o (grupo_usuario_inserir())

INSERT INTO grupo_usuario (gru_usucod,gru_grpnome)
  VALUES (2,'grupo1');

-- Obs: o c�digo do usu�rio no banco ("usesysid" = 101) deve estar inclu�do
--      no campo "grolist" da tabela "pg_group" do grupo 'grupo1'

-- 4.2 - Teste de mudan�a de login de usu�rio

UPDATE usuario
  SET usu_login = 'teste2'
  WHERE usu_login = 'teste1';

-- Obs: o campo "gru_usulogin" deve estar atualizado para 'teste2'
--      e o c�digo do usu�rio no banco ("usesysid" = 101) deve estar inclu�do
--      no campo "grolist" da tabela "pg_group" do grupo 'grupo1'

-- 4.3 - Teste de mudan�a de nome de grupo

UPDATE grupo
  SET grp_nome = 'grupo2'
  WHERE grp_nome = 'grupo1';

-- Obs: o campo "gru_grpnome" deve estar atualizado para 'grupo2'
--      e o c�digo do usu�rio no banco ("usesysid" = 101) deve estar inclu�do
--      no campo "grolist" da tabela "pg_group" do grupo 'grupo2'

-- 4.4 - Teste de desativa��o de usu�rio

UPDATE usuario
  SET usu_estado = 'i'
  WHERE usu_login = 'teste2';

-- Obs: o registro da tabela "grupo_usuario" ref. ao usu�rio ser� desativado
--      e o campo "grolist" da tabela "pg_group" deve estar vazio

-- 4.5 - Teste de reativa��o de usu�rio

UPDATE usuario
  SET usu_estado = 'a'
  WHERE usu_login = 'teste2';

INSERT INTO usu_shadow (pwr_usucod,pwr_shadow,pwr_serial)
  VALUES (2,'123teste2',1);

-- Obs: o registro da tabela "grupo_usuario" ref. ao usu�rio ser� reativado
--      e o c�digo do usu�rio no banco ("usesysid" = 101) deve estar inclu�do
--      no campo "grolist" da tabela "pg_group" do grupo 'grupo2'

-- 4.6 - Testes de altera��o (grupo_usuario_alterar())

UPDATE grupo_usuario
  SET gru_ativo = FALSE
  WHERE gru_usulogin = 'teste2'
    AND gru_grpnome = 'grupo2';

-- Obs: o registro da tabela "grupo_usuario" ref. ao usu�rio ser� desativado
--      e o campo "grolist" da tabela "pg_group" deve estar vazio

UPDATE grupo_usuario
  SET gru_ativo = TRUE
  WHERE gru_usulogin = 'teste2'
    AND gru_grpnome = 'grupo2';

-- Obs: o registro da tabela "grupo_usuario" ref. ao usu�rio ser� reativado
--      e o c�digo do usu�rio no banco ("usesysid" = 101) deve estar inclu�do
--      no campo "grolist" da tabela "pg_group" do grupo 'grupo2'

-- 4.7 - Teste de inclus�o de usu�rio no grupo de gerente

INSERT INTO grupo_usuario (gru_usucod,gru_grpnome)
  VALUES (2,'gerente');

-- Obs: o campo "usesuper" da tabela "pg_shadow" de ser TRUE (1)

-- 4.8 - Testes com o usu�rio "teste2" (senha "123teste2")

/* E13701: Somente supervisor pode criar supervisor
INSERT INTO grupo_usuario (gru_usucod,gru_grpnome)
  VALUES (2,'supervisor');
*/

/* E13801: Somente supervisor pode criar supervisor
UPDATE grupo_usuario
  SET gru_grpnome = 'supervisor'
  WHERE gru_usulogin = 'teste2'
    AND gru_grpnome = 'grupo2';
*/

-- 4.9 - Teste de inclus�o de usu�rio no grupo de supervisor

INSERT INTO grupo_usuario (gru_usucod,gru_grpnome)
  VALUES (2,'supervisor');

-- Obs: o campo "usecreatedb" da tabela "pg_shadow" de ser TRUE (1)

-- 4.10 - Testes de exclus�o (grupo_usuario_excluir())

DELETE FROM grupo_usuario
  WHERE gru_usucod = 2 AND gru_grpnome = 'grupo2';

-- Obs: o registro da tabela "grupo_usuario" ref. ao usu�rio ser� reativado
--      e o c�digo do usu�rio no banco ("usesysid" = 101) deve estar inclu�do
--      no campo "grolist" da tabela "pg_group" do grupo 'grupo2'

DELETE FROM grupo_usuario
  WHERE gru_usucod = 2 AND gru_grpnome = 'supervisor';

-- Obs: o campo "usecreatedb" da tabela "pg_shadow" de ser FALSE (0)

DELETE FROM grupo_usuario
  WHERE gru_usucod = 2 AND gru_grpnome = 'gerente';

-- Obs: o campo "usesuper" da tabela "pg_shadow" de ser FALSE (0)

-- 4.11 - Teste de inclus�o de usu�rio no grupo de supervisor

INSERT INTO grupo_usuario (gru_usucod,gru_grpnome)
  VALUES (2,'supervisor');

-- Obs: os campos "usecreatedb" e "usesuper" da tabela "pg_shadow"
--      devem ser TRUE (1)

-- 4.12 - Teste de exclus�o e inclus�o de senha

DELETE FROM usu_shadow
  WHERE pwr_usucod = 2;

-- Obs: o registro da tabela "grupo_usuario" ref. ao usu�rio ser� desativado
--      e o c�digo do usu�rio no banco ("usesysid" = 101) deve estar removido
--      no campo "grolist" da tabela "pg_group" do grupo 'supervisor'

INSERT INTO usu_shadow (pwr_usucod,pwr_shadow,pwr_serial)
  VALUES (2,'123teste3',1);

-- Obs: o registro da tabela "grupo_usuario" ref. ao usu�rio ser� reativado
--      e o c�digo do usu�rio no banco ("usesysid" = 101) deve estar inclu�do
--      no campo "grolist" da tabela "pg_group" do grupo 'supervisor'
-- Obs: os campos "usecreatedb" e "usesuper" da tabela "pg_shadow"
--      devem ser TRUE (1)

-- 4.13 - Teste de exclus�o de usu�rio

DELETE FROM usuario
  WHERE usu_login = 'teste2';

-- 4.14 - Teste de grupo com mais de um usu�rio

INSERT INTO usuario (usu_login,usu_nome,usu_estado)
  VALUES ('teste3','Terceiro Teste','A');

INSERT INTO usu_shadow (pwr_usucod,pwr_shadow,pwr_serial)
  VALUES (3,'123teste4',1);

INSERT INTO grupo_usuario (gru_usucod,gru_grpnome)
  VALUES (3,'grupo2');

INSERT INTO usuario (usu_login,usu_nome,usu_estado)
  VALUES ('teste4','Quarto Teste','A');

INSERT INTO usu_shadow (pwr_usucod,pwr_shadow,pwr_serial)
  VALUES (4,'123teste5',1);

INSERT INTO grupo_usuario (gru_usucod,gru_grpnome)
  VALUES (4,'grupo2');

-- 4.15 - Teste de mudan�a de nome

UPDATE grupo
  SET grp_nome = 'grupo3'
  WHERE grp_nome = 'grupo2';

-- Obs: o campo "gru_grpnome" deve estar atualizado para 'grupo3'
--      e o c�digos dos usu�rio no banco devem estar inclu�dos
--      no campo "grolist" da tabela "pg_group" do grupo 'grupo3'

-- 4.16 - Teste de exclus�o de grupo

DELETE FROM grupo
  WHERE grp_nome = 'grupo3';

DELETE FROM usuario
  WHERE usu_login = 'teste3';

DELETE FROM usuario
  WHERE usu_login = 'teste4';

-- 4.17 - Consultas para conferir as mudan�as dos testes anteriores

SELECT usu_cod, usu_login, usu_estado, usu_dtestado, usu_dtatual,
    pwr_shadow, pwr_prazo, pwr_dtatual, pwr_serial,
    usename, usesysid, usecreatedb, usesuper, passwd, valuntil
  FROM usuario
  LEFT JOIN usu_shadow ON pwr_usucod = usu_cod
  LEFT JOIN pg_shadow ON usename = cast( usu_login AS NAME )
  ORDER BY usu_login;

SELECT grp_cod, grp_nome, grp_prazo, grp_dtatual, grp_serial,
       groname, grosysid, grolist,
       gru_usucod, gru_usulogin, gru_ativo
  FROM grupo
  LEFT JOIN pg_group ON groname = cast( grp_nome AS NAME )
  LEFT JOIN grupo_usuario ON gru_grpnome = grp_nome
  ORDER BY grp_nome;

-- 4.18 - Acerto dos seq�enciais dos c�digos de grupo de usu�rio

SELECT setval('grupo_grp_cod_seq',5,false);

SELECT setval('usuario_usu_cod_seq',2,false);

------------------------------------------------------------------------------
-- Consultas para desenvolvimento da interface

-- Manuten��o

SELECT usu_cod, usu_login, usu_nome, usu_tel, usu_rua, usu_bai,
       usu_cid, usu_uf, usu_cep, usu_doc, usu_reg, usu_dtreg,
       usu_dtnasc, usu_dtinic, usu_dtsaid, usu_usucx, usu_com,
       usu_estado, usu_obs
  FROM usuario;

-- Consulta

SELECT usu_cod, usu_login, usu_nome, usu_tel, usu_rua, usu_bai,
       usu_cid, usu_uf, usu_cep, usu_doc, usu_reg, usu_dtreg,
       usu_dtnasc, usu_dtinic, usu_dtsaid, usu_estado
  FROM usuario_view
  ORDER BY usu_nome;

-- Sele��o

SELECT usu_cod, usu_login, usu_nome
  FROM usuario_view
  ORDER BY usu_nome;

------------------------------------------------------------------------------
-- Usu�rios para testes de outras tabelas

-- Usu�rio "gerente1"

INSERT INTO usuario (usu_login,usu_nome,usu_estado)
  VALUES ('gerente1','Primeiro Gerente','A');

INSERT INTO usu_shadow (pwr_usucod,pwr_shadow,pwr_serial)
  VALUES (2,'ger1',1);

INSERT INTO grupo_usuario (gru_usucod,gru_grpnome)
  VALUES (2,'gerente');

-- Usu�rio "usuario1"

INSERT INTO usuario (usu_login,usu_nome,usu_estado)
  VALUES ('usuario1','Usu�rio Comum','A');

INSERT INTO usu_shadow (pwr_usucod,pwr_shadow,pwr_serial)
  VALUES (3,'usu1',1);

INSERT INTO grupo_usuario (gru_usucod,gru_grpnome)
  VALUES (3,'usuario');

-- Usu�rio "caixa1"

INSERT INTO usuario (usu_login,usu_nome,usu_estado)
  VALUES ('caixa1','Primeiro Caixa','A');

INSERT INTO usu_shadow (pwr_usucod,pwr_shadow,pwr_serial)
  VALUES (4,'caixa1',1);

INSERT INTO grupo_usuario (gru_usucod,gru_grpnome)
  VALUES (4,'usuario');

INSERT INTO grupo_usuario (gru_usucod,gru_grpnome)
  VALUES (4,'caixa');

-- Usu�rio "caixa2"

INSERT INTO usuario (usu_login,usu_nome,usu_estado)
  VALUES ('caixa2','Segundo Caixa','A');

INSERT INTO usu_shadow (pwr_usucod,pwr_shadow,pwr_serial)
  VALUES (5,'caixa2',1);

INSERT INTO grupo_usuario (gru_usucod,gru_grpnome)
  VALUES (5,'caixa');

-- Usu�rio "gerente2"

INSERT INTO usuario (usu_login,usu_nome,usu_estado)
  VALUES ('gerente2','Segundo Gerente','A');

INSERT INTO usu_shadow (pwr_usucod,pwr_shadow,pwr_serial)
  VALUES (6,'ger2',1);

INSERT INTO grupo_usuario (gru_usucod,gru_grpnome)
  VALUES (6,'gerente');

INSERT INTO grupo_usuario (gru_usucod,gru_grpnome)
  VALUES (6,'caixa');

-- Usu�rio "vendedor1"

INSERT INTO usuario (usu_login,usu_nome,usu_estado)
  VALUES ('vendedor1','Primeiro vendedor','A');

INSERT INTO usu_shadow (pwr_usucod,pwr_shadow,pwr_serial)
  VALUES (7,'ven1',1);

------------------------------------------------------------------------------
-- vim: ai:syn=plsql
