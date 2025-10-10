-- ===========================
-- CREACIÓN DE TABLAS
-- ===========================

-- TIENDA
CREATE TABLE tienda (
    id_tienda SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(200)
);

-- Insertar 100 tiendas realistas
INSERT INTO tienda (nombre, direccion)
SELECT 'MiniMarket ' || gs, 'Dirección ' || gs
FROM generate_series(1, 100) AS gs;

-- TELEFONO_TIENDA
CREATE TABLE telefono_tienda (
    id_telefono_tienda SERIAL PRIMARY KEY,
    id_tienda INT NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    FOREIGN KEY (id_tienda) REFERENCES tienda(id_tienda)
);

-- EMPLEADOS
CREATE TABLE empleados (
    id_empleado SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(200),
    fecha_contratacion DATE,
    cargo VARCHAR(50),
    email VARCHAR(100) UNIQUE,
    salario NUMERIC(10,2),
    id_tienda INT NOT NULL,
    FOREIGN KEY (id_tienda) REFERENCES tienda(id_tienda)
);

-- Insertar 5 empleados por cada tienda (500 en total)
INSERT INTO empleados (nombre, direccion, fecha_contratacion, cargo, email, salario, id_tienda)
SELECT 
  nombres[((gs-1) % array_length(nombres, 1)) + 1] || ' ' || apellidos[((gs-1) % array_length(apellidos, 1)) + 1],
  'Dirección Empleado ' || gs,
  CURRENT_DATE - (random() * 730)::int,
  cargos[((gs-1) % array_length(cargos, 1)) + 1],
  'empleado' || gs || '@minimarket.com',
  (1500000 + (random() * 1500000))::numeric(10,2),
  ((gs-1) % 100) + 1
FROM generate_series(1, 500) AS gs,
LATERAL (SELECT ARRAY['Juan','Laura','Pedro','Sandra','María','Andrés','Paola','Javier','Carlos','Diana','Felipe','Natalia','Ana','Miguel','Camila','Oscar','Luis','Valentina','Sergio','Lucía','David','Andrea','Martín','Gabriela','Tomás','Patricia','Jorge','Sara','Alejandro','Elena','Manuel','Mónica','Camilo','Esteban','Sofía','Ricardo','Emilia','Mateo','Victoria','Simón'] AS nombres) n,
LATERAL (SELECT ARRAY['Torres','Pérez','Gómez','Rodríguez','Martínez','Ramírez','Herrera','Díaz','Castro','Peña','Ruiz','López','Vargas','Ríos','Suárez','Ramírez','Torres','Díaz','Gómez','Herrera','Peña','Castro','Ruiz','Gómez','Ramírez','Vargas','Ríos','Díaz','Torres','Ramírez','Herrera','Peña','Castro','Ruiz','Gómez','Ramírez','Vargas','Ríos','Díaz','Torres','Ramírez'] AS apellidos) a,
LATERAL (SELECT ARRAY['Cajero','Auxiliar','Administrador'] AS cargos) c;

-- CATEGORIA
CREATE TABLE categoria (
    id_categoria SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL
);

-- PROVEEDORES
CREATE TABLE proveedores (
    id_proveedor SERIAL PRIMARY KEY,
    nombre_empresa VARCHAR(100) NOT NULL,
    ciudad VARCHAR(100),
    nit VARCHAR(50) UNIQUE,
    representante_legal VARCHAR(100),
    email VARCHAR(100) UNIQUE
);

-- TELEFONO_PROVEEDOR
CREATE TABLE telefono_proveedor (
    id_telefono_proveedor SERIAL PRIMARY KEY,
    id_proveedor INT NOT NULL,
    telefono VARCHAR(20) NOT NULL,
    FOREIGN KEY (id_proveedor) REFERENCES proveedores(id_proveedor)
);

