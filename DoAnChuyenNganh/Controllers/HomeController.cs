using DoAnChuyenNganh.Filters;
using DoAnChuyenNganh.KNN;
using DoAnChuyenNganh.Models;
using System;
using System.Collections.Generic;
using System.Data.Entity.Core.Common.CommandTrees.ExpressionBuilder;
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
        public void LoadKM()
        {
            List<ChiTietKhuyenMai> lstctkm = db.ChiTietKhuyenMais.ToList();
            List<ChiTietSanPham> lstsp = db.ChiTietSanPhams.ToList();
            foreach (var a in lstctkm)
            {
                if (a.KhuyenMai.NgayKetThuc <= DateTime.Now && a.DaHetHan != true)
                {
                    a.DaHetHan = true;
                    foreach (var sp in lstsp)
                    {
                        if (a.SanPhamID == sp.SanPhamID)
                        {
                            sp.GiaDuocGiam -= (a.KhuyenMai.MucGiam * (decimal)0.01 * sp.Gia);
                        }
                    }
                }
            }
        }
        // GET: Home
        public ActionResult Index()
        {

            //PhanLoaiKNN kn = new PhanLoaiKNN();
            //kn.DocDuLieuHuanLuyen();
            //kn.DocDuLieuTuCSDL();
            LoadKM();
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
            List<ChiTietSanPham> sps = new List<ChiTietSanPham>();
            if (sanPhams.Count == 0)
            {
                sps = db.ChiTietSanPhams.Where(x => x.SanPham.SoSaoTB >= 4).OrderByDescending(x => x.SanPham.SoLuongDaBan).Take(30).ToList();
                sanPhams = sps;
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

            // Lấy từ khóa độ tuổi từ phân khúc
            string tuKhoaDoTuoi = LayTuKhoaDoTuoi(phanKhucKH);

            var sanPhamsQuery = db.ChiTietSanPhams
                .Where(sp =>
                    sp.Gia >= giaMin &&
                    sp.Gia < giaMax &&
                    sp.SoLuongTonKho > 0); // Lọc theo mức chi tiêu và tồn kho

            // Lọc sản phẩm theo từ khóa độ tuổi (phân khúc)
            if (!string.IsNullOrEmpty(tuKhoaDoTuoi))
            {
                sanPhamsQuery = sanPhamsQuery
                    .Where(sp => sp.SanPham.MoTa.ToLower().Contains(tuKhoaDoTuoi.ToLower()));
            }

            // Lọc sản phẩm theo giới tính
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

            // Lọc sản phẩm theo sở thích
            if (!string.IsNullOrEmpty(soThich))
            {
                var soThichArray = soThich.Split(',').Select(st => st.Trim().ToLower()).ToArray();
                sanPhamsQuery = sanPhamsQuery
                    .Where(sp => soThichArray.Any(st => sp.SanPham.DanhMuc.TenDanhMuc.ToLower().Contains(st)));
            }

            // Trả về danh sách các sản phẩm lọc xong
            return sanPhamsQuery.Distinct().Take(9).ToList();
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
                    return isMin ? 800000 : int.MaxValue;

                default:
                    return 0;
            }
        }
        private string LayTuKhoaDoTuoi(string phanKhucKH)
        {
            if (phanKhucKH.Contains("Thanh niên"))
                return "thanh niên";
            if (phanKhucKH.Contains("Trung niên"))
                return "trung niên";
            if (phanKhucKH.Contains("Cao tuổi"))
                return "cao tuổi";
            return string.Empty;
        }
    }
}
