using DoAnChuyenNganh.Filters;
using DoAnChuyenNganh.Models;
using System;
using System.Collections.Generic;
using System.Drawing.Drawing2D;
using System.IO;
using System.Linq;
using System.Text;
using System.Web.Mvc;

namespace DoAnChuyenNganh.Areas.Admin.Controllers
{
    [AdminAuthorization]
    public class BrandController : Controller
    {
        // GET: Admin/Brand
        ShopQuanAoEntities db = new ShopQuanAoEntities();
        public ActionResult Index()
        {
            List<DanhMuc> brands = db.DanhMucs.ToList();
            return View(brands);
        }
        public ActionResult Create()
        {
            ViewBag.Brands = db.DanhMucs.ToList();
            return View();
        }
        [HttpPost]
        public ActionResult Create(DanhMuc b)
        {
            db.DanhMucs.Add(b);
            db.SaveChanges();
            return RedirectToAction("Index");
        }
        public ActionResult Update()
        {
            List<DanhMuc> brands = db.DanhMucs.ToList();
            return View(brands);
        }
        [HttpPost]
        public ActionResult Update(List<DanhMuc> brands)
        {
            foreach (DanhMuc brand in brands)
            {
                DanhMuc oldBrand = db.DanhMucs.Find(brand.DanhMucID);
                oldBrand.TenDanhMuc = brand.TenDanhMuc;
            }
            db.SaveChanges();
            return RedirectToAction("Update");
        }
    }
}