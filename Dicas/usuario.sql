------------------------------------------------------------------------------
-- Definição das tabelas de cadastro de usuário
--
-- Versão:
--   1.1 (Março/2005)
--
-- Autor:
--   Márcio Gil Maldonado
--
-- E-mail:
--   marciomgil@bol.com.br / marciomgil@yahoo.com.br
--
-- Compatibilidade:
--   PostgreSQL 7.2
--   PostgreSQL 8.0
--
-- Este código pode ser utilizado livremente sem autorização prévia.
-- Qualquer correção ou melhoria deve ser informada ao autor, objetivando
-- com isso a contínua melhoria deste. Se houver alguma crítica, comentário
-- ou dúvida a respeito, favor entrar em contato.
--

/*
DROP TRIGGER usuario_before1_ins_upd            ON usuario;
DROP TRIGGER usuario_before2_ins                ON usuario;
DROP TRIGGER usuario_before3_upd                ON usuario;
DROP TRIGGER usuario_before4_del                ON usuario;
DROP TRIGGER usuario_after1_ins_upd             ON usuario;
DROP TRIGGER usu_shadow_before1_ins_upd         ON usu_shadow;
DROP TRIGGER usu_shadow_before2_del             ON usu_shadow;
DROP TRIGGER usu_shadow_after1_ins_upd          ON usu_shadow;
DROP TRIGGER grupo_before1_ins                  ON grupo;
DROP TRIGGER grupo_before2_upd                  ON grupo;
DROP TRIGGER grupo_before3_del                  ON grupo;
DROP TRIGGER grupo_usuario_before1_ins          ON grupo_usuario;
DROP TRIGGER grupo_usuario_before2_upd          ON grupo_usuario;
DROP TRIGGER grupo_usuario_before3_del          ON grupo_usuario;

DROP FUNCTION usuario_validar();
DROP FUNCTION usuario_inserir();
DROP FUNCTION usuario_alterar();
DROP FUNCTION usuario_excluir();
DROP FUNCTION usuario_atualizar();
DROP FUNCTION usu_shadow_validar();
DROP FUNCTION usu_shadow_atualizar();
DROP FUNCTION usu_shadow_excluir();
DROP FUNCTION grupo_inserir();
DROP FUNCTION grupo_alterar();
DROP FUNCTION grupo_excluir();
DROP FUNCTION grupo_usuario_inserir();
DROP FUNCTION grupo_usuario_alterar();
DROP FUNCTION grupo_usuario_excluir();

DROP VIEW usuario_view;
DROP VIEW grupo_view;

DROP SEQUENCE usuario_usu_cod_seq;
DROP SEQUENCE grupo_grp_cod_seq;

DROP TABLE grupo_usuario;
DROP TABLE grupo;
DROP TABLE usu_shadow;
DROP TABLE usuario;
*/

CREATE TABLE usuario (
  usu_cod       INTEGER         PRIMARY KEY,            -- Código         (pk)
  usu_login     VARCHAR(16)     NOT NULL UNIQUE,        -- Login
  usu_nome      VARCHAR(50)     NOT NULL UNIQUE,        -- Nome
  usu_tel       VARCHAR(30),                            -- Telefone
  usu_rua       VARCHAR(50),                            -- Endereço
  usu_bai       VARCHAR(30),                            -- Bairro
  usu_cid       VARCHAR(30),                            -- Cidade
  usu_uf        CHAR(2),                                -- Unidade federativa
  usu_cep       VARCHAR(8),                             -- CEP
  usu_doc       VARCHAR(11),                            -- CPF
  usu_reg       VARCHAR(20),                            -- Identidade
  usu_dtreg     DATE,                                   -- Data de registro
  usu_dtnasc    DATE,                                   -- Data de nascimento
  usu_dtinic    DATE,                                   -- Data de início
  usu_dtsaid    DATE,                                   -- Data de saída
  usu_com       NUMERIC(5,2),                           -- Comissão
  usu_usucx     INTEGER                                 -- Caixa
    REFERENCES usuario (usu_cod)
    ON UPDATE CASCADE,
  usu_estado    CHAR(1)         NOT NULL                -- Estado
    CHECK (usu_estado IN ('A','I','B')),
    -- Ativo, Inativo, Bloqueado
  usu_dtestado  TIMESTAMP       NOT NULL,               -- Data do estado  (i)
  usu_dtcad     TIMESTAMP       NOT NULL,               -- Data cadastro   (i)
  usu_dtatual   TIMESTAMP       NOT NULL,               -- Data atualização(i)
  usu_obs       TEXT                                    -- Observação
);

CREATE TABLE usu_shadow (
  pwr_usucod    INTEGER         PRIMARY KEY             -- Código         (pk)
    REFERENCES usuario (usu_cod)
    ON UPDATE CASCADE,
  pwr_shadow    VARCHAR(16)     NOT NULL,               -- Senha
  pwr_prazo     DATE,                                   -- Prazo
  pwr_dtatual   TIMESTAMP       NOT NULL,               -- Data atualização(i)
  pwr_serial    INTEGER         NOT NULL                -- Controle
);

CREATE TABLE grupo (
  grp_cod       INTEGER         PRIMARY KEY,            -- Código         (pk)
  grp_nome      VARCHAR(16)     NOT NULL UNIQUE,        -- Nome
  grp_prazo     DATE,                                   -- Prazo
  grp_dtatual   TIMESTAMP       NOT NULL,               -- Data atualização(i)
  grp_serial    INTEGER         NOT NULL                -- Controle
);

CREATE TABLE grupo_usuario (
  gru_usucod    INTEGER                                 -- Cód. usuário   (pk)
    REFERENCES usuario (usu_cod)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  gru_grpnome   VARCHAR(16)                             -- Nome do grupo  (pk)
    REFERENCES grupo (grp_nome)
    ON UPDATE CASCADE
    ON DELETE CASCADE,
  gru_usulogin  VARCHAR(16),                            -- Login do usuário(i)
  gru_ativo     BOOLEAN,                                -- Ativo

  PRIMARY KEY (gru_usucod,gru_grpnome)                  -- Chave primária
);

