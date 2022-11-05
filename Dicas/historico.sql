--
--  OBJETIVO:           Cria a infra-estrutura necessárias para geração de
--                      histórico das modificações efetuadas nas tabelas da
--                      base de dados.
--  AUTOR:              MAURO H. C. MATOS
--  DATA DE CRIAÇÃO:    16/09/2002
--  ÚLTIMA ATUALIZAÇÃO: 08/02/2006
--

--
--  PRÉ-REQUISITO:
--  --------------
--  Caso a linguagem plpgsql ainda não tenha sido definida em seu banco de
--  dados, o script plpgsql.sql deve ser rodado antes que se rode este script.
--  O terminal interativo do PostgreSQL (psql) poderá ser utilizado para essa
--  finalidade, lembre-se que o usuário deverá possuir privilégio de
--  "administrador" do banco de dados.
--  A função create_trigger(), assim como todas as demais funções criadas
--  pela mesma, são escrita nessa "linguagem procedural".
--  A infra-estrutura é criada no esquema (espaço de tabela) corrente.
--

--
-- CRIA a FUNÇÃO get_fields
--
CREATE OR REPLACE FUNCTION get_fields (text) RETURNS text[] AS $$
DECLARE
--
--  NOME:               get_fields
--  AUTOR:              MAURO H. C. MATOS
--  DATA DE CRIAÇÃO:    07/10/2005
--  ÚLTIMA ATUALIZAÇÃO: 08/02/2006
--  OBJETIVO:           RECUPERAR OS NOMES DOS CAMPOS DE UMA TABELA.
--  PARÂMETROS:         1=NOME DE TABELA COM OU SEM QUALIFICADOR
--  RETORNA:            ARRAY COM OS NOMES DOS CAMPOS OU NULO.
--  ----------------------------------------------------------------------------
--
    pNomeTab        alias for $1; -- nome da tabela com/sem qualificador
    aSQL            text;         -- instrução SQL
    aNomeEsqTab     text;         -- nome da esquema da tabela
    aNomeTab        text;         -- nome da tabela
    iQtd            integer;      -- usado em operações
    rIdRec          RECORD;       -- identificador de registro
    aVetor          text[];       -- vetor de retorno
BEGIN
    --
    -- VERIFICA OS PARÂMETROS
    --
    IF pNomeTab = '' THEN
        RAISE EXCEPTION '02001:Não pode haver parâmetro vazio.';
    END IF;
    --
    -- VERIFICA A FORMAÇÃO DOS NOME DAS TABELAS E RECUPERA OS CAMPOS
    --
    iQtd := strpos( pNomeTab, '.');
    IF iQtd > 0 THEN
        -- existe o nome do qualificador da tabela
        aNomeEsqTab := substr(pNomeTab, 1, iQtd - 1); -- nome do qualificador
        aNomeTab := substr(pNomeTab, iQtd + 1);       -- nome da tabela
        -- instrução SQL para recuperar os nomes dos campos da tabela
        aSQL := 'SELECT column_name' ||
                 ' FROM information_schema.columns' ||
                ' WHERE table_name = \'' || aNomeTab || '\'' ||
                  ' AND table_schema = \'' || aNomeEsqTab  || '\'' ||
                ' ORDER BY ordinal_position';
    ELSE
        aNomeEsqTab := NULL;
        -- verifica se existe mais de uma tabela com o mesmo nome no banco
        SELECT count(*)
        FROM pg_tables INTO iQtd
        WHERE tablename = pNomeTab;
        IF iQtd <> 1 THEN   -- existe mais de uma tabela com o mesmo nome
            RAISE EXCEPTION
            '02021:Especifique o qualificador da tabela %', pNomeTab;
        END IF;
        -- instrução SQL para recuperar os nomes dos campos da tabela
        aSQL := 'SELECT column_name' ||
                 ' FROM information_schema.columns' ||
                ' WHERE table_name = \'' || pNomeTab || '\'' ||
                ' ORDER BY ordinal_position';
    END IF;
    --
    -- MONTA O ARRAY
    --
    iQtd = 0; -- inicializa contador
    FOR rIdRec IN EXECUTE aSQL LOOP
        iQtd := iQtd + 1;
        aVetor[iQtd] := rIdRec.column_name::text;
    END LOOP;
    IF iQtd > 0 THEN
        RETURN aVetor; -- retorna o vetor
    ELSE
        RETURN NULL;   -- retorna nulo
    END IF;
