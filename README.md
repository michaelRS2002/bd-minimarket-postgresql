# Base de Datos MiniMarket - PostgreSQL

## 📊 Descripción General

Base de datos completa de un sistema de minimarket con datos masivos y realistas para análisis, reportería y práctica con Power BI. Contiene información detallada de 100 tiendas, miles de productos, empleados, clientes y transacciones.

## 🗄️ Estructura de la Base de Datos

### Tablas Principales

| Tabla | Registros | Descripción |
|-------|-----------|-------------|
| tienda | 100 | Tiendas distribuidas en diferentes ciudades |
| empleados | 500 | Personal (5 empleados por tienda) |
| clientes | 2,000 | Base de clientes con emails únicos |
| productos | 10,000 | Productos con 10 marcas diferentes |
| ventas | 15,000 | Transacciones (Sept 2023 - Sept 2025) |
| detalle_venta | ~47,600 | Líneas de detalle (promedio 3.17 productos/venta) |
| promociones | 20 | Ofertas activas (10 descuentos, 10 2x1) |
| producto_promocion | 800 | Relaciones producto-promoción |
| categoria | 10 | Categorías de productos |
| proveedores | 50 | Proveedores de productos |

### Esquema Relacional

```
tienda (1) ──< (N) empleados
tienda (1) ──< (N) telefono_tienda
tienda (1) ──< (N) productos

clientes (1) ──< (N) ventas
ventas (1) ──< (N) detalle_venta
productos (1) ──< (N) detalle_venta

categoria (1) ──< (N) productos
proveedores (1) ──< (N) productos
proveedores (1) ──< (N) telefono_proveedor

promociones (1) ──< (N) producto_promocion ──> (N) productos
```

## 🚀 Instalación y Uso

### Requisitos Previos
- Docker Desktop instalado
- Cliente de PostgreSQL (psql) instalado
- Git (opcional)

### Opción 1: Con Docker (Recomendado)

1) Levantar los servicios

```powershell
docker-compose up -d
```

Esto iniciará:
- PostgreSQL 17.6 en localhost:5432 (usuario postgres, contraseña super123)
- pgAdmin 4 en http://localhost:5050 (email admin@admin.com, contraseña admin123)
- La base de datos minimarket se crea automáticamente y ejecuta init.sql en el primer arranque

2) Reiniciar datos (opcional)

```powershell
# Limpiar y recrear el esquema
psql -h localhost -U postgres -d minimarket -c "DROP SCHEMA public CASCADE; CREATE SCHEMA public;"

# Ejecutar el script completo
psql -h localhost -U postgres -d minimarket -f init.sql
```

3) Conectarte desde pgAdmin
- URL: http://localhost:5050
- Email: admin@admin.com
- Contraseña: admin123
- En Add New Server → Connection, usa Host name/address: postgres, Port: 5432, Username: postgres, Password: super123

### Opción 2: PostgreSQL Local (sin Docker)

1) Crear la base de datos

```powershell
psql -h localhost -U postgres
CREATE DATABASE minimarket;
\q
```

2) Cargar datos

```powershell
psql -h localhost -U postgres -d minimarket -f init.sql
```

## 🔌 Conexión (Power BI u otras herramientas)
- Servidor: localhost
- Base de datos: minimarket
- Usuario: postgres
- Contraseña: super123 (o tu contraseña local)

## 📊 Consultas Útiles

Resumen general de conteos
```sql
SELECT 'tiendas' tabla, COUNT(*) registros FROM tienda
UNION ALL SELECT 'empleados', COUNT(*) FROM empleados
UNION ALL SELECT 'clientes', COUNT(*) FROM clientes
UNION ALL SELECT 'productos', COUNT(*) FROM productos
UNION ALL SELECT 'ventas', COUNT(*) FROM ventas
UNION ALL SELECT 'detalle_venta', COUNT(*) FROM detalle_venta
ORDER BY tabla;
```

Top 10 productos más vendidos
```sql
SELECT p.nombre_producto,
       COUNT(dv.id_detalle) AS veces_vendido,
       SUM(dv.cantidad) AS cantidad_total,
       SUM(dv.precio_unitario * dv.cantidad) AS ingresos_totales
FROM detalle_venta dv
JOIN productos p ON dv.id_producto = p.id_producto
GROUP BY p.nombre_producto
ORDER BY cantidad_total DESC
LIMIT 10;
```

Ventas por mes
```sql
SELECT TO_CHAR(fecha_transaccion, 'YYYY-MM') AS mes,
       COUNT(*) AS num_ventas,
       SUM(monto_total) AS monto_total
FROM ventas
GROUP BY mes
ORDER BY mes;
```

Top 10 tiendas por ventas
```sql
SELECT t.nombre_tienda,
       t.ciudad,
       COUNT(v.id_venta) AS num_ventas,
       SUM(v.monto_total) AS ventas_totales
FROM tienda t
JOIN productos p ON t.id_tienda = p.id_tienda
JOIN detalle_venta dv ON p.id_producto = dv.id_producto
JOIN ventas v ON dv.id_venta = v.id_venta
GROUP BY t.nombre_tienda, t.ciudad
ORDER BY ventas_totales DESC
LIMIT 10;
```

## 🛠️ Mantenimiento (Docker)

Detener servicios
```powershell
docker-compose down
```

Ver logs de Postgres
```powershell
docker-compose logs -f postgres_super
```

Recrear contenedores y datos
```powershell
docker-compose down -v
docker-compose up -d
```

Backup y restore
```powershell
pg_dump -h localhost -U postgres -d minimarket > backup_minimarket.sql
psql   -h localhost -U postgres -d minimarket < backup_minimarket.sql
```

## 📝 Notas Técnicas
- Encoding: UTF-8
- Motor: PostgreSQL 17.6 (imagen docker postgres:17.6)
- Generación de datos: generate_series, LATERAL y PL/pgSQL
- Integridad referencial: todas las foreign keys validadas
- Índices: en columnas de búsqueda frecuente
- Tiempo de generación: ~10-15 segundos

## 🤝 Autor
Michael Rodriguez  
GitHub: @michaelRS2002  
Repo: https://github.com/michaelRS2002/bd-minimarket-postgresql

## 📄 Licencia
Proyecto bajo Licencia MIT.

---
Si te resultó útil este proyecto, dale una estrella en GitHub.
