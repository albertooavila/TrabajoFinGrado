# Puesta en marcha local

1. Instala Visual Studio con soporte para ASP.NET / .NET Framework.
2. Instala SQL Server Express, Developer o LocalDB.
3. Ejecuta `database/database.sql` en SQL Server Management Studio.
4. Edita `CapaPresentacionAdmin/Web.config` y `CapaPresentaciomTienda/Web.config`.
5. Sustituye `YOUR_SQL_SERVER` por la instancia local.
6. Las credenciales PayPal/SMTP son opcionales para navegar por la aplicación; no incluyas secretos reales en GitHub.
7. Abre `TrabajoTFG.sln`.
8. Restaura los paquetes NuGet.
9. Ejecuta el proyecto de tienda o administración.

## Acceso demo

- Admin: `admin@demo.local` / `Admin123!`
- Cliente: `cliente@demo.local` / `Demo123!`

La base de datos es una reconstrucción compatible creada para la versión de portfolio.
