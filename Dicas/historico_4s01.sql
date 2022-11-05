--
--  OBJETIVO:           Cria a infra-estrutrua necessárias para geração de
--                      histórico das modificações efetuadas nas tabelas da
--                      base de dados.
--  AUTOR:              MAURO H. C. MATOS
--  DATA DE CRIAÇÃO:    16/09/2002
--  ÚLTIMA ATUALIZAÇÃO: 22/04/2005
--

--
--  PRÉ-REQUISITO:
--  --------------
--  Caso a linguagem plpgsql ainda não tenha sido definida em seu banco de
--  dados, o arquivo b1f01plpgsql.sql deve ser rodado no terminal interativo do
--  PostgreSQL (psql), como administrador do banco de dados, para criar a
--  linguagem plpgsql antes que se rode esse script. A função
--  f01criar_trigger(), assim como todas as demais funções criadas pela mesma,
--  são escrita nessa "linguagem procedural".
--

--
-- REMOVE OS ESQUEMA historico
--
DROP SCHEMA historico CASCADE;

--
-- CRIA ESQUEMA historico
--
CREATE SCHEMA historico;
COMMENT ON SCHEMA historico IS 'Esquema contendo a infra-estrutura para geração de histórico das tabelas';

--
-- CRIA VISÃO / VISTA v01campos
--
CREATE OR REPLACE VIEW historico.v01campos AS
SELECT  pg_namespace.nspname AS v01esquema,  -- nome do esquema
        pg_class.relname     AS v01tabela,   -- nome da tabela
        pg_attribute.attname AS v01campo,    -- nome do campo
        pg_type.typname      AS v01tipo,     -- tipo do campo
    CASE
    WHEN (pg_attribute.atttypmod > 0)
    AND (pg_attribute.attlen = -1) THEN
        -- TIPO DE DADO DE TAMANHO VARIADO --
        CASE
        WHEN pg_attribute.attstorage <> 'm' then -- NÚMERIC
            pg_attribute.atttypmod - 4
        ELSE
            substr(format_type(atttypid, atttypmod),9,
                strpos(format_type(atttypid, atttypmod),',')-9)::"int4"
        END
    WHEN (pg_attribute.attlen > 0) THEN
        pg_attribute.attlen
    END                      AS v01tamanho,  -- tamanho do campo
    CASE
    WHEN pg_attribute.attstorage = 'm' then
        substr(format_type(atttypid, atttypmod),
            strpos(format_type(atttypid,atttypmod),',')+1,
            char_length(format_type(atttypid, atttypmod))-
            strpos(format_type(atttypid,atttypmod),',')-1)::"int2"
    END                      AS v01decimais, -- casas decimais
    CASE
    WHEN pg_attribute.attnotnull THEN
        true    -- 'NOT NULL'
    ELSE
        false   -- PODE CONTER 'NULL'
    END                      AS v01notnull   -- propriedade do campo (not null)
FROM     pg_namespace, pg_class, pg_attribute, pg_type
WHERE    pg_namespace.oid = pg_class.relnamespace
AND      pg_class.relfilenode = pg_attribute.attrelid
AND      pg_attribute.atttypid = pg_type.oid
AND      pg_attribute.attnum > 0
AND      pg_class.relkind = 'r'
AND      pg_namespace.nspname <> 'information_schema'
AND      pg_namespace.nspname <> 'pg_catalog'
AND      pg_class.relname !~ 'pga_'
ORDER BY 1, 2;
COMMENT ON VIEW historico.v01campos IS 'Vista contendo os atributos dos campos das tabelas';

--
-- CRIA VISÃO / VISTA v02campos_idx
--
CREATE OR REPLACE VIEW historico.v02campos_idx AS
SELECT  x.esquema AS v02esquema,  -- nome do esquema
        x.tabela  AS v02tabela,   -- nome da tabela
        x.campo   AS v02campo ,   -- nome do campo
        y.relname AS v02idx,      -- campo é índice
        x.pk      AS v02pk,       -- campo é índice chave primária
        x.unica   AS v02unica     -- campo é índice de ocorrência única
