------------------------------------------------------------------------------
-- Testes do controle de usuários
--
-- Obs: efetua-los logado como supervisor
--

------------------------------------------------------------------------------
-- 1 - Testes da tabela "grupo"

-- 1.1 - Testes de inserção (grupo_inserir())

INSERT INTO grupo (grp_nome,grp_serial)
  VALUES ('teste1',1);

/* E13401: Informe o nome do grupo
INSERT INTO grupo (grp_nome,grp_serial)
  VALUES ('',1);
*/

/* E13402: Grupo já cadastrado sob código 5
INSERT INTO grupo (grp_nome,grp_serial)
  VALUES ('teste1',1);
*/

/* E13403: Código já existente: 5
INSERT INTO grupo (grp_cod,grp_nome,grp_serial)
  VALUES (5,'teste2',1);
*/

/* parser: parse error at or near "group"
INSERT INTO grupo (grp_nome,grp_serial)
  VALUES ('group',1);
*/

-- 1.2 - Teste de inserção (campo grp_serial)

/* null value in column "grp_serial" violates not-null constraint
INSERT INTO grupo (grp_nome,grp_serial)
  VALUES ('teste2',NULL);
*/

-- 1.3 - Testes de alteração (grupo_alterar())

/* E13501: Informe o nome do grupo
UPDATE grupo
  SET grp_nome = ''
  WHERE grp_nome = 'teste1';
*/

/* E13502: Grupo já cadastrado sob código 1
UPDATE grupo
  SET grp_nome = 'supervisor'
  WHERE grp_nome = 'teste1';
*/

/* E13503: Código inválido: <NULL>
UPDATE grupo
  SET grp_cod = NULL
  WHERE grp_nome = 'teste1';
*/

/* E13503: Código inválido: 0
UPDATE grupo
  SET grp_cod = 0
  WHERE grp_nome = 'teste1';
*/

/* E13504: Código já existente: 1
UPDATE grupo
  SET grp_cod = 1
  WHERE grp_nome = 'teste1';
*/

-- 1.4 - Teste de mudança de código

UPDATE grupo
  SET grp_cod = 6
  WHERE grp_nome = 'teste1';

-- 1.5 - Teste de mudança de nome

UPDATE grupo
  SET grp_nome = 'teste2'
  WHERE grp_nome = 'teste1';

-- Obs: O nome do grupo deve ser alterado tambem na tabela "pg_group"

-- 1.6 - Teste de exclusão (grupo_excluir())

DELETE FROM grupo
  WHERE grp_nome = 'teste2';

-- Obs: O grupo deve ser excluído tambem da tabela "pg_group"

-- 1.7 - Consultas para conferir as mudanças dos testes anteriores

SELECT *
  FROM grupo
  LEFT JOIN pg_group ON groname = cast( grp_nome AS NAME )
  ORDER BY grp_nome;

SELECT *
  FROM pg_group
  LEFT JOIN grupo ON grp_nome = cast( groname AS VARCHAR )
  ORDER BY groname;

-- 1.8 - Acerto do seqüencial do código

SELECT currval('grupo_grp_cod_seq');
-- Resulta: 7

SELECT setval('grupo_grp_cod_seq',5,false);

------------------------------------------------------------------------------
-- 2 - Testes da tabela "usuario"

-- 2.1 - Testes de validação (usuario_validar())

/* E13001: Informe o login do usuário
INSERT INTO usuario (usu_login,usu_nome,usu_estado,usu_dtestado,usu_dtcad)
  VALUES ('','','',NULL,NULL);
*/

/* E13002: Informe o nome do usuário
INSERT INTO usuario (usu_login,usu_nome,usu_estado,usu_dtestado,usu_dtcad)
  VALUES ('teste1','','',NULL,NULL);
*/

