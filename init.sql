
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

-- CLIENTES
CREATE TABLE clientes (
    cc_cliente VARCHAR(20) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(100) UNIQUE
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

-- PROMOCIONES
CREATE TABLE promociones (
    id_promocion SERIAL PRIMARY KEY,
    nombre VARCHAR(100),
    tipo VARCHAR(50),
    descuento NUMERIC(5,2),
    fecha_inicio DATE,
    fecha_fin DATE
);

-- PRODUCTO_PROMOCION
CREATE TABLE producto_promocion (
    id_producto_promocion SERIAL PRIMARY KEY,
    id_promocion INT NOT NULL,
    id_producto INT NOT NULL,
    FOREIGN KEY (id_promocion) REFERENCES promociones(id_promocion),
    FOREIGN KEY (id_producto) REFERENCES productos(id_producto)
);

-- ===========================
-- ÍNDICES SUGERIDOS PARA CONSULTAS FRECUENTES
-- ===========================
CREATE INDEX idx_clientes_email ON clientes(correo);
CREATE INDEX idx_proveedores_email ON proveedores(email);
CREATE INDEX idx_productos_nombre ON productos(nombre);