------------------------------------------------------------------------------
-- Seqüencial do código de usuário

/*
DROP SEQUENCE usuario_usu_cod_seq;
*/

CREATE SEQUENCE usuario_usu_cod_seq;

------------------------------------------------------------------------------
-- Validação do cadastro do usuário

/*
DROP TRIGGER usuario_before1_ins_upd            ON usuario;
DROP FUNCTION usuario_validar();
*/

CREATE FUNCTION usuario_validar() RETURNS OPAQUE AS '
DECLARE
  login  usuario.usu_login%TYPE;
BEGIN
  -- Confere o login do usuário
  NEW.usu_login := trim(from NEW.usu_login);

  IF NEW.usu_login IS NULL
      OR char_length(NEW.usu_login) = 0 THEN
    RAISE EXCEPTION ''E13001: Informe o login do usuário'';
  END IF;

  -- Confere o nome do usuário
  IF NEW.usu_nome IS NULL
      OR char_length(trim(from NEW.usu_nome)) = 0 THEN
    RAISE EXCEPTION ''E13002: Informe o nome do usuário'';
  END IF;

  -- Confere a comissão
  IF NEW.usu_com IS NULL OR NEW.usu_com < 0 THEN
    NEW.usu_com := 0;
  END IF;

  -- Confere o estado do usuário
  IF NEW.usu_estado IS NULL
      OR char_length(trim(from NEW.usu_estado)) = 0 THEN
    RAISE EXCEPTION ''E13003: Informe o estado do usuário'';
  END IF;

  NEW.usu_estado := upper(NEW.usu_estado);

  IF NOT NEW.usu_estado IN (''A'',''I'',''B'') THEN
    RAISE EXCEPTION ''E13004: Estado inválido: %'',
        NEW.usu_estado;
  END IF;

  -- Confere o caixa
  IF NEW.usu_usucx IS NOT NULL THEN
    IF (SELECT TRUE FROM usuario
          WHERE usu_cod = NEW.usu_usucx) IS NULL THEN
      RAISE EXCEPTION ''E13005: Caixa inexistente: %'',
          NEW.usu_usucx;
    END IF;

    IF (SELECT TRUE FROM grupo_usuario
          WHERE gru_usucod = NEW.usu_usucx
            AND gru_grpnome = ''caixa'') IS NULL THEN
      login := (
        SELECT usu_login FROM usuario
          WHERE usu_cod = NEW.usu_usucx
      );
      RAISE EXCEPTION ''E13006: O usuário % não está autorizado para manter um caixa'',
          login;
    END IF;
  END IF;

  RETURN NEW;
END; '
  LANGUAGE 'plpgsql';

------------------------------------------------------------------------------
-- Inclusão de usuário

/*
DROP TRIGGER usuario_before1_ins_upd            ON usuario;
DROP TRIGGER usuario_before2_ins                ON usuario;
DROP FUNCTION usuario_inserir();
*/

CREATE FUNCTION usuario_inserir() RETURNS OPAQUE AS '
DECLARE
  usucod  usuario.usu_cod%TYPE;
BEGIN
  -- Confere o login do usuário
  usucod := (
    SELECT usu_cod FROM usuario
      WHERE usu_login = NEW.usu_login
  );
  IF usucod IS NOT NULL THEN
    RAISE EXCEPTION ''E13101: Login já cadastrado sob código %'', usucod;
  END IF;

  -- Confere o nome do usuário
  usucod := (
    SELECT usu_cod FROM usuario
      WHERE usu_nome = NEW.usu_nome
  );
  IF usucod IS NOT NULL THEN
    RAISE EXCEPTION ''E13102: Nome já cadastrado sob código %'', usucod;
  END IF;

  -- Gera o código do usuário
  IF NEW.usu_cod IS NULL OR NEW.usu_cod <= 0 THEN
    usucod := nextval(''usuario_usu_cod_seq'');
    WHILE (SELECT TRUE FROM usuario
             WHERE usu_cod = usucod) LOOP
      usucod := nextval(''usuario_usu_cod_seq'');
    END LOOP;
    NEW.usu_cod := usucod;
  ELSE
    IF (SELECT TRUE FROM usuario
          WHERE usu_cod = NEW.usu_cod) THEN
      RAISE EXCEPTION ''E13103: Código já existente: %'',
        NEW.usu_cod;
    END IF;
  END IF;

  -- Confere a data do estado
  IF NEW.usu_dtestado IS NULL THEN
    NEW.usu_dtestado := CURRENT_TIMESTAMP;
  END IF;

  -- Confere a data do cadastro
  IF NEW.usu_dtcad IS NULL THEN
    NEW.usu_dtcad := CURRENT_TIMESTAMP;
  END IF;

  -- Data de atualização
  NEW.usu_dtatual := CURRENT_TIMESTAMP;

  RETURN NEW;
END; '
  LANGUAGE 'plpgsql';

------------------------------------------------------------------------------
-- Alteração de usuário

/*
DROP TRIGGER usuario_before1_ins_upd            ON usuario;
DROP TRIGGER usuario_before3_upd                ON usuario;
DROP FUNCTION usuario_alterar();
*/

CREATE FUNCTION usuario_alterar() RETURNS OPAQUE AS '
DECLARE
  usucod  usuario.usu_cod%TYPE;