/* E13003: Informe o estado do usuário
INSERT INTO usuario (usu_login,usu_nome,usu_estado,usu_dtestado,usu_dtcad)
  VALUES ('teste1','Primeiro Teste','',NULL,NULL);
*/

/* E13004: Estado inválido: X
INSERT INTO usuario (usu_login,usu_nome,usu_estado,usu_dtestado,usu_dtcad)
  VALUES ('teste1','Primeiro Teste','x',NULL,NULL);
*/

/* E13005: Caixa inexistente: 2
INSERT INTO usuario (usu_login,usu_nome,usu_estado,usu_dtestado,usu_dtcad,usu_usucx)
  VALUES ('teste1','Primeiro Teste','a',NULL,NULL,2);
*/

/* E13006: O usuário marcio não está autorizado para manter um caixa
INSERT INTO usuario (usu_login,usu_nome,usu_estado,usu_dtestado,usu_dtcad,usu_usucx)
  VALUES ('teste1','Primeiro Teste','a',NULL,NULL,1);
*/

-- 2.2 - Testes de inserção (usuario_inserir())

INSERT INTO usuario (usu_login,usu_nome,usu_estado,usu_dtestado,usu_dtcad)
  VALUES ('teste1','Primeiro Teste','a',NULL,NULL);

/* E13101: Login já cadastrado sob código 2
INSERT INTO usuario (usu_login,usu_nome,usu_estado,usu_dtestado,usu_dtcad)
  VALUES ('teste1','Primeiro Teste','i',NULL,NULL);
*/

/* E13102: Nome já cadastrado sob código 2
INSERT INTO usuario (usu_login,usu_nome,usu_estado,usu_dtestado,usu_dtcad)
  VALUES ('teste2','Primeiro Teste','i',NULL,NULL);
*/

/* E13103: Código já existente: 2
INSERT INTO usuario (usu_cod,usu_login,usu_nome,usu_estado)
  VALUES (2,'teste2','Segundo Teste','i');
*/

-- 2.3 - Testes de atualização (usuario_atualizar())

CREATE USER teste2;

INSERT INTO usuario (usu_cod,usu_login,usu_nome,usu_estado,usu_dtestado,usu_dtcad)
  VALUES (10,'teste2','Segundo Teste','a','2004-7-2','2004-7-1');

-- Obs: o usuário "teste2" deve ser mantido na tabela "pg_shadow"

CREATE USER teste3;

INSERT INTO usuario (usu_login,usu_nome,usu_estado)
  VALUES ('teste3','Terceiro Teste','i');

-- Obs: o usuário "teste3" deve ser REMOVIDO da tabela "pg_shadow"

-- 2.4 - Testes de alteração (usuario_alterar())

/* E13201: Login já cadastrado sob código 10
UPDATE usuario
  SET usu_login = 'teste2'
  WHERE usu_login = 'teste1';
*/

/* E13202: Nome já cadastrado sob código 10
UPDATE usuario
  SET usu_nome = 'Segundo Teste'
  WHERE usu_login = 'teste1';
*/

/* E13203: Código inválido: <NULL>
UPDATE usuario
  SET usu_cod = NULL
  WHERE usu_login = 'teste1';
*/

/* E13203: Código inválido: 0
UPDATE usuario
  SET usu_cod = 0
  WHERE usu_login = 'teste1';
*/

/* E13204: Código já existente: 3
UPDATE usuario
  SET usu_cod = 3
  WHERE usu_login = 'teste1';
*/

-- 2.5 - Teste de mudança de código e login

UPDATE usuario
  SET usu_cod = 4,
      usu_login = 'teste4'
  WHERE usu_login = 'teste2';

-- Obs: o usuário "teste2" será removido da tabela "pg_shadow"
--      Na versão 7.2 o PostgreSQL não permite alteção direta de login
--      (comando ALTER USER RENAME)

-- 2.6 - Teste de desativação de usuário

CREATE USER teste1;

