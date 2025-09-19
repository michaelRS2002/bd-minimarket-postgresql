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



-- Generar 10,000 productos con distribución equilibrada
INSERT INTO productos (nombre, precio_unitario, precio_compra, stock, marca, id_categoria, id_proveedor, id_tienda)
SELECT 
  nombres[((gs-1) % array_length(nombres, 1)) + 1] || ' ' || presentaciones[((gs-1) % array_length(presentaciones, 1)) + 1],
  (1000 + (random() * 9000))::numeric(10,2),
  (500 + (random() * 4000))::numeric(10,2),
  (10 + (random() * 190)::int),
  marcas[((gs-1) % array_length(marcas, 1)) + 1],
  categorias[((gs-1) % array_length(categorias, 1)) + 1],
  proveedores[((gs-1) % array_length(proveedores, 1)) + 1],
  tiendas[((gs-1) % array_length(tiendas, 1)) + 1]
FROM generate_series(1, 10000) AS gs,
LATERAL (SELECT ARRAY[
  'Leche Entera','Arroz Diana 1kg','Pan Tajado','Limpia Pisos Floral','Jabón de Manos','Gaseosa Cola 1.5L','Yogurt Fresa','Queso Campesino','Huevos AA x30','Detergente Ropa','Shampoo','Manzanas Rojas','Papas Criollas','Carne de Res','Pollo Entero','Cerveza Rubia','Galletas Festival','Papel Higiénico','Desodorante','Coca-Cola 250ml','Coca-Cola 600ml','Coca-Cola 3L','Esponja Multiusos','Cepillo de Dientes Adulto','Condones x3','Jabón Lavaplatos','Desinfectante','Toalla de Cocina','Papel Aluminio','Arroz Roa 500g','Pan Baguette','Pan Integral','Galletas Saltín','Salsa de Tomate','Mayonesa','Aceite de Girasol','Frijoles Empacados','Lentejas','Azúcar 1kg','Sal 500g','Cereal Chocapic','Cereal Zucaritas','Mermelada de Fresa','Mantequilla','Yogurt Natural','Galletas Ducales','Galletas Oreo','Maní Salado 100g','Aguardiente Antioqueño 375ml','Ron Medellín 375ml','Galletas Tosh Avena','Galletas Festival Vainilla','Ron Blanco 375ml','Pasta Dental 90g','Enjuague Bucal 250ml','Crema para Peinar','Toallas Húmedas','Pañales x30','Leche en Polvo 400g','Mantequilla de Maní','Cereal Fitness','Cereal Corn Flakes','Galletas Saltín Queso','Galletas Festival Limón','Maní Natural 100g','Galletas Tosh Chía','Galletas Festival Fresa','Galletas Festival Coco','Galletas Festival Mora','Galletas Festival Naranja','Galletas Festival Chocolate Blanco','Gaseosa Colombiana 1.5L','Gaseosa Manzana 1.5L','Gaseosa Uva 1.5L','Gaseosa Pepsi 1.5L','Café Sello Rojo 250g','Café Águila Roja 250g','Café Juan Valdez 250g','Café La Bastilla 250g','Salchicha Ranchera x10','Salchicha Zenú x10','Salchicha Pietrán x10','Papas Margarita Natural 30g','Papas Margarita Limón 30g','Papas Margarita BBQ 30g','Papas Margarita Pollo 30g','Papas Margarita Limón 105g','Papas Margarita Natural 105g'
] AS nombres) n,
LATERAL (SELECT ARRAY[
  'Alpina','Diana','Bimbo','Limpio Hogar','Protex','Coca-Cola','Colanta','Kikes','Ariel','Head & Shoulders','Frutas del Campo','Verduras Verdes','Carnes Selectas','Aguila','Noel','Familia','Rexona','Postobón','Pepsi','Colgate','Durex','Axion','Reynolds','Roa','Panadería El Trigo','Fruco','Premier','Zenú','Incauca','Refisal','Nestlé','Kellogg''s','Bavaria','Ramo','Tosh','Nectar','Caldas','Maggi','Van Camp''s','Nescafé','Hatsu','Hit','Suavel','Ranchera','Pietrán','Margarita','Jif','Juan Valdez','Pampers','Nido','Victoria'
] AS marcas) m,
LATERAL (SELECT ARRAY['x1','x2','x3','x4','x5','x6','x7','x8','x9','x10'] AS presentaciones) p,
LATERAL (SELECT ARRAY(SELECT id_categoria FROM categoria) AS categorias) c,
LATERAL (SELECT ARRAY(SELECT id_proveedor FROM proveedores) AS proveedores) pr,
LATERAL (SELECT ARRAY(SELECT id_tienda FROM tienda) AS tiendas) t;

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

