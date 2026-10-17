CREATE OR REPLACE FUNCTION fn_auditar_cambio_precio()
RETURNS TRIGGER AS $
BEGIN
    IF OLD.precio IS DISTINCT FROM NEW.precio THEN
        INSERT INTO auditoria_precios (
            id_producto,
            precio_anterior,
            precio_nuevo,
            fecha_modificacion,
            usuario_bd
        )
        VALUES (
            NEW.id_producto,
            OLD.precio,
            NEW.precio,
            CURRENT_TIMESTAMP,
            CURRENT_USER
        );
    END IF;

    RETURN NEW;
END;
$ LANGUAGE plpgsql;

DROP TRIGGER IF EXISTS trg_auditar_cambio_precio ON productos;

CREATE TRIGGER trg_auditar_cambio_precio
AFTER UPDATE OF precio ON productos
FOR EACH ROW
EXECUTE FUNCTION fn_auditar_cambio_precio();