UPDATE usuario
  SET usu_estado = 'b'
  WHERE usu_login = 'teste1';

-- Obs: o usuário "teste1" deverá ser REMOVIDO da tabela "pg_shadow"

-- 2.7 - Teste de mudança de login para usuário inativo e cadastrado no SGBD

CREATE USER teste3;

UPDATE usuario
  SET usu_login = 'teste5'
  WHERE usu_login = 'teste3';

-- Obs: o usuário "teste3" deverá ser REMOVIDO da tabela "pg_shadow"

-- 2.8 - Testes de exclusão (usuario_excluir())

CREATE USER teste4;

DELETE FROM usuario
  WHERE usu_login = 'teste4';

-- Obs: o usuário "teste4" deverá ser REMOVIDO da tabela "pg_shadow"

DELETE FROM usuario
  WHERE usu_login = 'teste5';

DELETE FROM usuario
  WHERE usu_login = 'teste1';

-- 2.9 - Consultas para conferir as mudanças dos testes anteriores

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

-- 2.10 - Acerto do seqüencial do código

SELECT currval('usuario_usu_cod_seq');
-- Resulta: 3

SELECT setval('usuario_usu_cod_seq',2,false);

------------------------------------------------------------------------------
-- 3 - Testes da tabela "usu_shadow"

INSERT INTO usuario (usu_login,usu_nome,usu_estado)
  VALUES ('teste1','Primeiro Teste','i');

INSERT INTO usuario (usu_login,usu_nome,usu_estado)
  VALUES ('teste2','Segundo Teste','a');

-- 3.1 - Teste de validação (usu_shadow_validar())

/* E131005: Informe a senha do usuário
INSERT INTO usu_shadow (pwr_usucod,pwr_shadow,pwr_serial)
  VALUES (2,'',1);
*/

-- 3.2 - Testes de atualização (usu_shadow_atualizar())

/* E131006: O usuário teste1 não está ativo
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

-- Obs: os usuários "teste1" e "teste2" deverão estar incluídos em "pg_shadow"

-- 3.3 - Teste de mudança de login

UPDATE usuario
  SET usu_login = 'teste3'
  WHERE usu_login = 'teste1';

-- Obs: o usuário "teste1" deverá ser renomeado para "teste3" em "pg_shadow"

-- 3.4 - Teste de bloqueio de usuário

UPDATE usuario
  SET usu_estado = 'b'
  WHERE usu_login = 'teste3';

-- Obs: o usuário "teste3" deverá ser removido de "pg_shadow"

-- 3.5 - Teste de inclusão de senha de usuário já cadastrado no SGBD

UPDATE usuario
  SET usu_estado = 'a'
  WHERE usu_login = 'teste3';

CREATE USER teste3;

INSERT INTO usu_shadow (pwr_usucod,pwr_shadow,pwr_serial)
  VALUES (2,'123teste3',1);

-- 3.6 - Teste de mudança de senha

/* E131005: Informe a senha do usuário
UPDATE usu_shadow
  SET pwr_shadow = ''
  WHERE pwr_usucod = 2;
*/

UPDATE usu_shadow
  SET pwr_shadow = '123teste4'
  WHERE pwr_usucod = 2;

INSERT INTO grupo_usuario (gru_usucod,gru_grpnome)
  VALUES (2,'usuario');

-- 3.7 - Teste com o usuário "postgres"

/* E131001: Acesso negado: usuário postgres não cadastrado no sistema
UPDATE usu_shadow
  SET pwr_shadow = '123teste5'
  WHERE pwr_usucod = 3;
*/

-- 3.8 - Testes com o usuário "teste3" (senha "123teste4")

/* permission denied for relation usu_shadow
UPDATE usu_shadow
  SET pwr_shadow = '123teste5'
  WHERE pwr_usucod = 3;
*/