END;
$$ LANGUAGE plpgsql STABLE STRICT;

COMMENT ON FUNCTION get_fields (text)
    IS 'Retorna os nomes dos campos de uma tabela';

--
-- REMOVE A TABELA history_template
--
DROP TABLE history_template;

--
-- CRIA A TABELA history_template
--
CREATE TABLE history_template (
    _date_          timestamp
                    with time zone, -- data e hora da atualização
    _local_         inet,           -- IP do local da alteração
    _user_          name,           -- identificador do usuário
    _op_            char(1),        -- operação (U=Update ou D=Delete)
    _ctrl_newrec_   text,           -- hash do novo registro na tabela auditada
    _ctrl_oldrec_   text,           -- hash do registro antigo
    _ctrl_audit_    text            -- hash do registro corrente
);
COMMENT ON TABLE history_template
    IS 'Modelo para montar as tabelas de histórico';

--
-- CRIA a FUNÇÃO create_trigger
--
CREATE OR REPLACE FUNCTION create_trigger (text, text) RETURNS void AS $$
DECLARE
--
--  NOME:               create_trigger
--  AUTOR:              MAURO H. C. MATOS
--  DATA DE CRIAÇÃO:    05/02/2004
--  ÚLTIMA ATUALIZAÇÃO: 02/11/2005
--  OBJETIVO:           CRIA A FUNÇÃO E O GATILHO PARA GERAR HISTÓRICO DE UMA
--                      TABELA.
--  PARÂMETROS:         1=NOME DA TABELA QUE SERÁ AUDITADA, OPCIONALMENTE PODE
--                        SER ESPECIFICADO O NOME DO ESQUEMA.
--                      2=NOME DA TABELA QUE SERÁ CRIADA PARA CONTER O
--                        HISTÓRICO, OPCIONALMENTE PODE SER ESPECIFICADO O
--                        NOME DO ESQUEMA.
--
    pTabAudit       alias for $1; -- nome da tabela auditada
    pTabHist        alias for $2; -- nome da tabela de histório a ser criada
    aNomeEsqAudit   text;         -- nome da esquema da tabela auditada
    aNomeEsqHist    text;         -- nome do esquema da tabela a ser criada
    aNomeTabAudit   text;         -- nome da tabela sem qualificador
    aNomeTabHist    text;         -- nome da tabela sem qualificador
    aNomeFunc       text;         -- nome da função
    aNomeGatilho    text;         -- nome do gatilho
    aSQL            text;         -- instrução SQL
    aSQL2           text;         -- complemento de instrução SQL
    iQtd            integer;      -- valor de retorno
    aCampos         text[];       -- array com o nome dos campos da tabela
    aDim            text;         -- dimensões do array com nomes dos campos
    iMax            integer;      -- indice máximo do array
    aCampo          text;         -- nome de um campo
