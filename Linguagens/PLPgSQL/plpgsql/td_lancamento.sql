-- Revisado em 15/06/2005. Ramiro.
CREATE or REPLACE FUNCTION td_lancamento() RETURNS trigger AS '
    BEGIN
        IF VerificaAssociadoDesligado(OLD.fk_associado_id) THEN
            RAISE EXCEPTION ''Este associado está desligado. %s'', OLD.fk_associado_id;
        ELSE
            IF VerificaMesReferenciaAberto(OLD.lancamento_anomes) THEN
                AtualizaConsignavelAssociado(OLD.lancamento_anomes,
                                             OLD.lancamento_valordevido,
                                             OLD.fk_associado_id); 
            ELSE
                RAISE EXCEPTION ''Este mês/ano já está fechado. %s'', OLD.lancamento_anomes;
            END IF;
        END IF;
        RETURN OLD;
    END;
' LANGUAGE plpgsql;

CREATE TRIGGER td_lancamento BEFORE DELETE ON lancamento
    FOR EACH ROW EXECUTE PROCEDURE td_lancamento();