-- Obs: este teste não funciona, por algum o banco requer o acesso de leitura.
--      Na verdade só seria necessário acesso para alteração, de modo que o
--      usuário atual pudesse alterar a sua prória senha.

/* Executar logado como supervisor para continuar os testes:
GRANT SELECT,UPDATE ON usu_shadow      TO teste3;
*/

/* E131003: Usuário não autorizado para alterar senha de outro usuário
UPDATE usu_shadow
  SET pwr_shadow = '123teste5'
  WHERE pwr_usucod = 3;
*/

/* E131004: Usuário não autorizado para alterar prazo de senha
UPDATE usu_shadow
  SET pwr_prazo = '9999-12-31'
  WHERE pwr_usucod = 2;
*/

UPDATE usu_shadow
  SET pwr_shadow = '123teste5'
  WHERE pwr_usucod = 2;

-- 3.9 - Testes de exclusão (usu_shadow_excluir())

DELETE FROM usu_shadow
  WHERE pwr_usucod = 2;

-- Obs: o usuário "teste3" deverá ser removido de "pg_shadow"

DELETE FROM usuario
  WHERE usu_login = 'teste3';

DELETE FROM usuario
  WHERE usu_login = 'teste2';

-- Obs: o usuário "teste2" deverá ser removido de "pg_shadow"

-- 3.10 - Consultas para conferir as mudanças dos testes anteriores

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

-- 3.11 - Acerto do seqüencial do código

SELECT setval('usuario_usu_cod_seq',2,false);

------------------------------------------------------------------------------
-- 4 - Testes da tabela "grupo_usuario"

INSERT INTO usuario (usu_login,usu_nome,usu_estado)
  VALUES ('teste1','Primeiro Teste','A');

INSERT INTO usu_shadow (pwr_usucod,pwr_shadow,pwr_serial)
  VALUES (2,'123teste',1);

INSERT INTO grupo (grp_nome,grp_serial)
  VALUES ('grupo1',1);

-- 4.1 - Teste de inserção (grupo_usuario_inserir())

INSERT INTO grupo_usuario (gru_usucod,gru_grpnome)
  VALUES (2,'grupo1');

-- Obs: o código do usuário no banco ("usesysid" = 101) deve estar incluído
--      no campo "grolist" da tabela "pg_group" do grupo 'grupo1'

-- 4.2 - Teste de mudança de login de usuário

UPDATE usuario
  SET usu_login = 'teste2'
  WHERE usu_login = 'teste1';

-- Obs: o campo "gru_usulogin" deve estar atualizado para 'teste2'
--      e o código do usuário no banco ("usesysid" = 101) deve estar incluído
--      no campo "grolist" da tabela "pg_group" do grupo 'grupo1'

-- 4.3 - Teste de mudança de nome de grupo

UPDATE grupo
  SET grp_nome = 'grupo2'
  WHERE grp_nome = 'grupo1';

-- Obs: o campo "gru_grpnome" deve estar atualizado para 'grupo2'
--      e o código do usuário no banco ("usesysid" = 101) deve estar incluído
--      no campo "grolist" da tabela "pg_group" do grupo 'grupo2'

-- 4.4 - Teste de desativação de usuário

UPDATE usuario
  SET usu_estado = 'i'
  WHERE usu_login = 'teste2';

-- Obs: o registro da tabela "grupo_usuario" ref. ao usuário será desativado
--      e o campo "grolist" da tabela "pg_group" deve estar vazio

-- 4.5 - Teste de reativação de usuário

UPDATE usuario
  SET usu_estado = 'a'
  WHERE usu_login = 'teste2';

INSERT INTO usu_shadow (pwr_usucod,pwr_shadow,pwr_serial)
  VALUES (2,'123teste2',1);

-- Obs: o registro da tabela "grupo_usuario" ref. ao usuário será reativado
--      e o código do usuário no banco ("usesysid" = 101) deve estar incluído
--      no campo "grolist" da tabela "pg_group" do grupo 'grupo2'