-- PRODUCTOS
CREATE TABLE productos (
    id_producto SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    precio_unitario NUMERIC(10,2),
    precio_compra NUMERIC(10,2),
    stock INT,
    marca VARCHAR(50),
    id_categoria INT NOT NULL,
    id_proveedor INT NOT NULL,
    id_tienda INT NOT NULL,
    FOREIGN KEY (id_categoria) REFERENCES categoria(id_categoria),
    FOREIGN KEY (id_proveedor) REFERENCES proveedores(id_proveedor),
    FOREIGN KEY (id_tienda) REFERENCES tienda(id_tienda)
);

-- CLIENTES
CREATE TABLE clientes (
    cc_cliente VARCHAR(20) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(100) UNIQUE
);

-- VENTAS
CREATE TABLE ventas (
    id_venta SERIAL PRIMARY KEY,
    cc_cliente VARCHAR(20) NOT NULL,
    fecha_transaccion DATE DEFAULT CURRENT_DATE,
    monto_total NUMERIC(12,2),
    FOREIGN KEY (cc_cliente) REFERENCES clientes(cc_cliente)
);

-- DETALLE_VENTA
CREATE TABLE detalle_venta (
    id_detalle_venta SERIAL PRIMARY KEY,
    id_venta INT NOT NULL,
    id_producto INT NOT NULL,
    cantidad INT,
    subtotal_producto NUMERIC(12,2),
    FOREIGN KEY (id_venta) REFERENCES ventas(id_venta),
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

-- Insertar 2000 clientes realistas
INSERT INTO clientes (cc_cliente, nombre, correo)
SELECT 
  (10000000 + gs)::text,
  nombres[((gs-1) % array_length(nombres, 1)) + 1] || ' ' || apellidos[((gs-1) % array_length(apellidos, 1)) + 1],
  'cliente' || gs || '@mail.com'
FROM generate_series(1, 2000) AS gs,
LATERAL (SELECT ARRAY['Camila','Juan','María','Carlos','Ana','Luis','Paula','Jorge','Sofía','Ricardo','Valentina','Andrés','Gabriela','Felipe','Laura','Tomás','Daniela','Martín','Patricia','Oscar','Lucía','Esteban','Sandra','David','Camilo','Natalia','Javier','Mónica','Alejandro','Elena','Sara','Manuel','Paola','Sergio','Julián','Gabriel','Valeria','Marcos','Andrea','Martina','Miguel','Diana','Sebastián','Emilia','Mateo','Isabella','Emilio','Victoria','Simón','Antonia'] AS nombres) n,
LATERAL (SELECT ARRAY['Torres','Pérez','Gómez','Rodríguez','Martínez','Ramírez','Herrera','Díaz','Castro','Peña','Ruiz','López','Vargas','Ríos','Suárez','Ramírez','Torres','Díaz','Gómez','Herrera','Peña','Castro','Ruiz','Gómez','Ramírez','Vargas','Ríos','Díaz','Torres','Ramírez','Herrera','Peña','Castro','Gómez','Vargas','Díaz','Torres','Ramírez','Herrera','Peña','Castro','Ruiz','Gómez','Ramírez','Vargas','Ríos','Díaz','Torres','Ramírez','Herrera'] AS apellidos) a;

-- PROMOCIONES
CREATE TABLE promociones (
    id_promocion SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    tipo VARCHAR(20) NOT NULL, -- 'Descuento' o '2x1'
    descuento NUMERIC(5,2),
    fecha_inicio DATE,
    fecha_fin DATE
);

-- PRODUCTO_PROMOCION
CREATE TABLE producto_promocion (
    id_promocion INT NOT NULL,
    id_producto INT NOT NULL,
    PRIMARY KEY (id_promocion, id_producto),
    FOREIGN KEY (id_promocion) REFERENCES promociones(id_promocion),
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

-- ===========================
-- ÍNDICES SUGERIDOS PARA CONSULTAS FRECUENTES
-- ===========================
CREATE INDEX idx_clientes_email ON clientes(correo);
CREATE INDEX idx_proveedores_email ON proveedores(email);
CREATE INDEX idx_productos_nombre ON productos(nombre);

-- ===========================
-- DATOS DE EJEMPLO MASIVOS
-- ===========================

-- Los clientes ya fueron generados automáticamente (2000 clientes)

-- Insertar 10 categorías
INSERT INTO categoria (nombre)
SELECT 'Categoría ' || gs FROM generate_series(1, 10) AS gs;

-- Insertar 50 proveedores
INSERT INTO proveedores (nombre_empresa, ciudad, nit, representante_legal, email)
SELECT 'Proveedor ' || gs, 'Ciudad ' || gs, 'NIT' || gs, 'Representante ' || gs, 'proveedor' || gs || '@mail.com'
FROM generate_series(1, 50) AS gs;



-- Generar 10,000 productos simplificados sin caracteres especiales
INSERT INTO productos (nombre, precio_unitario, precio_compra, stock, marca, id_categoria, id_proveedor, id_tienda)
SELECT 
  'Producto ' || gs,
  (1000 + (random() * 9000))::numeric(10,2),
  (500 + (random() * 4000))::numeric(10,2),
  (10 + (random() * 190)::int),
  CASE (gs % 10)
    WHEN 0 THEN 'Alpina'
    WHEN 1 THEN 'Diana'
    WHEN 2 THEN 'Bimbo'
    WHEN 3 THEN 'Coca-Cola'
    WHEN 4 THEN 'Colanta'
    WHEN 5 THEN 'Noel'
    WHEN 6 THEN 'Nestle'
    WHEN 7 THEN 'Bavaria'
    WHEN 8 THEN 'Ramo'
    ELSE 'Zenú'
  END,
  ((gs % 10) + 1),
  ((gs % 50) + 1),
  ((gs % 100) + 1)
FROM generate_series(1, 10000) AS gs;

-- ===========================
-- INSERTAR PROMOCIONES (2023-2024)
-- ===========================

INSERT INTO promociones (nombre, tipo, descuento, fecha_inicio, fecha_fin) VALUES
  ('Descuento Lácteos', 'Descuento', 10.00, '2023-03-01', '2023-03-31'),
  ('Descuento Panadería', 'Descuento', 15.00, '2023-04-01', '2023-04-30'),
  ('Descuento Bebidas', 'Descuento', 20.00, '2023-05-01', '2023-05-31'),
  ('Descuento Abarrotes', 'Descuento', 12.00, '2023-06-01', '2023-06-30'),
  ('Descuento Carnes', 'Descuento', 18.00, '2023-07-01', '2023-07-31'),
  ('Descuento Frutas', 'Descuento', 8.00, '2023-08-01', '2023-08-31'),
  ('Descuento Verduras', 'Descuento', 9.00, '2023-09-01', '2023-09-30'),
  ('Descuento Limpieza', 'Descuento', 14.00, '2023-10-01', '2023-10-31'),
  ('Descuento Cuidado Personal', 'Descuento', 11.00, '2023-11-01', '2023-11-30'),
  ('Descuento Snacks', 'Descuento', 13.00, '2023-12-01', '2023-12-31'),
  ('2x1 Lácteos', '2x1', 0.00, '2024-01-15', '2024-01-31'),
  ('2x1 Panadería', '2x1', 0.00, '2024-02-01', '2024-02-29'),
  ('2x1 Bebidas', '2x1', 0.00, '2024-03-01', '2024-03-15'),
  ('2x1 Abarrotes', '2x1', 0.00, '2024-04-01', '2024-04-15'),
  ('2x1 Carnes', '2x1', 0.00, '2024-05-01', '2024-05-15'),
  ('2x1 Frutas', '2x1', 0.00, '2024-06-01', '2024-06-15'),
  ('2x1 Verduras', '2x1', 0.00, '2024-07-01', '2024-07-15'),
  ('2x1 Limpieza', '2x1', 0.00, '2024-08-01', '2024-08-15'),
  ('2x1 Cuidado Personal', '2x1', 0.00, '2024-09-01', '2024-09-15'),
  ('2x1 Snacks', '2x1', 0.00, '2024-10-01', '2024-10-15');

-- Asociar productos a promociones (cada promoción con 10-20 productos)
INSERT INTO producto_promocion (id_promocion, id_producto) 
SELECT p.id_promocion, pr.id_producto 
FROM promociones p 
CROSS JOIN (SELECT id_producto FROM productos ORDER BY random() LIMIT 200) pr
LIMIT 800;

-- ===========================
-- GENERAR VENTAS REALISTAS (2023-2024) - VERSION SIMPLIFICADA
-- ===========================

-- Primero eliminamos ventas existentes para evitar duplicados
DELETE FROM detalle_venta;
DELETE FROM ventas;

-- Generar 15000 ventas con fechas entre septiembre 2023 y septiembre 2025
INSERT INTO ventas (cc_cliente, fecha_transaccion, monto_total)
SELECT 
  c.cc_cliente,
  '2023-09-01'::date + (random() * 730)::int,
  0
FROM (
  SELECT cc_cliente, 
         generate_series(1, 8) as serie -- Cada cliente puede tener hasta 8 ventas
  FROM clientes
) c
WHERE (c.cc_cliente::int % 100) < 75 -- 75% de clientes tienen ventas
LIMIT 15000;

-- Generar detalles de venta con distribución realista
DO $$
DECLARE
    venta RECORD;
    num_productos INT;
    i INT;
    producto_id INT;
    cantidad INT;
    precio NUMERIC;
    subtotal NUMERIC;
BEGIN
    FOR venta IN SELECT id_venta FROM ventas ORDER BY id_venta LOOP
        -- Determinar número de productos por venta con distribución realista
        CASE 
            WHEN random() < 0.3 THEN num_productos := 1 + floor(random() * 2)::int; -- 30% compras pequeñas (1-2 productos)
            WHEN random() < 0.7 THEN num_productos := 2 + floor(random() * 3)::int; -- 40% compras medianas (2-4 productos)
            ELSE num_productos := 4 + floor(random() * 5)::int; -- 30% compras grandes (4-8 productos)
        END CASE;
        
        -- Insertar productos para esta venta
        FOR i IN 1..num_productos LOOP
            -- Seleccionar producto aleatorio
            SELECT id_producto, precio_unitario INTO producto_id, precio
            FROM productos 
            ORDER BY random() 
            LIMIT 1;
            
            -- Cantidad entre 1 y 3
            cantidad := 1 + floor(random() * 3)::int;
            
            -- Calcular subtotal
            subtotal := precio * cantidad;
            
            -- Insertar detalle
            INSERT INTO detalle_venta (id_venta, id_producto, cantidad, subtotal_producto)
            VALUES (venta.id_venta, producto_id, cantidad, subtotal);
        END LOOP;
    END LOOP;
END $$;

-- Actualizar montos totales de las ventas
UPDATE ventas 
SET monto_total = (
  SELECT COALESCE(SUM(subtotal_producto), 0)
  FROM detalle_venta 
  WHERE detalle_venta.id_venta = ventas.id_venta
);

-- ===========================
-- DATOS CONSISTENTES DE EJEMPLO
-- ===========================

-- Las categorías ya fueron insertadas anteriormente

-- Los proveedores ya fueron insertados anteriormente



-- ===========================
-- INSERTAR TELÉFONOS DE TIENDAS
-- ===========================

INSERT INTO telefono_tienda (id_tienda, telefono) VALUES
  (1, '3101234567'),
  (2, '3112345678'),
  (3, '3123456789'),
  (4, '3134567890'),
  (5, '3145678901'),
  (6, '3156789012'),
  (7, '3167890123'),
  (8, '3178901234'),
  (9, '3189012345'),
  (10, '3190123456');

-- Insertar teléfonos para todas las tiendas restantes
INSERT INTO telefono_tienda (id_tienda, telefono) 
SELECT id_tienda, '320' || LPAD((2000000 + id_tienda)::text, 7, '0') 
FROM tienda 
WHERE id_tienda NOT IN (SELECT id_tienda FROM telefono_tienda);

-- Insertar teléfonos para todos los proveedores
INSERT INTO telefono_proveedor (id_proveedor, telefono)
SELECT id_proveedor, '310' || LPAD((1000000 + id_proveedor)::text, 7, '0')
FROM proveedores;