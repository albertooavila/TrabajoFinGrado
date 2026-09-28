/*
 DBCARRITO - reconstructed development database
 Reconstructed from the original C# data-access layer for portfolio use.
 The original database was not available, so this is a compatible reconstruction,
 not a byte-for-byte copy of the database used during the academic project.
*/
IF DB_ID(N'DBCARRITO') IS NULL CREATE DATABASE DBCARRITO;
GO
USE DBCARRITO;
GO

DROP PROCEDURE IF EXISTS dbo.sp_RegistrarUsuario;
DROP PROCEDURE IF EXISTS dbo.sp_EditarUsuario;
DROP PROCEDURE IF EXISTS dbo.sp_RegistrarCliente;
DROP PROCEDURE IF EXISTS dbo.sp_RegistrarCategoria;
DROP PROCEDURE IF EXISTS dbo.sp_EditarCategoria;
DROP PROCEDURE IF EXISTS dbo.sp_EliminarCategoria;
DROP PROCEDURE IF EXISTS dbo.sp_RegistrarMarca;
DROP PROCEDURE IF EXISTS dbo.sp_EditarMarca;
DROP PROCEDURE IF EXISTS dbo.sp_EliminarMarca;
DROP PROCEDURE IF EXISTS dbo.sp_RegistrarProducto;
DROP PROCEDURE IF EXISTS dbo.sp_EditarProducto;
DROP PROCEDURE IF EXISTS dbo.sp_EliminarProducto;
DROP PROCEDURE IF EXISTS dbo.sp_ExisteCarrito;
DROP PROCEDURE IF EXISTS dbo.sp_OperacionCarrito;
DROP PROCEDURE IF EXISTS dbo.sp_EliminarCarrito;
DROP PROCEDURE IF EXISTS dbo.usp_RegistrarVenta;
DROP PROCEDURE IF EXISTS dbo.DB_ReporteVentas;
DROP PROCEDURE IF EXISTS dbo.sp_ReporteDashboard;
GO
DROP FUNCTION IF EXISTS dbo.fn_obtenerCarritoCliente;
DROP FUNCTION IF EXISTS dbo.fn_ListarCompra;
GO

IF OBJECT_ID('dbo.DETALLE_VENTA','U') IS NOT NULL DROP TABLE dbo.DETALLE_VENTA;
IF OBJECT_ID('dbo.VENTA','U') IS NOT NULL DROP TABLE dbo.VENTA;
IF OBJECT_ID('dbo.CARRITO','U') IS NOT NULL DROP TABLE dbo.CARRITO;
IF OBJECT_ID('dbo.PRODUCTO','U') IS NOT NULL DROP TABLE dbo.PRODUCTO;
IF OBJECT_ID('dbo.DISTRITO','U') IS NOT NULL DROP TABLE dbo.DISTRITO;
IF OBJECT_ID('dbo.PROVINCIA','U') IS NOT NULL DROP TABLE dbo.PROVINCIA;
IF OBJECT_ID('dbo.DEPARTAMENTO','U') IS NOT NULL DROP TABLE dbo.DEPARTAMENTO;
IF OBJECT_ID('dbo.MARCA','U') IS NOT NULL DROP TABLE dbo.MARCA;
IF OBJECT_ID('dbo.CATEGORIA','U') IS NOT NULL DROP TABLE dbo.CATEGORIA;
IF OBJECT_ID('dbo.CLIENTE','U') IS NOT NULL DROP TABLE dbo.CLIENTE;
IF OBJECT_ID('dbo.USUARIO','U') IS NOT NULL DROP TABLE dbo.USUARIO;
GO