-- 4.6 - Testes de alteração (grupo_usuario_alterar())

UPDATE grupo_usuario
  SET gru_ativo = FALSE
  WHERE gru_usulogin = 'teste2'
    AND gru_grpnome = 'grupo2';

-- Obs: o registro da tabela "grupo_usuario" ref. ao usuário será desativado
--      e o campo "grolist" da tabela "pg_group" deve estar vazio

UPDATE grupo_usuario
  SET gru_ativo = TRUE
  WHERE gru_usulogin = 'teste2'
    AND gru_grpnome = 'grupo2';

-- Obs: o registro da tabela "grupo_usuario" ref. ao usuário será reativado
--      e o código do usuário no banco ("usesysid" = 101) deve estar incluído
--      no campo "grolist" da tabela "pg_group" do grupo 'grupo2'

-- 4.7 - Teste de inclusão de usuário no grupo de gerente

INSERT INTO grupo_usuario (gru_usucod,gru_grpnome)
  VALUES (2,'gerente');

-- Obs: o campo "usesuper" da tabela "pg_shadow" de ser TRUE (1)

-- 4.8 - Testes com o usuário "teste2" (senha "123teste2")

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

-- 4.9 - Teste de inclusão de usuário no grupo de supervisor

INSERT INTO grupo_usuario (gru_usucod,gru_grpnome)
  VALUES (2,'supervisor');

-- Obs: o campo "usecreatedb" da tabela "pg_shadow" de ser TRUE (1)

-- 4.10 - Testes de exclusão (grupo_usuario_excluir())

DELETE FROM grupo_usuario
  WHERE gru_usucod = 2 AND gru_grpnome = 'grupo2';

-- Obs: o registro da tabela "grupo_usuario" ref. ao usuário será reativado
--      e o código do usuário no banco ("usesysid" = 101) deve estar incluído
--      no campo "grolist" da tabela "pg_group" do grupo 'grupo2'

DELETE FROM grupo_usuario
  WHERE gru_usucod = 2 AND gru_grpnome = 'supervisor';

-- Obs: o campo "usecreatedb" da tabela "pg_shadow" de ser FALSE (0)

DELETE FROM grupo_usuario
  WHERE gru_usucod = 2 AND gru_grpnome = 'gerente';

-- Obs: o campo "usesuper" da tabela "pg_shadow" de ser FALSE (0)

-- 4.11 - Teste de inclusão de usuário no grupo de supervisor

INSERT INTO grupo_usuario (gru_usucod,gru_grpnome)
  VALUES (2,'supervisor');

-- Obs: os campos "usecreatedb" e "usesuper" da tabela "pg_shadow"
--      devem ser TRUE (1)

-- 4.12 - Teste de exclusão e inclusão de senha

DELETE FROM usu_shadow
  WHERE pwr_usucod = 2;

-- Obs: o registro da tabela "grupo_usuario" ref. ao usuário será desativado
--      e o código do usuário no banco ("usesysid" = 101) deve estar removido
--      no campo "grolist" da tabela "pg_group" do grupo 'supervisor'

INSERT INTO usu_shadow (pwr_usucod,pwr_shadow,pwr_serial)
  VALUES (2,'123teste3',1);

-- Obs: o registro da tabela "grupo_usuario" ref. ao usuário será reativado
--      e o código do usuário no banco ("usesysid" = 101) deve estar incluído
--      no campo "grolist" da tabela "pg_group" do grupo 'supervisor'
-- Obs: os campos "usecreatedb" e "usesuper" da tabela "pg_shadow"
--      devem ser TRUE (1)

-- 4.13 - Teste de exclusão de usuário

DELETE FROM usuario
  WHERE usu_login = 'teste2';

-- 4.14 - Teste de grupo com mais de um usuário

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

-- 4.15 - Teste de mudança de nome

