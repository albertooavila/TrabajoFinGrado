# Seguridad y configuración

Este repositorio es una versión saneada del proyecto académico para su publicación.

## Secretos

No se incluyen credenciales reales de:

- PayPal Sandbox;
- correo SMTP;
- SQL Server;
- rutas locales del equipo de desarrollo.

Las claves presentes en la versión académica original deben considerarse comprometidas y **revocarse/rotarse** antes de reutilizar cualquier servicio asociado.

## Contraseñas de usuarios

El proyecto académico utiliza SHA-256 para almacenar contraseñas. Esto se conserva para no romper la compatibilidad con la base de datos original, pero **no es una práctica recomendada para un proyecto nuevo**. Una evolución debería migrar a ASP.NET Identity y a un algoritmo específico para contraseñas como PBKDF2, bcrypt o Argon2 con salt.

## Producción

Este código se publica como proyecto académico/portfolio. Antes de utilizarlo en producción se debería revisar, entre otros puntos, autenticación, gestión de secretos, validación de entradas, protección CSRF, logging, errores y dependencias.
