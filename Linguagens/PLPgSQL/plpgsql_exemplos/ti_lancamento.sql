-- Revisado em 15/06/2005. Ramiro.
CREATE or REPLACE FUNCTION ti_lancamento() RETURNS trigger AS '
    DECLARE
        anomesAnterior lancamento.lancamento_anomes%TYPE;
        recconsignavel RECORD;
        consignavelAnterior consignavel.consignavel_valordisponivel%TYPE;
    BEGIN
        IF NEW.lancamento_anomes IS NULL THEN
            RAISE EXCEPTION ''Mês e ano precisam ser preenchidos.'';
        END IF;
        IF NEW.fk_associado_id IS NULL THEN
            RAISE EXCEPTION ''É necessário escolher um associado.'';
        END IF;
        IF NEW.lancamento_valordevido IS NULL THEN
            RAISE EXCEPTION ''É necessário preencher o valor do lançamento'';
        END IF;
        IF VerificaAssociadoDesligado(NEW.fk_associado_id) THEN
            RAISE EXCEPTION ''Este associado está desligado. %s'', NEW.fk_associado_id;
        ELSE
            IF VerificaMesReferenciaAberto(NEW.lancamento_anomes) then
                SELECT INTO recconsignavel * 
                FROM consignavel 
                WHERE consignavel_anomes = NEW.lancamento_anomes
                AND fk_associado_id = NEW.fk_associado_id;

                IF NOT FOUND THEN
                    anomesAnterior := anomesPrev(NEW.lancamento_anomes);
                    SELECT INTO consignavelAnterior consignavel_valordisponivel
                    FROM consignavel 
                    WHERE consignavel_anomes = anomesAnterior
                    AND fk_associado_id = NEW.fk_associado_id;

                    INSERT INTO consignavel( consignavel_anomes,
                                                 fk_associado_id,
                                             consignavel_valordisponivel,
                                             consignavel_valorutilizado )
                                     VALUES( NEW.lancamento_anomes,
                                             NEW.fk_associado_id,
                                             consignavelAnterior,
                                             0 );

                    SELECT INTO recconsignavel * 
                    FROM consignavel 
                    WHERE consignavel_anomes = NEW.lancamento_anomes
                    AND fk_associado_id = NEW.fk_associado_id;
                    IF NOT FOUND THEN
                        RAISE EXCEPTION ''Consignavel não encontrado.'';
                    END IF;
                END IF;

                IF NEW.lancamento_valordevido >
                      (recconsignavel.consignavel_valordisponivel-
                       recconsignavel.consignavel_valorutilizado) THEN
                    RAISE EXCEPTION ''Não há saldo consignável disponível. %'',NEW.lancamento_anomes;
                ELSE
                    UPDATE consignavel
                    SET consignavel_valorutilizado = consignavel_valorutilizado+
                                                     NEW.lancamento_valordevido
                    WHERE consignavel_anomes = NEW.lancamento_anomes
                    AND fk_associado_id = NEW.fk_associado_id;
                    IF NOT FOUND THEN
                        RAISE EXCEPTION ''Não foi possível atualizar o saldo consignável'';
                    END IF;
                END IF;
            END IF;
        END IF;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;

CREATE TRIGGER ti_lancamento BEFORE INSERT ON lancamento
    FOR EACH ROW EXECUTE PROCEDURE ti_lancamento();
