# Base de Datos MiniMarket - PostgreSQL# Base de Datos MiniMarket - PostgreSQL# MiniMarket - Entorno de Base de Datos con Docker



## 📊 Descripción General



Base de datos completa de un sistema de minimarket con **datos masivos y realistas** para análisis, reportería y práctica con Power BI. Contiene información detallada de 100 tiendas, miles de productos, empleados, clientes y transacciones.## 📊 Descripción GeneralEste proyecto contiene todo lo necesario para levantar una base de datos PostgreSQL y una interfaz de administración pgAdmin usando Docker.



## 🗄️ Estructura de la Base de Datos



### Tablas PrincipalesBase de datos completa de un sistema de minimarket con **datos masivos y realistas** para análisis, reportería y práctica con Power BI. Contiene información detallada de 100 tiendas, miles de productos, empleados, clientes y transacciones.## Requisitos previos



| Tabla | Registros | Descripción |- Tener instalado [Docker Desktop](https://www.docker.com/products/docker-desktop/) y ejecutándolo en tu equipo.

|-------|-----------|-------------|

| **tienda** | 100 | Tiendas distribuidas en diferentes ciudades |## 🗄️ Estructura de la Base de Datos- (Opcional) Tener instalado [Visual Studio Code](https://code.visualstudio.com/) para editar archivos y usar extensiones como SQLTools.

| **empleados** | 500 | Personal (5 empleados por tienda) |

| **clientes** | 2,000 | Base de clientes con emails únicos |

| **productos** | 10,000 | Productos con 10 marcas diferentes |

| **ventas** | 15,000 | Transacciones (Sept 2023 - Sept 2025) |### Tablas Principales## Instrucciones

| **detalle_venta** | ~47,600 | Líneas de detalle (promedio 3.17 productos/venta) |

| **promociones** | 20 | Ofertas activas (10 descuentos, 10 2x1) |

| **producto_promocion** | 800 | Relaciones producto-promoción |

| **categoria** | 10 | Categorías de productos || Tabla | Registros | Descripción |1. **Clona o descarga este repositorio en tu equipo.**

| **proveedores** | 50 | Proveedores de productos |

|-------|-----------|-------------|

### Esquema Relacional

| **tienda** | 100 | Tiendas distribuidas en diferentes ciudades |2. **Asegúrate de que Docker Desktop esté abierto y corriendo.**

```

tienda (1) ──< (N) empleados| **empleados** | 500 | Personal (5 empleados por tienda) |

tienda (1) ──< (N) telefono_tienda

tienda (1) ──< (N) productos| **clientes** | 2,000 | Base de clientes con emails únicos |3. **Abre una terminal en la carpeta del proyecto y ejecuta:**



clientes (1) ──< (N) ventas| **productos** | 10,000 | Productos con 10 marcas diferentes |

ventas (1) ──< (N) detalle_venta

productos (1) ──< (N) detalle_venta| **ventas** | 15,000 | Transacciones (Sept 2023 - Sept 2025) |   ```powershell



categoria (1) ──< (N) productos| **detalle_venta** | ~47,600 | Líneas de detalle (promedio 3.17 productos/venta) |   docker-compose up -d

proveedores (1) ──< (N) productos

proveedores (1) ──< (N) telefono_proveedor| **promociones** | 20 | Ofertas activas (10 descuentos, 10 2x1) |   ```



promociones (1) ──< (N) producto_promocion ──> (N) productos| **producto_promocion** | 800 | Relaciones producto-promoción |   Esto descargará las imágenes necesarias y levantará dos servicios:

```

| **categoria** | 10 | Categorías de productos |   - `postgres`: Base de datos PostgreSQL con la base `minimarket` y las tablas iniciales.

## 🚀 Instalación y Uso

| **proveedores** | 50 | Proveedores de productos |   - `pgadmin`: Interfaz web para administrar la base de datos.

### Requisitos Previos

- Docker Desktop instalado

- PostgreSQL client (psql) instalado

- Git (opcional)### Esquema Relacional4. **Accede a pgAdmin desde tu navegador:**



### Opción 1: Con Docker (Recomendado)   - URL: [http://localhost:5050](http://localhost:5050)



#### 1. Levantar los Servicios```   - Email: `admin@admin.com`



```powershelltienda (1) ──< (N) empleados   - Contraseña: `admin123`

docker-compose up -d

```tienda (1) ──< (N) telefono_tienda



Esto iniciará:tienda (1) ──< (N) productos5. **Agregar el servidor en pgAdmin:**

- **PostgreSQL 17.2** en `localhost:5432`

- **pgAdmin 4** en `http://localhost:5050`   - Haz clic en "Add New Server".

- La base de datos `minimarket` se crea automáticamente

clientes (1) ──< (N) ventas   - En la pestaña "General":

#### 2. Inicializar la Base de Datos

ventas (1) ──< (N) detalle_venta     - Name: `minimarket`

El script `init.sql` se ejecuta automáticamente. Si necesitas reiniciar:

productos (1) ──< (N) detalle_venta   - En la pestaña "Connection":

```powershell

# Limpiar y recrear     - Host name/address: `postgres`

psql -h localhost -U postgres -d minimarket -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;"

categoria (1) ──< (N) productos     - Port: `5432`

# Ejecutar script completo

psql -h localhost -U postgres -d minimarket -f init.sqlproveedores (1) ──< (N) productos     - Username: `postgres`

```

proveedores (1) ──< (N) telefono_proveedor     - Password: `super123`

### Opción 2: PostgreSQL Local (Sin Docker)

   - Haz clic en "Save".

Si ya tienes PostgreSQL instalado localmente:

promociones (1) ──< (N) producto_promocion ──> (N) productos

#### 1. Crear la Base de Datos

```6. **¡Listo!**

```powershell

# Conectar a PostgreSQL   - Ya puedes ver y administrar la base de datos minimarket y sus tablas desde pgAdmin.

psql -h localhost -U postgres

## 🚀 Instalación y Uso

# Crear la base de datos

CREATE DATABASE minimarket;## Notas



# Salir### Requisitos Previos- Si necesitas reiniciar todo desde cero (borrar datos y volver a crear la base), ejecuta:

\q

```- Docker Desktop instalado  ```powershell



#### 2. Ejecutar el Script de Inicialización- Git (opcional)  docker-compose down -v



```powershell  docker-compose up -d

psql -h localhost -U postgres -d minimarket -f init.sql

```### 1. Levantar los Servicios  ```



### 3. Credenciales- El archivo `init.sql` contiene la estructura inicial de la base de datos.



**PostgreSQL:**```powershell- Si tienes dudas, consulta este README o pregunta a tu compañero responsable del entorno.

- Host: `localhost`

- Puerto: `5432`docker-compose up -d

- Base de datos: `minimarket`

- Usuario: `postgres````---

- Contraseña: `super123` (Docker) o tu contraseña local

Esto iniciará:

**pgAdmin (solo con Docker):**- **PostgreSQL 17.2** en `localhost:5432`

- URL: `http://localhost:5050`- **pgAdmin 4** en `http://localhost:5050`

- Email: `admin@admin.com`

- Contraseña: `admin`### 2. Inicializar la Base de Datos



## 📈 Características de los DatosEl script `init.sql` se ejecuta automáticamente al crear el contenedor. Si necesitas reiniciar:



### Distribución de Ventas```powershell

- **30%** de ventas pequeñas (1-2 productos)# Limpiar y recrear

- **40%** de ventas medianas (2-4 productos)psql -h localhost -U postgres -d minimarket -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;"

- **30%** de ventas grandes (4-8 productos)

# Ejecutar script completo

### Productospsql -h localhost -U postgres -d minimarket -f init.sql

- 10 marcas diferentes: Colgate, Nestle, Dove, Coca-Cola, Lays, Alpina, Ramo, Noel, Claro, Samsung```

- Distribuidos equitativamente en 10 categorías

- Precios realistas en pesos colombianos (COP)### 3. Credenciales



### Tiendas**PostgreSQL:**

- 100 tiendas en 20 ciudades diferentes- Host: `localhost`

- 5 empleados por tienda (Gerente, Cajero, Vendedor, Seguridad, Limpieza)- Puerto: `5432`

- Base de datos: `minimarket`

### Rango de Fechas- Usuario: `postgres`

- **Ventas:** Septiembre 2023 - Septiembre 2025 (2 años)- Contraseña: `super123`

- **Promociones:** 2023-2024

**pgAdmin:**

## 🔌 Conexión con Power BI- URL: `http://localhost:5050`

- Email: `admin@admin.com`

1. En Power BI Desktop: **Obtener datos** → **PostgreSQL**- Contraseña: `admin`

2. Ingresar:

   - Servidor: `localhost`## 📈 Características de los Datos

   - Base de datos: `minimarket`

3. Usar credenciales:### Distribución de Ventas

   - Usuario: `postgres`- **30%** de ventas pequeñas (1-2 productos)

   - Contraseña: `super123` (o tu contraseña local)- **40%** de ventas medianas (2-4 productos)

- **30%** de ventas grandes (4-8 productos)

## 📊 Consultas Útiles

### Productos

### Resumen General- 10 marcas diferentes: Colgate, Nestle, Dove, Coca-Cola, Lays, Alpina, Ramo, Noel, Claro, Samsung

```sql- Distribuidos equitativamente en 10 categorías

SELECT - Precios realistas en pesos colombianos (COP)

  'tiendas' as tabla, COUNT(*) as registros FROM tienda

UNION ALL SELECT 'empleados', COUNT(*) FROM empleados### Tiendas

UNION ALL SELECT 'clientes', COUNT(*) FROM clientes- 100 tiendas en 20 ciudades diferentes

UNION ALL SELECT 'productos', COUNT(*) FROM productos- 5 empleados por tienda (Gerente, Cajero, Vendedor, Seguridad, Limpieza)

UNION ALL SELECT 'ventas', COUNT(*) FROM ventas

UNION ALL SELECT 'detalle_venta', COUNT(*) FROM detalle_venta### Rango de Fechas

ORDER BY tabla;- **Ventas:** Septiembre 2023 - Septiembre 2025 (2 años)

```- **Promociones:** 2023-2024



### Top 10 Productos Más Vendidos## 🔌 Conexión con Power BI

```sql

SELECT 1. En Power BI Desktop: **Obtener datos** → **PostgreSQL**

  p.nombre_producto,2. Ingresar:

  COUNT(dv.id_detalle) as veces_vendido,   - Servidor: `localhost`

  SUM(dv.cantidad) as cantidad_total,   - Base de datos: `minimarket`

  SUM(dv.precio_unitario * dv.cantidad) as ingresos_totales3. Usar credenciales:

FROM detalle_venta dv   - Usuario: `postgres`

JOIN productos p ON dv.id_producto = p.id_producto   - Contraseña: `super123`

GROUP BY p.nombre_producto

ORDER BY cantidad_total DESC## 📊 Consultas Útiles

LIMIT 10;

```### Resumen General

```sql

### Ventas por MesSELECT 

```sql  'tiendas' as tabla, COUNT(*) as registros FROM tienda

SELECT UNION ALL SELECT 'empleados', COUNT(*) FROM empleados

  TO_CHAR(fecha_transaccion, 'YYYY-MM') as mes,UNION ALL SELECT 'clientes', COUNT(*) FROM clientes

  COUNT(*) as num_ventas,UNION ALL SELECT 'productos', COUNT(*) FROM productos

  SUM(monto_total) as monto_totalUNION ALL SELECT 'ventas', COUNT(*) FROM ventas

FROM ventasUNION ALL SELECT 'detalle_venta', COUNT(*) FROM detalle_venta

GROUP BY mesORDER BY tabla;

ORDER BY mes;```

```

### Top 10 Productos Más Vendidos

### Top 10 Tiendas por Ventas```sql

```sqlSELECT 

SELECT   p.nombre_producto,

  t.nombre_tienda,  COUNT(dv.id_detalle) as veces_vendido,

  t.ciudad,  SUM(dv.cantidad) as cantidad_total,

  COUNT(v.id_venta) as num_ventas,  SUM(dv.precio_unitario * dv.cantidad) as ingresos_totales

  SUM(v.monto_total) as ventas_totalesFROM detalle_venta dv

FROM tienda tJOIN productos p ON dv.id_producto = p.id_producto

JOIN productos p ON t.id_tienda = p.id_tiendaGROUP BY p.nombre_producto

JOIN detalle_venta dv ON p.id_producto = dv.id_productoORDER BY cantidad_total DESC

JOIN ventas v ON dv.id_venta = v.id_ventaLIMIT 10;

GROUP BY t.nombre_tienda, t.ciudad```

ORDER BY ventas_totales DESC

LIMIT 10;### Ventas por Mes

``````sql

SELECT 

## 🛠️ Mantenimiento  TO_CHAR(fecha_transaccion, 'YYYY-MM') as mes,

  COUNT(*) as num_ventas,

### Detener los Servicios (Docker)  SUM(monto_total) as monto_total

```powershellFROM ventas

docker-compose downGROUP BY mes

```ORDER BY mes;

```

### Reiniciar desde Cero (Docker)

```powershell### Top 10 Tiendas por Ventas

docker-compose down -v```sql

docker-compose up -dSELECT 

```  t.nombre_tienda,

  t.ciudad,

### Ver Logs (Docker)  COUNT(v.id_venta) as num_ventas,

```powershell  SUM(v.monto_total) as ventas_totales

docker-compose logs -f postgres_superFROM tienda t

```JOIN productos p ON t.id_tienda = p.id_tienda

JOIN detalle_venta dv ON p.id_producto = dv.id_producto

### Backup de la Base de DatosJOIN ventas v ON dv.id_venta = v.id_venta

```powershellGROUP BY t.nombre_tienda, t.ciudad

pg_dump -h localhost -U postgres -d minimarket > backup_minimarket.sqlORDER BY ventas_totales DESC

```LIMIT 10;

```

### Restaurar desde Backup

```powershell## 🛠️ Mantenimiento

psql -h localhost -U postgres -d minimarket < backup_minimarket.sql

```### Detener los Servicios

```powershell

## 📝 Notas Técnicasdocker-compose down

```

- **Encoding:** UTF-8

- **Motor:** PostgreSQL 17.2### Ver Logs

- **Generación de Datos:** Scripts SQL con `generate_series`, `LATERAL`, y PL/pgSQL```powershell

- **Integridad Referencial:** Todas las foreign keys validadasdocker-compose logs -f postgres_super

- **Índices:** Creados en columnas de búsqueda frecuente```

- **Tiempo de Ejecución:** ~10-15 segundos para generar todos los datos

### Backup de la Base de Datos

## 🤝 Autor```powershell

pg_dump -h localhost -U postgres -d minimarket > backup_minimarket.sql

**Michael Rodriguez**```

- GitHub: [@michaelRS2002](https://github.com/michaelRS2002)

- Repositorio: [bd-minimarket-postgresql](https://github.com/michaelRS2002/bd-minimarket-postgresql)## 📝 Notas Técnicas



## 📄 Licencia- **Encoding:** UTF-8

- **Motor:** PostgreSQL 17.2

Este proyecto está bajo la Licencia MIT - ver el archivo LICENSE para más detalles.- **Generación de Datos:** Scripts SQL con `generate_series`, `LATERAL`, y PL/pgSQL

- **Integridad Referencial:** Todas las foreign keys validadas

---- **Índices:** Creados en columnas de búsqueda frecuente



⭐ Si te resultó útil este proyecto, ¡dale una estrella en GitHub!## 🤝 Autor


**Michael Rodriguez**
- GitHub: [@michaelRS2002](https://github.com/michaelRS2002)
- Repositorio: [bd-minimarket-postgresql](https://github.com/michaelRS2002/bd-minimarket-postgresql)

## 📄 Licencia

Este proyecto está bajo la Licencia MIT - ver el archivo LICENSE para más detalles.

---

⭐ Si te resultó útil este proyecto, ¡dale una estrella en GitHub!
