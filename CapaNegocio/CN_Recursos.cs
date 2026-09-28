using System;
using System.Collections.Generic;
using System.Linq;
using System.Security.Cryptography;
using System.Text;
using System.Threading.Tasks;
using System.Net.Mail;
using System.Net;
using System.IO;
using System.Configuration;



namespace CapaNegocio
{
    public class CN_Recursos
    {
        //Genera clave automática que manda al usuario
        public static string GenerarClave()
        {
            //Crea la clave de 0 a 6 dígitos
            string clave = Guid.NewGuid().ToString("N").Substring(0, 6);
            return clave;
        }
        //encriptacion de texto en sha256
        public static string ConvertirSha256(String texto)
        {
            StringBuilder sb = new StringBuilder();
            //Usamos la referencia de "system.security.cryptography"
            using (SHA256 hash = SHA256Managed.Create())
            {
                Encoding enc = Encoding.UTF8;
                byte[] result = hash.ComputeHash(enc.GetBytes(texto));

                foreach (byte b in result)
                {
                    sb.Append(b.ToString("x2"));
                }
            }
            return sb.ToString();
        }


        public static bool EnviarCorreo(string correo, string asunto, string mensaje)
        {
            try
            {
                string smtpEmail = ConfigurationManager.AppSettings["SmtpEmail"];
                string smtpPassword = ConfigurationManager.AppSettings["SmtpAppPassword"];
                string smtpHost = ConfigurationManager.AppSettings["SmtpHost"] ?? "smtp.gmail.com";
                int smtpPort;

                if (!int.TryParse(ConfigurationManager.AppSettings["SmtpPort"], out smtpPort))
                {
                    smtpPort = 587;
                }

                // Las credenciales no se almacenan en el código fuente.
                // Deben configurarse localmente en el Web.config de la aplicación.
                if (string.IsNullOrWhiteSpace(smtpEmail) || string.IsNullOrWhiteSpace(smtpPassword))
                {
                    return false;
                }

                using (MailMessage mail = new MailMessage())
                {
                    mail.To.Add(correo);
                    mail.From = new MailAddress(smtpEmail);
                    mail.Subject = asunto;
                    mail.Body = mensaje;
                    mail.IsBodyHtml = true;

                    using (SmtpClient smtp = new SmtpClient())
                    {
                        smtp.Credentials = new NetworkCredential(smtpEmail, smtpPassword);
                        smtp.Host = smtpHost;
                        smtp.Port = smtpPort;
                        smtp.EnableSsl = true;
                        smtp.Send(mail);
                    }
                }

                return true;
            }
            catch (Exception)
            {
                return false;
            }
        }
        public static string ConvertirBase64(string ruta, out bool conversion)
        {
            string textoBase64 = string.Empty;
            conversion = true;

            try
            {
                byte[] bytes = File.ReadAllBytes(ruta);
                textoBase64 = Convert.ToBase64String(bytes);
            }
            catch 
            {
                conversion = false;
            }
            return textoBase64;

        }       
    }
}