FROM    (SELECT a.nspname      AS esquema,
                b.relname      AS tabela,
                d.attname      AS campo,
                c.indisprimary AS pk,
                c.indisunique  AS unica,
                c.indexrelid   AS oid_id
        FROM    pg_namespace a, pg_class b, pg_index c, pg_attribute d
        WHERE   a.oid = b.relnamespace
        AND     b.relfilenode = c.indrelid
        AND     c.indexrelid = d.attrelid
        AND     b.relname !~ 'pg'
        ) x, pg_class y
WHERE   x.oid_id = y.oid
ORDER BY 1,2;
COMMENT ON VIEW historico.v02campos_idx IS 'Vista contendo os atributos dos índices dos campos das tabelas';

--
-- REMOVE SEQÜÊNCIA s01chave_t01
--
--DROP SEQUENCE historico.s01chave_t01;

--
-- CRIA SEQÜÊNCIA s01chave_t01
--
CREATE SEQUENCE historico.s01chave_t01 CYCLE;
-- MAXVALUE(9223372036854775807/2147483647)

--
-- REMOVE TABELA t01historico_tabelas
--
--DROP TABLE historico.t01historico_tabelas cascade;

--
-- CRIA TABELA t01historico_tabelas
--
CREATE TABLE historico.t01historico_tabelas (
    t01id              INT4 CONSTRAINT t01historico_tabelas_pk PRIMARY KEY
                       DEFAULT (nextval('s01chave_t01')),  -- identificador
    t01dt_atualizacao  TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                       -- data de atualização do registro, data corrente
    t01usuario         TEXT NOT NULL DEFAULT CURRENT_USER, -- usuário
    t01esquema         TEXT NOT NULL,  -- nome do esquema
    t01tabela          TEXT NOT NULL,  -- nome da tabela
    t01chave           TEXT NOT NULL,  -- chave de acesso
    t01operacao        CHAR NOT NULL   -- operação (U=update/D=delete)
)
WITHOUT OIDS;
COMMENT ON TABLE historico.t01historico_tabelas IS 'Informações referentes as modificações nas tabelas';

--
-- CRIA ÍNDICE h1i01historico
--
CREATE INDEX t01historico_tabelas_tabela_idx ON historico.t01historico_tabelas(t01tabela);

--
-- REMOVE TABELA t02historico_campos
--
--DROP TABLE t02historico_campos cascade;

--
-- CRIA TABELA t02historico_campos
--
CREATE TABLE historico.t02historico_campos (
    t02id              INT4 CONSTRAINT t02id_fk
                       REFERENCES historico.t01historico_tabelas(t01id)
                       ON DELETE CASCADE
                       ON UPDATE CASCADE, -- chave estrangeira da t01historico_tabelas
    t02campo           TEXT NOT NULL,     -- nome do campo
    t02info            TEXT,              -- informação que existia no campo
    CONSTRAINT t02historico_campos_pk PRIMARY KEY (t02id, t02campo)
)
WITHOUT OIDS;
COMMENT ON TABLE historico.t02historico_campos IS 'Informações referentes ao conteúdo anteriormente armazenados nos campos';

