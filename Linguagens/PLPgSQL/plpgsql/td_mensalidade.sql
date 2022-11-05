-- Revisado em 15/06/2005. Ramiro.
CREATE or REPLACE FUNCTION td_mensalidade() RETURNS trigger AS '
    BEGIN
        IF VerificaAssociadoDesligado(OLD.fk_associado_id) THEN
            RAISE EXCEPTION ''Este associado está desligado. %s'', OLD.fk_associado_id;
        ELSE
            IF VerificaMesReferenciaAberto(OLD.mensalidade_anomes) THEN
                DELETE FROM lancamento 
                    WHERE lancamento_anomes = OLD.mensalidade_anomes
                    AND fk_associado_id = OLD.fk_associado_id
                    AND fk_tipolancamento_id = 1
                    AND fk_faixamensalidade_id = OLD.fk_faixamensalidade_id;
            ELSE
                RAISE EXCEPTION ''Este mês/ano já está fechado. %s'', %OLD.mensalidade_anomes;
            END IF;
        END IF;
        RETURN OLD;
    END;
' LANGUAGE plpgsql;

CREATE TRIGGER td_mensalidade BEFORE DELETE ON mensalidade
    FOR EACH ROW EXECUTE PROCEDURE td_mensalidade();
