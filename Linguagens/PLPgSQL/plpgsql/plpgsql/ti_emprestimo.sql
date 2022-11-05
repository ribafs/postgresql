-- Revisado em 15/06/2005. Ramiro.
CREATE or REPLACE FUNCTION ti_emprestimo() RETURNS trigger AS '
    DECLARE
        emp_anomes emprestimo.emprestimo_anomes%TYPE;
    BEGIN
        IF NEW.emprestimo_anomes IS NULL THEN
            RAISE EXCEPTION ''Mês e ano precisam ser preenchidos.'';
        END IF;
        IF NEW.emprestimo_nrvezes IS NULL THEN
             RAISE EXCEPTION ''É necessário preencher o número de vezes'';
        END IF;
        IF NEW.emprestimo_vlrprestacao IS NULL THEN
             RAISE EXCEPTION ''É necessário preencher o valor da prestação'';
        END IF;
        IF NEW.emprestimo_descricao IS NULL THEN
             RAISE EXCEPTION ''É necessário preencher a descrição'';
        END IF;

        IF VerificaAssociadoDesligado(NEW.fk_associado_id) THEN
            RAISE EXCEPTION ''Este associado está desligado. %s'', NEW.fk_associado_id;
        ELSE
            emp_anomes := NEW.emprestimo_anomes;
            IF VerificaMesReferencia(emp_anomes) THEN
                FOR i IN 1..NEW.emprestimo_nrvezes LOOP
                    INSERT INTO lancamento( lancamento_anomes,
                                            lancamento_nome,
                                            lancamento_valordevido,
                                            fk_associado_id,
                                            fk_tipolancamento_id,
                                            fk_emprestimo_id) 
                    VALUES (emp_anomes,
                            NEW.emprestimo_descricao,
                            NEW.emprestimo_vlrprestacao,
                            NEW.fk_associado_id,
                            3,
                            NEW.emprestimo_id);
                    emp_anomes := anomesNext(emp_anomes);
                END LOOP;
            END IF;
        END IF;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;

CREATE TRIGGER ti_emprestimo BEFORE INSERT ON emprestimo
    FOR EACH ROW EXECUTE PROCEDURE ti_emprestimo();
