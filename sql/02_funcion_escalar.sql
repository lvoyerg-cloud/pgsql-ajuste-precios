-- Función escalar para calcular el precio ajustado con validaciones

CREATE OR REPLACE FUNCTION calcular_precio_ajustado(
    precio_actual NUMERIC,
    porcentaje NUMERIC
)
RETURNS NUMERIC AS $$
BEGIN
    -- Validar nulos
    IF precio_actual IS NULL OR porcentaje IS NULL THEN
        RAISE EXCEPTION 'Los parámetros precio_actual y porcentaje no pueden ser NULL.';
    END IF;

    -- Validar precio base
    IF precio_actual <= 0 THEN
        RAISE EXCEPTION 'El precio actual debe ser mayor a cero. Valor ingresado: %', precio_actual;
    END IF;

    -- Validar rango de porcentaje (-50% a 100%)
    IF porcentaje < -50 OR porcentaje > 100 THEN
        RAISE EXCEPTION 'El porcentaje debe estar comprendido entre -50 y 100. Valor ingresado: %', porcentaje;
    END IF;

    RETURN ROUND(precio_actual * (1 + porcentaje / 100.0), 2);
END;
$$ LANGUAGE plpgsql;
