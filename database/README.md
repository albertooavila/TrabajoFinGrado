# Base de datos reconstruida

La base de datos original del TFG no se conservaba. `database.sql` ha sido **reconstruido a partir de la capa de acceso a datos del proyecto** para que la versión de portfolio pueda volver a ejecutarse.

No se presenta como una copia exacta de la base original: reproduce las tablas, relaciones, funciones, tipo de tabla y procedimientos almacenados que el código C# espera utilizar.

## Instalación

1. Abre SQL Server Management Studio.
2. Conéctate a SQL Server.
3. Ejecuta `database.sql`.
4. En los dos `Web.config`, sustituye `YOUR_SQL_SERVER` por tu instancia.

Ejemplos: `(localdb)\\MSSQLLocalDB`, `.\\SQLEXPRESS` o `localhost`.

## Datos demo

- Administrador: `admin@demo.local` / `Admin123!`
- Cliente: `cliente@demo.local` / `Demo123!`

Estas cuentas son solo para desarrollo/portfolio.

## Objetos reconstruidos

Tablas de usuarios, clientes, catálogo, carrito, ubicaciones y ventas; claves foráneas; `DetalleVentaType`; procedimientos CRUD; carrito; registro de ventas; historial; reporting y dashboard.

## Corrección asociada

Durante la reconstrucción se corrigió una inconsistencia original en `CD_Ubicacion.cs`: se intentaba leer `IdDescripcion` al cargar un distrito, aunque el modelo y el resto de la aplicación utilizan `IdDistrito`.