BEGIN
  -- Confere o login do usuário
  IF NEW.usu_login <> OLD.usu_login THEN
    usucod := (
      SELECT usu_cod FROM usuario
        WHERE usu_login = NEW.usu_login
    );
    IF usucod IS NOT NULL THEN
      RAISE EXCEPTION ''E13201: Login já cadastrado sob código %'', usucod;
    END IF;
  END IF;

  -- Confere o nome do usuário
  IF NEW.usu_nome <> OLD.usu_nome THEN
    usucod := (
      SELECT usu_cod FROM usuario
        WHERE usu_nome = NEW.usu_nome
    );
    IF usucod IS NOT NULL THEN
      RAISE EXCEPTION ''E13202: Nome já cadastrado sob código %'', usucod;
    END IF;
  END IF;

  -- Confere o código do usuário
  IF NEW.usu_cod IS NULL OR NEW.usu_cod <> OLD.usu_cod THEN
    IF NEW.usu_cod IS NULL OR NEW.usu_cod <= 0 THEN
      RAISE EXCEPTION ''E13203: Código inválido: %'',
        NEW.usu_cod;
    END IF;
    IF (SELECT TRUE FROM usuario
          WHERE usu_cod = NEW.usu_cod) THEN
      RAISE EXCEPTION ''E13204: Código já existente: %'',
        NEW.usu_cod;
    END IF;
  END IF;

  -- Confere a data do estado
  IF NEW.usu_dtestado IS NULL OR
      (NEW.usu_dtestado = OLD.usu_dtestado
        AND NEW.usu_estado <> OLD.usu_estado) THEN
    NEW.usu_dtestado := CURRENT_TIMESTAMP;
  END IF;

  -- Data de atualização
  NEW.usu_dtatual := CURRENT_TIMESTAMP;

  RETURN NEW;
END; '
  LANGUAGE 'plpgsql';

------------------------------------------------------------------------------
-- Exclusão de usuário

/*
DROP TRIGGER usuario_before4_del                ON usuario;
DROP FUNCTION usuario_excluir();
*/

CREATE FUNCTION usuario_excluir() RETURNS OPAQUE AS '
DECLARE
  txt     TEXT;
BEGIN
  -- Exclui o usuário do SGBD
  IF (SELECT TRUE FROM pg_user
        WHERE usename = cast( OLD.usu_login AS NAME )) THEN
    txt := ''DROP USER '' || quote_ident(OLD.usu_login);
    EXECUTE txt;
  END IF;

  -- Exclui o usuário dos grupos
  DELETE FROM grupo_usuario
    WHERE gru_usucod = OLD.usu_cod;

  -- Exclui a senha do usuário
  DELETE FROM usu_shadow
    WHERE pwr_usucod = OLD.usu_cod;

  RETURN OLD;
END; '
  LANGUAGE 'plpgsql';

------------------------------------------------------------------------------
-- Atualização de usuário

/*
DROP TRIGGER usuario_after1_ins_upd             ON usuario;
DROP FUNCTION usuario_atualizar();
*/

CREATE FUNCTION usuario_atualizar() RETURNS OPAQUE AS '
DECLARE
  usucod  usuario.usu_cod%TYPE;
  atual   BOOLEAN;
  login   NAME;
  txt     TEXT;
BEGIN
  -- Verifica desabilitação ou mudança de login
  IF TG_OP = ''INSERT'' THEN
    IF NEW.usu_estado <> ''A'' THEN
      atual := TRUE;
      login := cast( NEW.usu_login AS NAME );
      usucod := NEW.usu_cod;
    ELSE
      atual := FALSE;
    END IF;
  ELSE
    IF NEW.usu_estado <> ''A'' AND OLD.usu_estado = ''A''
        OR NEW.usu_login <> OLD.usu_login THEN
      atual := TRUE;
      login := cast( OLD.usu_login AS NAME );
      usucod := OLD.usu_cod;
    ELSE
      atual := FALSE;
    END IF;
  END IF;

  IF atual THEN
    IF (SELECT TRUE FROM pg_user
          WHERE usename = login) THEN
      -- Exclui o usuário do SGBD
      txt := ''DROP USER '' || quote_ident(login);
      EXECUTE txt;

      -- Atualiza os grupos do usuário
      UPDATE grupo_usuario
        SET gru_ativo = FALSE
        WHERE gru_usucod = usucod;
    END IF;
  END IF;

  -- Verifica desabilitação do usuário
  IF TG_OP = ''UPDATE'' THEN
    IF NEW.usu_estado <> ''A'' AND OLD.usu_estado = ''A'' THEN
      atual := TRUE;
    ELSE
      atual := FALSE;
    END IF;
  END IF;

  IF atual THEN
    DELETE FROM usu_shadow
      WHERE pwr_usucod = usucod;
  END IF;

  -- Verifica habilitação do usuário
  IF TG_OP = ''INSERT'' THEN
    IF NEW.usu_estado = ''A'' THEN
      atual := TRUE;
      usucod := NEW.usu_cod;
    ELSE
      atual := FALSE;
    END IF;
  ELSE
    IF NEW.usu_estado = ''A'' AND (OLD.usu_estado <> ''A''
          OR NEW.usu_login <> OLD.usu_login) THEN
      atual := TRUE;
      usucod := OLD.usu_cod;
    ELSE
      atual := FALSE;
    END IF;
  END IF;

  IF atual THEN
    login := cast( NEW.usu_login AS NAME );

    -- Atualiza a senha do usuário
    UPDATE usu_shadow
      SET pwr_usucod = NEW.usu_cod
      WHERE pwr_usucod = usucod;
  END IF;

  RETURN NULL;
END; '
  LANGUAGE 'plpgsql';

------------------------------------------------------------------------------
-- Inclusão e alteração de senha

/*
DROP TRIGGER usu_shadow_before1_ins_upd         ON usu_shadow;
DROP FUNCTION usu_shadow_validar();
*/

CREATE FUNCTION usu_shadow_validar() RETURNS OPAQUE AS '
DECLARE
  usures usuario.usu_cod%TYPE;
  login  usuario.usu_login%TYPE;
