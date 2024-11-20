using DoAnChuyenNganh.Filters;
using DoAnChuyenNganh.Models;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Web.Mvc;

namespace DoAnChuyenNganh.Areas.Admin.Controllers
{
    [AdminAuthorization]
    public class SizeController : Controller
    {
        // GET: Admin/Brand
        ShopQuanAoEntities db = new ShopQuanAoEntities();
        public ActionResult Index()
        {
            List<Size> sizes = db.Sizes.ToList();
            return View(sizes);
        }
        public ActionResult Create()
        {
            ViewBag.Sizes = db.Sizes.ToList();
            return View();
        }
        [HttpPost]
        public ActionResult Create(Size b)
        {
            db.Sizes.Add(b);
            db.SaveChanges();
            return RedirectToAction("Index");
        }
        public ActionResult Update()
        {
            List<Size> sizes = db.Sizes.ToList();
            return View(sizes);
        }
        [HttpPost]
        public ActionResult Update(List<Size> sizes)
        {
            foreach (Size size in sizes)
            {
                Size oldSize = db.Sizes.Find(size.SizeID);
                oldSize.SizeName = size.SizeName;
            }
            db.SaveChanges();
            return RedirectToAction("Update");
        }
    }
}