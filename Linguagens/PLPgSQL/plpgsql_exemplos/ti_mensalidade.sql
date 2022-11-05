CREATE or REPLACE FUNCTION ti_mensalidade() RETURNS trigger AS '
    DECLARE fxm_valor faixamensalidade.faixamensalidade_valorref%TYPE;
    BEGIN
        IF NEW.mensalidade_anomes IS NULL THEN
            RAISE EXCEPTION ''Mês e ano precisam ser preenchidos.'';
        END IF;
        IF NEW.fk_faixamensalidade_id IS NULL THEN
             RAISE EXCEPTION ''É necessário escolher uma faixa de mensalidade'';
        END IF;
        IF NEW.fk_associado_id IS NULL THEN
             RAISE EXCEPTION ''É necessário escolher um associado'';
        END IF;
        IF VerificaAssociadoDesligado(NEW.fk_associado_id) THEN
            RAISE EXCEPTION ''Este associado está desligado. %s'', NEW.fk_associado_id;
        ELSE
            IF VerificaMesReferenciaAberto(NEW.mensalidade_anomes) THEN
                SELECT INTO fxm_valor faixamensalidade_valorref 
                FROM faixamensalidade 
                WHERE faixamensalidade_id = NEW.fk_faixamensalidade_id;
                IF NOT FOUND THEN
                    RAISE EXCEPTION ''Não foi possível encontrar valor de referencia.'';
                END IF;

                INSERT INTO lancamento( lancamento_anomes,
	                                lancamento_nome,
	                                lancamento_valordevido,
	                                fk_associado_id,
	                                fk_tipolancamento_id,
	                                fk_faixamensalidade_id) 
                VALUES (NEW.mensalidade_anomes,
                        ''MENSALIDADE'',
                        fxm_valor,
                        NEW.fk_associado_id,
                        1,
                        NEW.fk_faixamensalidade_id);
            ELSE
                RAISE EXCEPTION ''Este mês/ano já está fechado. %'', NEW.mensalidade_anomes;
            END IF;
        END IF;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;

CREATE TRIGGER ti_mensalidade BEFORE INSERT ON mensalidade
    FOR EACH ROW EXECUTE PROCEDURE ti_mensalidade();