BEGIN
  -- Verifica qual o usuário responsável pelo evento
  usures := (
    SELECT usu_cod FROM usuario
      WHERE usu_login = cast( CURRENT_USER AS VARCHAR )
  );

  IF usures IS NULL THEN
    login := CURRENT_USER;
    RAISE EXCEPTION ''E131001: Acesso negado: usuário % não cadastrado no sistema'',
        login;
  END IF;

  -- Verifica o login do usuário
  login := (
    SELECT usu_login FROM usuario
      WHERE usu_cod = NEW.pwr_usucod
  );

  -- Verifica a permissão de acesso
  IF (SELECT TRUE FROM grupo_usuario
        WHERE gru_usucod = usures AND gru_ativo
          AND gru_grpnome IN (''gerente'',''supervisor'')
        LIMIT 1) IS NULL THEN
    IF TG_OP = ''INSERT'' OR
        (SELECT TRUE FROM pg_user
           WHERE usename = login) IS NULL THEN
      RAISE EXCEPTION ''E131002: Usuário não autorizado para cadastrar senha'';
    END IF;
    IF NEW.pwr_usucod <> usures THEN
      RAISE EXCEPTION ''E131003: Usuário não autorizado para alterar senha de outro usuário'';
    END IF;
    IF NEW.pwr_prazo IS NULL AND OLD.pwr_prazo IS NOT NULL
        OR NEW.pwr_prazo IS NOT NULL AND OLD.pwr_prazo IS NULL
        OR NEW.pwr_prazo <> OLD.pwr_prazo THEN
      RAISE EXCEPTION ''E131004: Usuário não autorizado para alterar prazo de senha'';
    END IF;
  END IF;

  -- Verifica a senha
  NEW.pwr_shadow := trim(from NEW.pwr_shadow);

  IF NEW.pwr_shadow IS NULL
      OR char_length(NEW.pwr_shadow) = 0 THEN
    RAISE EXCEPTION ''E131005: Informe a senha do usuário'';
  END IF;

  -- Data de atualização
  NEW.pwr_dtatual := CURRENT_TIMESTAMP;

  RETURN NEW;
END; '
  LANGUAGE 'plpgsql';

------------------------------------------------------------------------------
-- Exclusão de senha

/*
DROP TRIGGER usu_shadow_before2_del             ON usu_shadow;
DROP FUNCTION usu_shadow_excluir();
*/

CREATE FUNCTION usu_shadow_excluir() RETURNS OPAQUE AS '
DECLARE
  login   NAME;
  txt     TEXT;
BEGIN
  -- Verifica o login do usuário
  login := (
    SELECT usu_login FROM usuario
      WHERE usu_cod = OLD.pwr_usucod
  );

  -- Exclui o usuário do SGBD
  IF (SELECT TRUE FROM pg_user
        WHERE usename = login) THEN
    txt := ''DROP USER '' || quote_ident(login);
    EXECUTE txt;
  END IF;

  -- Atualiza os grupos do usuário
  UPDATE grupo_usuario
    SET gru_ativo = FALSE
    WHERE gru_usucod = OLD.pwr_usucod;

  RETURN OLD;
END; '
  LANGUAGE 'plpgsql';

------------------------------------------------------------------------------
-- Atualiza inclusão e alteração de senha

/*
DROP TRIGGER usu_shadow_after1_ins_upd          ON usu_shadow;
DROP FUNCTION usu_shadow_atualizar();
*/

CREATE FUNCTION usu_shadow_atualizar() RETURNS OPAQUE AS '
DECLARE
  estado  usuario.usu_estado%TYPE;
  login   NAME;
  txt     TEXT;
BEGIN
  -- Confere o login do usuário
  login := (
    SELECT usu_login FROM usuario
      WHERE usu_cod = NEW.pwr_usucod
  );

  -- Confere o estado atual
  estado := (
    SELECT usu_estado FROM usuario
      WHERE usu_cod = NEW.pwr_usucod
  );

  IF estado IS NULL OR estado <> ''A'' THEN
    RAISE EXCEPTION ''E131006: O usuário % não está ativo'',
        login;
  END IF;

  -- Verifica se o usuário está cadastrado no SGDB
  IF (SELECT TRUE FROM pg_user
        WHERE usename = login) THEN
    -- Altera a senha do usuário
    txt := ''ALTER USER '' || quote_ident(login)
        || '' WITH PASSWORD '' || quote_literal( NEW.pwr_shadow );

    -- Prazo de validade
    IF TG_OP = ''INSERT'' THEN
      IF NEW.pwr_prazo IS NULL THEN
        NEW.pwr_prazo := CURRENT_DATE + 365;
      END IF;
      txt := txt || '' VALID UNTIL '' || quote_literal( cast(
             NEW.pwr_prazo AS TEXT ) );
    ELSE
      IF NEW.pwr_prazo IS NULL AND OLD.pwr_prazo IS NOT NULL
          OR NEW.pwr_prazo IS NOT NULL AND OLD.pwr_prazo IS NULL
          OR NEW.pwr_prazo <> OLD.pwr_prazo THEN
        IF NEW.pwr_prazo IS NULL THEN
          NEW.pwr_prazo := CURRENT_DATE + 365;
        END IF;
        txt := txt || '' VALID UNTIL '' || quote_literal( cast(
               NEW.pwr_prazo AS TEXT ) );
      END IF;
    END IF;

    EXECUTE txt;
  ELSE
    -- Cria o usuário no SGBD
    txt := ''CREATE USER '' || quote_ident(login)
        || '' WITH PASSWORD '' || quote_literal(NEW.pwr_shadow);

    -- Verifica se o usuário é supervisor
    IF (SELECT TRUE FROM grupo_usuario
          WHERE gru_usucod = NEW.pwr_usucod
            AND gru_grpnome = ''supervisor'') THEN
      txt := txt || '' CREATEDB CREATEUSER'';
    ELSE
      -- Verifica se o usuário é gerente
      IF (SELECT TRUE FROM grupo_usuario
            WHERE gru_usucod = NEW.pwr_usucod
              AND gru_grpnome = ''gerente'') THEN
        txt := txt || '' NOCREATEDB CREATEUSER'';
      ELSE
        txt := txt || '' NOCREATEDB NOCREATEUSER'';
      END IF;
    END IF;

    -- Prazo de validade
    IF NEW.pwr_prazo IS NULL THEN
      NEW.pwr_prazo := CURRENT_DATE + 365;
    END IF;

    txt := txt || '' VALID UNTIL '' || quote_literal( cast(
           NEW.pwr_prazo AS TEXT ) );

    EXECUTE txt;

    IF (SELECT TRUE FROM pg_user
          WHERE usename = login ) IS NULL THEN
      RAISE EXCEPTION ''E131007: Não foi possível criar o usuário: login inválido'';
    END IF;

    -- Atualiza os grupos do usuário
    UPDATE grupo_usuario
      SET gru_usulogin = login,
          gru_ativo = TRUE
      WHERE gru_usucod = NEW.pwr_usucod;
  END IF;

  RETURN NULL;
