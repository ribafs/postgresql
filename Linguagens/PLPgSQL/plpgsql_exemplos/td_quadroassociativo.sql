-- Revisado em 15/06/2005. Ramiro.
CREATE or REPLACE FUNCTION td_quadroassociativo() RETURNS trigger AS '
    BEGIN
        UPDATE associado set associado_desligado = ''t''
	WHERE associado_id = OLD.fk_associado_id;
        RETURN OLD;
    END;
' LANGUAGE plpgsql;

CREATE TRIGGER td_quadroassociativo BEFORE DELETE ON quadroassociativo
    FOR EACH ROW EXECUTE PROCEDURE td_quadroassociativo();
