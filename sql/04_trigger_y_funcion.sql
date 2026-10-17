-- Caso 1: Función aumento (+10%) y reducción (-50%)
SELECT 
    calcular_precio_ajustado(10.00, 10) AS aumento_10_porc,
    calcular_precio_ajustado(10.00, -50) AS reduccion_50_porc;

-- Caso 2: Función entradas inválidas
DO $$ BEGIN PERFORM calcular_precio_ajustado(10.00, NULL); EXCEPTION WHEN OTHERS THEN RAISE NOTICE 'Error Caso 2a: \%', SQLERRM; END $$;

DO $$ BEGIN PERFORM calcular_precio_ajustado(0.00, 10); EXCEPTION WHEN OTHERS THEN RAISE NOTICE 'Error Caso 2b: \%', SQLERRM; END $$;

DO $$ BEGIN PERFORM calcular_precio_ajustado(100.00, 150); EXCEPTION WHEN OTHERS THEN RAISE NOTICE 'Error Caso 2c: \%', SQLERRM; END $$;

-- Caso 3: Procedimiento cambio válido
CALL aplicar_ajuste_precio(1, 10);
SELECT * FROM productos WHERE id_producto = 1;
SELECT * FROM auditoria_precios WHERE id_producto = 1;

-- Caso 4: Procedimiento ID inexistente
DO $$ BEGIN CALL aplicar_ajuste_precio(9999, 10); EXCEPTION WHEN OTHERS THEN RAISE NOTICE 'Error Caso 4: \%', SQLERRM; END $$;

-- Caso 5: Procedimiento porcentaje inválido
DO $$ BEGIN CALL aplicar_ajuste_precio(2, 200); EXCEPTION WHEN OTHERS THEN RAISE NOTICE 'Error Caso 5: \%', SQLERRM; END $$;

-- Caso 6: Trigger UPDATE directo
UPDATE productos SET precio = 200.00 WHERE id_producto = 3;
SELECT * FROM auditoria_precios WHERE id_producto = 3;

-- Caso 7: Trigger precio sin cambio
UPDATE productos SET precio = 200.00 WHERE id_producto = 3;

-- Caso 8: Integridad transaccional
BEGIN;
CALL aplicar_ajuste_precio(2, 20);
SELECT precio FROM productos WHERE id_producto = 2;
ROLLBACK;
SELECT precio FROM productos WHERE id_producto = 2;
