using DoAnChuyenNganh.Filters;
using DoAnChuyenNganh.Models;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace DoAnChuyenNganh.Areas.Admin.Controllers
{
    [AdminAuthorization]
    public class ProductController : Controller
    {
        ShopQuanAoEntities db = new ShopQuanAoEntities();

        // Hiển thị danh sách sản phẩm
        public ActionResult Index(string search = "", int page = 1)
        {
            List<SanPham> sanphams = db.SanPhams
                .Where(row => row.TenSanPham.Contains(search))
                .OrderBy(row => row.TenSanPham)
                .ToList();

            int NoOfRecordPerPage = 5;
            int NoOfPages = Convert.ToInt32(Math.Ceiling(Convert.ToDouble(sanphams.Count) / NoOfRecordPerPage));
            int NoOfRecordToSkip = (page - 1) * NoOfRecordPerPage;
            foreach (var sanpham in sanphams)
            {
                var chiTietSanPhams = db.ChiTietSanPhams
                    .Where(ct => ct.SanPhamID == sanpham.SanPhamID)
                    .ToList();

                if (chiTietSanPhams.All(ct => ct.SoLuongTonKho == 0 || ct.KichHoat == false))
                {
                    sanpham.KichHoat = false; // Deactivate the product
                }
                else
                {
                    // If any of the ChiTietSanPhams has stock or is active, activate the product
                    if (chiTietSanPhams.Any(ct => ct.SoLuongTonKho > 0 && ct.KichHoat == true))
                    {
                        sanpham.KichHoat = true; // Activate the product
                    }
                }
            }
            ViewBag.Page = page;
            ViewBag.NoOfPages = NoOfPages;
            sanphams = sanphams.Skip(NoOfRecordToSkip).Take(NoOfRecordPerPage).ToList();
            return View(sanphams);
        }

        // Tạo mới sản phẩm
        public ActionResult Create()
        {
            ViewBag.DanhMucList = db.DanhMucs.ToList();
            return View();
        }

        [HttpPost]
        public ActionResult Create(SanPham sanpham)
        {
            if (ModelState.IsValid)
            {
                sanpham.SoLuongDaBan = 0;
                sanpham.SoSaoTB = 0;
                sanpham.KichHoat = true;
                db.SanPhams.Add(sanpham);
                db.SaveChanges();
                return RedirectToAction("Index");
            }

            ViewBag.DanhMucList = db.DanhMucs.ToList();
            return View(sanpham);
        }

        // Sửa thông tin sản phẩm
        public ActionResult Edit(int id)
        {
            SanPham products = db.SanPhams.FirstOrDefault(row => row.SanPhamID == id);
            if (products == null) return HttpNotFound();

            ViewBag.Brands = db.DanhMucs.ToList();
            ViewBag.ChiTietSanPham = db.ChiTietSanPhams.Where(x => x.SanPhamID == id).ToList();
            return View(products);
        }

        [HttpPost]
        public ActionResult Edit(SanPham pro)
        {
            SanPham products = db.SanPhams.FirstOrDefault(row => row.SanPhamID == pro.SanPhamID);
            if (products == null) return HttpNotFound();

            products.TenSanPham = pro.TenSanPham;
            products.MoTa = pro.MoTa;
            products.DanhMucID = pro.DanhMucID;

            db.SaveChanges();
            return RedirectToAction("Index");
        }
        public ActionResult CreateCTSP(int id)
        {
            ViewBag.Size = db.Sizes.ToList();
            ViewBag.Mau = db.Maus.ToList();
            ViewBag.id = id;
            return View();
        }
        [HttpPost]
        public ActionResult CreateCTSP(int id, ChiTietSanPham ctsp, HttpPostedFileBase imageFile)
        {
            if (imageFile != null && imageFile.ContentLength > 0)
            {
                var fileName = Path.GetFileName(imageFile.FileName);
                var path = Path.Combine(Server.MapPath("~/img"), fileName);
                imageFile.SaveAs(path);
                ctsp.HinhAnhUrl = fileName;
            }
            if (ModelState.IsValid)
            {
                ctsp.SanPhamID = id;
                ctsp.KichHoat = true;
                db.ChiTietSanPhams.Add(ctsp);
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(ctsp);
        }
        // Sửa chi tiết sản phẩm
        public ActionResult EditCTSP(int id)
        {
            ChiTietSanPham products = db.ChiTietSanPhams.Find(id);
            if (products == null) return HttpNotFound();
            ViewBag.Size = db.Sizes.ToList();
            ViewBag.Mau = db.Maus.ToList();
            return View(products);
        }

        [HttpPost]
        public ActionResult EditCTSP(ChiTietSanPham pro, HttpPostedFileBase imageFile)
        {
            ChiTietSanPham products = db.ChiTietSanPhams.FirstOrDefault(row => row.ChiTietSanPhamID == pro.ChiTietSanPhamID);
            if (products == null) return HttpNotFound();

            products.Gia = pro.Gia;
            products.MauID = pro.MauID;
            products.SizeID = pro.SizeID;
            products.SoLuongTonKho = pro.SoLuongTonKho;

            if (imageFile != null)
            {
                var oldImagePath = Path.Combine(Server.MapPath("~/img"), products.HinhAnhUrl);
                if (System.IO.File.Exists(oldImagePath))
                {
                    System.IO.File.Delete(oldImagePath);
                }

                var fileName = Path.GetFileName(imageFile.FileName);
                var newPath = Path.Combine(Server.MapPath("~/img"), fileName);
                imageFile.SaveAs(newPath);

                products.HinhAnhUrl = fileName;
            }

            db.SaveChanges();
            return RedirectToAction("Edit", new { id = products.SanPhamID });
        }

        // Vô hiệu hoặc kích hoạt chi tiết sản phẩm
        public ActionResult VoHieuKichHoatCTSP(int id, int kichHoat)
        {
            ChiTietSanPham sanphams = db.ChiTietSanPhams.FirstOrDefault(row => row.ChiTietSanPhamID == id);
            if (sanphams == null) return HttpNotFound();

            sanphams.KichHoat = kichHoat == 1;
            db.SaveChanges();
            return RedirectToAction("Edit", new { id = sanphams.SanPhamID });
        }
    }
}
