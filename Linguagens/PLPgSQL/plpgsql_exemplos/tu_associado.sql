CREATE or REPLACE FUNCTION tu_associado() RETURNS trigger AS '
    DECLARE fxm_valor faixamensalidade.faixamensalidade_valorref%TYPE;
        anomes mesreferencia.mesreferencia_anomes%TYPE;
    BEGIN
        IF VerificaAssociadoDesligado(OLD.associado_id) and (NEW.fk_faixamensalidade_id <> OLD.fk_faixamensalidade_id) THEN
            RAISE EXCEPTION ''Este associado está desligado. %s'', OLD.associado_id;
        ELSE
            IF NEW.fk_faixamensalidade_id <> OLD.fk_faixamensalidade_id THEN
	        anomes := MesReferenciaAberto();
                IF anomes IS NOT NULL THEN  
                    SELECT INTO fxm_valor faixamensalidade_valorref FROM faixamensalidade WHERE faixamensalidade_id = NEW.fk_faixamensalidade_id;
                    IF NOT FOUND THEN
                        RAISE EXCEPTION ''Não foi possível encontrar valor de referência. %'', anomes;
                    END IF;
  
                    UPDATE lancamento 
                    SET lancamento_valordevido = fxm_valor,
                    fk_faixamensalidade_id = NEW.fk_faixamensalidade_id
                    WHERE fk_associado_id = OLD.fk_associado_id
	            AND fk_tipolancamento_id = 1
        	    AND fk_faixamensalidade_id = OLD.fk_faixamensalidade_id
                    AND lancamento_anomes = anomes;
                ELSE
                    RAISE EXCEPTION ''Este mês/ano já está fechado. %'', anomes;
                END IF;
            END IF;
	END IF;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;

CREATE TRIGGER tu_associado BEFORE UPDATE ON associado
    FOR EACH ROW EXECUTE PROCEDURE tu_associado();
