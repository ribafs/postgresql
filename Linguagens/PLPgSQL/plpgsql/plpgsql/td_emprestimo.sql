--Alterado em 15/06/2005. Ramiro.
CREATE or REPLACE FUNCTION td_emprestimo() RETURNS trigger AS '
    DECLARE
        anomes emprestimo.emprestimo_anomes%TYPE;
    BEGIN
        IF VerificaAssociadoDesligado(OLD.fk_associado_id) THEN
            RAISE EXCEPTION ''Este associado está desligado. %s'', OLD.fk_associado_id;
        ELSE
            anomes := OLD.emprestimo_anomes;
            IF VerificaLancamentosAnterioresMes(OLD.fk_associado_id, null, OLD.emprestimo_id, anomes,2) THEN
                FOR i IN 1..OLD.emprestimo_nrvezes LOOP
                    IF VerificaMesReferenciaAberto(anomes) THEN
                        DELETE FROM lancamento 
                            WHERE fk_associado_id = OLD.fk_associado_id
                            AND fk_tipolancamento_id = 3
                            AND lancamento_anomes = anomes
                            AND fk_emprestimo_id = OLD.emprestimo_id;
                    ELSE
                        RAISE EXCEPTION ''Este mês/ano já foi fechado. %s'', OLD.emprestimo_anomes;
                    END IF;
                    anomes := AnoMesNext(anomes);
                END LOOP;
		    END IF;
        END IF;
        RETURN OLD;
    END;
' LANGUAGE plpgsql;

CREATE TRIGGER td_emprestimo BEFORE DELETE ON emprestimo
    FOR EACH ROW EXECUTE PROCEDURE td_emprestimo();
