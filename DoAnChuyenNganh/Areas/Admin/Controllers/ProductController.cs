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
        ShopQuanAoEntities2 db = new ShopQuanAoEntities2();
        public ActionResult Index(string search = "", string IconClass = "fa-sort-asc", int page = 1)
        {
            List<SanPham> sanphams = db.SanPhams.Where(row => row.TenSanPham.Contains(search)).ToList();
            int NoOfRecordPerPage = 5;
            int NoOfPages = Convert.ToInt32(Math.Ceiling(Convert.ToDouble(sanphams.Count) / Convert.ToDouble(NoOfRecordPerPage)));
            int NoOfRecordToSkip = (page - 1) * NoOfRecordPerPage;
            ViewBag.Page = page;
            ViewBag.NoOfPages = NoOfPages;
            sanphams = sanphams.Skip(NoOfRecordToSkip).Take(NoOfRecordPerPage).ToList();
            return View(sanphams);
        }
        public ActionResult VoHieuKichHoat(int id, int kichHoat)
        {
            SanPham sanphams = db.SanPhams.Where(row => row.SanPhamID == id).FirstOrDefault();
            if (kichHoat == 1)
            {
                sanphams.KichHoat = true;
            }
            else
            {
                sanphams.KichHoat = false;
            }
            db.SaveChanges();
            return RedirectToAction("Index");
        }
        public ActionResult Create()
        {
            ViewBag.DanhMucList = db.DanhMucs.ToList();
            return View();
        }
        [HttpPost]
        public ActionResult Create(SanPham sanPham, HttpPostedFileBase imageFile)
        {
            if (ModelState.IsValid)
            {
                if (imageFile != null && imageFile.ContentLength > 0)
                {
                    var fileName = Path.GetFileName(imageFile.FileName);
                    var path = Path.Combine(Server.MapPath("~/img"), fileName);
                    imageFile.SaveAs(path);
                    sanPham.HinhAnhUrl = fileName;
                }
                sanPham.NgayTao = DateTime.Now;
                sanPham.SoLuongDaBan = 0;
                sanPham.KichHoat = true;
                db.SanPhams.Add(sanPham);
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            ViewBag.DanhMucList = db.DanhMucs.ToList();
            return View(sanPham);
        }
        public ActionResult Delete(int id)
        {
            SanPham products = db.SanPhams.Where(row => row.SanPhamID == id).FirstOrDefault();
            return View(products);
        }
        [HttpPost]
        public ActionResult Delete(int id, SanPham p)
        {
            SanPham products = db.SanPhams.Where(row => row.SanPhamID == id).FirstOrDefault();
            if(products.HinhAnhUrl != null)
            {
                var imagePath = Path.Combine(Server.MapPath("~/img"), products.HinhAnhUrl);
                if (System.IO.File.Exists(imagePath))
                {
                    System.IO.File.Delete(imagePath);
                }
            }
            db.SanPhams.Remove(products);
            db.SaveChanges();
            return RedirectToAction("Index");
        }
        string anh = "";
        public ActionResult Edit(int id)
        {
            SanPham products = db.SanPhams.Where(row => row.SanPhamID == id).FirstOrDefault();
            anh = products.HinhAnhUrl;
            ViewBag.Brands = db.DanhMucs.ToList();
            return View(products);
        }
        [HttpPost]
        public ActionResult Edit(SanPham pro, HttpPostedFileBase imageFile)
        {
            // Tìm sản phẩm trong cơ sở dữ liệu theo ID
            SanPham products = db.SanPhams.Where(row => row.SanPhamID == pro.SanPhamID).FirstOrDefault();

            if (products == null)
            {
                return HttpNotFound();
            }

            // Cập nhật thông tin sản phẩm
            products.TenSanPham = pro.TenSanPham;
            products.MoTa = pro.MoTa;
            products.SoLuongTonKho = pro.SoLuongTonKho;
            products.Gia = pro.Gia;
            products.Mau = pro.Mau;
            products.DanhMucID = pro.DanhMucID;

            // Kiểm tra và cập nhật ảnh nếu có ảnh mới
            if (imageFile != null)
            {
                // Đường dẫn của ảnh hiện tại
                var oldImagePath = Path.Combine(Server.MapPath("~/img"), products.HinhAnhUrl);

                // Xóa ảnh cũ nếu tồn tại
                if (System.IO.File.Exists(oldImagePath))
                {
                    System.IO.File.Delete(oldImagePath);
                }

                // Lưu ảnh mới và cập nhật đường dẫn
                var fileName = Path.GetFileName(imageFile.FileName);
                var newPath = Path.Combine(Server.MapPath("~/img"), fileName);
                imageFile.SaveAs(newPath);

                // Cập nhật URL ảnh trong cơ sở dữ liệu
                products.HinhAnhUrl = fileName;
            }

            db.SaveChanges();
            return RedirectToAction("Index");
        }

    }
}