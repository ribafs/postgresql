CREATE or REPLACE FUNCTION ti_quadroassociativo() RETURNS trigger AS '
    DECLARE
        qaa_desligado boolean;
    BEGIN
        IF NEW.fk_associado_id IS NULL THEN
            RAISE EXCEPTION ''É necessário escolher um associado'';
        END IF;
        IF NEW.quadroassociativo_admissao IS NULL THEN
            RAISE EXCEPTION ''É necessário preencher a data de admissão.'';
        END IF;
        IF NEW.quadroassociativo_desligamento IS NULL THEN
	    qaa_desligado := ''f'';
	ELSE
	    qaa_desligado := ''t'';
        END IF;

        UPDATE associado set associado_desligado = qaa_desligado
	WHERE associado_id = NEW.fk_associado_id;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;

CREATE TRIGGER ti_quadroassociativo BEFORE INSERT ON quadroassociativo
    FOR EACH ROW EXECUTE PROCEDURE ti_quadroassociativo();