CREATE TABLE dbo.USUARIO(
 IdUsuario INT IDENTITY(1,1) PRIMARY KEY,
 Nombres NVARCHAR(100) NOT NULL,
 Apellido NVARCHAR(100) NOT NULL,
 Correos NVARCHAR(200) NOT NULL UNIQUE,
 Clave NVARCHAR(256) NOT NULL,
 Reestablecer BIT NOT NULL DEFAULT(0),
 Activo BIT NOT NULL DEFAULT(1)
);
CREATE TABLE dbo.CLIENTE(
 IdCliente INT IDENTITY(1,1) PRIMARY KEY,
 Nombres NVARCHAR(100) NOT NULL,
 Apellido NVARCHAR(100) NOT NULL,
 Correos NVARCHAR(200) NOT NULL UNIQUE,
 Clave NVARCHAR(256) NOT NULL,
 Reestablecer BIT NOT NULL DEFAULT(0)
);
CREATE TABLE dbo.CATEGORIA(
 IdCategoria INT IDENTITY(1,1) PRIMARY KEY,
 Descripcion NVARCHAR(150) NOT NULL UNIQUE,
 Activo BIT NOT NULL DEFAULT(1)
);
CREATE TABLE dbo.MARCA(
 IdMarca INT IDENTITY(1,1) PRIMARY KEY,
 Descripcion NVARCHAR(150) NOT NULL UNIQUE,
 Activo BIT NOT NULL DEFAULT(1)
);
CREATE TABLE dbo.PRODUCTO(
 IdProducto INT IDENTITY(1,1) PRIMARY KEY,
 Nombre NVARCHAR(200) NOT NULL,
 Descripcion NVARCHAR(1000) NULL,
 IdMarca INT NOT NULL,
 IdCategoria INT NOT NULL,
 Precio DECIMAL(18,2) NOT NULL CHECK(Precio>=0),
 Stock INT NOT NULL CHECK(Stock>=0),
 RutaImagen NVARCHAR(500) NULL,
 NombreImagen NVARCHAR(260) NULL,
 Activo BIT NOT NULL DEFAULT(1),
 FOREIGN KEY(IdMarca) REFERENCES dbo.MARCA(IdMarca),
 FOREIGN KEY(IdCategoria) REFERENCES dbo.CATEGORIA(IdCategoria)
);
CREATE TABLE dbo.CARRITO(
 IdCarrito INT IDENTITY(1,1) PRIMARY KEY,
 IdCliente INT NOT NULL,
 IdProducto INT NOT NULL,
 Cantidad INT NOT NULL DEFAULT(1) CHECK(Cantidad>0),
 CONSTRAINT UQ_CARRITO UNIQUE(IdCliente,IdProducto),
 FOREIGN KEY(IdCliente) REFERENCES dbo.CLIENTE(IdCliente),
 FOREIGN KEY(IdProducto) REFERENCES dbo.PRODUCTO(IdProducto)
);
CREATE TABLE dbo.DEPARTAMENTO(
 IdDepartamento VARCHAR(10) PRIMARY KEY,
 Descripcion NVARCHAR(150) NOT NULL
);
CREATE TABLE dbo.PROVINCIA(
 IdProvincia VARCHAR(10) NOT NULL,
 IdDepartamento VARCHAR(10) NOT NULL,
 Descripcion NVARCHAR(150) NOT NULL,
 PRIMARY KEY(IdProvincia,IdDepartamento),
 FOREIGN KEY(IdDepartamento) REFERENCES dbo.DEPARTAMENTO(IdDepartamento)
);
CREATE TABLE dbo.DISTRITO(
 IdDistrito VARCHAR(20) PRIMARY KEY,
 IdProvincia VARCHAR(10) NOT NULL,
 IdDepartamento VARCHAR(10) NOT NULL,
 Descripcion NVARCHAR(150) NOT NULL,
 FOREIGN KEY(IdProvincia,IdDepartamento) REFERENCES dbo.PROVINCIA(IdProvincia,IdDepartamento)
);
CREATE TABLE dbo.VENTA(
 IdVenta INT IDENTITY(1,1) PRIMARY KEY,
 IdCliente INT NOT NULL,
 TotalProducto INT NOT NULL,
 MontoTotal DECIMAL(18,2) NOT NULL,
 Contacto NVARCHAR(150) NULL,
 IdDistrito VARCHAR(20) NULL,
 Telefono NVARCHAR(50) NULL,
 Direccion NVARCHAR(300) NULL,
 FechaVenta DATETIME2(0) NOT NULL DEFAULT(SYSDATETIME()),
 IdTransaccion NVARCHAR(150) NOT NULL,
 FOREIGN KEY(IdCliente) REFERENCES dbo.CLIENTE(IdCliente),
 FOREIGN KEY(IdDistrito) REFERENCES dbo.DISTRITO(IdDistrito)
);
CREATE TABLE dbo.DETALLE_VENTA(
 IdDetalleVenta INT IDENTITY(1,1) PRIMARY KEY,
 IdVenta INT NOT NULL,
 IdProducto INT NOT NULL,
 Cantidad INT NOT NULL CHECK(Cantidad>0),
 Total DECIMAL(18,2) NOT NULL CHECK(Total>=0),
 FOREIGN KEY(IdVenta) REFERENCES dbo.VENTA(IdVenta),
 FOREIGN KEY(IdProducto) REFERENCES dbo.PRODUCTO(IdProducto)
);
GO

