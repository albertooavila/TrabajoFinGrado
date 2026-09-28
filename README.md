# E-commerce ASP.NET MVC

Proyecto de comercio electrónico desarrollado como **Trabajo Final de Grado**, utilizando C#, ASP.NET MVC 5 y SQL Server. Incluye dos aplicaciones web: la tienda para clientes y un panel de administración.

> Este repositorio se publica como proyecto académico y de portfolio. La versión pública ha sido saneada para eliminar credenciales, rutas locales y archivos generados por Visual Studio.

## Funcionalidades

### Tienda

- registro e inicio de sesión de clientes;
- recuperación y cambio de contraseña;
- catálogo de productos;
- filtrado por categorías y marcas;
- detalle de producto;
- carrito de compra y gestión de cantidades;
- proceso de compra;
- integración con **PayPal Sandbox**;
- historial de compras.

### Administración

- autenticación de usuarios administradores;
- gestión de usuarios;
- gestión de productos e imágenes;
- gestión de categorías;
- gestión de marcas;
- dashboard;
- informes de ventas y exportación de datos.

## Tecnologías

- **C#**
- **ASP.NET MVC 5**
- **.NET Framework 4.7.2**
- **SQL Server**
- **ADO.NET**
- **HTML / CSS / JavaScript**
- **jQuery**
- **Bootstrap**
- **PayPal REST API (Sandbox)**
- **ClosedXML** para exportación de datos

## Arquitectura

El proyecto está dividido en capas:

```text
CapaPresentaciomTienda   ─┐
                         ├──> CapaNegocio ──> CapaDatos ──> SQL Server
CapaPresentacionAdmin   ─┘        │
                                  └──> CapaEntidad
```

- `CapaEntidad`: modelos de dominio.
- `CapaDatos`: acceso a SQL Server mediante ADO.NET y procedimientos almacenados.
- `CapaNegocio`: lógica de negocio y servicios auxiliares.
- `CapaPresentaciomTienda`: interfaz de la tienda.
- `CapaPresentacionAdmin`: panel de administración.

> Se mantiene el nombre original `CapaPresentaciomTienda` para evitar modificar los namespaces y referencias del proyecto académico.

## Configuración

### 1. Requisitos

- Windows
- Visual Studio 2019 o posterior
- .NET Framework 4.7.2 Developer Pack
- SQL Server / SQL Server Express
- NuGet

### 2. Restaurar paquetes

Abrir `TrabajoTFG.sln` en Visual Studio y restaurar los paquetes NuGet definidos en los archivos `packages.config`.

### 3. Base de datos

El código espera una base SQL Server llamada `DBCARRITO`.

La copia académica facilitada para preparar este repositorio no incluía el script o backup de la base de datos. Consulta [`database/README.md`](database/README.md) para conocer los procedimientos almacenados utilizados y cómo incorporar el script original si está disponible.

### 4. Cadena de conexión

Configurar `cadena` en:

- `CapaPresentaciomTienda/Web.config`
- `CapaPresentacionAdmin/Web.config`

Ejemplo:

```xml
<add name="cadena"
     providerName="System.Data.ProviderName"
     connectionString="Data Source=.\\SQLEXPRESS; Initial Catalog=DBCARRITO; Integrated Security=True" />
```

### 5. PayPal Sandbox

En `CapaPresentaciomTienda/Web.config` configurar:

```xml
<add key="UrlPaypal" value="https://api-m.sandbox.paypal.com" />
<add key="ClientId" value="YOUR_PAYPAL_SANDBOX_CLIENT_ID" />
<add key="Secret" value="YOUR_PAYPAL_SANDBOX_SECRET" />
```

Nunca subir credenciales reales al repositorio.

### 6. SMTP

Las funciones de alta/recuperación que envían correos leen la configuración desde el `Web.config` de la aplicación:

```xml
<add key="SmtpEmail" value="YOUR_SMTP_EMAIL" />
<add key="SmtpAppPassword" value="YOUR_SMTP_APP_PASSWORD" />
<add key="SmtpHost" value="smtp.gmail.com" />
<add key="SmtpPort" value="587" />
```

### 7. Imágenes de productos

En `CapaPresentacionAdmin/Web.config`, configurar `ServidorFotos` con una ruta local válida para almacenar las imágenes de productos.

## Capturas

Añade capturas reales del proyecto en `docs/screenshots/`. Para un portfolio se recomienda incluir, al menos:

1. página principal / catálogo;
2. detalle de producto;
3. carrito;
4. checkout con PayPal Sandbox;
5. panel de administración;
6. dashboard o informe de ventas.

## Cambios realizados para la publicación

- eliminados `.vs/`, `bin/`, `obj/` y el cache local de paquetes NuGet;
- eliminados archivos `.user` de Visual Studio;
- sustituidas las credenciales de PayPal por valores de ejemplo;
- eliminada la contraseña SMTP incrustada en el código;
- parametrizada la configuración SMTP;
- eliminadas rutas locales y nombres de equipo de los `Web.config`;
- corregida la operación del carrito para respetar el parámetro `sumar` al incrementar o disminuir unidades;
- añadido `.gitignore`;
- añadida documentación de configuración, seguridad y base de datos.

## Limitaciones conocidas / mejoras futuras

Al ser un proyecto académico basado en ASP.NET MVC 5 y .NET Framework, existen mejoras que serían recomendables en una evolución:

- migración a ASP.NET Core;
- uso de ASP.NET Identity;
- migración del almacenamiento de contraseñas a PBKDF2, bcrypt o Argon2;
- gestión de secretos mediante variables de entorno o un secret manager;
- Entity Framework o una capa de persistencia más moderna;
- tests unitarios e integración continua;
- API REST separada del frontend;
- contenerización y despliegue automatizado.

## Autor

**Alberto Ávila Romero**  
GitHub: [@albertooavila](https://github.com/albertooavila)  
LinkedIn: [Alberto Ávila Romero](https://www.linkedin.com/in/alberto-avila-romero-459090278)

## Base de datos reconstruida

La base de datos SQL Server original no se conservó después del proyecto académico. Para esta versión de portfolio se ha reconstruido un esquema funcional a partir de la propia capa `CapaDatos`.

[`database/database.sql`](database/database.sql) crea `DBCARRITO`, sus tablas, relaciones, funciones, procedimientos almacenados y datos mínimos de demostración. La reconstrucción busca compatibilidad con el código conservado y no se presenta como una reproducción exacta de la base utilizada originalmente.

**Cuentas demo**

- Administración: `admin@demo.local` / `Admin123!`
- Cliente: `cliente@demo.local` / `Demo123!`

Consulta [`SETUP.md`](SETUP.md) para la puesta en marcha.

## Verificación automática

El repositorio incluye un flujo de **GitHub Actions** en `.github/workflows/build.yml`.
Cada vez que se hace `push` a la rama `main`, GitHub intenta restaurar los paquetes NuGet
y compilar la solución en un runner de Windows. Esto permite comprobar el estado de la
compilación sin tener Visual Studio instalado localmente.
