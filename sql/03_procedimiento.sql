CREATE OR REPLACE PROCEDURE aplicar_ajuste_precio(
    p_id_producto INT,
    p_porcentaje NUMERIC
)
LANGUAGE plpgsql AS $
DECLARE
    v_precio_actual NUMERIC;
    v_precio_nuevo NUMERIC;
BEGIN
    IF p_id_producto IS NULL THEN
        RAISE EXCEPTION 'El ID del producto no puede ser NULL.'
            USING ERRCODE = '22004';
    END IF;

    SELECT precio INTO v_precio_actual
    FROM productos
    WHERE id_producto = p_id_producto;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'El producto con ID % no existe en el catálogo.', p_id_producto
            USING ERRCODE = 'P0002';
    END IF;

    v_precio_nuevo := calcular_precio_ajustado(v_precio_actual, p_porcentaje);

    UPDATE productos
    SET precio = v_precio_nuevo
    WHERE id_producto = p_id_producto;
END;
$;