--
-- CRIAR FUNÇÃO f01criar_trigger
--
CREATE OR REPLACE FUNCTION historico.f01criar_trigger (text, text, text, text) RETURNS void
AS '
DECLARE
--
--  NOME:               f01criar_trigger
--  AUTOR:              MAURO H. C. MATOS
--  DATA DE CRIAÇÃO:    05/02/2004
--  ÚLTIMA ATUALIZAÇÃO: 22/04/2005
--  OBJETIVO:           CRIA A FUNÇÃO E O GATILHO PARA GERAR HISTÓRICO DE UMA
--                      TABELA
--  PARÂMETROS:         1=NOME DO ESQUEMA ONDE SE LOCALIZA A TABELA
--                      2=NOME DA TABELA QUE SERÁ GERADO O HISTÓRICO
--                      3=NOME DO GATILHO / TRIGGER QUE SERÁ CRIADO
--                      4=NOME DA FUNÇÃO QUE SERÁ CRIADA
--  ----------------------------------------------------------------------------
--
    vp_esquema      ALIAS FOR $1;       -- NOME DO ESQUEMA
    vp_tabela       ALIAS FOR $2;       -- NOME DA TABELA
    vp_trigger      ALIAS FOR $3;       -- NOME DA TRIGGER
    vp_funcao       ALIAS FOR $4;       -- NOME DA FUNÇÃO
    vl_int          integer;            -- ARMAZENAMENTO TEMPORÁRIO
    vl_fun_trig     text;               -- SEQÜÊNCIA QUE DESCREVE A FUNÇÃO
    vl_str_comp     text;               -- SEQÜÊNCIA COMPLEMENTAR DA FUNÇÃO
    vl_chave_new    text;               -- SEQÜÊNCIA QUE É A CHAVE DE ACESSO
    vl_chave_old    text;               -- SEQÜÊNCIA QUE É A CHAVE DE ACESSO
    vl_reg          RECORD;             -- IDENTIFICADOR DE REGISTRO
    vl_sql          text;               -- INSTRUÇÃO SQL
    vl_sql2         text;               -- INSTRUÇÃO SQL SECUNDÁRIA
    vl_esq_hist     text;               -- NOME DO ESQUEMA DA tab_historico
    vl_cref         refcursor;          -- CURSOR
