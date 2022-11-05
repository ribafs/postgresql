--Alterado em 15/06/2005. Ramiro.
CREATE or REPLACE FUNCTION anomesInc(char(6),integer) RETURNS char(6) AS '
DECLARE
    anomes ALIAS for $1;
    n ALIAS for $2;
    ano integer;
    mes integer;
BEGIN
    ano := substr(anomes, 1, 4)::integer;
    mes := substr(anomes, 5, 2)::integer;
    FOR i in 1..n LOOP
        mes := mes + 1;
        IF mes = 13 THEN
            mes := 1;
            ano := ano + 1;
        END IF;
    END LOOP; 
    RETURN ano::text || lpad(mes::text,2,''0'');
END;
' LANGUAGE plpgsql;

CREATE or REPLACE FUNCTION anomesDec(char(6),integer) RETURNS char(6) AS '
DECLARE
    anomes ALIAS for $1;
    n ALIAS for $2;
    ano integer;
    mes integer;
BEGIN
    ano := substr(anomes, 1, 4)::integer;
    mes := substr(anomes, 5, 2)::integer;
    FOR i in 1..n LOOP
        mes := mes - 1;
        IF mes = 0 THEN
            mes := 12;
            ano := ano - 1;
        END IF;
    END LOOP; 
    RETURN ano::text || lpad(mes::text,2,''0'');
END;
' LANGUAGE plpgsql;

CREATE or REPLACE FUNCTION anomesPrev(char(6)) RETURNS char(6) AS '
DECLARE
    anomes ALIAS for $1;
    ano integer;
    mes integer;
    resultado char(6);
BEGIN
    SELECT INTO resultado anomesDec(anomes,1);
    RETURN resultado;
END;
' LANGUAGE plpgsql;

CREATE or REPLACE FUNCTION anomesNext(char(6)) RETURNS char(6) AS '
DECLARE
    anomes ALIAS for $1;
    ano integer;
    mes integer;
    resultado char(6);
BEGIN
    SELECT INTO resultado anomesInc(anomes,1);
    RETURN resultado;
END;
' LANGUAGE plpgsql;

CREATE or REPLACE FUNCTION LancamentoMensalidade() RETURNS boolean AS '
BEGIN
    INSERT INTO mensalidade (mensalidade_anomes,
                             fk_associado_id,
                             fk_faixamensalidade_id) SELECT m.mesreferencia_anomes,
                                                            a.associado_id,
                                                            a.fk_faixamensalidade_id 
                                                     FROM associado as a, mesreferencia as m
                                                     WHERE a.associado_desligado = ''f''
                                                     AND m.mesreferencia_aberto = ''t''
                                                     AND a.fk_faixamensalidade_id IS NOT NULL;
    RETURN FOUND;
END;
' LANGUAGE plpgsql;

CREATE or REPLACE FUNCTION VerificaAssociadoDesligado(integer) RETURNS boolean AS '
DECLARE
    resultado boolean;
BEGIN
    SELECT INTO resultado associado_desligado
    FROM associado
    WHERE associado_id = $1;
    RETURN resultado;
END;
' LANGUAGE plpgsql;

CREATE or REPLACE FUNCTION VerificaMesReferenciaAberto(char(6)) RETURNS boolean AS '
DECLARE
    anomes ALIAS FOR $1;
    resultado boolean;
BEGIN
    SELECT INTO resultado mesreferencia_aberto
    FROM mesreferencia
    WHERE mesreferencia_anomes = anomes;
    IF NOT FOUND THEN
        INSERT INTO mesreferencia (mesreferencia_anomes, mesreferencia_aberto, mesreferencia_nome)
        VALUES (anomes,''t'',MesExtenso(int4(substr(anomes,5,2)))||''/''||substr(anomes,1,4));
        resultado = true;
    END IF;
    RETURN resultado;
END;
' LANGUAGE plpgsql;

CREATE or REPLACE FUNCTION MesReferenciaAberto() RETURNS mesreferencia.mesreferencia_anomes%TYPE AS '
DECLARE
    resultado mesreferencia.mesreferencia_anomes%TYPE;
BEGIN
    SELECT INTO resultado mesreferencia_anomes
    FROM mesreferencia
    WHERE mesreferencia_anomes = (SELECT min(mesreferencia_anomes)
				                FROM mesreferencia
						       WHERE mesreferencia_aberto = ''t'');
    RETURN resultado;
