CREATE or REPLACE FUNCTION tu_lancamento() RETURNS trigger AS '
    DECLARE
        recconsignavel RECORD;
    BEGIN
        IF NEW.lancamento_valordevido < 0 THEN
            RAISE EXCEPTION ''Não é permitido valores negativos.'';
        ELSIF VerificaAssociadoDesligado(NEW.fk_associado_id) THEN
            RAISE EXCEPTION ''Este associado está desligado. %s'', NEW.fk_associado_id;
        ELSIF VerificaMesReferenciaAberto(NEW.lancamento_anomes) THEN
            SELECT INTO recconsignavel * 
            FROM consignavel 
            WHERE consignavel_anomes = NEW.lancamento_anomes
            AND fk_associado_id = NEW.fk_associado_id;

            IF OLD.lancamento_valordevido > NEW.lancamento_valordevido THEN
                AtualizaConsignvelAssociado(NEW.lancamento_anomes,
                    consignavel_valorutilizado-(OLD.lancamento_valordevido-NEW.lancamento_valordevido),
                    NEW.fk_associado_id);
            ELSIF OLD.lancamento_valordevido < NEW.lancamento_valordevido THEN
                IF NEW.lancamento_valordevido > (recconsignavel.consignavel_valordisponivel-recconsignavel.consignavel_valorutilizado) THEN
                    RAISE EXCEPTION ''Não há saldo consignável disponível.'';
                ELSE
                AtualizaConsignvelAssociado(NEW.lancamento_anomes,
                    consignavel_valorutilizado+(NEW.lancamento_valordevido-OLD.lancamento_valordevido),
                    NEW.fk_associado_id);
                END IF;
            END IF;
        ELSE
            RAISE EXCEPTION ''Este mês/ano já está fechado. %s'', NEW.lancamento_anomes;
        END IF;

        RETURN NEW;
    END;
' LANGUAGE plpgsql;

CREATE TRIGGER tu_lancamento BEFORE UPDATE ON lancamento
    FOR EACH ROW EXECUTE PROCEDURE tu_lancamento();