IF TYPE_ID(N'dbo.DetalleVentaType') IS NOT NULL DROP TYPE dbo.DetalleVentaType;
GO
CREATE TYPE dbo.DetalleVentaType AS TABLE(
 IdProducto VARCHAR(20) NOT NULL,
 Cantidad INT NOT NULL,
 Total DECIMAL(18,2) NOT NULL
);
GO

CREATE PROCEDURE dbo.sp_RegistrarUsuario
 @Nombres NVARCHAR(100),@Apellido NVARCHAR(100),@Correos NVARCHAR(200),@Clave NVARCHAR(256),@Activo BIT,
 @Resultado INT OUTPUT,@Mensaje NVARCHAR(500) OUTPUT
AS
BEGIN
 SET NOCOUNT ON;
 IF EXISTS(SELECT 1 FROM dbo.USUARIO WHERE Correos=@Correos)
 BEGIN SET @Resultado=0; SET @Mensaje=N'El correo ya está registrado.'; RETURN; END;
 INSERT dbo.USUARIO(Nombres,Apellido,Correos,Clave,Activo) VALUES(@Nombres,@Apellido,@Correos,@Clave,@Activo);
 SET @Resultado=SCOPE_IDENTITY(); SET @Mensaje=N'Usuario registrado correctamente.';
END
GO
CREATE PROCEDURE dbo.sp_EditarUsuario
 @IdUsuario INT,@Nombres NVARCHAR(100),@Apellido NVARCHAR(100),@Correos NVARCHAR(200),@Activo BIT,
 @Resultado BIT OUTPUT,@Mensaje NVARCHAR(500) OUTPUT
AS
BEGIN
 SET NOCOUNT ON;
 IF EXISTS(SELECT 1 FROM dbo.USUARIO WHERE Correos=@Correos AND IdUsuario<>@IdUsuario)
 BEGIN SET @Resultado=0; SET @Mensaje=N'El correo ya pertenece a otro usuario.'; RETURN; END;
 UPDATE dbo.USUARIO SET Nombres=@Nombres,Apellido=@Apellido,Correos=@Correos,Activo=@Activo WHERE IdUsuario=@IdUsuario;
 SET @Resultado=IIF(@@ROWCOUNT>0,1,0); SET @Mensaje=IIF(@Resultado=1,N'Usuario actualizado.',N'Usuario no encontrado.');
END
GO
CREATE PROCEDURE dbo.sp_RegistrarCliente
 @Nombres NVARCHAR(100),@Apellido NVARCHAR(100),@Correos NVARCHAR(200),@Clave NVARCHAR(256),
 @Resultado INT OUTPUT,@Mensaje NVARCHAR(500) OUTPUT
AS
BEGIN
 SET NOCOUNT ON;
 IF EXISTS(SELECT 1 FROM dbo.CLIENTE WHERE Correos=@Correos)
 BEGIN SET @Resultado=0; SET @Mensaje=N'El correo ya está registrado.'; RETURN; END;
 INSERT dbo.CLIENTE(Nombres,Apellido,Correos,Clave) VALUES(@Nombres,@Apellido,@Correos,@Clave);
 SET @Resultado=SCOPE_IDENTITY(); SET @Mensaje=N'Cliente registrado correctamente.';
END
GO
CREATE PROCEDURE dbo.sp_RegistrarCategoria
 @Descripcion NVARCHAR(150),@Activo BIT,@Resultado INT OUTPUT,@Mensaje NVARCHAR(500) OUTPUT
AS
BEGIN
 IF EXISTS(SELECT 1 FROM dbo.CATEGORIA WHERE Descripcion=@Descripcion)
 BEGIN SET @Resultado=0; SET @Mensaje=N'La categoría ya existe.'; RETURN; END;
 INSERT dbo.CATEGORIA(Descripcion,Activo) VALUES(@Descripcion,@Activo);
 SET @Resultado=SCOPE_IDENTITY(); SET @Mensaje=N'Categoría registrada.';
