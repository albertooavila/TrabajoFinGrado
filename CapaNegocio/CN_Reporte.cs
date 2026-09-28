using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

using CapaDatos;
using CapaEntidad;

namespace CapaNegocio
{
    public class CN_Reporte
    {
        private CD_Reporte objCapadato = new CD_Reporte();
        public List<Reporte> Ventas(string fechainicio, string fechafin, string idtransaccion)
        {
            return objCapadato.Ventas(fechainicio,fechafin,idtransaccion);
        }

        public DashBoard VerDashBoard()
        {
            return objCapadato.VerDashBoard();
        }


    }
}
