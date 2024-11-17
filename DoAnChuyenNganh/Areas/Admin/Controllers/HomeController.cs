using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using DoAnChuyenNganh.Models;
using DoAnChuyenNganh.Filters;
namespace DoAnChuyenNganh.Areas.Admin.Controllers
{
    [AdminAuthorization]
    public class HomeController : Controller
    {
        // GET: Admin/Home
        public ActionResult Index()
        {
            return View();
        }
        public ActionResult Mypf(int? id)
        {
            ShopQuanAoEntities db = new ShopQuanAoEntities();
            NguoiDung user = db.NguoiDungs.FirstOrDefault(row => row.NguoiDungID == id);

            if (user == null)
            {
                // Handle the case where the user with the specified id is not found
                return HttpNotFound();
            }

            return View(user);
        }
    }
}