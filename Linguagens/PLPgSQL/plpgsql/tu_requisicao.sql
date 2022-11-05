CREATE or REPLACE FUNCTION tu_requisicao() RETURNS trigger AS '
    DECLARE
        req_anomes requisicao.requisicao_anomes%TYPE;
    BEGIN
        IF VerificaAssociadoDesligado(NEW.fk_associado_id) THEN
            RAISE EXCEPTION ''Este associado está desligado. %s'', NEW.fk_associado_id;
        ELSE
            IF NEW.requisicao_anomes IS NULL THEN
                RAISE EXCEPTION ''Mês e ano precisam ser preenchidos.'';
            ELSIF VerificaMesReferenciaAberto(NEW.requisicao_anomes) THEN
                IF NEW.requisicao_nrvezes IS NULL THEN
                     RAISE EXCEPTION ''É necessário preencher o número de vezes'';
                END IF;
                IF NEW.requisicao_valorprestacao IS NULL THEN
                     RAISE EXCEPTION ''É necessário preencher o valor da prestação'';
                END IF;
                IF NEW.requisicao_descricao IS NULL THEN
                     RAISE EXCEPTION ''É necessário preencher a descrição'';
                END IF;
                IF VerificaMesReferenciaAberto(NEW.requisicao_anomes) AND
                   VerificaLancamentosAnterioresMes(OLD.fk_associado_id, OLD.requisicao_id, NEW.requisicao_anomes,2) THEN
                    DELETE FROM lancamento 
                        WHERE fk_associado_id = OLD.fk_associado_id
                        AND fk_tipolancamento_id = 2
                        AND fk_requisicao_id = OLD.requisicao_id;
    
                    req_anomes := NEW.requisicao_anomes;
                    FOR i IN 1..NEW.requisicao_nrvezes LOOP
                        IF VerificaMesReferenciaAberto(req_anomes) THEN
                            INSERT INTO lancamento( lancamento_anomes,
                                                    lancamento_nome,
                                                    lancamento_valordevido,
                                                    fk_associado_id,
                                                    fk_tipolancamento_id,
                                                    fk_requisicao_id) 
                            VALUES (req_anomes,
                                    NEW.requisicao_descricao,
                                    NEW.requisicao_valorprestacao,
                                    NEW.fk_associado_id,
                                    2,
                                    NEW.requisicao_id);
                            req_anomes := anomesNext(req_anomes);
                        ELSE
                            RAISE EXCEPTION ''Este mês/ano já está fechado. %s'', req_anomes;
                        END IF;
                    END LOOP;
                ELSE
                    RAISE EXCEPTION ''Este mês/ano já está fechado ou algum mês/ano anterior à este lançamento. %s'', req_anomes;
                END IF;
            ELSE
                RAISE EXCEPTION ''Este mês/ano já está fechado. %s'', NEW.requisicao_anomes;
            END IF;
        END IF;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;

CREATE TRIGGER tu_requisicao BEFORE UPDATE ON requisicao
    FOR EACH ROW EXECUTE PROCEDURE tu_requisicao();
