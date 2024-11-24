-- trigger_num_episodio.sql debe correrse antes de insercion.sql
-- esto es para que todas las series tengan datos correctos
CREATE OR REPLACE FUNCTION upd_num_episodios_serie()
RETURNS TRIGGER
LANGUAGE PLPGSQL
AS $$
BEGIN
    UPDATE Serie S
    SET num_episodios = (SELECT count(*) FROM Episodio E WHERE E.id_contenido = S.id_contenido)
    WHERE S.id_contenido = NEW.id_contenido OR S.id_contenido = OLD.id_contenido;
    RETURN NEW;
END;
$$;

CREATE TRIGGER upd_num_episodios_serie
AFTER INSERT OR UPDATE OF id_contenido OR DELETE ON Episodio
FOR EACH ROW
EXECUTE PROCEDURE upd_num_episodios_serie();