END
GO
CREATE PROCEDURE dbo.sp_EditarCategoria
 @IdCategoria INT,@Descripcion NVARCHAR(150),@Activo BIT,@Resultado BIT OUTPUT,@Mensaje NVARCHAR(500) OUTPUT
AS
BEGIN
 IF EXISTS(SELECT 1 FROM dbo.CATEGORIA WHERE Descripcion=@Descripcion AND IdCategoria<>@IdCategoria)
 BEGIN SET @Resultado=0; SET @Mensaje=N'La categoría ya existe.'; RETURN; END;
 UPDATE dbo.CATEGORIA SET Descripcion=@Descripcion,Activo=@Activo WHERE IdCategoria=@IdCategoria;
 SET @Resultado=IIF(@@ROWCOUNT>0,1,0); SET @Mensaje=IIF(@Resultado=1,N'Categoría actualizada.',N'Categoría no encontrada.');
END
GO
CREATE PROCEDURE dbo.sp_EliminarCategoria
 @IdCategoria INT,@Resultado BIT OUTPUT,@Mensaje NVARCHAR(500) OUTPUT
AS
BEGIN
 IF EXISTS(SELECT 1 FROM dbo.PRODUCTO WHERE IdCategoria=@IdCategoria)
 BEGIN SET @Resultado=0; SET @Mensaje=N'No se puede eliminar: hay productos asociados.'; RETURN; END;
 DELETE dbo.CATEGORIA WHERE IdCategoria=@IdCategoria;
 SET @Resultado=IIF(@@ROWCOUNT>0,1,0); SET @Mensaje=IIF(@Resultado=1,N'Categoría eliminada.',N'Categoría no encontrada.');
END
GO
CREATE PROCEDURE dbo.sp_RegistrarMarca
 @Descripcion NVARCHAR(150),@Activo BIT,@Resultado INT OUTPUT,@Mensaje NVARCHAR(500) OUTPUT
AS
BEGIN
 IF EXISTS(SELECT 1 FROM dbo.MARCA WHERE Descripcion=@Descripcion)
 BEGIN SET @Resultado=0; SET @Mensaje=N'La marca ya existe.'; RETURN; END;
 INSERT dbo.MARCA(Descripcion,Activo) VALUES(@Descripcion,@Activo);
 SET @Resultado=SCOPE_IDENTITY(); SET @Mensaje=N'Marca registrada.';
END
GO
CREATE PROCEDURE dbo.sp_EditarMarca
 @IdMarca INT,@Descripcion NVARCHAR(150),@Activo BIT,@Resultado BIT OUTPUT,@Mensaje NVARCHAR(500) OUTPUT
AS
BEGIN
 IF EXISTS(SELECT 1 FROM dbo.MARCA WHERE Descripcion=@Descripcion AND IdMarca<>@IdMarca)
 BEGIN SET @Resultado=0; SET @Mensaje=N'La marca ya existe.'; RETURN; END;
 UPDATE dbo.MARCA SET Descripcion=@Descripcion,Activo=@Activo WHERE IdMarca=@IdMarca;
 SET @Resultado=IIF(@@ROWCOUNT>0,1,0); SET @Mensaje=IIF(@Resultado=1,N'Marca actualizada.',N'Marca no encontrada.');
END
GO
CREATE PROCEDURE dbo.sp_EliminarMarca
 @IdMarca INT,@Resultado BIT OUTPUT,@Mensaje NVARCHAR(500) OUTPUT
AS
BEGIN
 IF EXISTS(SELECT 1 FROM dbo.PRODUCTO WHERE IdMarca=@IdMarca)
 BEGIN SET @Resultado=0; SET @Mensaje=N'No se puede eliminar: hay productos asociados.'; RETURN; END;
 DELETE dbo.MARCA WHERE IdMarca=@IdMarca;
 SET @Resultado=IIF(@@ROWCOUNT>0,1,0); SET @Mensaje=IIF(@Resultado=1,N'Marca eliminada.',N'Marca no encontrada.');
END
GO
CREATE PROCEDURE dbo.sp_RegistrarProducto
 @Nombre NVARCHAR(200),@Descripcion NVARCHAR(1000),@IdMarca INT,@IdCategoria INT,@Precio DECIMAL(18,2),@Stock INT,@Activo BIT,
 @Resultado INT OUTPUT,@Mensaje NVARCHAR(500) OUTPUT
