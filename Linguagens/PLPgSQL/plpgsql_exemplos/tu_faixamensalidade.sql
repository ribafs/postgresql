CREATE or REPLACE FUNCTION tu_faixamensalidade() RETURNS trigger AS '
    DECLARE 
        mesref_anomes mesreferencia.mesreferencia_anomes%TYPE;
        ano integer;
        mes integer;
    BEGIN
	SELECT INTO mesref_anomes min(mesreferencia_anomes) FROM mesreferencia WHERE mesreferencia_aberto = ''t'';
	IF NOT FOUND THEN
             RAISE EXCEPTION ''Não foi possível encontrar mês de referencia.'';
        ELSE
            ano := substr(mesref_anomes, 1, 4)::integer;
            mes := substr(mesref_anomes, 5, 2)::integer;

            UPDATE lancamento  
            SET lancamento_valordevido = NEW.faixamensalidade_valorref
            WHERE fk_tipolancamento_id = 1
            AND fk_faixamensalidade_id = NEW.faixamensalidade_id
            AND substr(lancamento_anomes,1,4)::integer >= ano
            AND substr(lancamento_anomes,5,2)::integer >= mes
            AND fk_associado_id IN (SELECT a.associado_id
                                    FROM associado AS a, lancamento AS l
                                    WHERE a.associado_desligado=''f''
                                    AND l.fk_associado_id = a.associado_id
                                    AND l.lancamento_id = lancamento_id);
	END IF;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;

CREATE TRIGGER tu_faixamensalidade BEFORE UPDATE ON faixamensalidade
    FOR EACH ROW EXECUTE PROCEDURE tu_faixamensalidade();
