CREATE OR REPLACE FUNCTION calcular_precio_ajustado(
    precio_actual NUMERIC,
    porcentaje NUMERIC
)
RETURNS NUMERIC AS $$
DECLARE
    precio_calculado NUMERIC;
BEGIN
    IF precio_actual IS NULL OR porcentaje IS NULL THEN
        RAISE EXCEPTION 'Los parámetros precio_actual y porcentaje no pueden ser NULL.'
            USING ERRCODE = '22004';
    END IF;

    IF precio_actual <= 0 THEN
        RAISE EXCEPTION 'El precio actual debe ser mayor a cero. Valor ingresado: %', precio_actual
            USING ERRCODE = '22003';
    END IF;

    IF porcentaje < -50 OR porcentaje > 100 THEN
        RAISE EXCEPTION 'El porcentaje debe estar comprendido entre -50 y 100. Valor ingresado: %', porcentaje
            USING ERRCODE = '22003';
    END IF;

    precio_calculado := ROUND(precio_actual * (1 + porcentaje / 100.0), 2);

    IF precio_calculado <= 0 THEN
        RAISE EXCEPTION 'El precio resultante (%) tras aplicar el ajuste debe ser mayor a cero.', precio_calculado
            USING ERRCODE = '22003';
    END IF;

    RETURN precio_calculado;
END;
$$ LANGUAGE plpgsql IMMUTABLE;
