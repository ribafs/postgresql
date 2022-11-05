CREATE or REPLACE FUNCTION ti_mesreferencia() RETURNS trigger AS '
    DECLARE
        contador integer;
    BEGIN
        IF NEW.mesreferencia_aberto IS NULL THEN
            RAISE EXCEPTION ''É necessário informar se o mês está aberto ou fechado.'';
        END IF;

        SELECT count(*) INTO contador FROM mesreferencia WHERE mesreferencia_aberto = ''t'';

        IF NEW.mesreferencia_aberto AND contador > 0 then
            RAISE EXCEPTION ''Só é permitido a existencia de um mês aberto.'';
        END IF;

        RETURN NEW;
    END;
' LANGUAGE plpgsql;

CREATE TRIGGER ti_mesreferencia BEFORE INSERT ON mesreferencia
    FOR EACH ROW EXECUTE PROCEDURE ti_mesreferencia();