BEGIN
    --
    -- VERIFICA OS PARÂMETROS
    --
    IF pTabAudit = '' OR pTabHist = '' THEN
        RAISE EXCEPTION '02001:Não pode haver parâmetro vazio.';
    END IF;

    --
    -- VERIFICA SE PARÂMETROS SÃO DIFERNTES
    --
    IF pTabAudit = pTabHist THEN
        RAISE EXCEPTION '02002:Deverá ser especificados parâmetros diferentes.';
    END IF;

    --
    -- VERIFICA A FORMAÇÃO DOS NOME DAS TABELAS
    --
    iQtd := strpos( pTabAudit, '.');
    IF iQtd > 0 THEN
        -- existe o identificador de esquema da tabelas
        aNomeEsqAudit := substr(pTabAudit, 1, iQtd - 1);
        aNomeTabAudit := substr(pTabAudit, iQtd + 1);
    ELSE
        aNomeEsqAudit := NULL;
        aNomeTabAudit := pTabAudit;
    END IF;
    iQtd := strpos( pTabHist, '.');
    IF iQtd > 0 THEN
        -- existe o identificador de esquema da tabelas
        aNomeEsqHist := substr(pTabHist, 1, iQtd - 1);
        aNomeTabHist := substr(pTabHist, iQtd + 1);
        -- monta o nome da função
        aNomeFunc := aNomeEsqHist || '.' || aNomeTabAudit || '_audit()';
    ELSE
        aNomeEsqHist := NULL;
        aNomeTabHist := pTabHist;
        -- monta o nome da função
        aNomeFunc := pTabAudit || '_audit()';
    END IF;

    --
    -- VERIFICA A EXISTÊNCIA DA DEFINIÇÃO DA LINGUAGEM
    --
    SELECT count(*) FROM pg_catalog.pg_language  INTO iQtd
    WHERE lanname = 'plpgsql';
    IF iQtd = 0 THEN
         RAISE EXCEPTION '02010:A linguagem plpgsql ainda não foi definida.';
    END IF;

    --
    -- VERIFICA A EXISTÊNCIA DA TABELA history_template
    --
    SELECT count(*) FROM pg_catalog.pg_tables  INTO iQtd
    WHERE tablename = 'history_template';
    IF iQtd = 0 THEN
         RAISE EXCEPTION '02003:A tabela history_template não exite.';
    END IF;

    --
    -- VERIFICA A EXISTÊNCIA DA TABELA A SER AUDITADA
    --
    IF aNomeEsqAudit IS NULL THEN
        SELECT count(*) FROM pg_tables INTO iQtd
        WHERE tablename = aNomeTabAudit;
    ELSE
        SELECT count(*) FROM pg_tables INTO iQtd
        WHERE schemaname = aNomeEsqAudit
        AND tablename = aNomeTabAudit;
    END IF;
    IF iQtd = 0 THEN
        RAISE EXCEPTION '02004:A tabela % não exite.', aNomeTabAudit;
    END IF;

    --
    -- CRIA A NOVA TABELA PARA ARMAZENAR O HISTÓRICO DA TABELA AUDITADA
    --
    IF aNomeEsqHist IS NULL THEN
        SELECT count(*) FROM pg_tables INTO iQtd
        WHERE tablename = aNomeTabHist;
    ELSE
        SELECT count(*) FROM pg_tables INTO iQtd
        WHERE schemaname = aNomeEsqHist
        AND tablename = aNomeTabHist;
    END IF;
    IF iQtd = 0 THEN
        -- a tabela ainda não existe
        aSQL := 'CREATE TABLE ' || pTabHist || ' WITHOUT OIDS AS ' ||
            'SELECT * FROM history_template CROSS JOIN ' || pTabAudit ||';';
        RAISE NOTICE '%', aSQL; -- mostra o comando create
        EXECUTE aSQL;
        IF NOT FOUND THEN
            RAISE EXCEPTION '02005:Não foi possível criar a tabela %.', pTabHist;
        END IF;
        -- comantário para a tabela criada
        aSQL := 'COMMENT ON TABLE ' || pTabHist ||
            ' IS \'Histórico da tablela ' || pTabAudit || '\';';
        RAISE NOTICE '%', aSQL; -- mostra o comando comment
        EXECUTE aSQL;
        -- permissões para os usuários incluirem dados na tabela criada
        aSQL := 'GRANT INSERT ON TABLE ' || pTabHist || ' TO PUBLIC;';
        RAISE NOTICE '%', aSQL; -- mostra o comando grant
        EXECUTE aSQL;
        IF NOT FOUND THEN
            RAISE EXCEPTION
            '02006:Não foi possível conceder privilégios para %.', pTabHist;
        END IF;
    ELSE
        aSQL := '\n\n===> ATENÇÃO: A tabela ' || pTabHist || ' já exite, ' ||
        'irá ocorrer erro\n ao tentar atualizar ou remover dados na tabela ' ||
        pTabAudit || ',\n se tiver havido alteração na estrutura da mesma.\n';
        RAISE NOTICE '%', aSQL;
    END IF;

    --
    -- MONTA A FUNÇÃO CHAMADA PELO GATILHO
    --
    -- início da primeira parte da função
    aSQL :=
    '\nCREATE OR REPLACE FUNCTION ' || aNomeFunc ||
    ' RETURNS trigger AS $BODY$ ' ||
    '\nDECLARE' ||
    '\n    tNow        timestamp with time zone;  -- data e hora' ||
    '\n    iLocal      inet;    -- identificador da máquina cliente' ||
    '\n    aUsr        name;    -- identificador do usuário' ||
    '\n    cOp         char;    -- identificador da operação' ||
    '\n    aCtrlNewRec text;    -- hash do novo registro da tab. auditada' ||
    '\n    aCtrlOldRec text;    -- hash do antigo registro da tab. auditada' ||
    '\n    aCtrlAudit  text;    -- hash para o registro da tab do histórico' ||
    '\n    aData       text[];  -- dado de um campo' ||
    '\n    aDataFields text;    -- dados dos campos' ||
    '\n    iQtd        integer; -- quantidade' ||
    '\nBEGIN' ||
    '\n    tNow := now();' ||
    '\n    iLocal := inet_client_addr();' ||
    '\n    aUsr := current_user;' ||
    '\n    cOp := substr(TG_OP, 1, 1); -- inicial da descrição da operação' ||
    '\n    aDataFields := \'\'; -- limpa a variável' ||
    '\n    iQtd := 0;';
    -- fim da primeira parte da função

    -- início da segunda parte da função
    aCampos := get_fields(pTabAudit); -- nome dos campos
    aDim := array_dims(aCampos);      -- dimensões do array
    iMax := replace(split_part(aDim,':',2),']','')::int;
    -- monta complemento da instrução SQL
    aSQL2 := '';
    FOR iX IN 1 .. iMax LOOP
        aCampo :=  'OLD.' || aCampos[iX];
        aSQL2 := aSQL2 ||
        '\n    IF ' || aCampo || ' IS NOT NULL THEN' ||
        '\n        iQtd := iQtd + 1;' ||
        '\n        aData[iQtd] := ' || aCampo || ';' ||
        '\n    END IF;';
    END LOOP; -- fim do laço FOR
    -- fim da segunda parte da função

    aSQL := aSQL || aSQL2; -- monta a segunda parte na instrução SQL

    -- início da terceira parte da função
    aSQL2 :=
    '\n    -- calcula o hash do registro antigo' ||
    '\n    FOR iX IN 1..iQtd LOOP' ||
    '\n        aDataFields := aDataFields || aData[iX];' ||
    '\n    END LOOP;' ||
    '\n    aCtrlOldRec := md5(aDataFields);' ||
    '\n    IF (cOp = \'U\') THEN         -- UPDATE' ||
    '\n       iQtd := 0;';
    -- fim da terceira parte da função

    aSQL := aSQL || aSQL2; -- monta a terceira parte na instrução SQL

    -- início da quarta parte da função
    aSQL2 := '';
    FOR iX IN 1 .. iMax LOOP
        aCampo :=  'NEW.' || aCampos[iX];
        aSQL2 := aSQL2 ||
        '\n        IF ' || aCampo || ' IS NOT NULL THEN' ||
        '\n            iQtd := iQtd + 1;' ||
        '\n            aData[iQtd] := ' || aCampo || ';' ||
        '\n        END IF;';
    END LOOP; -- fim do laço FOR
    -- fim da terceira parte da função

    aSQL := aSQL || aSQL2; -- monta a quarta parte na instrução SQL

    -- início da quinta parte da função
    aSQL := aSQL ||
    '\n        aDataFields := \'\'; -- limpa a variável' ||
    '\n        FOR iX IN 1..iQtd LOOP' ||
    '\n            aDataFields := aDataFields || aData[iX];' ||
    '\n        END LOOP;' ||
    '\n        aCtrlNewRec := md5(aDataFields);' ||
    '\n        aDataFields := tNow::text || iLocal::text || aUsr || cOp' ||
    '\n                       || aCtrlNewRec || aCtrlOldRec;' ||
    '\n        aCtrlAudit := md5(aDataFields);' ||
    '\n        INSERT INTO ' || pTabHist ||
    '\n            SELECT tNow,' ||
    '\n                   iLocal,' ||
    '\n                   aUsr,' ||
    '\n                   cOp,' ||
    '\n                   aCtrlNewRec,' ||
    '\n                   aCtrlOldRec,' ||
    '\n                   aCtrlAudit,' ||
    '\n                   OLD.*;' ||
    '\n        RETURN NEW;' ||
    '\n    ELSIF (cOp = \'D\') THEN      -- DELETE' ||
    '\n        aCtrlNewRec := \'\';      -- sem conteúdo' ||
    '\n        aDataFields := tNow::text || iLocal::text || aUsr || cOp' ||
    '\n                       || aCtrlNewRec || aCtrlOldRec;' ||
    '\n        aCtrlAudit := md5(aDataFields);' ||
    '\n        INSERT INTO ' || pTabHist ||
    '\n            SELECT tNow,' ||
    '\n                   iLocal,' ||
    '\n                   aUsr,' ||
    '\n                   cOp,' ||
    '\n                   aCtrlNewRec,' ||
    '\n                   aCtrlOldRec,' ||
    '\n                   aCtrlAudit,' ||
    '\n                   OLD.*;' ||
    '\n        RETURN OLD;' ||
    '\n    ELSE' ||
    '\n        RETURN NULL;' ||
    '\n    END IF;' ||
    '\nEND;' ||
    '\n$BODY$ LANGUAGE plpgsql STRICT;';
    -- fim da função

    --
    -- CRIA A FUNÇÃO NA BASE DE DADOS
    --
    RAISE NOTICE '%', aSQL; -- mostra a função criada
    EXECUTE aSQL;
    IF NOT FOUND THEN
        RAISE EXCEPTION '02007:Não foi possível criar a função %.', aNomeFunc;
    END IF;
    -- comantário para a função criada
    aSQL := 'COMMENT ON FUNCTION ' || aNomeFunc ||
        ' IS \'Registra modificações na tablela ' || pTabAudit || '\';';
    RAISE NOTICE '%', aSQL; -- mostra o comando comment
    EXECUTE aSQL;

    --
    -- PERMISSÕES PARA OS USUÁRIOS EXECUTAREM A FUNÇÃO
    --
    aSQL := 'GRANT EXECUTE ON FUNCTION ' || aNomeFunc || ' TO PUBLIC;';
    RAISE NOTICE '%', aSQL; -- mostra o comando grant
    EXECUTE aSQL;
    IF NOT FOUND THEN
        RAISE EXCEPTION '02008:Não foi possível conceder privilégios para %.',
            aNomeFunc;
    END IF;

    --
    -- MONTA O NOME DO GATILHO
    --
    aNomeGatilho := aNomeTabHist || '_audit';

    --
    -- REMOVE O GATILHO SE EXISTIR
    --
    SELECT count(*) FROM pg_trigger INTO iQtd
    WHERE tgname =  aNomeGatilho;
    IF iQtd > 0 THEN
        -- exite trigger definida
        aSQL := 'DROP TRIGGER ' || aNomeGatilho || ' ON ' || pTabAudit ||
            ' CASCADE;';
        RAISE NOTICE '%', aSQL; -- mostra o comando drop
        EXECUTE aSQL;
    END IF;

    --
    -- CRIA O GATILHO QUE DISPARA A FUNÇÃO CRIADA
    --
    aSQL := 'CREATE TRIGGER ' || aNomeGatilho ||
        ' BEFORE UPDATE OR DELETE ON '  || pTabAudit ||
        ' FOR EACH ROW EXECUTE PROCEDURE ' || aNomeFunc;
    RAISE NOTICE '%', aSQL; -- mostra o comando create trigger
    EXECUTE aSQL;
    IF NOT FOUND THEN
        RAISE EXCEPTION '02009:Não foi possível criar o gatilho %.',aNomeGatilho;
    END IF;
    RAISE NOTICE 'create_trigger() - Versão 5 (NOV/2005)'; -- mensagem final
    RETURN;
END;
$$ LANGUAGE plpgsql STRICT;

COMMENT ON FUNCTION create_trigger (text, text)
    IS 'Cria a infra-estrutura necessária para gerar histórico de uma tabela';

