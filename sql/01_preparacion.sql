-- Creación de tablas e inserción de datos iniciales

DROP TABLE IF EXISTS auditoria_precios CASCADE;
DROP TABLE IF EXISTS productos CASCADE;

CREATE TABLE productos (
    id_producto SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    precio NUMERIC(10, 2) NOT NULL
);

CREATE TABLE auditoria_precios (
    id_auditoria SERIAL PRIMARY KEY,
    id_producto INT NOT NULL,
    precio_anterior NUMERIC(10, 2) NOT NULL,
    precio_nuevo NUMERIC(10, 2) NOT NULL,
    fecha_modificacion TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    usuario_bd VARCHAR(50) NOT NULL DEFAULT CURRENT_USER,
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

INSERT INTO productos (nombre, precio) VALUES
('Producto 1', 50.00),
('Producto 2', 100.00),
('Producto 3', 200.00);