-- Asociar productos a promociones
INSERT INTO producto_promocion (id_promocion, id_producto) 
SELECT p.id_promocion, pr.id_producto 
FROM promociones p 
CROSS JOIN (SELECT id_producto FROM productos ORDER BY random() LIMIT 200) pr;

-- ===========================
-- GENERAR VENTAS REALISTAS (2023-2024)
-- ===========================

DO $$
DECLARE
  v_id_venta INT;
  v_cc_cliente VARCHAR(20);
  v_fecha DATE;
  v_monto_total NUMERIC(12,2);
  v_cant_productos INT;
  v_id_producto INT;
  v_cantidad INT;
  v_precio NUMERIC(10,2);
  v_subtotal NUMERIC(12,2);
  v_i INT;
  v_j INT;
  v_ids_clientes TEXT[];
  v_ids_productos INT[];
BEGIN
  -- Obtener arrays de clientes y productos existentes
  SELECT ARRAY(SELECT cc_cliente FROM clientes LIMIT 2000) INTO v_ids_clientes;
  SELECT ARRAY(SELECT id_producto FROM productos LIMIT 10000) INTO v_ids_productos;
  
  -- Generar 2000 ventas
  FOR v_i IN 1..2000 LOOP
    -- Seleccionar cliente aleatorio
    v_cc_cliente := v_ids_clientes[1 + floor(random() * (array_length(v_ids_clientes, 1) - 1))];
    
    -- Fecha aleatoria entre 2023-01-01 y 2024-12-31
    v_fecha := '2023-01-01'::date + (floor(random() * 730))::int;
    
    v_monto_total := 0;
    
    -- Insertar venta
    INSERT INTO ventas (cc_cliente, fecha_transaccion, monto_total) 
    VALUES (v_cc_cliente, v_fecha, 0) 
    RETURNING id_venta INTO v_id_venta;
    
    -- Entre 1 y 5 productos por venta
    v_cant_productos := 1 + floor(random() * 5);
    
    FOR v_j IN 1..v_cant_productos LOOP
      -- Seleccionar producto aleatorio
      v_id_producto := v_ids_productos[1 + floor(random() * (array_length(v_ids_productos, 1) - 1))];
      
      -- Obtener precio del producto
      SELECT precio_unitario INTO v_precio FROM productos WHERE id_producto = v_id_producto;
      
      -- Cantidad entre 1 y 4
      v_cantidad := 1 + floor(random() * 4);
      
      -- Calcular subtotal
      v_subtotal := v_precio * v_cantidad;
      
      -- Insertar detalle de venta
      INSERT INTO detalle_venta (id_venta, id_producto, cantidad, subtotal_producto)
      VALUES (v_id_venta, v_id_producto, v_cantidad, v_subtotal);
      
      v_monto_total := v_monto_total + v_subtotal;
    END LOOP;
    
    -- Actualizar monto total de la venta
    UPDATE ventas SET monto_total = v_monto_total WHERE id_venta = v_id_venta;
  END LOOP;
END$$;

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