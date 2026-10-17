# Caso Práctico: Cambios de Precios con Trazabilidad en PostgreSQL

Este repositorio contiene la solución completa para la implementación de lógica de negocio y auditoría automática de catálogo en PostgreSQL.

## Datos del Entorno
- **Motor de Base de Datos:** PostgreSQL 18
- **Herramienta de Administración:** pgAdmin 4 / psql

## Estructura de Archivos
- sql/01_preparacion.sql: Creación de la tabla de catálogo productos y la tabla uditoria_precios con datos semilla.
- sql/02_funcion_escalar.sql: Definición de la función calcular_precio_ajustado.
- sql/03_procedimiento.sql: Definición del procedimiento almacenado plicar_ajuste_precio.
- sql/04_trigger_y_funcion.sql: Función de soporte y Trigger 	rg_auditar_cambio_precio.
- sql/05_pruebas.sql: Batería de pruebas con los 8 casos exigidos.

