using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks;
using CapaDatos;
using CapaEntidad;

namespace CapaNegocio
{
    public class CN_Usuarios
    {
        private CD_Usuarios objCapaDato= new CD_Usuarios();

        public List<Usuario> Listar()
        {
            return objCapaDato.Listar();
        }

        public int Regsitrar(Usuario obj, out String Mensaje)
        {
            Mensaje = string.Empty;

            if(string.IsNullOrEmpty(obj.Nombres) || string.IsNullOrWhiteSpace(obj.Nombres)){
                Mensaje = "El nombre del usuario no puede estar vacio";
            }
            else if (string.IsNullOrEmpty(obj.Apellido) || string.IsNullOrWhiteSpace(obj.Apellido))
            {
                Mensaje = "El apellido del usuario no puede estar vacio";
            }
            else if (string.IsNullOrEmpty(obj.Correos) || string.IsNullOrWhiteSpace(obj.Correos))
            {
                Mensaje = "El correo del usuario no puede estar vacio";
            }

            if (string.IsNullOrEmpty(Mensaje))
            {
                //Enviamos mensaje a cuando se registre a uno nuevo

                string clave = CN_Recursos.GenerarClave();
                //detalles del correo
                string asunto = "Creación de Cuenta";
                string mensaje_correo = "<h3>Su cuenta fue creada correctamente</h3></br><p>Su contraseña para acceder es: !clave!</p>";
                //se reemplaza !clave! por la variabe clave
                mensaje_correo = mensaje_correo.Replace("!clave!", clave);

                bool respuesta = CN_Recursos.EnviarCorreo(obj.Correos, asunto, mensaje_correo);

                if (respuesta)
                {

                    obj.Clave = CN_Recursos.ConvertirSha256(clave);
                    return objCapaDato.Regsitrar(obj, out Mensaje);
                }
                else
                {
                    Mensaje = "No se puede enviar el correo";
                    return 0 ;
                }

            }
            else
            {
                return 0;
            }

        }


        public bool Editar(Usuario obj, out String Mensaje)
        {
            Mensaje = string.Empty;

            if (string.IsNullOrEmpty(obj.Nombres) || string.IsNullOrWhiteSpace(obj.Nombres))
            {
                Mensaje = "El nombre del usuario no puede estar vacio";
            }
            else if (string.IsNullOrEmpty(obj.Apellido) || string.IsNullOrWhiteSpace(obj.Apellido))
            {
                Mensaje = "El apellido del usuario no puede estar vacio";
            }
            else if (string.IsNullOrEmpty(obj.Correos) || string.IsNullOrWhiteSpace(obj.Correos))
            {
                Mensaje = "El correo del usuario no puede estar vacio";
            }

            if (string.IsNullOrEmpty(Mensaje))
            {
                return objCapaDato.Editar(obj, out Mensaje);

            }
            else
            {
                return false;
            }

        }
        public bool Eliminar(int id, out string Mensaje)
        {
            return objCapaDato.Eliminar(id, out Mensaje);
        }

        //creamos lals funcoones que va a tener el usuario a la hora de crear la nueva contraseña
        public bool CambiarClave(int idusuario, string nuevaclave, out string Mensaje)
        {
            return objCapaDato.CambiarClave(idusuario,nuevaclave, out Mensaje);
        }

        public bool ReestablecerClave(int idusuario,string correos, out String Mensaje)
        {
            Mensaje = string.Empty;

            string nuevaclave = CN_Recursos.GenerarClave(); //nos obtiene la clave autogenerada
            bool resultado = objCapaDato.ReestablecerClave(idusuario,CN_Recursos.ConvertirSha256(nuevaclave), out Mensaje);

            if (resultado)
            {
                //detalles del correo
                string asunto = "Contraseña reestablecida";
                string mensaje_correo = "<h3>Su cuenta fue reestablecida correctamente</h3></br><p>Su contraseña para acceder ahora es: !clave!</p>";
                //se reemplaza !clave! por la variabe clave
                mensaje_correo = mensaje_correo.Replace("!clave!", nuevaclave);

                bool respuesta = CN_Recursos.EnviarCorreo(correos, asunto, mensaje_correo);

                if (respuesta)
                {

                    return true;
                }
                else
                {
                    Mensaje = "No se pudo enviar el correo";
                    return false;
                }
            }
            else
            {
                Mensaje = "No se pudo reestablecer la contraseña";
                return false;
            }

        }

    }
}
