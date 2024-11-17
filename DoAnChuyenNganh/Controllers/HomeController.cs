using DoAnChuyenNganh.Filters;
using DoAnChuyenNganh.KNN;
using DoAnChuyenNganh.Models;
using System;
using System.Collections.Generic;
using System.Diagnostics;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace DoAnChuyenNganh.Controllers
{
    [UserAuthorization]
    public class HomeController : Controller
    {
        ShopQuanAoEntities db = new ShopQuanAoEntities();

        // GET: Home
        public ActionResult Index()
        {
            PhanLoaiKNN kn = new PhanLoaiKNN();
            var authCookie = Request.Cookies["auth"];
            string tenDangNhap = authCookie != null ? authCookie.Value : null;
            List<ChiTietSanPham> sanPhams = new List<ChiTietSanPham>();
            List<GioHang> cart = new List<GioHang>();
            int totalQuantity = 0;
            if (!string.IsNullOrEmpty(tenDangNhap))
            {
                NguoiDung kh = db.NguoiDungs.FirstOrDefault(u => u.TenDangNhap == tenDangNhap);
                if (kh != null)
                {
                    cart = db.GioHangs.Where(g => g.NguoiDungID == kh.NguoiDungID).ToList();
                    totalQuantity = cart.Sum(item => item.SoLuong);
                    sanPhams = LaySanPhamTheoPhanKhucVaSoThich(kh.PhanKhucKH, kh.SoThich, kh.GioiTinh);
                }
            }
            
            if (sanPhams.Count == 0)
            {
                sanPhams = db.ChiTietSanPhams.OrderBy(sp => sp.Gia).Take(10).ToList();
            }
            sanPhams = sanPhams
             .GroupBy(row => row.SanPham.SanPhamID)
             .Select(group => group.OrderBy(row => row.Gia).FirstOrDefault())
             .ToList();
            ViewBag.SLSP = totalQuantity;
            ViewBag.SanPhamLienQuan = sanPhams;
            return View(sanPhams);
        }


        public List<ChiTietSanPham> LaySanPhamTheoPhanKhucVaSoThich(string phanKhucKH, string soThich, string gioiTinh)
        {
            // Lấy giá tối thiểu và tối đa dựa trên phân khúc
            int giaMin = LayGiaTuPhanKhuc(phanKhucKH, true);
            int giaMax = LayGiaTuPhanKhuc(phanKhucKH, false);
            var sanPhamsQuery = db.ChiTietSanPhams
                .Where(sp => sp.Gia >= giaMin && sp.Gia < giaMax);
            if (!string.IsNullOrEmpty(gioiTinh))
            {
                string gioiTinhLower = gioiTinh.ToLower();

                if (gioiTinhLower == "nam")
                {
                    sanPhamsQuery = sanPhamsQuery.Where(sp =>
                        sp.SanPham.TenSanPham.ToLower().Contains("nam") ||
                        sp.SanPham.TenSanPham.ToLower().Contains("unisex"));
                }
                else if (gioiTinhLower == "nữ")
                {
                    sanPhamsQuery = sanPhamsQuery.Where(sp =>
                        sp.SanPham.TenSanPham.ToLower().Contains("nữ") ||
                        sp.SanPham.TenSanPham.ToLower().Contains("unisex"));
                }
            }

            if (!string.IsNullOrEmpty(soThich))
            {
                var soThichArray = soThich.Split(',').Select(st => st.Trim()).ToArray();
                sanPhamsQuery = sanPhamsQuery
                    .Where(sp => soThichArray.Any(st => sp.SanPham.DanhMuc.TenDanhMuc.Contains(st)));
            }
            return sanPhamsQuery.Distinct().ToList();
        }

        // Hàm lấy giá tối thiểu và tối đa dựa trên phân khúc
        private int LayGiaTuPhanKhuc(string phanKhucKH, bool isMin)
        {
            switch (phanKhucKH)
            {
                case "Thanh niên từ 0 đến 37 tuổi chi tiêu thấp":
                case "Trung niên từ 38 đến 60 tuổi chi tiêu thấp":
                case "Cao tuổi từ 60 tuổi trở lên chi tiêu thấp":
                    return isMin ? 150000 : 400000;

                case "Thanh niên từ 0 đến 37 tuổi chi tiêu vừa phải":
                case "Trung niên từ 38 đến 60 tuổi chi tiêu vừa phải":
                case "Cao tuổi từ 60 tuổi trở lên chi tiêu vừa phải":
                    return isMin ? 500000 : 750000;

                case "Thanh niên từ 0 đến 37 tuổi chi tiêu cao":
                case "Trung niên từ 38 đến 60 tuổi chi tiêu cao":
                case "Cao tuổi từ 60 tuổi trở lên chi tiêu cao":
                    return isMin ? 800000: int.MaxValue;

                default:
                    return 0;
            }
        }
    }
}