END; '
  LANGUAGE 'plpgsql';

------------------------------------------------------------------------------
-- Seqüencial do código de grupo

/*
DROP SEQUENCE grupo_grp_cod_seq;
*/

CREATE SEQUENCE grupo_grp_cod_seq;

------------------------------------------------------------------------------
-- Inclusão de grupo

/*
DROP TRIGGER grupo_before1_ins                  ON grupo;
DROP FUNCTION grupo_inserir();
*/

CREATE FUNCTION grupo_inserir() RETURNS OPAQUE AS '
DECLARE
  grpcod  grupo.grp_cod%TYPE;
  txt     TEXT;
BEGIN
  -- Confere o nome do grupo
  IF NEW.grp_nome IS NULL
      OR char_length(trim(from NEW.grp_nome)) = 0 THEN
    RAISE EXCEPTION ''E13401: Informe o nome do grupo'';
  END IF;

  grpcod := (
    SELECT grp_cod FROM grupo
      WHERE grp_nome = NEW.grp_nome
  );
  IF grpcod IS NOT NULL THEN
    RAISE EXCEPTION ''E13402: Grupo já cadastrado sob código %'', grpcod;
  END IF;

  -- Gera o código do grupo
  IF NEW.grp_cod IS NULL OR NEW.grp_cod <= 0 THEN
    grpcod := nextval(''grupo_grp_cod_seq'');
    WHILE (SELECT TRUE FROM grupo
             WHERE grp_cod = grpcod) LOOP
      grpcod := nextval(''grupo_grp_cod_seq'');
    END LOOP;
    NEW.grp_cod := grpcod;
  ELSE
    IF (SELECT TRUE FROM grupo
          WHERE grp_cod = NEW.grp_cod) THEN
      RAISE EXCEPTION ''E13403: Código já existente: %'',
        NEW.grp_cod;
    END IF;
  END IF;

  -- Confere o código do sistema
  IF (SELECT TRUE FROM pg_group
        WHERE groname = cast( NEW.grp_nome AS NAME )) IS NULL THEN
    -- Cria o grupo no SGBD
    txt := ''CREATE GROUP '' || quote_ident(NEW.grp_nome);
    EXECUTE txt;
    IF (SELECT TRUE FROM pg_group
          WHERE groname = cast( NEW.grp_nome AS NAME )) IS NULL THEN
      RAISE EXCEPTION ''E13404: Não foi possível criar o grupo: nome inválido'';
    END IF;
  END IF;

  -- Prazo de acesso
  IF NEW.grp_prazo IS NULL THEN
    NEW.grp_prazo := CURRENT_DATE + 365;
  END IF;

  -- Data de atualização
  NEW.grp_dtatual := CURRENT_TIMESTAMP;

  RETURN NEW;
END; '
  LANGUAGE 'plpgsql';

------------------------------------------------------------------------------
-- Alteração de grupo

/*
DROP TRIGGER grupo_before2_upd                  ON grupo;
DROP FUNCTION grupo_alterar();
*/

CREATE FUNCTION grupo_alterar() RETURNS OPAQUE AS '
DECLARE
  grpcod  grupo.grp_cod%TYPE;
  txt     TEXT;
BEGIN
  -- Confere o nome do grupo
  IF NEW.grp_nome IS NULL
      OR char_length(trim(from NEW.grp_nome)) = 0 THEN
    RAISE EXCEPTION ''E13501: Informe o nome do grupo'';
  END IF;

  IF NEW.grp_nome <> OLD.grp_nome THEN
    grpcod := (
      SELECT grp_cod FROM grupo
        WHERE grp_nome = NEW.grp_nome
    );
    IF grpcod IS NOT NULL THEN
      RAISE EXCEPTION ''E13502: Grupo já cadastrado sob código %'', grpcod;
    END IF;
  END IF;

  -- Confere o código do grupo
  IF NEW.grp_cod IS NULL OR NEW.grp_cod <> OLD.grp_cod THEN
    IF NEW.grp_cod IS NULL OR NEW.grp_cod <= 0 THEN
      RAISE EXCEPTION ''E13503: Código inválido: %'',
        NEW.grp_cod;
    END IF;
    IF (SELECT TRUE FROM grupo
          WHERE grp_cod = NEW.grp_cod) THEN
      RAISE EXCEPTION ''E13504: Código já existente: %'',
        NEW.grp_cod;
    END IF;
  END IF;

  -- Verifica mudança de nome
  IF NEW.grp_nome <> OLD.grp_nome THEN
    -- Exclui o grupo do SGBD
    IF (SELECT TRUE FROM pg_group
          WHERE groname = cast( OLD.grp_nome AS NAME )) THEN
      txt := ''DROP GROUP '' || quote_ident(OLD.grp_nome);
      EXECUTE txt;

      -- Atualiza os usuário do grupo
      UPDATE grupo_usuario
        SET gru_ativo = FALSE
        WHERE gru_grpnome = NEW.grp_nome;
    END IF;
  END IF;

  -- Verifica se o grupo está cadastrado no SGBD
  IF (SELECT TRUE FROM pg_group
        WHERE groname = cast( NEW.grp_nome AS NAME )) IS NULL THEN
    -- Cria o grupo no SGBD
    txt := ''CREATE GROUP '' || quote_ident(NEW.grp_nome);
    EXECUTE txt;
    IF (SELECT TRUE FROM pg_group
          WHERE groname = cast( NEW.grp_nome AS NAME )) IS NULL THEN
      RAISE EXCEPTION ''E13505: Não possível criar o grupo: nome inválido'';
    END IF;

    -- Atualiza os usuário do grupo
    UPDATE grupo_usuario
      SET gru_ativo = TRUE
      WHERE gru_grpnome = NEW.grp_nome;
  END IF;

  -- Data de atualização
  NEW.grp_dtatual := CURRENT_TIMESTAMP;

  RETURN NEW;