UPDATE grupo
  SET grp_nome = 'grupo3'
  WHERE grp_nome = 'grupo2';

-- Obs: o campo "gru_grpnome" deve estar atualizado para 'grupo3'
--      e o códigos dos usuário no banco devem estar incluídos
--      no campo "grolist" da tabela "pg_group" do grupo 'grupo3'

-- 4.16 - Teste de exclusão de grupo

DELETE FROM grupo
  WHERE grp_nome = 'grupo3';

DELETE FROM usuario
  WHERE usu_login = 'teste3';

DELETE FROM usuario
  WHERE usu_login = 'teste4';

-- 4.17 - Consultas para conferir as mudanças dos testes anteriores

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

-- 4.18 - Acerto dos seqüenciais dos códigos de grupo de usuário

SELECT setval('grupo_grp_cod_seq',5,false);

SELECT setval('usuario_usu_cod_seq',2,false);

------------------------------------------------------------------------------
-- Consultas para desenvolvimento da interface

-- Manutenção

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

-- Seleção

SELECT usu_cod, usu_login, usu_nome
  FROM usuario_view
  ORDER BY usu_nome;

------------------------------------------------------------------------------
-- Usuários para testes de outras tabelas

-- Usuário "gerente1"

INSERT INTO usuario (usu_login,usu_nome,usu_estado)
  VALUES ('gerente1','Primeiro Gerente','A');

INSERT INTO usu_shadow (pwr_usucod,pwr_shadow,pwr_serial)
  VALUES (2,'ger1',1);

INSERT INTO grupo_usuario (gru_usucod,gru_grpnome)
  VALUES (2,'gerente');

-- Usuário "usuario1"

INSERT INTO usuario (usu_login,usu_nome,usu_estado)
  VALUES ('usuario1','Usuário Comum','A');

INSERT INTO usu_shadow (pwr_usucod,pwr_shadow,pwr_serial)
  VALUES (3,'usu1',1);

INSERT INTO grupo_usuario (gru_usucod,gru_grpnome)
  VALUES (3,'usuario');

-- Usuário "caixa1"

INSERT INTO usuario (usu_login,usu_nome,usu_estado)
  VALUES ('caixa1','Primeiro Caixa','A');

INSERT INTO usu_shadow (pwr_usucod,pwr_shadow,pwr_serial)
  VALUES (4,'caixa1',1);

INSERT INTO grupo_usuario (gru_usucod,gru_grpnome)
  VALUES (4,'usuario');

INSERT INTO grupo_usuario (gru_usucod,gru_grpnome)
  VALUES (4,'caixa');

-- Usuário "caixa2"

INSERT INTO usuario (usu_login,usu_nome,usu_estado)
  VALUES ('caixa2','Segundo Caixa','A');

INSERT INTO usu_shadow (pwr_usucod,pwr_shadow,pwr_serial)
  VALUES (5,'caixa2',1);

INSERT INTO grupo_usuario (gru_usucod,gru_grpnome)
  VALUES (5,'caixa');

-- Usuário "gerente2"

INSERT INTO usuario (usu_login,usu_nome,usu_estado)
  VALUES ('gerente2','Segundo Gerente','A');

INSERT INTO usu_shadow (pwr_usucod,pwr_shadow,pwr_serial)
  VALUES (6,'ger2',1);

INSERT INTO grupo_usuario (gru_usucod,gru_grpnome)
  VALUES (6,'gerente');

INSERT INTO grupo_usuario (gru_usucod,gru_grpnome)
  VALUES (6,'caixa');

-- Usuário "vendedor1"

INSERT INTO usuario (usu_login,usu_nome,usu_estado)
  VALUES ('vendedor1','Primeiro vendedor','A');

INSERT INTO usu_shadow (pwr_usucod,pwr_shadow,pwr_serial)
  VALUES (7,'ven1',1);

------------------------------------------------------------------------------
-- vim: ai:syn=plsql
