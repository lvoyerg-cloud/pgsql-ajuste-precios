# Sistema de Gestión y Auditoría de Precios de Catálogo

[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-18.0-blue.svg)](https://www.postgresql.org/)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](#licencia)
[![Status](https://img.shields.io/badge/Status-Completed-success.svg)](#)

Este repositorio contiene una solución integral de base de datos desarrollada en **PostgreSQL 18** para la actualización controlada y trazabilidad automatizada del catálogo de precios de una plataforma de comercio electrónico.

La arquitectura implementada garantiza la separación estricta de responsabilidades mediante la integración de una **función escalar**, un **procedimiento almacenado** y un **trigger AFTER UPDATE**.

---

## 📋 Tabla de Contenidos

- [Contexto del Problema](#-contexto-del-problema)
- [Arquitectura de la Solución](#-arquitectura-de-la-solución)
- [Estructura del Repositorio](#-estructura-del-repositorio)
- [Guía de Instalación y Ejecución](#-guía-de-instalación-y-ejecución)
- [Batería de Pruebas y Validación](#-batería-de-pruebas-y-validación)
- [Licencia](#-licencia)

---

## 🎯 Contexto del Problema

Una tienda digital requiere aplicar ajustes porcentuales de precio sobre su catálogo de productos manteniendo las siguientes directrices operativas:

1. **Previsualización segura:** Posibilidad de calcular incrementos o descuentos sin persistir cambios en las tablas del sistema.
2. **Control transaccional:** Garantizar que las actualizaciones validen la existencia del producto y rangos de porcentaje permitidos.
3. **Auditoría transparente:** Generar registros automáticos de trazabilidad solo cuando ocurra una modificación efectiva de precio, registrando valores anteriores, nuevos, marcas de tiempo y el usuario de la base de datos que ejecutó la operación.
4. **Protección histórica:** Asegurar que los registros de ventas o facturación previa no sufran alteraciones.

---

## ⚙️ Arquitectura de la Solución

El sistema se compone de tres objetos de base de datos independientes y complementarios:

| Objeto | Tipo | Responsabilidad Principal |
| :--- | :--- | :--- |
| `calcular_precio_ajustado` | **Función Escalar** | Recibe el precio actual y un porcentaje (entre -50% y +100%), retornando el nuevo precio redondeado a 2 decimales sin modificar la base de datos. |
| `aplicar_ajuste_precio` | **Procedimiento Almacenado** | Valida la existencia del producto, invoca la función escalar para calcular el ajuste y aplica la sentencia `UPDATE` sobre el catálogo. |
| `trg_auditar_cambio_precio` | **Trigger & Función** | Disparador `AFTER UPDATE OF precio` que evalúa cambios mediante `IS DISTINCT FROM` e inserta automáticamente la trazabilidad en `auditoria_precios`. |

### Justificación Técnica: Función Escalar vs. Table-Valued Function
La función `calcular_precio_ajustado` fue implementada como una **función escalar** que retorna `NUMERIC` debido a:
* **Responsabilidad única:** Realiza un cálculo aritmético puntual sobre valores atómicos.
* **Composibilidad:** Permite integrarse de forma directa dentro de clausulas `SELECT`, expresiones condicionales y rutinas de procedimientos almacenados.
* **Aislamiento de contexto:** No requiere consultar ni transformar estructuras de datos relacionales completas.

---

## 📁 Estructura del Repositorio

```text
├── README.md
└── sql/
    ├── 01_preparacion.sql          # Creación de tablas base, auditoría y datos semilla.
    ├── 02_funcion_escalar.sql      # Definición de la función calcular_precio_ajustado.
    ├── 03_procedimiento.sql        # Definición del procedimiento aplicar_ajuste_precio.
    ├── 04_trigger_y_funcion.sql    # Trigger y función de soporte para auditoría.
    └── 05_pruebas.sql              # Batería completa de pruebas (8 casos obligatorios).
```

---

## 🚀 Guía de Instalación y Ejecución

### Prerrequisitos
* **PostgreSQL 12.0+** (Recomendado **PostgreSQL 18**).
* Acceso a través de `psql` (CLI) o una interfaz gráfica como **pgAdmin 4**.

### Secuencia de Despliegue (CLI)

Ejecute los scripts de forma secuencial desde su terminal de comandos:

```bash
# 1. Preparación de tablas y datos iniciales
psql -U postgres -d tu_base_datos -f sql/01_preparacion.sql

# 2. Creación de la función escalar
psql -U postgres -d tu_base_datos -f sql/02_funcion_escalar.sql

# 3. Creación del procedimiento almacenado
psql -U postgres -d tu_base_datos -f sql/03_procedimiento.sql

# 4. Creación del trigger y su función de soporte
psql -U postgres -d tu_base_datos -f sql/04_trigger_y_funcion.sql

# 5. Ejecución de la suite de pruebas
psql -U postgres -d tu_base_datos -f sql/05_pruebas.sql
```

---

## 🧪 Batería de Pruebas y Validación

El archivo `sql/05_pruebas.sql` valida de forma aislada e integral los 8 escenarios operativos clave:

1. **Función Escalar (Cálculo Válido):** Verificación de aumentos (+10%) y reducciones (-50%).
2. **Función Escalar (Entradas Inválidas):** Control de excepciones ante valores `NULL`, precios no positivos y porcentajes fuera del rango `[-50, 100]`.
3. **Procedimiento Almacenado (Actualización Exitosa):** Verificación de actualización en el catálogo e inserción automática de auditoría.
4. **Procedimiento Almacenado (Producto Inexistente):** Manejo de errores controlados (`SQLSTATE P0002`).
5. **Procedimiento Almacenado (Parámetros Fuera de Rango):** Validación de detención y ausencia de actualizaciones parciales.
6. **Trigger (UPDATE Directo):** Comprobación de auditoría automatizada al ejecutar sentencias `UPDATE` sin utilizar el procedimiento.
7. **Trigger (Sin Cambio Efectivo):** Confirmación de que updates con valores idénticos no generen registros de auditoría redundantes.
8. **Integridad Transaccional:** Validación de rollback de actualización y registro de auditoría dentro de bloques `BEGIN ... ROLLBACK`.

---

## 📄 Licencia

Este proyecto se distribuye bajo la licencia **MIT**. Para más información, consulte el archivo de licencia correspondiente.