END; '
  LANGUAGE 'plpgsql';

------------------------------------------------------------------------------
-- Exclusão de grupo

/*
DROP TRIGGER grupo_before3_del                  ON grupo;
DROP FUNCTION grupo_excluir();
*/

CREATE FUNCTION grupo_excluir() RETURNS OPAQUE AS '
DECLARE
  txt     TEXT;
BEGIN
  -- Exclui o grupo do SGBD
  IF (SELECT TRUE FROM pg_group
        WHERE groname = cast( OLD.grp_nome AS NAME )) THEN
    txt := ''DROP GROUP '' || quote_ident(OLD.grp_nome);
    EXECUTE txt;
  END IF;

  -- Exclui os usuários do grupo
  DELETE FROM grupo_usuario
    WHERE gru_grpnome = OLD.grp_nome;

  RETURN OLD;
END; '
  LANGUAGE 'plpgsql';

------------------------------------------------------------------------------
-- Inserção de usuário em grupo

/*
DROP TRIGGER grupo_usuario_before1_ins          ON grupo_usuario;
DROP FUNCTION grupo_usuario_inserir();
*/

CREATE FUNCTION grupo_usuario_inserir() RETURNS OPAQUE AS '
DECLARE
  atual   BOOLEAN;
  txt     TEXT;
BEGIN
  -- Confere o campo ativo
  IF NEW.gru_ativo IS NULL THEN
    NEW.gru_ativo = TRUE;
  END IF;

  -- Confere o login do usuário
  IF NEW.gru_usulogin IS NULL THEN
    NEW.gru_usulogin := (
      SELECT usu_login FROM usuario
        WHERE usu_cod = NEW.gru_usucod
    );
  END IF;

  IF NEW.gru_ativo THEN
    -- Verifica se o grupo e usuário estão cadastrados no SGBD
    IF (SELECT TRUE FROM pg_group
          WHERE groname = cast( NEW.gru_grpnome AS NAME )) THEN
      IF (SELECT TRUE FROM pg_user
            WHERE usename = cast( NEW.gru_usulogin AS NAME )) THEN
        atual = TRUE;
      ELSE
        atual = FALSE;
      END IF;
    ELSE
      atual = FALSE;
    END IF;

    IF atual THEN
      -- Altera as permissões do usuário
      IF NEW.gru_grpnome = ''supervisor'' THEN
        IF NOT (SELECT usecreatedb FROM pg_user
              WHERE usename = CURRENT_USER) THEN
           RAISE EXCEPTION ''E13701: Somente supervisor pode criar supervisor'';
        END IF;
        txt := ''ALTER USER '' || quote_ident(NEW.gru_usulogin)
            || '' CREATEDB CREATEUSER'';
        EXECUTE txt;
      ELSE
        IF NEW.gru_grpnome = ''gerente'' THEN
          txt := ''ALTER USER '' || quote_ident(NEW.gru_usulogin)
              || '' CREATEUSER'';
          EXECUTE txt;
        END IF;
      END IF;

      -- Insere o usuário no grupo
      txt := ''ALTER GROUP '' || quote_ident(NEW.gru_grpnome)
          || '' ADD USER '' || quote_ident(NEW.gru_usulogin);
      EXECUTE txt;
    ELSE
      NEW.gru_ativo = FALSE;
    END IF;
  END IF;

  RETURN NEW;
END; '
  LANGUAGE 'plpgsql';

------------------------------------------------------------------------------
-- Alteração de usuário em grupo

/*
DROP TRIGGER grupo_usuario_before2_upd          ON grupo_usuario;
DROP FUNCTION grupo_usuario_alterar();
*/

CREATE FUNCTION grupo_usuario_alterar() RETURNS OPAQUE AS '
DECLARE
  atual   BOOLEAN;
  txt     TEXT;
