CREATE or REPLACE FUNCTION tu_mensalidade() RETURNS trigger AS '
    DECLARE fxm_valor faixamensalidade.faixamensalidade_valorref%TYPE;
    BEGIN
        IF VerificaAssociadoDesligado(OLD.fk_associado_id) THEN
            RAISE EXCEPTION ''Este associado está desligado. %s'', OLD.fk_associado_id;
        ELSE
            IF VerificaMesReferenciaAberto(OLD.mensalidade_anomes) THEN  
                SELECT INTO fxm_valor faixamensalidade_valorref FROM faixamensalidade WHERE faixamensalidade_id = NEW.fk_faixamensalidade_id;
                IF NOT FOUND THEN
                    RAISE EXCEPTION ''Não foi possível encontrar valor de referência.'';
                END IF;

                UPDATE lancamento 
                SET lancamento_valordevido = fxm_valor,
                    fk_faixamensalidade_id = NEW.fk_faixamensalidade_id
                WHERE fk_associado_id = OLD.fk_associado_id
                AND fk_tipolancamento_id = 1
                AND fk_faixamensalidade_id = OLD.fk_faixamensalidade_id
                AND lancamento_anomes = OLD.mensalidade_anomes;
            ELSE
                RAISE EXCEPTION ''Este mês/ano já está fechado. %'', OLD.mensalidade_anomes;
            END IF;
        END IF;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;

CREATE TRIGGER tu_mensalidade BEFORE UPDATE ON mensalidade
    FOR EACH ROW EXECUTE PROCEDURE tu_mensalidade();
