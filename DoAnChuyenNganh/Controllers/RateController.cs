using DoAnChuyenNganh.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace DoAnChuyenNganh.Controllers
{
    public class RateController : Controller
    {
        // GET: Rate
        ShopQuanAoEntities db = new ShopQuanAoEntities();

        public ActionResult Index(int id)
        {
            // Lấy đơn hàng theo ID
            DonHang dh = db.DonHangs.FirstOrDefault(x => x.DonHangID == id);
            dh.TinhTrangDonHang = "Hoàn Thành";
            db.SaveChanges();
            ViewBag.iddonhang = id;
            if (dh == null)
            {
                return HttpNotFound("Không tìm thấy đơn hàng.");
            }

            // Lấy danh sách ChiTietSanPham từ ChiTietDonHang liên quan đến DonHang
            var ctdhList = db.ChiTietDonHangs.Where(x => x.DonHangID == id).ToList();
            ctdhList = ctdhList.Where(x => x.TinhTrangDanhGia == null || x.TinhTrangDanhGia == 0).ToList();





            return View(ctdhList); // Truyền danh sách ChiTietSanPham ra View
        }
        public ActionResult Rate(int id,int iddonhang)
        {
            // Lấy thông tin sản phẩm dựa trên ID
            ChiTietSanPham sp = db.ChiTietSanPhams.FirstOrDefault(x => x.ChiTietSanPhamID == id);
            if (sp == null)
            {
                return HttpNotFound("Sản phẩm không tồn tại.");
            }
            ViewBag.iddonhang = iddonhang;
            return View(sp); // Truyền sản phẩm vào View
        }

        [HttpPost]
        public ActionResult Rate(int id, int danhGia, string noiDung, int iddonhang)
        {
            ChiTietDonHang ctdh = db.ChiTietDonHangs
    .Where(x => x.SanPhamID == id && x.DonHangID == iddonhang) // Điều kiện thứ hai
    .FirstOrDefault(); // Lấy phần tử đầu tiên thỏa mãn điều kiện
            ctdh.TinhTrangDanhGia = 1;
            db.SaveChanges();
            // Kiểm tra sản phẩm tồn tại
            id = ctdh.ChiTietSanPham.SanPham.SanPhamID;
            SanPham sp = db.SanPhams.Where(x => x.SanPhamID == id).FirstOrDefault();
            if (sp == null)
            {
                return HttpNotFound("Sản phẩm không tồn tại.");
            }

            // Lấy người dùng hiện tại (giả sử đã đăng nhập)
            int nguoiDungID = GetCurrentUserId(); // Thay bằng logic lấy ID người dùng đăng nhập

            // Thêm phản hồi vào cơ sở dữ liệu
            PhanHoi ph = new PhanHoi
            {
                SanPhamID = id,
                NguoiDungID = nguoiDungID,
                NoiDung = noiDung,
                DanhGia = danhGia,
                NgayPhanHoi = DateTime.Now
            };
            db.PhanHois.Add(ph);

            // Lấy số sao trung bình của sản phẩm, nếu không có đánh giá nào thì gán số sao đầu tiên làm số sao trung bình.
            var danhGiaTB = db.PhanHois
                               .Where(x => x.SanPhamID == id)
                               .Average(x => (double?)x.DanhGia);

            // Nếu không có đánh giá nào, gán số sao TB bằng số sao của lượt đánh giá đầu tiên
            if (sp.SoSaoTB == null || sp.SoSaoTB == 0)
            {
                sp.SoSaoTB = danhGia;
            }
            else
            {
                sp.SoSaoTB = (int)Math.Round(danhGiaTB.Value);
            }


            db.SaveChanges();
            return RedirectToAction("index", new { id = iddonhang });
        }
        private int GetCurrentUserId()
        {
            var authCookie = Request.Cookies["auth"];
            if (authCookie != null)
            {
                string tenDangNhap = authCookie.Value;
                var user = db.NguoiDungs.FirstOrDefault(u => u.TenDangNhap == tenDangNhap);
                if (user != null)
                {
                    return user.NguoiDungID;
                }
            }
            return 0;
        }

        private ActionResult CheckUserLoggedIn()
        {
            if (Session["UserID"] == null)
            {
                return RedirectToAction("Login", "User");
            }
            return null;
        }

    }
}