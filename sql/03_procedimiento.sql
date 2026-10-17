-- Procedimiento almacenado para aplicar ajuste de precio a un producto

CREATE OR REPLACE PROCEDURE aplicar_ajuste_precio(
    p_id_producto INT,
    p_porcentaje NUMERIC
)
AS $$
DECLARE
    v_precio_actual NUMERIC;
    v_precio_nuevo NUMERIC;
BEGIN
    -- Verificar si el producto existe y obtener precio actual
    SELECT precio INTO v_precio_actual
    FROM productos
    WHERE id_producto = p_id_producto;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'El producto con ID % no existe en el catálogo.', p_id_producto;
    END IF;

    -- Calcular el nuevo precio usando la función escalar
    v_precio_nuevo := calcular_precio_ajustado(v_precio_actual, p_porcentaje);

    -- Actualizar el precio del producto
    UPDATE productos
    SET precio = v_precio_nuevo
    WHERE id_producto = p_id_producto;
END;
$$ LANGUAGE plpgsql;