BEGIN
  -- Confere o campo ativo
  IF NEW.gru_ativo IS NULL THEN
    NEW.gru_ativo = FALSE;
  END IF;

  IF NOT NEW.gru_ativo AND OLD.gru_ativo
      OR NEW.gru_grpnome <> OLD.gru_grpnome
      OR NEW.gru_usulogin <> OLD.gru_usulogin THEN
    -- Verifica se o grupo e usuário estão cadastrados no SGBD
    IF (SELECT TRUE FROM pg_group
          WHERE groname = cast( OLD.gru_grpnome AS NAME )) THEN
      IF (SELECT TRUE FROM pg_user
            WHERE usename = cast( OLD.gru_usulogin AS NAME )) THEN
        atual = TRUE;
      ELSE
        atual = FALSE;
      END IF;
    ELSE
      atual = FALSE;
    END IF;

    IF atual THEN
      -- Altera as permissões do usuário
      IF OLD.gru_grpnome = ''supervisor'' THEN
        IF (SELECT TRUE FROM grupo_usuario
              WHERE gru_usucod = OLD.gru_usucod
                AND gru_grpnome = ''gerente'') THEN
          txt := ''ALTER USER '' || quote_ident(OLD.gru_usulogin)
              || '' NOCREATEDB'';
        ELSE
          txt := ''ALTER USER '' || quote_ident(OLD.gru_usulogin)
              || '' NOCREATEDB NOCREATEUSER'';
        END IF;
        EXECUTE txt;
      ELSE
        IF OLD.gru_grpnome = ''gerente'' THEN
          txt := ''ALTER USER '' || quote_ident(OLD.gru_usulogin)
              || '' NOCREATEUSER'';
          EXECUTE txt;
        END IF;
      END IF;

      -- Exclui o usuário do grupo
      txt := ''ALTER GROUP '' || quote_ident(OLD.gru_grpnome)
          || '' DROP USER '' || quote_ident(OLD.gru_usulogin);
      EXECUTE txt;
    END IF;
  END IF;

  IF NEW.gru_ativo THEN
    -- Verifica se o grupo e usuário estão cadastrados no SGBD
    IF (SELECT TRUE FROM pg_group
          WHERE groname = cast( NEW.gru_grpnome AS NAME )) THEN
      IF (SELECT TRUE FROM pg_user
            WHERE usename = cast( NEW.gru_usulogin AS NAME )) THEN
        atual = TRUE;
      ELSE
        atual = FALSE;
      END IF;
    ELSE
      atual = FALSE;
    END IF;

    IF atual THEN
      IF NOT OLD.gru_ativo
          OR NEW.gru_grpnome <> OLD.gru_grpnome
          OR NEW.gru_usulogin <> OLD.gru_usulogin THEN
        -- Altera as permissões do usuário
        IF NEW.gru_grpnome = ''supervisor'' THEN
          IF NOT (SELECT usecreatedb FROM pg_user
                WHERE usename = CURRENT_USER) THEN
             RAISE EXCEPTION ''E13801: Somente supervisor pode criar supervisor'';
          END IF;
          txt := ''ALTER USER '' || quote_ident(NEW.gru_usulogin)
              || '' CREATEDB CREATEUSER'';
          EXECUTE txt;
        ELSE
          IF NEW.gru_grpnome = ''gerente'' THEN
            txt := ''ALTER USER '' || quote_ident(NEW.gru_usulogin)
                || '' CREATEUSER'';
            EXECUTE txt;
          END IF;
        END IF;

        -- Insere o usuário no grupo
        txt := ''ALTER GROUP '' || quote_ident(NEW.gru_grpnome)
            || '' ADD USER '' || quote_ident(NEW.gru_usulogin);
        EXECUTE txt;
      END IF;
    ELSE
      NEW.gru_ativo = FALSE;
    END IF;
  END IF;

  RETURN NEW;
END; '
  LANGUAGE 'plpgsql';

------------------------------------------------------------------------------
-- Exclusão de usuário em grupo

/*
DROP TRIGGER grupo_usuario_before3_del          ON grupo_usuario;
DROP FUNCTION grupo_usuario_excluir();
*/

CREATE FUNCTION grupo_usuario_excluir() RETURNS OPAQUE AS '
DECLARE
  atual   BOOLEAN;
  txt     TEXT;
BEGIN
  IF OLD.gru_ativo THEN
    -- Verifica se o grupo e usuário estão cadastrados no SGBD
    IF (SELECT TRUE FROM pg_group
          WHERE groname = cast( OLD.gru_grpnome AS NAME )) THEN
      IF (SELECT TRUE FROM pg_user
            WHERE usename = cast( OLD.gru_usulogin AS NAME )) THEN
        atual = TRUE;
      ELSE
        atual = FALSE;
      END IF;
    ELSE
      atual = FALSE;
    END IF;

    IF atual THEN
      -- Altera as permissões do usuário
      IF OLD.gru_grpnome = ''supervisor'' THEN
        IF (SELECT TRUE FROM grupo_usuario
              WHERE gru_usucod = OLD.gru_usucod
                AND gru_grpnome = ''gerente'') THEN
          txt := ''ALTER USER '' || quote_ident(OLD.gru_usulogin)
              || '' NOCREATEDB'';
        ELSE
          txt := ''ALTER USER '' || quote_ident(OLD.gru_usulogin)
              || '' NOCREATEDB NOCREATEUSER'';
        END IF;
        EXECUTE txt;
      ELSE
        IF OLD.gru_grpnome = ''gerente'' THEN
          IF (SELECT TRUE FROM grupo_usuario
                WHERE gru_usucod = OLD.gru_usucod
                  AND gru_grpnome = ''supervisor'') IS NULL THEN
            txt := ''ALTER USER '' || quote_ident(OLD.gru_usulogin)
                || '' NOCREATEUSER'';
            EXECUTE txt;
          END IF;
        END IF;
      END IF;

      -- Exclui o usuário do grupo
      txt := ''ALTER GROUP '' || quote_ident(OLD.gru_grpnome)
          || '' DROP USER '' || quote_ident(OLD.gru_usulogin);
      EXECUTE txt;
    END IF;
  END IF;

  RETURN OLD;
END; '
  LANGUAGE 'plpgsql';

------------------------------------------------------------------------------
-- Gatilhos da tabela "usuario"

CREATE TRIGGER usuario_before2_ins
  BEFORE INSERT ON usuario
  FOR EACH ROW EXECUTE PROCEDURE usuario_inserir();

CREATE TRIGGER usuario_before3_upd
  BEFORE UPDATE ON usuario
  FOR EACH ROW EXECUTE PROCEDURE usuario_alterar();

CREATE TRIGGER usuario_before1_ins_upd
  BEFORE INSERT OR UPDATE ON usuario
  FOR EACH ROW EXECUTE PROCEDURE usuario_validar();

CREATE TRIGGER usuario_before4_del
  BEFORE DELETE ON usuario
  FOR EACH ROW EXECUTE PROCEDURE usuario_excluir();

CREATE TRIGGER usuario_after1_ins_upd
  AFTER INSERT OR UPDATE ON usuario
  FOR EACH ROW EXECUTE PROCEDURE usuario_atualizar();

------------------------------------------------------------------------------
-- Gatilhos da tabela "usu_shadow"

CREATE TRIGGER usu_shadow_before1_ins_upd
  BEFORE INSERT OR UPDATE ON usu_shadow
  FOR EACH ROW EXECUTE PROCEDURE usu_shadow_validar();

CREATE TRIGGER usu_shadow_before2_del
  BEFORE DELETE ON usu_shadow
  FOR EACH ROW EXECUTE PROCEDURE usu_shadow_excluir();

