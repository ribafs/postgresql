CREATE or REPLACE FUNCTION tu_quadroassociativo() RETURNS trigger AS '
    BEGIN
        IF (OLD.quadroassociativo_desligamento IS NULL) AND 
           (NEW.quadroassociativo_desligamento IS NOT NULL) THEN
            UPDATE associado SET associado_desligado = ''t''
            WHERE associado_id = OLD.fk_associado_id;
	ELSIF (OLD.quadroassociativo_desligamento IS NOT NULL) AND 
              (NEW.quadroassociativo_desligamento IS NULL) THEN
            UPDATE associado SET associado_desligado = ''f''
            WHERE associado_id = OLD.fk_associado_id;
	END IF;
        RETURN NEW;
    END;
' LANGUAGE plpgsql;

CREATE TRIGGER tu_quadroassociativo BEFORE UPDATE ON quadroassociativo
    FOR EACH ROW EXECUTE PROCEDURE tu_quadroassociativo();