AS
BEGIN
 INSERT dbo.PRODUCTO(Nombre,Descripcion,IdMarca,IdCategoria,Precio,Stock,Activo)
 VALUES(@Nombre,@Descripcion,@IdMarca,@IdCategoria,@Precio,@Stock,@Activo);
 SET @Resultado=SCOPE_IDENTITY(); SET @Mensaje=N'Producto registrado.';
END
GO
CREATE PROCEDURE dbo.sp_EditarProducto
 @IdProducto INT,@Nombre NVARCHAR(200),@Descripcion NVARCHAR(1000),@IdMarca INT,@IdCategoria INT,@Precio DECIMAL(18,2),@Stock INT,@Activo BIT,
 @Resultado BIT OUTPUT,@Mensaje NVARCHAR(500) OUTPUT
AS
BEGIN
 UPDATE dbo.PRODUCTO SET Nombre=@Nombre,Descripcion=@Descripcion,IdMarca=@IdMarca,IdCategoria=@IdCategoria,Precio=@Precio,Stock=@Stock,Activo=@Activo
 WHERE IdProducto=@IdProducto;
 SET @Resultado=IIF(@@ROWCOUNT>0,1,0); SET @Mensaje=IIF(@Resultado=1,N'Producto actualizado.',N'Producto no encontrado.');
END
GO
CREATE PROCEDURE dbo.sp_EliminarProducto
 @IdProducto INT,@Resultado BIT OUTPUT,@Mensaje NVARCHAR(500) OUTPUT
AS
BEGIN
 IF EXISTS(SELECT 1 FROM dbo.DETALLE_VENTA WHERE IdProducto=@IdProducto)
 BEGIN SET @Resultado=0; SET @Mensaje=N'No se puede eliminar un producto incluido en ventas.'; RETURN; END;
 DELETE dbo.CARRITO WHERE IdProducto=@IdProducto;
 DELETE dbo.PRODUCTO WHERE IdProducto=@IdProducto;
 SET @Resultado=IIF(@@ROWCOUNT>0,1,0); SET @Mensaje=IIF(@Resultado=1,N'Producto eliminado.',N'Producto no encontrado.');
END
GO

CREATE PROCEDURE dbo.sp_ExisteCarrito @IdCliente INT,@IdProducto INT,@Resultado BIT OUTPUT
AS
BEGIN
 SET @Resultado=IIF(EXISTS(SELECT 1 FROM dbo.CARRITO WHERE IdCliente=@IdCliente AND IdProducto=@IdProducto),1,0);
END
GO
CREATE PROCEDURE dbo.sp_OperacionCarrito
 @IdCliente INT,@IdProducto INT,@Sumar BIT,@Resultado BIT OUTPUT,@Mensaje NVARCHAR(500) OUTPUT
AS
BEGIN
 SET NOCOUNT ON; SET @Resultado=0; SET @Mensaje=N'';
 IF NOT EXISTS(SELECT 1 FROM dbo.PRODUCTO WHERE IdProducto=@IdProducto AND Activo=1)
 BEGIN SET @Mensaje=N'Producto no disponible.'; RETURN; END;
 IF @Sumar=1
 BEGIN
   IF EXISTS(SELECT 1 FROM dbo.CARRITO WHERE IdCliente=@IdCliente AND IdProducto=@IdProducto)
   BEGIN
     IF (SELECT Cantidad FROM dbo.CARRITO WHERE IdCliente=@IdCliente AND IdProducto=@IdProducto) >= (SELECT Stock FROM dbo.PRODUCTO WHERE IdProducto=@IdProducto)
     BEGIN SET @Mensaje=N'No hay más stock disponible.'; RETURN; END;
     UPDATE dbo.CARRITO SET Cantidad=Cantidad+1 WHERE IdCliente=@IdCliente AND IdProducto=@IdProducto;
   END
   ELSE
   BEGIN
     IF (SELECT Stock FROM dbo.PRODUCTO WHERE IdProducto=@IdProducto)<=0 BEGIN SET @Mensaje=N'Producto sin stock.'; RETURN; END;
     INSERT dbo.CARRITO(IdCliente,IdProducto,Cantidad) VALUES(@IdCliente,@IdProducto,1);
   END
 END
 ELSE
 BEGIN
   IF NOT EXISTS(SELECT 1 FROM dbo.CARRITO WHERE IdCliente=@IdCliente AND IdProducto=@IdProducto)
   BEGIN SET @Mensaje=N'El producto no está en el carrito.'; RETURN; END;
   IF (SELECT Cantidad FROM dbo.CARRITO WHERE IdCliente=@IdCliente AND IdProducto=@IdProducto)<=1
     DELETE dbo.CARRITO WHERE IdCliente=@IdCliente AND IdProducto=@IdProducto;
   ELSE UPDATE dbo.CARRITO SET Cantidad=Cantidad-1 WHERE IdCliente=@IdCliente AND IdProducto=@IdProducto;
 END
 SET @Resultado=1; SET @Mensaje=N'Carrito actualizado.';
