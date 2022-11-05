--Alterado em 15/06/2005. Ramiro.
CREATE or REPLACE FUNCTION td_requisicao() RETURNS trigger AS '
    DECLARE
        anomes requisicao.requisicao_anomes%TYPE;
    BEGIN
        anomes := OLD.requisicao_anomes;
        IF VerificaAssociadoDesligado(OLD.fk_associado_id) THEN
            RAISE EXCEPTION ''Este associado está desligado. %s'', OLD.fk_associado_id;
        ELSE
            IF VerificaLancamentosAnterioresMes(OLD.fk_associado_id, OLD.requisicao_id, null, OLD.requisicao_anomes,2) THEN
                FOR i IN 1..OLD.requisicao_nrvezes LOOP
                    IF VerificaMesReferenciaAberto(anomes) THEN
                        DELETE FROM lancamento 
                            WHERE fk_associado_id = OLD.fk_associado_id
                            AND fk_tipolancamento_id = 2
                            AND lancamento_anomes = anomes;
                            AND fk_requisicao_id = OLD.requisicao_id;
                    ELSE
                        RAISE EXCEPTION ''Este mês/ano já está fechado. %s'', OLD.requisicao_anomes;
                    END IF;
                    anomes := AnoMesNext(anomes);
                END LOOP;
		    END IF;
        END IF;
        RETURN OLD;
    END;
' LANGUAGE plpgsql;

CREATE TRIGGER td_requisicao BEFORE DELETE ON requisicao
    FOR EACH ROW EXECUTE PROCEDURE td_requisicao();
