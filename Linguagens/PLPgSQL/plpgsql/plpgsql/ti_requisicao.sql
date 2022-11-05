CREATE or REPLACE FUNCTION ti_requisicao() RETURNS trigger AS '
    DECLARE
        req_anomes requisicao.requisicao_anomes%TYPE;
    BEGIN
        IF NEW.requisicao_anomes IS NULL THEN
            RAISE EXCEPTION ''Mês e ano precisam ser preenchidos.'';
        END IF;
        IF NOT VerificaMesReferenciaAberto(NEW.requisicao_anomes) THEN
            RAISE EXCEPTION ''Este mês/ano já está fechado. %s'', NEW.requisicao_anomes;
        END IF;
        IF NEW.requisicao_id IS NULL THEN
             RAISE EXCEPTION ''É necessário escolher uma requisição'';
        END IF;
        IF NEW.FK_associado_id IS NULL THEN
             RAISE EXCEPTION ''É necessário escolher um associado'';
        END IF;
        IF VerificaAssociadoDesligado(NEW.fk_associado_id) THEN
             RAISE EXCEPTION ''Este associado está desligado. %s'', NEW.fk_associado_id;
        END IF;
        IF NEW.requisicao_data IS NULL THEN
             RAISE EXCEPTION ''É necessário preencher a data.'';
        END IF;
        IF NEW.requisicao_validade IS NULL THEN
             RAISE EXCEPTION ''É necessário preencher a validade'';
        END IF;
        IF NEW.requisicao_valorprestacao IS NULL THEN
             RAISE EXCEPTION ''É necessário preencher o valor.'';
        END IF;
        IF NEW.requisicao_valorprestacao < 0 THEN
            RAISE EXCEPTION ''O valor não pode ser negativo'';
        END IF;
        IF NEW.fk_convenio_id IS NULL THEN
            RAISE EXCEPTION ''É necessário escolher um convenio'';
        END IF;
        IF NEW.fk_tiporequisicao_id IS NULL THEN
            RAISE EXCEPTION ''É necessário escolher um tipo de requisição'';
        END IF;

        req_anomes := NEW.requisicao_anomes;
	FOR i IN 1..NEW.requisicao_nrvezes LOOP
            IF VerificaMesReferenciaAberto(req_anomes) THEN
                INSERT INTO lancamento( lancamento_anomes,
                                        lancamento_nome,
                                        lancamento_valordevido,
                                        fk_associado_id,
                                        fk_tipolancamento_id,
                                        fk_requisicao_id) 
                VALUES ( req_anomes,
                         NEW.requisicao_descricao,
                         NEW.requisicao_valorprestacao,
                         NEW.fk_associado_id,
                         2,
                         NEW.requisicao_id);
            ELSE
                RAISE EXCEPTION ''Este mês/ano já está fechado. %s'', req_anomes;
            END IF;
            req_anomes := anomesNext(req_anomes);
	END LOOP;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;

CREATE TRIGGER ti_requisicao BEFORE INSERT ON requisicao
    FOR EACH ROW EXECUTE PROCEDURE ti_requisicao();