END
GO
CREATE PROCEDURE dbo.sp_EliminarCarrito @IdCliente INT,@IdProducto INT,@Resultado BIT OUTPUT
AS
BEGIN
 DELETE dbo.CARRITO WHERE IdCliente=@IdCliente AND IdProducto=@IdProducto;
 SET @Resultado=IIF(@@ROWCOUNT>0,1,0);
END
GO
CREATE FUNCTION dbo.fn_obtenerCarritoCliente(@IdCliente INT)
RETURNS TABLE AS RETURN(
 SELECT p.IdProducto,p.Nombre,p.Precio,p.RutaImagen,p.NombreImagen,m.Descripcion AS DesMarca,c.Cantidad
 FROM dbo.CARRITO c JOIN dbo.PRODUCTO p ON p.IdProducto=c.IdProducto JOIN dbo.MARCA m ON m.IdMarca=p.IdMarca
 WHERE c.IdCliente=@IdCliente
);
GO

CREATE PROCEDURE dbo.usp_RegistrarVenta
 @IdCliente INT,@TotalProducto INT,@MontoTotal DECIMAL(18,2),@Contacto NVARCHAR(150),@IdDistrito VARCHAR(20),@Telefono NVARCHAR(50),@Direccion NVARCHAR(300),
 @IdTransaccion NVARCHAR(150),@DetalleVenta dbo.DetalleVentaType READONLY,@Resultado BIT OUTPUT,@Mensaje NVARCHAR(500) OUTPUT
AS
BEGIN
 SET NOCOUNT ON; SET XACT_ABORT ON;
 BEGIN TRY
   BEGIN TRAN;
   IF EXISTS(SELECT 1 FROM @DetalleVenta d JOIN dbo.PRODUCTO p ON p.IdProducto=TRY_CONVERT(INT,d.IdProducto) WHERE p.Stock<d.Cantidad)
     THROW 50001,'Stock insuficiente para completar la venta.',1;
   INSERT dbo.VENTA(IdCliente,TotalProducto,MontoTotal,Contacto,IdDistrito,Telefono,Direccion,IdTransaccion)
   VALUES(@IdCliente,@TotalProducto,@MontoTotal,@Contacto,NULLIF(@IdDistrito,''),@Telefono,@Direccion,@IdTransaccion);
   DECLARE @IdVenta INT=SCOPE_IDENTITY();
   INSERT dbo.DETALLE_VENTA(IdVenta,IdProducto,Cantidad,Total)
   SELECT @IdVenta,TRY_CONVERT(INT,IdProducto),Cantidad,Total FROM @DetalleVenta;
   UPDATE p SET p.Stock=p.Stock-d.Cantidad
   FROM dbo.PRODUCTO p JOIN (SELECT TRY_CONVERT(INT,IdProducto) IdProducto,SUM(Cantidad) Cantidad FROM @DetalleVenta GROUP BY TRY_CONVERT(INT,IdProducto)) d ON d.IdProducto=p.IdProducto;
   DELETE c FROM dbo.CARRITO c JOIN @DetalleVenta d ON TRY_CONVERT(INT,d.IdProducto)=c.IdProducto WHERE c.IdCliente=@IdCliente;
   COMMIT; SET @Resultado=1; SET @Mensaje=N'Venta registrada correctamente.';
 END TRY
 BEGIN CATCH
   IF @@TRANCOUNT>0 ROLLBACK; SET @Resultado=0; SET @Mensaje=ERROR_MESSAGE();
 END CATCH
