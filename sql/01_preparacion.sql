DROP TABLE IF EXISTS auditoria_precios CASCADE;
DROP TABLE IF EXISTS productos CASCADE;

CREATE TABLE productos (
    id_producto SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    precio NUMERIC(10,2) NOT NULL CHECK (precio > 0)
);

INSERT INTO productos (nombre, precio) VALUES
    ('Teclado Mecánico RGB', 50.00),
    ('Ratón Inalámbrico Ergonomico', 25.50),
    ('Monitor 24 Pulgadas Full HD', 180.00);

CREATE TABLE auditoria_precios (
    id_auditoria SERIAL PRIMARY KEY,
    id_producto INT NOT NULL,
    precio_anterior NUMERIC(10,2) NOT NULL,
    precio_nuevo NUMERIC(10,2) NOT NULL,
    fecha_modificacion TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    usuario_bd VARCHAR(100) DEFAULT CURRENT_USER
);
