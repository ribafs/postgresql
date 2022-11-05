CREATE or REPLACE FUNCTION tu_mesreferencia() RETURNS trigger AS '
    DECLARE
        contador integer;
    BEGIN
        IF NEW.mesreferencia_aberto IS NULL THEN
            RAISE EXCEPTION ''É necessário informar se o mês está aberto ou fechado.'';
        END IF;


        IF NEW.mesreferencia_aberto != OLD.mesreferencia_aberto then
            SELECT count(*) INTO contador FROM mesreferencia WHERE mesreferencia_aberto = ''t'';

            IF NEW.mesreferencia_aberto AND NEW.mesreferencia_aberto != OLD.mesreferencia_aberto AND contador > 0 then
                RAISE EXCEPTION ''Só é permitido a existencia de um mês aberto.'';
            END IF;
        END IF;

        RETURN NEW;
    END;
' LANGUAGE plpgsql;

CREATE TRIGGER tu_mesreferencia BEFORE UPDATE ON mesreferencia
    FOR EACH ROW EXECUTE PROCEDURE tu_mesreferencia();