END;
' LANGUAGE plpgsql;

CREATE or REPLACE FUNCTION AtualizaConsignvelAssociado(char(6),numeric, integer) RETURNS boolean AS '
DECLARE
    anomes ALIAS FOR $1;
    ValorDesconto ALIAS FOR $2;
    associado_id ALIAS FOR $3;
    resultado boolean;
BEGIN
    UPDATE consignavel 
    SET consignavel_valorutilizado = consignavel_valorutilizado-ValorDesconto
    WHERE consignavel_anomes = anomes
    AND fk_associado_id = associado_id;

    RETURN FOUND;
END;
' LANGUAGE plpgsql;

CREATE or REPLACE FUNCTION FechamentoMensal(char(6)) RETURNS boolean AS '
DECLARE
    anomes ALIAS FOR $1;
    novo_anomes mesreferencia.mesreferencia_anomes%TYPE;
BEGIN
    UPDATE mesreferencia 
    SET mesreferencia_aberto = ''f''
    WHERE mesreferencia_anomes = anomes
    AND mesreferencia_aberto = ''t'';
    
    IF NOT FOUND THEN
        RAISE EXCEPTION ''Não foi possível encontrar mês/ano aberto. %'', anomes;
    END IF;
    
    novo_anomes := anomesNext(anomes);
    
    INSERT INTO mesreferencia (mesreferencia_anomes, mesreferencia_aberto, mesreferencia_nome)
    VALUES (novo_anomes,''t'',MesExtenso(int4(substr(novo_anomes,5,2)))||''/''||substr(novo_anomes,1,4));
    
    INSERT INTO mensalidade (mensalidade_anomes, fk_associado_id, fk_faixamensalidade_id)
        SELECT novo_anomes, ass.associado_id, ass.fk_faixamensalidade_id 
        FROM associado AS ass
        WHERE ass.associado_desligado = ''f'';
    RETURN FOUND;
END;
' LANGUAGE plpgsql;

CREATE or REPLACE FUNCTION MesExtenso(integer) RETURNS char(10) AS '
DECLARE
    mes ALIAS FOR $1;
    retorno char(10);
BEGIN
    IF mes = 1 THEN 
        retorno := ''JANEIRO'';
    ELSIF mes = 2 THEN 
        retorno := ''FEVEREIRO'';
    ELSIF mes = 3 THEN 
        retorno := ''MARÇO'';
    ELSIF mes = 4 THEN 
        retorno := ''ABRIL'';
    ELSIF mes = 5 THEN 
        retorno := ''MAIO'';
    ELSIF mes = 6 THEN 
        retorno := ''JUNHO'';
    ELSIF mes = 7 THEN 
        retorno := ''JULHO'';
    ELSIF mes = 8 THEN 
        retorno := ''AGOSTO'';
    ELSIF mes = 9 THEN 
        retorno := ''SETEMBRO'';
    ELSIF mes = 10 THEN 
        retorno := ''OUTUBRO'';
    ELSIF mes = 11 THEN 
        retorno := ''NOVEMBRO'';
    ELSIF mes = 12 THEN 
        retorno := ''DEZEMBRO'';
    ELSE
        RAISE EXCEPTION ''Mês inválido. %'', mes;
    END IF;
    RETURN retorno;
END;
' LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION VerificaLancamentosAnterioresMes(integer, integer, integer, char(6), integer) RETURNS boolean AS '
DECLARE 
   associado_id ALIAS FOR $1;
   requisicao_id ALIAS FOR $2;
   emprestimo_id ALIAS FOR $3;
   anomes ALIAS FOR $4;
   tipolancamento_id ALIAS FOR $5;
BEGIN
    -- TODO:VERIFICAR PARAMETROS NULOS.
    SELECT INTO resultado m.mesreferencia_anomes
    FROM mesreferencia m, lancamento l
    WHERE m.mesreferencia_aberto = ''f''
    AND int4(m.mesreferencia_anomes) <= int4(anomes)
    AND l.lancamento_anomes = m.mesreferencia
    AND l.fk_associado_id = associado_id
    AND ((l.fk_requisicao_id = requisicao_id)or(requisicao_id IS NULL))
    AND ((l.fk_emprestimo_id = emprestimo_id)or(emprestimo_id IS NULL))
    AND l.fk_tipolancamento_id = tipolancamento_id;
    RETURN resultado='';
END; 
' LANGUAGE plpgsql;