using DoAnChuyenNganh.Filters;
using DoAnChuyenNganh.Models;
using System;
using System.Collections.Generic;
using System.Drawing;
using System.IO;
using System.Linq;
using System.Text;
using System.Web.Mvc;

namespace DoAnChuyenNganh.Areas.Admin.Controllers
{
    [AdminAuthorization]
    public class ColorController : Controller
    {
        // GET: Admin/Brand
        ShopQuanAoEntities db = new ShopQuanAoEntities();
        public ActionResult Index()
        {
            List<Mau> maus = db.Maus.ToList();
            return View(maus);
        }
        public ActionResult Create()
        {
            ViewBag.Maus = db.Maus.ToList();
            return View();
        }
        [HttpPost]
        public ActionResult Create(Mau b)
        {
            db.Maus.Add(b);
            db.SaveChanges();
            return RedirectToAction("Index");
        }
        public ActionResult Update()
        {
            List<Mau> maus = db.Maus.ToList();
            return View(maus);
        }
        [HttpPost]
        public ActionResult Update(List<Mau> maus)
        {
            foreach (Mau mau in maus)
            {
                Mau oldBrand = db.Maus.Find(mau.MauID);
                oldBrand.MauName = mau.MauName;
            }
            db.SaveChanges();
            return RedirectToAction("Update");
        }
    }
}