-- Script de ejecuciones y pruebas de los 8 Casos de Uso

-- ==========================================
-- CASO 1: Función Escalar – Cálculo Válido (+10% y -50%)
-- ==========================================
SELECT 
    calcular_precio_ajustado(10.00, 10) AS aumento_10_porc,
    calcular_precio_ajustado(10.00, -50) AS reduccion_50_porc;

-- ==========================================
-- CASO 2: Función Escalar – Entradas Inválidas
-- ==========================================
-- 2a: Parámetro Nulo
DO $$ 
BEGIN 
    PERFORM calcular_precio_ajustado(10.00, NULL); 
EXCEPTION WHEN OTHERS THEN 
    RAISE NOTICE 'Error Caso 2a: %', SQLERRM;
END $$;

-- 2b: Precio Base <= 0
DO $$ 
BEGIN 
    PERFORM calcular_precio_ajustado(0.00, 10); 
EXCEPTION WHEN OTHERS THEN 
    RAISE NOTICE 'Error Caso 2b: %', SQLERRM;
END $$;

-- 2c: Porcentaje Fuera de Rango (> 100%)
DO $$ 
BEGIN 
    PERFORM calcular_precio_ajustado(100.00, 150); 
EXCEPTION WHEN OTHERS THEN 
    RAISE NOTICE 'Error Caso 2c: %', SQLERRM;
END $$;

-- ==========================================
-- CASO 3: Procedimiento – Ajuste Exitoso (+10% Producto 1)
-- ==========================================
CALL aplicar_ajuste_precio(1, 10);
SELECT * FROM productos WHERE id_producto = 1;
SELECT * FROM auditoria_precios WHERE id_producto = 1;

-- ==========================================
-- CASO 4: Procedimiento – Producto Inexistente
-- ==========================================
DO $$ 
BEGIN 
    CALL aplicar_ajuste_precio(9999, 10); 
EXCEPTION WHEN OTHERS THEN 
    RAISE NOTICE 'Error Caso 4: %', SQLERRM;
END $$;

-- ==========================================
-- CASO 5: Procedimiento – Porcentaje Inválido
-- ==========================================
DO $$ 
BEGIN 
    CALL aplicar_ajuste_precio(2, 200); 
EXCEPTION WHEN OTHERS THEN 
    RAISE NOTICE 'Error Caso 5: %', SQLERRM;
END $$;

-- ==========================================
-- CASO 6: Trigger – UPDATE Directo sobre el Catálogo
-- ==========================================
UPDATE productos SET precio = 200.00 WHERE id_producto = 3;
SELECT * FROM auditoria_precios WHERE id_producto = 3;

-- ==========================================
-- CASO 7: Trigger – UPDATE Redundante (Mismo Precio)
-- ==========================================
UPDATE productos SET precio = 200.00 WHERE id_producto = 3;
SELECT COUNT(*) FROM auditoria_precios WHERE id_producto = 3;

-- ==========================================
-- CASO 8: Transaccionalidad – Deshacer Cambio (ROLLBACK)
-- ==========================================
BEGIN;
CALL aplicar_ajuste_precio(1, 20);
SELECT precio FROM productos WHERE id_producto = 1;
ROLLBACK;

SELECT precio FROM productos WHERE id_producto = 1;
