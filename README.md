# MiniMarket - Entorno de Base de Datos con Docker

Este proyecto contiene todo lo necesario para levantar una base de datos PostgreSQL y una interfaz de administración pgAdmin usando Docker.

## Requisitos previos
- Tener instalado [Docker Desktop](https://www.docker.com/products/docker-desktop/) y ejecutándolo en tu equipo.
- (Opcional) Tener instalado [Visual Studio Code](https://code.visualstudio.com/) para editar archivos y usar extensiones como SQLTools.

## Instrucciones

1. **Clona o descarga este repositorio en tu equipo.**

2. **Asegúrate de que Docker Desktop esté abierto y corriendo.**

3. **Abre una terminal en la carpeta del proyecto y ejecuta:**

   ```powershell
   docker-compose up -d
   ```
   Esto descargará las imágenes necesarias y levantará dos servicios:
   - `postgres`: Base de datos PostgreSQL con la base `minimarket` y las tablas iniciales.
   - `pgadmin`: Interfaz web para administrar la base de datos.

4. **Accede a pgAdmin desde tu navegador:**
   - URL: [http://localhost:5050](http://localhost:5050)
   - Email: `admin@admin.com`
   - Contraseña: `admin123`

5. **Agregar el servidor en pgAdmin:**
   - Haz clic en "Add New Server".
   - En la pestaña "General":
     - Name: `minimarket`
   - En la pestaña "Connection":
     - Host name/address: `postgres`
     - Port: `5432`
     - Username: `postgres`
     - Password: `super123`
   - Haz clic en "Save".

6. **¡Listo!**
   - Ya puedes ver y administrar la base de datos minimarket y sus tablas desde pgAdmin.

## Notas
- Si necesitas reiniciar todo desde cero (borrar datos y volver a crear la base), ejecuta:
  ```powershell
  docker-compose down -v
  docker-compose up -d
  ```
- El archivo `init.sql` contiene la estructura inicial de la base de datos.
- Si tienes dudas, consulta este README o pregunta a tu compañero responsable del entorno.

---

¡Feliz desarrollo!