CREATE or REPLACE FUNCTION tu_emprestimo() RETURNS trigger AS '
    DECLARE
        emp_anomes emprestimo.emprestimo_anomes%TYPE;
    BEGIN
        IF NEW.emprestimo_anomes IS NULL THEN
            RAISE EXCEPTION ''Mês e ano precisam ser preenchidos.'';
        END IF;
        IF VerificaAssociadoDesligado(NEW.fk_associado_id) THEN
            RAISE EXCEPTION ''Este associado está desligado. %s'', NEW.fk_associado_id;
        ELSE
            IF VerificaMesReferenciaAberto(NEW.emprestimo_anomes) THEN
                IF NEW.emprestimo_nrvezes IS NULL THEN
                     RAISE EXCEPTION ''É necessário preencher o número de vezes'';
                END IF;
                IF NEW.emprestimo_vlrprestacao IS NULL THEN
                     RAISE EXCEPTION ''É necessário preencher o valor da prestação'';
                END IF;
                IF NEW.emprestimo_descricao IS NULL THEN
                     RAISE EXCEPTION ''É necessário preencher a descrição'';
                END IF;
		
                SELECT INTO emp_mesanterior count(l.fk_emprestimo_id) 
		       FROM lancamento l, mesreferencia m 
		       WHERE l.fk_emprestimo_id = OLD.fk_emprestimo_id 
		       AND l.lancamento_anomes < NEW.emprestimo_anomes
		       AND l.lancamento_anomes = m.mesreferencia_anomes
		       AND m.mesreferencia_aberto = ''f'';

                IF emp_mesanterior >= 1 THEN
                    DELETE FROM lancamento 
                    WHERE fk_associado_id = OLD.fk_associado_id
                    AND fk_tipolancamento_id = 3
                    AND fk_emprestimo_id = OLD.emprestimo_id;
		    
                    emp_anomes := NEW.emprestimo_anomes;
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
        END IF;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;

CREATE TRIGGER tu_emprestimo BEFORE UPDATE ON emprestimo
    FOR EACH ROW EXECUTE PROCEDURE tu_emprestimo();
