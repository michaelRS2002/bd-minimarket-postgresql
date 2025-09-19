-- ===========================
-- CREACIÓN DE TABLAS
-- ===========================

-- TIENDA
CREATE TABLE tienda (
    id_tienda SERIAL PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    direccion VARCHAR(200)
);

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

--- CLIENTES
CREATE TABLE clientes (
    cc_cliente VARCHAR(20) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(100) UNIQUE
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

-- Insertar 100 clientes realistas
INSERT INTO clientes (cc_cliente, nombre, correo) VALUES
  ('10000001', 'Camila Torres', 'camila.torres@mail.com'),
  ('10000002', 'Juan Pérez', 'juan.perez@mail.com'),
  ('10000003', 'María Gómez', 'maria.gomez@mail.com'),
  ('10000004', 'Carlos Rodríguez', 'carlos.rodriguez@mail.com'),
  ('10000005', 'Ana Martínez', 'ana.martinez@mail.com'),
  ('10000006', 'Luis Ramírez', 'luis.ramirez@mail.com'),
  ('10000007', 'Paula Herrera', 'paula.herrera@mail.com'),
  ('10000008', 'Jorge Díaz', 'jorge.diaz@mail.com'),
  ('10000009', 'Sofía Castro', 'sofia.castro@mail.com'),
  ('10000010', 'Ricardo Peña', 'ricardo.pena@mail.com'),
  ('10000011', 'Valentina Ruiz', 'valentina.ruiz@mail.com'),
  ('10000012', 'Andrés López', 'andres.lopez@mail.com'),
  ('10000013', 'Gabriela Vargas', 'gabriela.vargas@mail.com'),
  ('10000014', 'Felipe Ríos', 'felipe.rios@mail.com'),
  ('10000015', 'Laura Suárez', 'laura.suarez@mail.com'),
  ('10000016', 'Tomás Ramírez', 'tomas.ramirez@mail.com'),

-- ===========================
-- 500 VENTAS REALISTAS CON PROMOCIONES
-- ===========================
-- NOTA: Se asume que los id_producto del 1 al 10 tienen promociones (como en producto_promocion)
-- y que los id_promocion 1-10 son Descuento, 11-20 son 2x1

-- Generar 500 ventas, cada una con 1 a 5 productos, algunas con promociones
-- Para simplificar, se usan clientes y productos existentes, y fechas recientes

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
  v_descuento NUMERIC(5,2);
  v_tipo_promo TEXT;
  v_id_promocion INT;
  v_i INT;
  v_j INT;
  v_ids_clientes TEXT[] := ARRAY(SELECT cc_cliente FROM clientes LIMIT 100);
  v_ids_productos INT[] := ARRAY(SELECT id_producto FROM productos LIMIT 100);
BEGIN
  FOR v_i IN 1..500 LOOP
    v_cc_cliente := v_ids_clientes[1 + floor(random()*99)::int];
    v_fecha := CURRENT_DATE - (floor(random()*365))::int;
    v_monto_total := 0;
    INSERT INTO ventas (cc_cliente, fecha_transaccion, monto_total) VALUES (v_cc_cliente, v_fecha, 0) RETURNING id_venta INTO v_id_venta;
    v_cant_productos := 1 + floor(random()*5)::int;
    FOR v_j IN 1..v_cant_productos LOOP
      v_id_producto := v_ids_productos[1 + floor(random()*99)::int];
      v_precio := (SELECT precio_unitario FROM productos WHERE id_producto = v_id_producto);
      v_cantidad := 1 + floor(random()*4)::int;
      v_id_promocion := (SELECT id_promocion FROM producto_promocion WHERE id_producto = v_id_producto LIMIT 1);
      IF v_id_promocion IS NOT NULL THEN
        v_tipo_promo := (SELECT tipo FROM promociones WHERE id_promocion = v_id_promocion);
        IF v_tipo_promo = 'Descuento' THEN
          v_descuento := (SELECT descuento FROM promociones WHERE id_promocion = v_id_promocion);
          v_subtotal := v_precio * v_cantidad * (1 - v_descuento/100);
        ELSIF v_tipo_promo = '2x1' THEN
          IF v_cantidad % 2 = 1 THEN v_cantidad := v_cantidad + 1; END IF;
          v_subtotal := v_precio * (v_cantidad/2);
        ELSE
          v_subtotal := v_precio * v_cantidad;
        END IF;
      ELSE
        v_subtotal := v_precio * v_cantidad;
      END IF;
      INSERT INTO detalle_venta (id_venta, id_producto, cantidad, subtotal_producto)
        VALUES (v_id_venta, v_id_producto, v_cantidad, v_subtotal);
      v_monto_total := v_monto_total + v_subtotal;
    END LOOP;
    UPDATE ventas SET monto_total = v_monto_total WHERE id_venta = v_id_venta;
  END LOOP;
END$$;
  ('10000017', 'Daniela Torres', 'daniela.torres@mail.com'),
  ('10000018', 'Martín Díaz', 'martin.diaz@mail.com'),
  ('10000019', 'Patricia Gómez', 'patricia.gomez@mail.com'),
  ('10000020', 'Oscar Herrera', 'oscar.herrera@mail.com'),
  ('10000021', 'Lucía Peña', 'lucia.pena@mail.com'),
  ('10000022', 'Esteban Castro', 'esteban.castro@mail.com'),
  ('10000023', 'Sandra Ruiz', 'sandra.ruiz@mail.com'),
  ('10000024', 'David Gómez', 'david.gomez@mail.com'),
  ('10000025', 'Camilo Ramírez', 'camilo.ramirez@mail.com'),
  ('10000026', 'Natalia Vargas', 'natalia.vargas@mail.com'),
  ('10000027', 'Javier Ríos', 'javier.rios@mail.com'),
  ('10000028', 'Mónica Díaz', 'monica.diaz@mail.com'),
  ('10000029', 'Alejandro Torres', 'alejandro.torres@mail.com'),
  ('10000030', 'Elena Ramírez', 'elena.ramirez@mail.com'),
  ('10000031', 'Sara Herrera', 'sara.herrera@mail.com'),
  ('10000032', 'Manuel Peña', 'manuel.pena@mail.com'),
  ('10000033', 'Paola Castro', 'paola.castro@mail.com'),
  ('10000034', 'Sergio Gómez', 'sergio.gomez@mail.com'),
  ('10000035', 'Lucía Vargas', 'lucia.vargas@mail.com'),
  ('10000036', 'Julián Díaz', 'julian.diaz@mail.com'),
  ('10000037', 'Gabriel Torres', 'gabriel.torres@mail.com'),
  ('10000038', 'Valeria Ramírez', 'valeria.ramirez@mail.com'),
  ('10000039', 'Marcos Herrera', 'marcos.herrera@mail.com'),
  ('10000040', 'Patricia Peña', 'patricia.pena@mail.com'),
  ('10000041', 'Tomás Castro', 'tomas.castro@mail.com'),
  ('10000042', 'Andrea Gómez', 'andrea.gomez@mail.com'),
  ('10000043', 'Martina Vargas', 'martina.vargas@mail.com'),
  ('10000044', 'Felipe Díaz', 'felipe.diaz@mail.com'),
  ('10000045', 'Camila Torres', 'camila.torres2@mail.com'),
  ('10000046', 'Juan Pérez', 'juan.perez2@mail.com'),
  ('10000047', 'María Gómez', 'maria.gomez2@mail.com'),
  ('10000048', 'Carlos Rodríguez', 'carlos.rodriguez2@mail.com'),
  ('10000049', 'Ana Martínez', 'ana.martinez2@mail.com'),
  ('10000050', 'Luis Ramírez', 'luis.ramirez2@mail.com'),
  ('10000051', 'Paula Herrera', 'paula.herrera2@mail.com'),
  ('10000052', 'Jorge Díaz', 'jorge.diaz2@mail.com'),
  ('10000053', 'Sofía Castro', 'sofia.castro2@mail.com'),
  ('10000054', 'Ricardo Peña', 'ricardo.pena2@mail.com'),
  ('10000055', 'Valentina Ruiz', 'valentina.ruiz2@mail.com'),
  ('10000056', 'Andrés López', 'andres.lopez2@mail.com'),
  ('10000057', 'Gabriela Vargas', 'gabriela.vargas2@mail.com'),
  ('10000058', 'Felipe Ríos', 'felipe.rios2@mail.com'),
  ('10000059', 'Laura Suárez', 'laura.suarez2@mail.com'),
  ('10000060', 'Tomás Ramírez', 'tomas.ramirez2@mail.com'),
  ('10000061', 'Daniela Torres', 'daniela.torres2@mail.com'),
  ('10000062', 'Martín Díaz', 'martin.diaz2@mail.com'),
  ('10000063', 'Patricia Gómez', 'patricia.gomez2@mail.com'),
  ('10000064', 'Oscar Herrera', 'oscar.herrera2@mail.com'),
  ('10000065', 'Lucía Peña', 'lucia.pena2@mail.com'),
  ('10000066', 'Esteban Castro', 'esteban.castro2@mail.com'),
  ('10000067', 'Sandra Ruiz', 'sandra.ruiz2@mail.com'),
  ('10000068', 'David Gómez', 'david.gomez2@mail.com'),
  ('10000069', 'Camilo Ramírez', 'camilo.ramirez2@mail.com'),
  ('10000070', 'Natalia Vargas', 'natalia.vargas2@mail.com'),
  ('10000071', 'Javier Ríos', 'javier.rios2@mail.com'),
  ('10000072', 'Mónica Díaz', 'monica.diaz2@mail.com'),
  ('10000073', 'Alejandro Torres', 'alejandro.torres2@mail.com'),
  ('10000074', 'Elena Ramírez', 'elena.ramirez2@mail.com'),
  ('10000075', 'Sara Herrera', 'sara.herrera2@mail.com'),
  ('10000076', 'Manuel Peña', 'manuel.pena2@mail.com'),
  ('10000077', 'Paola Castro', 'paola.castro2@mail.com'),
  ('10000078', 'Sergio Gómez', 'sergio.gomez2@mail.com'),
  ('10000079', 'Lucía Vargas', 'lucia.vargas2@mail.com'),
  ('10000080', 'Julián Díaz', 'julian.diaz2@mail.com'),
  ('10000081', 'Gabriel Torres', 'gabriel.torres2@mail.com'),
  ('10000082', 'Valeria Ramírez', 'valeria.ramirez2@mail.com'),
  ('10000083', 'Marcos Herrera', 'marcos.herrera2@mail.com'),
  ('10000084', 'Patricia Peña', 'patricia.pena2@mail.com'),
  ('10000085', 'Tomás Castro', 'tomas.castro2@mail.com'),
  ('10000086', 'Andrea Gómez', 'andrea.gomez2@mail.com'),
  ('10000087', 'Martina Vargas', 'martina.vargas2@mail.com'),
  ('10000088', 'Felipe Díaz', 'felipe.diaz2@mail.com'),
  ('10000089', 'Camila Torres', 'camila.torres3@mail.com'),
  ('10000090', 'Juan Pérez', 'juan.perez3@mail.com'),
  ('10000091', 'María Gómez', 'maria.gomez3@mail.com'),
  ('10000092', 'Carlos Rodríguez', 'carlos.rodriguez3@mail.com'),
  ('10000093', 'Ana Martínez', 'ana.martinez3@mail.com'),
  ('10000094', 'Luis Ramírez', 'luis.ramirez3@mail.com'),
  ('10000095', 'Paula Herrera', 'paula.herrera3@mail.com'),
  ('10000096', 'Jorge Díaz', 'jorge.diaz3@mail.com'),
  ('10000097', 'Sofía Castro', 'sofia.castro3@mail.com'),
  ('10000098', 'Ricardo Peña', 'ricardo.pena3@mail.com'),
  ('10000099', 'Valentina Ruiz', 'valentina.ruiz3@mail.com'),
  ('10000100', 'Andrés López', 'andres.lopez3@mail.com');

-- Insertar 10 categorías
INSERT INTO categoria (nombre)
SELECT 'Categoría ' || gs FROM generate_series(1, 10) AS gs;

-- Insertar 50 proveedores
INSERT INTO proveedores (nombre_empresa, ciudad, nit, representante_legal, email)
SELECT 'Proveedor ' || gs, 'Ciudad ' || gs, 'NIT' || gs, 'Representante ' || gs, 'proveedor' || gs || '@mail.com'
FROM generate_series(1, 50) AS gs;

-- Insertar 1000 productos
INSERT INTO productos (nombre, precio_unitario, precio_compra, stock, marca, id_categoria, id_proveedor, id_tienda)
SELECT
  'Producto ' || gs,
  (random() * 100 + 1)::numeric(10,2),
  (random() * 50 + 1)::numeric(10,2),
  (random() * 100)::int,
  'Marca ' || (gs % 10 + 1),
  (gs % 10 + 1),
  (gs % 50 + 1),
  (gs % 10 + 1)
FROM generate_series(1, 1000) AS gs;

-- Insertar 1000 ventas
INSERT INTO ventas (cc_cliente, fecha_transaccion, monto_total)
SELECT
  (random() * 999 + 1)::int::text,
  CURRENT_DATE - (random() * 365)::int,
  (random() * 500 + 10)::numeric(12,2)
FROM generate_series(1, 1000) AS gs;

-- ===========================
-- DATOS CONSISTENTES DE EJEMPLO
-- ===========================

-- Insertar 10 marcas
INSERT INTO categoria (nombre) VALUES
  ('Lácteos'),
  ('Panadería'),
  ('Bebidas'),
  ('Abarrotes'),
  ('Carnes'),
  ('Frutas'),
  ('Verduras'),
  ('Limpieza'),
  ('Cuidado Personal'),
  ('Snacks');

-- Insertar 10 proveedores
INSERT INTO proveedores (nombre_empresa, ciudad, nit, representante_legal, email) VALUES
  ('Alimentos S.A.', 'Bogotá', 'NIT1001', 'Carlos Ruiz', 'proveedor1@mail.com'),
  ('Panificadora El Trigo', 'Medellín', 'NIT1002', 'Ana Torres', 'proveedor2@mail.com'),
  ('Bebidas del Valle', 'Cali', 'NIT1003', 'Luis Gómez', 'proveedor3@mail.com'),
  ('Abarrotes Express', 'Barranquilla', 'NIT1004', 'Marta Díaz', 'proveedor4@mail.com'),
  ('Carnes Selectas', 'Cartagena', 'NIT1005', 'Pedro López', 'proveedor5@mail.com'),
  ('Frutas del Campo', 'Pereira', 'NIT1006', 'Sofía Ramírez', 'proveedor6@mail.com'),
  ('Verduras Verdes', 'Bucaramanga', 'NIT1007', 'Jorge Herrera', 'proveedor7@mail.com'),
  ('Limpio Hogar', 'Manizales', 'NIT1008', 'Paula Castro', 'proveedor8@mail.com'),
  ('Belleza Total', 'Ibagué', 'NIT1009', 'Ricardo Peña', 'proveedor9@mail.com'),
  ('Snacks y Más', 'Cúcuta', 'NIT1010', 'Gloria Suárez', 'proveedor10@mail.com');



-- ===========================
-- 500 PRODUCTOS REALES DE EJEMPLO
-- ===========================

INSERT INTO productos (nombre, precio_unitario, precio_compra, stock, marca, id_categoria, id_proveedor, id_tienda) VALUES
  -- Leche Entera en tiendas 1,2,3,4,5
  ('Leche Entera', 3500, 3000, 100, 'Alpina', 1, 1, 1),
  ('Leche Entera', 3550, 3050, 80, 'Alpina', 1, 1, 2),
  ('Leche Entera', 3600, 3100, 120, 'Alpina', 1, 1, 3),
  ('Leche Entera', 3450, 2950, 90, 'Alpina', 1, 1, 4),
  ('Leche Entera', 3400, 2900, 110, 'Alpina', 1, 1, 5),
  -- Arroz Diana 1kg en tiendas 2,4,6,8,10
  ('Arroz Diana 1kg', 4200, 3500, 200, 'Diana', 4, 4, 2),
  ('Arroz Diana 1kg', 4250, 3550, 180, 'Diana', 4, 4, 4),
  ('Arroz Diana 1kg', 4300, 3600, 160, 'Diana', 4, 4, 6),
  ('Arroz Diana 1kg', 4150, 3450, 140, 'Diana', 4, 4, 8),
  ('Arroz Diana 1kg', 4100, 3400, 120, 'Diana', 4, 4, 10),
  -- Pan Tajado en tiendas 1,3,5,7,9
  ('Pan Tajado', 2500, 2000, 150, 'Bimbo', 2, 2, 1),
  ('Pan Tajado', 2550, 2050, 130, 'Bimbo', 2, 2, 3),
  ('Pan Tajado', 2600, 2100, 120, 'Bimbo', 2, 2, 5),
  ('Pan Tajado', 2450, 1950, 110, 'Bimbo', 2, 2, 7),
  ('Pan Tajado', 2400, 1900, 100, 'Bimbo', 2, 2, 9),
  -- Limpia Pisos Floral en tiendas 3,4,5,6,7
  ('Limpia Pisos Floral', 5000, 4000, 80, 'Limpio Hogar', 8, 8, 3),
  ('Limpia Vidrios', 4800, 3900, 60, 'Limpio Hogar', 8, 8, 3),
  ('Jabón de Manos', 3200, 2500, 120, 'Protex', 9, 9, 2),
  ('Jabón de Manos', 3250, 2550, 110, 'Protex', 9, 9, 4),
  ('Jabón de Manos', 3300, 2600, 100, 'Protex', 9, 9, 6),
  ('Jabón de Manos', 3150, 2450, 90, 'Protex', 9, 9, 8),
  ('Jabón de Manos', 3100, 2400, 80, 'Protex', 9, 9, 10),
  -- Gaseosa Cola 1.5L (Coca-Cola) en las 10 tiendas
  ('Gaseosa Cola 1.5L', 3700, 3000, 90, 'Coca-Cola', 3, 3, 1),
  ('Yogurt Fresa', 2900, 2300, 110, 'Alpina', 1, 1, 2),
  ('Queso Campesino', 6500, 5500, 70, 'Colanta', 1, 1, 1),
  ('Huevos AA x30', 12000, 10000, 50, 'Kikes', 4, 4, 2),
  ('Detergente Ropa', 8500, 7000, 60, 'Ariel', 8, 8, 3),
  ('Shampoo', 7800, 6500, 75, 'Head & Shoulders', 9, 9, 2),
  ('Manzanas Rojas', 5200, 4000, 100, 'Frutas del Campo', 6, 6, 1),
  ('Papas Criollas', 3500, 2500, 130, 'Verduras Verdes', 7, 7, 2),
  ('Carne de Res', 18000, 15000, 40, 'Carnes Selectas', 5, 5, 1),
  ('Pollo Entero', 14000, 12000, 45, 'Carnes Selectas', 5, 5, 2),
  ('Cerveza Rubia', 3500, 2800, 90, 'Aguila', 3, 3, 1),
  ('Galletas Festival', 2200, 1800, 140, 'Noel', 10, 10, 2),
  ('Papel Higiénico', 9000, 7500, 80, 'Familia', 8, 8, 3),
  ('Desodorante', 6700, 5500, 70, 'Rexona', 9, 9, 2),
  ('Coca-Cola 250ml', 1800, 1500, 60, 'Coca-Cola', 3, 3, 1),
  ('Coca-Cola 600ml', 2500, 2000, 80, 'Coca-Cola', 3, 3, 2),
  ('Coca-Cola 1.5L', 3700, 3000, 90, 'Coca-Cola', 3, 3, 1),
  ('Coca-Cola 3L', 5200, 4500, 50, 'Coca-Cola', 3, 3, 3),
  ('Esponja Multiusos', 1200, 900, 200, 'Limpio Hogar', 8, 8, 2),
  ('Cepillo de Dientes Adulto', 3500, 2500, 120, 'Colgate', 9, 9, 1),
  ('Cepillo de Dientes Infantil', 3200, 2200, 100, 'Colgate', 9, 9, 2),
  ('Condones x3', 6000, 5000, 80, 'Durex', 9, 9, 3),
  ('Condones x12', 18000, 15000, 40, 'Durex', 9, 9, 1),
  ('Jabón Lavaplatos', 2500, 2000, 150, 'Axion', 8, 8, 2),
  ('Desinfectante', 4800, 4000, 90, 'Limpio Hogar', 8, 8, 3),
  ('Toalla de Cocina', 3500, 3000, 110, 'Familia', 8, 8, 1),
  ('Papel Aluminio', 4200, 3500, 70, 'Reynolds', 8, 8, 2),
  ('Arroz Roa 500g', 2200, 1800, 130, 'Roa', 4, 4, 1),
  ('Arroz Roa 1kg', 4200, 3500, 200, 'Roa', 4, 4, 2),
  ('Pan Baguette', 3200, 2500, 90, 'Panadería El Trigo', 2, 2, 1),
  ('Pan Integral', 3500, 2800, 80, 'Bimbo', 2, 2, 2),
  ('Galletas Saltín', 2100, 1700, 140, 'Noel', 10, 10, 3),
  ('Salsa de Tomate', 2900, 2300, 100, 'Fruco', 4, 4, 1),
  ('Mayonesa', 3500, 2800, 90, 'Fruco', 4, 4, 2),
  ('Aceite de Girasol', 7800, 6500, 60, 'Premier', 4, 4, 3),
  ('Frijoles Empacados', 5200, 4000, 70, 'Zenú', 4, 4, 1),
  ('Lentejas', 3500, 2500, 100, 'Diana', 4, 4, 2),
  ('Azúcar 1kg', 3200, 2500, 120, 'Incauca', 4, 4, 1),
  ('Sal 500g', 1200, 900, 200, 'Refisal', 4, 4, 2),
  ('Cereal Chocapic', 8500, 7000, 60, 'Nestlé', 10, 10, 3),
  ('Cereal Zucaritas', 9000, 7500, 80, 'Kellogg''s', 10, 10, 1),
  ('Mermelada de Fresa', 6700, 5500, 70, 'Bavaria', 10, 10, 2),
  ('Mantequilla', 7800, 6500, 75, 'Colanta', 1, 1, 3),
  ('Yogurt Natural', 2900, 2300, 110, 'Alpina', 1, 1, 2),
  ('Galletas Ducales', 2500, 2000, 120, 'Noel', 10, 10, 1),
  ('Galletas Festival Chocolate', 2300, 1800, 110, 'Noel', 10, 10, 2),
  ('Galletas Saltín Noel', 2100, 1700, 140, 'Noel', 10, 10, 3),
  ('Maní Salado 100g', 3200, 2500, 90, 'Zenú', 10, 10, 1),
  ('Maní Japones 80g', 3500, 2800, 80, 'Zenú', 10, 10, 2),
  ('Aguardiente Antioqueño 375ml', 18000, 15000, 60, 'Antioqueño', 3, 3, 1),
  ('Aguardiente Antioqueño 750ml', 32000, 27000, 40, 'Antioqueño', 3, 3, 2),
  ('Ron Medellín 375ml', 17000, 14000, 50, 'Fábrica de Licores', 3, 3, 3),
  ('Ron Medellín 750ml', 31000, 26000, 30, 'Fábrica de Licores', 3, 3, 1),
  ('Galletas Oreo', 2800, 2200, 100, 'Nabisco', 10, 10, 2),
  ('Maní con Pasas 100g', 3700, 3000, 70, 'Zenú', 10, 10, 3),
  ('Galletas Chocoramo', 3200, 2500, 90, 'Ramo', 10, 10, 1),
  ('Galletas Tosh Avena', 3500, 2800, 80, 'Tosh', 10, 10, 2),
  ('Galletas Saltín Integral', 2100, 1700, 140, 'Noel', 10, 10, 3),
  ('Aguardiente Nectar 375ml', 17500, 14500, 60, 'Nectar', 3, 3, 1),
  ('Aguardiente Nectar 750ml', 31500, 26500, 40, 'Nectar', 3, 3, 2),
  ('Ron Viejo de Caldas 375ml', 16500, 13500, 50, 'Caldas', 3, 3, 3),
  ('Ron Viejo de Caldas 750ml', 30500, 25500, 30, 'Caldas', 3, 3, 1),
  ('Sopa Instantánea Pollo', 1800, 1500, 120, 'Maggi', 4, 4, 1),
  ('Sopa Instantánea Carne', 1800, 1500, 110, 'Maggi', 4, 4, 2),
  ('Sopa Instantánea Gallina', 1800, 1500, 100, 'Maggi', 4, 4, 3),
  ('Atún en Agua', 5200, 4500, 90, 'Van Camp''s', 4, 4, 1),
  ('Atún en Aceite', 5400, 4700, 80, 'Van Camp''s', 4, 4, 2),
  ('Sardinas en Salsa', 3200, 2500, 100, 'Zenú', 4, 4, 3),
  ('Milo 400g', 8500, 7000, 60, 'Nestlé', 3, 3, 1),
  ('Café Molido 250g', 7800, 6500, 75, 'Sello Rojo', 3, 3, 2),
  ('Café Instantáneo 170g', 9500, 8000, 50, 'Nescafé', 3, 3, 3),
  ('Té Hatsu Limón', 3200, 2500, 90, 'Hatsu', 3, 3, 1),
  ('Té Hatsu Durazno', 3200, 2500, 80, 'Hatsu', 3, 3, 2),
  ('Jugo Hit Mango', 2500, 2000, 100, 'Hit', 3, 3, 3),
  ('Jugo Hit Naranja', 2500, 2000, 90, 'Hit', 3, 3, 1),
  ('Galletas Saltín Integral', 2100, 1700, 140, 'Noel', 10, 10, 2),
  ('Galletas Tosh Coco', 3500, 2800, 80, 'Tosh', 10, 10, 3),
  ('Galletas Festival Vainilla', 2300, 1800, 110, 'Noel', 10, 10, 1),
  ('Maní Picante 100g', 3700, 3000, 70, 'Zenú', 10, 10, 2),
  ('Maní Miel 100g', 3700, 3000, 70, 'Zenú', 10, 10, 3),
  ('Ron Blanco 375ml', 16000, 13000, 50, 'Caldas', 3, 3, 1),
  ('Ron Blanco 750ml', 30000, 25000, 30, 'Caldas', 3, 3, 2),
  ('Aguardiente Sin Azúcar 375ml', 18500, 15500, 60, 'Antioqueño', 3, 3, 3),
  ('Aguardiente Sin Azúcar 750ml', 32500, 27500, 40, 'Antioqueño', 3, 3, 1),
  ('Cepillo para Uñas', 2500, 2000, 100, 'Limpio Hogar', 8, 8, 2),
  ('Cepillo para Baño', 3500, 2800, 80, 'Limpio Hogar', 8, 8, 3),
  ('Esponja Metálica', 1200, 900, 200, 'Limpio Hogar', 8, 8, 1),
  ('Trapeador', 8500, 7000, 60, 'Limpio Hogar', 8, 8, 2),
  ('Escoba', 7800, 6500, 75, 'Limpio Hogar', 8, 8, 3),
  ('Recogedor', 3200, 2500, 90, 'Limpio Hogar', 8, 8, 1),
  ('Balde', 3500, 2800, 80, 'Limpio Hogar', 8, 8, 2),
  ('Guantes de Aseo', 2100, 1700, 140, 'Limpio Hogar', 8, 8, 3),
  ('Pasta Dental 90g', 3200, 2500, 100, 'Colgate', 9, 9, 1),
  ('Enjuague Bucal 250ml', 4800, 4000, 80, 'Listerine', 9, 9, 2),
  ('Crema para Peinar', 6700, 5500, 70, 'Pantene', 9, 9, 3),
  ('Desodorante Roll-On', 3500, 2800, 90, 'Rexona', 9, 9, 1),
  ('Toallas Húmedas', 4200, 3500, 70, 'Huggies', 9, 9, 2),
  ('Pañales x30', 32000, 27000, 40, 'Pampers', 9, 9, 3),
  ('Leche en Polvo 400g', 18500, 15500, 60, 'Nido', 1, 1, 1),
  ('Mantequilla de Maní', 9500, 8000, 50, 'Jif', 4, 4, 2),
  ('Mermelada de Mora', 3200, 2500, 90, 'Bavaria', 10, 10, 3),
  ('Cereal Fitness', 8500, 7000, 60, 'Nestlé', 10, 10, 1),
  ('Cereal Corn Flakes', 7800, 6500, 75, 'Kellogg''s', 10, 10, 2),
  ('Galletas Saltín Queso', 2100, 1700, 140, 'Noel', 10, 10, 3),
  ('Galletas Festival Limón', 2300, 1800, 110, 'Noel', 10, 10, 1),
  ('Maní Natural 100g', 3700, 3000, 70, 'Zenú', 10, 10, 2),
  ('Galletas Tosh Chía', 3500, 2800, 80, 'Tosh', 10, 10, 3),
  ('Galletas Festival Fresa', 2300, 1800, 110, 'Noel', 10, 10, 1),
  ('Galletas Festival Coco', 2300, 1800, 110, 'Noel', 10, 10, 2),
  ('Galletas Festival Mora', 2300, 1800, 110, 'Noel', 10, 10, 3),
  ('Galletas Festival Naranja', 2300, 1800, 110, 'Noel', 10, 10, 1),
  ('Galletas Festival Chocolate Blanco', 2300, 1800, 110, 'Noel', 10, 10, 2),
  ('Gaseosa Colombiana 1.5L', 3700, 3000, 90, 'Postobón', 3, 3, 1),
  ('Gaseosa Manzana 1.5L', 3700, 3000, 90, 'Postobón', 3, 3, 2),
  ('Gaseosa Uva 1.5L', 3700, 3000, 90, 'Postobón', 3, 3, 3),
  ('Gaseosa Pepsi 1.5L', 3700, 3000, 90, 'Pepsi', 3, 3, 1),
  ('Gaseosa Pepsi 600ml', 2500, 2000, 80, 'Pepsi', 3, 3, 2),
  ('Café Sello Rojo 250g', 7800, 6500, 75, 'Sello Rojo', 3, 3, 1),
  ('Café Águila Roja 250g', 7900, 6600, 70, 'Águila Roja', 3, 3, 2),
  ('Café Juan Valdez 250g', 12000, 10000, 60, 'Juan Valdez', 3, 3, 3),
  ('Café La Bastilla 250g', 7500, 6200, 65, 'La Bastilla', 3, 3, 1),
  ('Servilletas Familia x100', 3500, 2800, 100, 'Familia', 8, 8, 2),
  ('Servilletas Suavel x100', 3200, 2500, 90, 'Suavel', 8, 8, 3),
  ('Salchicha Ranchera x10', 9500, 8000, 60, 'Ranchera', 4, 4, 1),
  ('Salchicha Zenú x10', 9000, 7500, 70, 'Zenú', 4, 4, 2),
  ('Salchicha Pietrán x10', 9800, 8200, 50, 'Pietrán', 4, 4, 3),
  ('Papas Margarita Natural 30g', 1800, 1500, 120, 'Margarita', 10, 10, 1),
  ('Papas Margarita Limón 30g', 1800, 1500, 110, 'Margarita', 10, 10, 2),
  ('Papas Margarita BBQ 30g', 1800, 1500, 100, 'Margarita', 10, 10, 3),
  ('Papas Margarita Pollo 30g', 1800, 1500, 90, 'Margarita', 10, 10, 1),
  ('Papas Margarita Limón 105g', 3500, 2800, 80, 'Margarita', 10, 10, 2),
  ('Papas Margarita Natural 105g', 3500, 2800, 80, 'Margarita', 10, 10, 3);

-- Insertar 10 tiendas reales
INSERT INTO tienda (nombre, direccion) VALUES
  ('MiniMarket Central', 'Calle 123 #45-67'),
  ('MiniMarket Norte', 'Carrera 10 #20-30'),
  ('MiniMarket Sur', 'Avenida 15 #50-60'),
  ('MiniMarket Este', 'Diagonal 22 #33-44'),
  ('MiniMarket Oeste', 'Transversal 5 #12-34'),
  ('MiniMarket El Ahorro', 'Calle 50 #10-20'),
  ('MiniMarket La Esquina', 'Carrera 8 #18-25'),
  ('MiniMarket Doña Marta', 'Calle 80 #25-40'),
  ('MiniMarket San Juan', 'Avenida 68 #90-12'),
  ('MiniMarket El Centro', 'Calle 13 #5-10');

-- Insertar teléfonos para las tiendas
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
-- Insertar 20 promociones (10 de descuento, 10 de 2x1)
INSERT INTO promociones (nombre, tipo, descuento, fecha_inicio, fecha_fin) VALUES
  ('Descuento Lácteos', 'Descuento', 10.00, '2025-09-01', '2025-09-30'),
  ('Descuento Panadería', 'Descuento', 15.00, '2025-09-01', '2025-09-30'),
  ('Descuento Bebidas', 'Descuento', 20.00, '2025-09-01', '2025-09-30'),
  ('Descuento Abarrotes', 'Descuento', 12.00, '2025-09-01', '2025-09-30'),
  ('Descuento Carnes', 'Descuento', 18.00, '2025-09-01', '2025-09-30'),
  ('Descuento Frutas', 'Descuento', 8.00, '2025-09-01', '2025-09-30'),
  ('Descuento Verduras', 'Descuento', 9.00, '2025-09-01', '2025-09-30'),
  ('Descuento Limpieza', 'Descuento', 14.00, '2025-09-01', '2025-09-30'),
  ('Descuento Cuidado Personal', 'Descuento', 11.00, '2025-09-01', '2025-09-30'),
  ('Descuento Snacks', 'Descuento', 13.00, '2025-09-01', '2025-09-30'),
  ('2x1 Lácteos', '2x1', 0.00, '2025-09-10', '2025-09-20'),
  ('2x1 Panadería', '2x1', 0.00, '2025-09-10', '2025-09-20'),
  ('2x1 Bebidas', '2x1', 0.00, '2025-09-10', '2025-09-20'),
  ('2x1 Abarrotes', '2x1', 0.00, '2025-09-10', '2025-09-20'),
  ('2x1 Carnes', '2x1', 0.00, '2025-09-10', '2025-09-20'),
  ('2x1 Frutas', '2x1', 0.00, '2025-09-10', '2025-09-20'),
  ('2x1 Verduras', '2x1', 0.00, '2025-09-10', '2025-09-20'),
  ('2x1 Limpieza', '2x1', 0.00, '2025-09-10', '2025-09-20'),
  ('2x1 Cuidado Personal', '2x1', 0.00, '2025-09-10', '2025-09-20'),
  ('2x1 Snacks', '2x1', 0.00, '2025-09-10', '2025-09-20');

-- Asociar productos a promociones (primeros productos de cada categoría)
-- Suponiendo que los primeros 10 productos tienen id_producto del 1 al 10
INSERT INTO producto_promocion (id_promocion, id_producto) VALUES
  (1, 1), (2, 2), (3, 3), (4, 4), (5, 5), (6, 6), (7, 7), (8, 8), (9, 9), (10, 10),
  (11, 1), (12, 2), (13, 3), (14, 4), (15, 5), (16, 6), (17, 7), (18, 8), (19, 9), (20, 10);

INSERT INTO empleados (nombre, direccion, fecha_contratacion, cargo, email, salario, id_tienda) VALUES
-- 4 empleados por cada tienda (40 en total)
INSERT INTO empleados (nombre, direccion, fecha_contratacion, cargo, email, salario, id_tienda) VALUES
  -- Tienda 1
  ('Juan Pérez', 'Calle 10 #5-20', '2022-01-15', 'Cajero', 'juan.perez1@minimarket.com', 1800000, 1),
  ('Laura Torres', 'Calle 11 #6-21', '2022-03-10', 'Auxiliar', 'laura.torres1@minimarket.com', 1600000, 1),
  ('Pedro Gómez', 'Calle 12 #7-22', '2023-02-05', 'Administrador', 'pedro.gomez1@minimarket.com', 2500000, 1),
  ('Sandra Ruiz', 'Calle 13 #8-23', '2021-12-20', 'Cajero', 'sandra.ruiz1@minimarket.com', 1800000, 1),
  -- Tienda 2
  ('María Gómez', 'Carrera 8 #12-34', '2021-11-10', 'Administrador', 'maria.gomez2@minimarket.com', 2500000, 2),
  ('Andrés López', 'Carrera 9 #13-35', '2022-04-12', 'Auxiliar', 'andres.lopez2@minimarket.com', 1600000, 2),
  ('Paola Díaz', 'Carrera 10 #14-36', '2023-01-18', 'Cajero', 'paola.diaz2@minimarket.com', 1800000, 2),
  ('Javier Castro', 'Carrera 11 #15-37', '2022-06-25', 'Cajero', 'javier.castro2@minimarket.com', 1800000, 2),
  -- Tienda 3
  ('Carlos Rodríguez', 'Avenida 15 #50-60', '2023-03-01', 'Auxiliar', 'carlos.rodriguez3@minimarket.com', 1600000, 3),
  ('Diana Herrera', 'Avenida 16 #51-61', '2022-05-15', 'Cajero', 'diana.herrera3@minimarket.com', 1800000, 3),
  ('Felipe Ramírez', 'Avenida 17 #52-62', '2021-10-30', 'Administrador', 'felipe.ramirez3@minimarket.com', 2500000, 3),
  ('Natalia Peña', 'Avenida 18 #53-63', '2022-08-22', 'Auxiliar', 'natalia.pena3@minimarket.com', 1600000, 3),
  -- Tienda 4
  ('Ana Torres', 'Calle 80 #25-40', '2022-07-20', 'Cajero', 'ana.torres4@minimarket.com', 1800000, 4),
  ('Miguel Suárez', 'Calle 81 #26-41', '2023-02-14', 'Auxiliar', 'miguel.suarez4@minimarket.com', 1600000, 4),
  ('Camila Vargas', 'Calle 82 #27-42', '2021-09-18', 'Administrador', 'camila.vargas4@minimarket.com', 2500000, 4),
  ('Oscar Ruiz', 'Calle 83 #28-43', '2022-11-11', 'Cajero', 'oscar.ruiz4@minimarket.com', 1800000, 4),
  -- Tienda 5
  ('Luis Martínez', 'Diagonal 22 #33-44', '2021-09-05', 'Administrador', 'luis.martinez5@minimarket.com', 2500000, 5),
  ('Valentina Ríos', 'Diagonal 23 #34-45', '2022-10-09', 'Auxiliar', 'valentina.rios5@minimarket.com', 1600000, 5),
  ('Sergio Castro', 'Diagonal 24 #35-46', '2023-03-21', 'Cajero', 'sergio.castro5@minimarket.com', 1800000, 5),
  ('Lucía Peña', 'Diagonal 25 #36-47', '2022-01-27', 'Cajero', 'lucia.pena5@minimarket.com', 1800000, 5),
  -- Tienda 6
  ('Paula Ramírez', 'Transversal 5 #12-34', '2023-02-10', 'Auxiliar', 'paula.ramirez6@minimarket.com', 1600000, 6),
  ('David Gómez', 'Transversal 6 #13-35', '2022-07-13', 'Cajero', 'david.gomez6@minimarket.com', 1800000, 6),
  ('Andrea Torres', 'Transversal 7 #14-36', '2021-11-29', 'Administrador', 'andrea.torres6@minimarket.com', 2500000, 6),
  ('Manuel Díaz', 'Transversal 8 #15-37', '2022-03-19', 'Auxiliar', 'manuel.diaz6@minimarket.com', 1600000, 6),
  -- Tienda 7
  ('Jorge Herrera', 'Calle 50 #10-20', '2022-05-18', 'Cajero', 'jorge.herrera7@minimarket.com', 1800000, 7),
  ('Sara Ruiz', 'Calle 51 #11-21', '2023-01-07', 'Auxiliar', 'sara.ruiz7@minimarket.com', 1600000, 7),
  ('Esteban Castro', 'Calle 52 #12-22', '2021-08-16', 'Administrador', 'esteban.castro7@minimarket.com', 2500000, 7),
  ('Mónica Peña', 'Calle 53 #13-23', '2022-09-30', 'Cajero', 'monica.pena7@minimarket.com', 1800000, 7),
  -- Tienda 8
  ('Sofía Castro', 'Carrera 10 #20-30', '2021-12-12', 'Administrador', 'sofia.castro8@minimarket.com', 2500000, 8),
  ('Tomás Ramírez', 'Carrera 11 #21-31', '2022-06-16', 'Auxiliar', 'tomas.ramirez8@minimarket.com', 1600000, 8),
  ('Gabriela Gómez', 'Carrera 12 #22-32', '2023-04-28', 'Cajero', 'gabriela.gomez8@minimarket.com', 1800000, 8),
  ('Martín Díaz', 'Carrera 13 #23-33', '2022-02-23', 'Cajero', 'martin.diaz8@minimarket.com', 1800000, 8),
  -- Tienda 9
  ('Ricardo Peña', 'Avenida 68 #90-12', '2023-04-03', 'Auxiliar', 'ricardo.pena9@minimarket.com', 1600000, 9),
  ('Daniela Torres', 'Avenida 69 #91-13', '2022-08-02', 'Cajero', 'daniela.torres9@minimarket.com', 1800000, 9),
  ('Alejandro Ruiz', 'Avenida 70 #92-14', '2021-10-11', 'Administrador', 'alejandro.ruiz9@minimarket.com', 2500000, 9),
  ('Camilo Herrera', 'Avenida 71 #93-15', '2022-12-05', 'Auxiliar', 'camilo.herrera9@minimarket.com', 1600000, 9),
  -- Tienda 10
  ('Gloria Suárez', 'Calle 13 #5-10', '2022-08-25', 'Cajero', 'gloria.suarez10@minimarket.com', 1800000, 10),
  ('Marcos Gómez', 'Calle 14 #6-11', '2023-03-15', 'Auxiliar', 'marcos.gomez10@minimarket.com', 1600000, 10),
  ('Patricia Díaz', 'Calle 15 #7-12', '2021-09-28', 'Administrador', 'patricia.diaz10@minimarket.com', 2500000, 10),
  ('Elena Ramírez', 'Calle 16 #8-13', '2022-11-03', 'Cajero', 'elena.ramirez10@minimarket.com', 1800000, 10);