BEGIN
    --
    -- VERIFICA OS PARÂMETROS
    --
    IF vp_esquema IS NULL OR vp_tabela IS NULL
    OR vp_trigger IS NULL OR vp_funcao IS NULL  THEN
        RAISE EXCEPTION ''02001:Não pode haver parâmetro nulo.'';
    ELSIF vp_esquema = '''' OR vp_tabela = ''''
    OR vp_trigger = '''' OR vp_funcao = '''' THEN
        RAISE EXCEPTION ''02002:Não pode haver parâmetro vazio.'';
    END IF;
    --
    -- VERIFICA O ESQUEMA DA TABELA DO HISTÓRICO
    --
    SELECT n.nspname INTO vl_esq_hist
    FROM   pg_catalog.pg_namespace n, pg_catalog.pg_class c
    WHERE  n.oid = c.relnamespace
    AND    c.relname = ''t01historico_tabelas'';
    IF NOT FOUND THEN
        RAISE EXCEPTION ''02003:Falha ao tentar obter o nome do esquema.'';
    END IF;
    --
    -- VERIFICA A EXISTÊNCIA DA TABELA
    --
    SELECT COUNT(*) INTO vl_int
    FROM pg_tables
    WHERE schemaname = vp_esquema
    AND tablename = vp_tabela;
    IF vl_int = 0 THEN
        RAISE EXCEPTION ''02004:A tabela %.% não existe.'', vp_esquema,vp_tabela;
    END IF;
    --
    -- INICIA INSTRUÇÃO SQL PARA CONSULTAR OS NOMES DOS CAMPOS DA TABELA
    --
    vl_sql := ''SELECT v02campo '' ||
              ''FROM   '' || vl_esq_hist || ''.v02campos_idx '' ||
              ''WHERE  v02esquema = \'\''' || vp_esquema || ''\'\' '' ||
              ''AND    v02tabela = \'\''' || vp_tabela || ''\'\''';
    --
    -- VERIFICA A EXISTÊNCIA DE CHAVE NA TABELA
    --
    vl_sql2 := ''SELECT COUNT(*) '' ||
               ''FROM   '' || vl_esq_hist || ''.v02campos_idx '' ||
               ''WHERE  v02esquema = \'\''' || vp_esquema || ''\'\' '' ||
               ''AND    v02tabela = \'\''' || vp_tabela  || ''\'\' '' ||
               ''AND    v02pk'';
    OPEN vl_cref FOR EXECUTE vl_sql2;
    FETCH vl_cref INTO vl_int;
    CLOSE vl_cref;
    IF vl_int = 0 THEN
        --
        -- VERIFICA A EXISTÊNCIA DE ÍNDICE ÚNICO NA TABELA
        --
        vl_sql2 := ''SELECT COUNT(*) '' ||
                   ''FROM   '' || vl_esq_hist || ''.v02campos_idx '' ||
                   ''WHERE  v02esquema = \'\''' || vp_esquema || ''\'\' '' ||
                   ''AND    v02tabela = \'\''' || vp_tabela  || ''\'\' '' ||
                   ''AND    v02unica'';
        OPEN vl_cref FOR EXECUTE vl_sql2;
        FETCH vl_cref INTO vl_int;
        CLOSE vl_cref;
        IF vl_int = 0 THEN
            RAISE EXCEPTION ''02005:A tabela %.% não tem chave definida.'', vp_esquema, vp_tabela;
        END IF;
        vl_sql := vl_sql || '' AND v02unica'';  -- CAMPOS CHAVE ÚNICA
    ELSE
        vl_sql := vl_sql || '' AND v02pk'';     -- CAMPO CHAVE PRIMÁRIA
    END IF;
    --
    -- SELECIONA OS CAMPOS DA CHAVE OU ÍNDICE ÚNICO NA TABELA DE ÍNDICES
    -- E MONTA A CHAVE DE ACESSO
    --
    FOR vl_reg IN EXECUTE vl_sql LOOP
        -- VERIFICA SE JÁ EXISTE ALGUM CONTEÚDO NA CHAVE
        IF vl_chave_new IS NOT NULL THEN
           vl_chave_new := vl_chave_new ||
           '' || chr(39) || \'\'\'\' AND \'\'\'\' || '';
           vl_chave_old := vl_chave_old ||
           '' || chr(39) || \'\'\'\' AND \'\'\'\' || '';
        ELSE
           vl_chave_new := '''';
           vl_chave_old := '''';
        END IF;
        -- MONTA A CHAVE DE ACESSO AO REGISTRO
        vl_chave_new := vl_chave_new ||
                        ''\'\'\'\''' || vl_reg.v02campo ||
                        ''=\'\'\'\' || chr(39) || NEW.'' || vl_reg.v02campo;
        vl_chave_old := vl_chave_old ||
                        ''\'\'\'\''' || vl_reg.v02campo ||
                        ''=\'\'\'\' || chr(39) || OLD.'' || vl_reg.v02campo;
    END LOOP;
    -- FINALIZA MONTAGEM DA CHAVE DE ACESSO AO REGISTRO
    vl_chave_new := vl_chave_new || '' || chr(39) ;'';
    vl_chave_old := vl_chave_old || '' || chr(39) ;'';
    --
    -- MONTA A FUNÇÃO CHAMADA PELO GATILHO
    --
    vl_fun_trig :=
    ''CREATE OR REPLACE FUNCTION '' || vp_funcao || ''() '' ||''RETURNS trigger AS '' || chr(39) ||
    ''\nDECLARE'' ||
    ''\n\tvl_chave    text;     -- CHAVE DE ACESSO AO REGISTRO'' ||
    ''\n\tvl_ok       integer;  -- ROW_COUNT DA ÚLTIMA INSTRUÇÃO SQL''||
    ''\n\tvl_op       char;     -- OPERAÇÃO'' ||
    ''\n\tvl_reg      RECORD;   -- IDENTIFICADOR DA t01historico_tabelas'' ||
    ''\n\tvl_id       integer;  -- IDENTIFICADOR DE REGISTRO'' ||
    ''\n\tvl_new      text;     -- NOVO VALOR'' ||
    ''\n\tvl_old      text;     -- VALOR ANTERIOR'' ||
    ''\nBEGIN'' ||
    ''\n\tvl_op := substr(TG_OP,1,1); -- OPERAÇÃO.'' ||
    ''\n\tIF vl_op = \'\'\'\'D\'\'\'\' THEN'' ||
    ''\n\t\tvl_chave = '' || vl_chave_old ||
    ''\n\tELSE'' ||
    ''\n\t\tvl_chave = '' || vl_chave_new ||
    ''\n\tEND IF;'' ||
    ''\n\t--'' ||
    ''\n\t-- SELECIONA O NOVO VALOR DA SEQÜÊNCIA'' ||
    ''\n\t--'' ||
    ''\n\tSELECT INTO vl_reg'' || '' nextval(\'\'\'\''' || vl_esq_hist || ''.s01chave_t01\'\'\'\')'' || '' AS seq;'' ||
    ''\n\tIF NOT FOUND THEN'' ||
    ''\n\t\tRAISE EXCEPTION \'\'\'\'02100:Falha ao tentar executar a função ''|| ''nextval(\\\\\'\'\\\\\'\''' || vl_esq_hist || ''.s01chave_t01\\\\\'\'\\\\\'\').\'\'\'\';'' ||
    ''\n\tEND IF;'' ||
    ''\n\tvl_id := vl_reg.seq;'' ||
    ''\n\t--'' ||
    ''\n\t-- INSERE NA TABELA t01historico_tabelas'' ||
    ''\n\t--'' ||
    ''\n\tINSERT INTO '' || vl_esq_hist || ''.t01historico_tabelas '' || ''(t01id, t01esquema, t01tabela, t01chave, t01operacao)'' ||
    ''\n\tVALUES (vl_id, \'\'\'\''' || vp_esquema || ''\'\'\'\', '' || ''TG_RELNAME, vl_chave, vl_op);'' ||
    ''\n\tGET DIAGNOSTICS vl_ok := ROW_COUNT;'' ||
    ''\n\tIF vl_ok <> 1 THEN'' ||
    ''\n\t\tRAISE EXCEPTION \'\'\'\'02101:Falha ao tentar inserir na tabela '' || vl_esq_hist || ''.t01historico_tabelas.\'\'\'\';'' ||
    ''\n\tEND IF;'' ||
    ''\n\tIF vl_op <> \'\'\'\'I\'\'\'\' THEN'' ||
    ''\n\t\t--'' ||
    ''\n\t\t-- VERIFICA OS CAMPOS, SEUS VALORES ANTERIORES E O NOVOS'' ||
    ''\n\t\t--'' ||
    ''\n\t\tFOR vl_reg IN SELECT v01campo'' ||
    ''\n\t\t              FROM '' || vl_esq_hist || ''.v01campos'' ||
    ''\n\t\t              WHERE  v01esquema = \'\'\'\''' || vp_esquema || ''\'\'\'\''' ||
    ''\n\t\t              AND    v01tabela = \'\'\'\''' ||  vp_tabela || ''\'\'\'\' LOOP'';
    --
    -- RECUPERA O NOME DE CADA CAMPO DA TABELA
    -- 
    vl_sql := ''SELECT v01campo '' ||
              ''FROM   '' || vl_esq_hist || ''.v01campos '' ||
              ''WHERE  v01esquema = \'\''' || vp_esquema || ''\'\' '' ||
              ''AND    v01tabela = \'\''' || vp_tabela || ''\'\''';
    FOR vl_reg IN EXECUTE vl_sql LOOP
        IF vl_str_comp IS NOT NULL THEN
            vl_str_comp := vl_str_comp || ''\n\t\t\tELS'';
        ELSE
            vl_str_comp := ''\n\t\t\t''; -- INÍCIO DA SEQÜÊNCIA
        END IF;
        vl_str_comp := vl_str_comp ||
        ''IF vl_reg.v01campo = \'\'\'\''' || vl_reg.v01campo || ''\'\'\'\''' || '' THEN'' ||
        ''\n\t\t\t\tIF vl_op = \'\'\'\'U\'\'\'\' THEN'' ||
        ''\n\t\t\t\t\tvl_new := NEW.'' || vl_reg.v01campo || '';'' ||
        ''\n\t\t\t\tEND IF;'' ||
        ''\n\t\t\t\tvl_old := OLD.'' || vl_reg.v01campo || '';'';
    END LOOP;
    --
    -- FINALIZA A MONTAGEM DA FUNÇÃO CHAMADA PELO GATILHO
    --
    vl_fun_trig := vl_fun_trig || vl_str_comp ||
    ''\n\t\t\tEND IF;'' ||
    ''\n\t\t\t--'' ||
    ''\n\t\t\t-- INSERE NA TABELA t02historico_campos'' ||
    ''\n\t\t\t--'' ||
    ''\n\t\t\tIF vl_op = \'\'\'\'U\'\'\'\' THEN'' ||
    ''\n\t\t\t\t-- OPERAÇÃO DE ATUALIZAÇÃO DE REGISTRO.'' ||
    ''\n\t\t\t\tIF vl_new <> vl_old'' ||
    ''\n\t\t\t\tOR (vl_new IS NULL AND vl_old IS NOT NULL)'' ||
    ''\n\t\t\t\tOR (vl_old IS NULL AND vl_new IS NOT NULL) THEN'' ||
    ''\n\t\t\t\t\tINSERT INTO '' || vl_esq_hist || ''.t02historico_campos '' || ''(t02id, t02campo, t02info)'' ||
    ''\n\t\t\t\t\tVALUES (vl_id, vl_reg.v01campo, vl_old);'' ||
    ''\n\t\t\t\tEND IF;'' ||
    ''\n\t\t\tELSIF vl_op = \'\'\'\'D\'\'\'\' THEN'' ||
    ''\n\t\t\t\tINSERT INTO '' || vl_esq_hist || ''.t02historico_campos '' || ''(t02id, t02campo, t02info)'' ||
    ''\n\t\t\t\tVALUES (vl_id, vl_reg.v01campo, vl_old);'' ||
    ''\n\t\t\tEND IF;'' ||
    ''\n\t\t\tGET DIAGNOSTICS vl_ok := ROW_COUNT;'' ||
    ''\n\t\t\tIF vl_ok <> 1 THEN'' ||
    ''\n\t\t\t\tRAISE EXCEPTION \'\'\'\'02102:Falha ao tentar inserir na tabela '' || vl_esq_hist || ''.t02historico_campos.\'\'\'\';'' ||
    ''\n\t\t\tEND IF;'' ||
    ''\n\t\tEND LOOP;'' ||
    ''\n\tEND IF;'' ||
    ''\n\tIF vl_op = \'\'\'\'D\'\'\'\' THEN'' ||
    ''\n\t\tRETURN OLD;'' ||
    ''\n\tELSE'' ||
    ''\n\t\tRETURN NEW;'' ||
    ''\n\tEND IF;'' ||
    ''\nEND;'' || chr(39) ||
    ''\nLANGUAGE ''''plpgsql'''';\n'';
    --
    -- CRIA A FUNÇÃO NO BANCO DE DADOS
    --
    EXECUTE vl_fun_trig;
    IF NOT FOUND THEN
        RAISE EXCEPTION ''02006:Não foi possível criar a função %()'', vp_funcao;
    END IF;
    --
    -- MOSTRA A FUNÇÃO CONSTRUÍDA NA TELA
    --
    RAISE NOTICE ''\n%'', vl_fun_trig;
    RAISE NOTICE ''\nCriada a função %().'', vp_funcao;
    --
    -- MONTA O GATILHO OU "TRIGGER"
    --
    vl_fun_trig :=
    ''CREATE TRIGGER '' || vp_trigger ||
    '' BEFORE UPDATE OR DELETE ON '' || vp_esquema || ''.'' || vp_tabela ||
    '' FOR EACH ROW EXECUTE PROCEDURE '' || vp_funcao || ''()'';
    --
    -- CRIA O GATILHO NO BANCO DE DADOS
    --
    EXECUTE vl_fun_trig;
    IF NOT FOUND THEN
        RAISE EXCEPTION ''02008:Não foi possível criar o gatilho %.'', vp_trigger;
    ELSE
        RAISE NOTICE ''\n%'', vl_fun_trig;
        RAISE NOTICE ''\nCriado o gatilho %'', vp_trigger;
        RAISE NOTICE ''\nf01criar_trigger() - Versão 4 (abr/2005)\nOk.'';
    END IF;
    RETURN;
END;
'
LANGUAGE 'plpgsql';

COMMENT ON FUNCTION historico.f01criar_trigger (text, text, text, text) IS
'Cria a função e o gatilho para gerar histórico de uma tabela';