END
GO
CREATE FUNCTION dbo.fn_ListarCompra(@IdCliente INT)
RETURNS TABLE AS RETURN(
 SELECT p.Nombre,p.Precio,p.RutaImagen,p.NombreImagen,dv.Cantidad,dv.Total,v.IdTransaccion
 FROM dbo.VENTA v JOIN dbo.DETALLE_VENTA dv ON dv.IdVenta=v.IdVenta JOIN dbo.PRODUCTO p ON p.IdProducto=dv.IdProducto
 WHERE v.IdCliente=@IdCliente
);
GO
CREATE PROCEDURE dbo.DB_ReporteVentas @fechainicio VARCHAR(20),@fechafin VARCHAR(20),@idtransaccion NVARCHAR(150)
AS
BEGIN
 DECLARE @Inicio DATE=TRY_CONVERT(DATE,@fechainicio,103),@Fin DATE=TRY_CONVERT(DATE,@fechafin,103);
 SELECT CONVERT(VARCHAR(10),v.FechaVenta,103) FechaVenta,CONCAT(c.Nombres,' ',c.Apellido) Cliente,p.Nombre Producto,p.Precio,dv.Cantidad,dv.Total,v.IdTransaccion
 FROM dbo.VENTA v JOIN dbo.CLIENTE c ON c.IdCliente=v.IdCliente JOIN dbo.DETALLE_VENTA dv ON dv.IdVenta=v.IdVenta JOIN dbo.PRODUCTO p ON p.IdProducto=dv.IdProducto
 WHERE (@Inicio IS NULL OR CAST(v.FechaVenta AS DATE)>=@Inicio) AND (@Fin IS NULL OR CAST(v.FechaVenta AS DATE)<=@Fin)
   AND (ISNULL(@idtransaccion,'')='' OR v.IdTransaccion=@idtransaccion)
 ORDER BY v.FechaVenta DESC;
END
GO
CREATE PROCEDURE dbo.sp_ReporteDashboard
AS
BEGIN
 SELECT (SELECT COUNT(*) FROM dbo.CLIENTE) TotalCliente,(SELECT COUNT(*) FROM dbo.VENTA) TotalVenta,(SELECT COUNT(*) FROM dbo.PRODUCTO) TotalProducto;
END
GO

INSERT dbo.CATEGORIA(Descripcion,Activo) VALUES(N'Informática',1),(N'Accesorios',1),(N'Audio',1);
INSERT dbo.MARCA(Descripcion,Activo) VALUES(N'Logitech',1),(N'Samsung',1),(N'Generic',1);
INSERT dbo.PRODUCTO(Nombre,Descripcion,IdMarca,IdCategoria,Precio,Stock,Activo,RutaImagen,NombreImagen) VALUES
(N'Ratón inalámbrico',N'Producto de demostración para el portfolio.',1,2,29.99,15,1,NULL,NULL),
(N'Monitor 24 pulgadas',N'Producto de demostración para el portfolio.',2,1,149.90,8,1,NULL,NULL),
(N'Auriculares',N'Producto de demostración para el portfolio.',3,3,39.50,20,1,NULL,NULL);
INSERT dbo.DEPARTAMENTO(IdDepartamento,Descripcion) VALUES('MD',N'Madrid');
INSERT dbo.PROVINCIA(IdProvincia,IdDepartamento,Descripcion) VALUES('MAD','MD',N'Madrid');
INSERT dbo.DISTRITO(IdDistrito,IdProvincia,IdDepartamento,Descripcion) VALUES('GET','MAD','MD',N'Getafe'),('MAD-C','MAD','MD',N'Madrid');
INSERT dbo.USUARIO(Nombres,Apellido,Correos,Clave,Reestablecer,Activo) VALUES(N'Administrador',N'Demo',N'admin@demo.local',N'3EB3FE66B31E3B4D10FA70B5CAD49C7112294AF6AE4E476A1C405155D45AA121',0,1);
INSERT dbo.CLIENTE(Nombres,Apellido,Correos,Clave,Reestablecer) VALUES(N'Cliente',N'Demo',N'cliente@demo.local',N'588C55F3CE2B8569B153C5ABBF13F9F74308B88A20017CC699B835CC93195D16',0);
PRINT 'DBCARRITO reconstructed successfully.';
PRINT 'Admin demo: admin@demo.local / Admin123!';
PRINT 'Client demo: cliente@demo.local / Demo123!';
GO
