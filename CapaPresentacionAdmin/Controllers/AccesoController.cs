using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using System.Web.Security;

using CapaEntidad;
using CapaNegocio;

namespace CapaPresentacionAdmin.Controllers
{
    public class AccesoController : Controller
    {
        // GET: Acceso
        public ActionResult Index()
        {
            return View();
        }

        public ActionResult CambiarClave()
        {
            return View();
        }

        public ActionResult ReestablecerClave()
        {
            return View();
        }

        [HttpPost]
        public ActionResult Index(string correos, string clave)
        {
            Usuario oUsuario = new Usuario();

            oUsuario = new CN_Usuarios().Listar().Where(u => u.Correos == correos && u.Clave == CN_Recursos.ConvertirSha256(clave)).FirstOrDefault();

            if(oUsuario == null)
            {
                ViewBag.Error = "Correo o contraseña incorrecto"; //mostrar un mensaje de error, el view bag sirve para gurdar informacion y mostrar en la vista
                return View();
            }
            else
            {

                if (oUsuario.Reestablecer)
                {
                    TempData["IdUsuario"] = oUsuario.IdUsuario;
                    return RedirectToAction("CambiarClave");
                }

                FormsAuthentication.SetAuthCookie(oUsuario.Correos, false);
                ViewBag.Error = null;

                return RedirectToAction("Index", "Home");

            }


        }

        [HttpPost]
        public ActionResult CambiarClave(string idusuario, string claveactual, string nuevaclave, string confirmarclave)
        {

            Usuario oUsuario = new Usuario();

            oUsuario = new CN_Usuarios().Listar().Where(u => u.IdUsuario == int.Parse(idusuario)).FirstOrDefault();

            if(oUsuario.Clave != CN_Recursos.ConvertirSha256(claveactual))
            {

                TempData["IdUsuario"] = idusuario;
                ViewData["vclave"] = "";
                ViewBag.Error = "La contraseña actual no es correcta";
                return View();
            }
            else if(nuevaclave != confirmarclave){

                TempData["IdUsuario"] = idusuario;
                ViewData["vclave"] = "";
                ViewBag.Error = "Las contraseñas no coinciden";
                return View();
            }
            ViewData["vclave"] = "";

            nuevaclave = CN_Recursos.ConvertirSha256(nuevaclave);

            string mensaje = string.Empty;

            bool respuesta = new CN_Usuarios().CambiarClave(int.Parse(idusuario), nuevaclave, out mensaje);

            if (respuesta)
            {
                return RedirectToAction("Index");
            }
            else
            {
                TempData["IdUsuario"] = idusuario;

                ViewBag.Error = mensaje;
                return View();
            }
        }

        //Para reestablecer la contraseña
        [HttpPost]
        public ActionResult ReestablecerClave(string correo)
        {
            Usuario ousuario = new Usuario();
            ousuario = new CN_Usuarios().Listar().Where(item => item.Correos == correo).FirstOrDefault();

            if (ousuario == null)
            {
                ViewBag.Error = "No se encontro un usuario relacionado con ese correo";
                return View();
            }

            string mensaje = string.Empty;
            bool respuesta = new CN_Usuarios().ReestablecerClave(ousuario.IdUsuario, correo, out mensaje);

            if (respuesta)
            {
                ViewBag.Error = null;
                return RedirectToAction("Index", "Acceso");
            }
            else
            {
                ViewBag.Error = mensaje;
                return View();
            }
        }

        public ActionResult CerrarSesion()
        {
            FormsAuthentication.SignOut();
            return RedirectToAction("Index","Acceso");
        }
    }
}