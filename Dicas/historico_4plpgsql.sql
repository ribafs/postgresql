/*
    OBJETIVO:    INSTALAR A LINGUAGEM PL/pgSQL NO BANCO DE DADOS.
    AUTOR:       MAURO H. C. MATOS
    CRIAÇÃO:     13/09/2002
    ATUALIZAÇÃO: 21/04/2005
*/

-- REGISTRA A FUNÇÃO TRATADORA DE CHAMADAS
CREATE OR REPLACE FUNCTION plpgsql_call_handler() RETURNS language_handler
    AS '$libdir/plpgsql'
    LANGUAGE C;
COMMENT ON FUNCTION plpgsql_call_handler() IS 'Registra o tratador de chamadas associado linguagem plpgsql';

-- CRIA A LINGUAGEM PL/pgSQL
CREATE TRUSTED PROCEDURAL LANGUAGE plpgsql
    HANDLER plpgsql_call_handler;