CREATE TRIGGER usu_shadow_after1_ins_upd
  AFTER INSERT OR UPDATE ON usu_shadow
  FOR EACH ROW EXECUTE PROCEDURE usu_shadow_atualizar();

------------------------------------------------------------------------------
-- Gatilhos da tabela "grupo"

CREATE TRIGGER grupo_before1_ins
  BEFORE INSERT ON grupo
  FOR EACH ROW EXECUTE PROCEDURE grupo_inserir();

CREATE TRIGGER grupo_before2_upd
  BEFORE UPDATE ON grupo
  FOR EACH ROW EXECUTE PROCEDURE grupo_alterar();

CREATE TRIGGER grupo_before3_del
  BEFORE DELETE ON grupo
  FOR EACH ROW EXECUTE PROCEDURE grupo_excluir();

------------------------------------------------------------------------------
-- Gatilhos da tabela "grupo_usuario"

CREATE TRIGGER grupo_usuario_before1_ins
  BEFORE INSERT ON grupo_usuario
  FOR EACH ROW EXECUTE PROCEDURE grupo_usuario_inserir();

CREATE TRIGGER grupo_usuario_before2_upd
  BEFORE UPDATE ON grupo_usuario
  FOR EACH ROW EXECUTE PROCEDURE grupo_usuario_alterar();

CREATE TRIGGER grupo_usuario_before3_del
  BEFORE DELETE ON grupo_usuario
  FOR EACH ROW EXECUTE PROCEDURE grupo_usuario_excluir();

------------------------------------------------------------------------------
-- Grupos básicos

INSERT INTO grupo (grp_nome,grp_serial)
  VALUES ('supervisor',1);

INSERT INTO grupo (grp_nome,grp_serial)
  VALUES ('gerente',2);

INSERT INTO grupo (grp_nome,grp_serial)
  VALUES ('usuario',3);

INSERT INTO grupo (grp_nome,grp_serial)
  VALUES ('caixa',4);

------------------------------------------------------------------------------
-- Views

CREATE VIEW usuario_view AS
  SELECT usu_cod, usu_login, usu_nome, usu_tel, usu_rua, usu_bai,
         usu_cid, usu_uf, usu_cep, usu_doc, usu_reg, usu_dtreg,
         usu_dtnasc, usu_dtinic, usu_dtsaid, usu_estado, usu_dtestado,
         usu_dtcad, usu_dtatual, usu_usucx
  FROM usuario
  WHERE usu_cod > 1;

CREATE VIEW grupo_view AS
  SELECT grp_cod, grp_nome
  FROM grupo
  WHERE grp_cod > 1;

------------------------------------------------------------------------------
-- Permissões de acesso

GRANT SELECT, INSERT, UPDATE, DELETE ON usuario         TO GROUP supervisor;
GRANT SELECT, INSERT, UPDATE, DELETE ON usuario         TO GROUP gerente;
GRANT SELECT                         ON usuario         TO GROUP caixa;
GRANT SELECT                         ON usuario         TO GROUP usuario;

GRANT SELECT                         ON usuario_view    TO GROUP supervisor;
GRANT SELECT                         ON usuario_view    TO GROUP gerente;
GRANT SELECT                         ON usuario_view    TO GROUP caixa;
GRANT SELECT                         ON usuario_view    TO GROUP usuario;

GRANT SELECT, INSERT, UPDATE, DELETE ON usu_shadow      TO GROUP supervisor;
GRANT SELECT, INSERT, UPDATE, DELETE ON usu_shadow      TO GROUP gerente;
GRANT UPDATE                         ON usu_shadow      TO GROUP caixa;
GRANT UPDATE                         ON usu_shadow      TO GROUP usuario;

GRANT SELECT, INSERT, UPDATE, DELETE ON grupo           TO GROUP supervisor;
REVOKE ALL                           ON grupo         FROM GROUP gerente;
REVOKE ALL                           ON grupo         FROM GROUP caixa;
REVOKE ALL                           ON grupo         FROM GROUP usuario;

GRANT SELECT                         ON grupo_view      TO GROUP supervisor;
GRANT SELECT                         ON grupo_view      TO GROUP gerente;
GRANT SELECT                         ON grupo_view      TO GROUP caixa;
GRANT SELECT                         ON grupo_view      TO GROUP usuario;

GRANT SELECT, INSERT, UPDATE, DELETE ON grupo_usuario   TO GROUP supervisor;
GRANT SELECT, INSERT, UPDATE, DELETE ON grupo_usuario   TO GROUP gerente;
GRANT SELECT                         ON grupo_usuario   TO GROUP caixa;
GRANT SELECT                         ON grupo_usuario   TO GROUP usuario;

GRANT SELECT, UPDATE    ON usuario_usu_cod_seq          TO GROUP supervisor;
GRANT SELECT, UPDATE    ON usuario_usu_cod_seq          TO GROUP gerente;
REVOKE ALL              ON usuario_usu_cod_seq        FROM GROUP caixa;
REVOKE ALL              ON usuario_usu_cod_seq        FROM GROUP usuario;

GRANT SELECT, UPDATE    ON grupo_grp_cod_seq            TO GROUP supervisor;
GRANT SELECT, UPDATE    ON grupo_grp_cod_seq            TO GROUP gerente;
REVOKE ALL              ON grupo_grp_cod_seq          FROM GROUP caixa;
REVOKE ALL              ON grupo_grp_cod_seq          FROM GROUP usuario;

------------------------------------------------------------------------------
-- Supervisor

-- Obs: A conta de acesso do supervisor (DBA) deve ser criado fora do sistema
--      (via PgAdmin ou comando CREATE USER)

INSERT INTO usuario (usu_login,usu_nome,usu_estado)
  VALUES ('marcio','Marcio Gil Maldonado','A');

INSERT INTO grupo_usuario (gru_usucod,gru_grpnome)
  VALUES (1,'supervisor');

------------------------------------------------------------------------------
-- vim: ai:syn=plsql
