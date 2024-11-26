using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using DoAnChuyenNganh.Models;
using DoAnChuyenNganh.Filters;
using DoAnChuyenNganh.KNN;

namespace DoAnChuyenNganh.Controllers
{
    [UserAuthorization]
    public class ProductController : Controller
    {
        // GET: Product
        ShopQuanAoEntities db = new ShopQuanAoEntities();
        public ActionResult Index(string search = "", string SortColumn = "Price", string IconClass = "fa-sort-asc", int page = 1, int dotuoi = 0, string gioitinh = "", string sothich = "", decimal mucchitieu = 0, bool trangthaigoiy = false)
        {
            LoadKM();
            var authCookie = Request.Cookies["auth"];
            string tenDangNhap = authCookie != null ? authCookie.Value : null;
            List<ChiTietSanPham> lstsp = db.ChiTietSanPhams
             .Where(row => row.SanPham.TenSanPham.Contains(search) && row.SoLuongTonKho > 0 && row.KichHoat == true)
             .GroupBy(row => row.SanPham.SanPhamID)
             .Select(group => group.OrderBy(row => row.Gia).FirstOrDefault())
             .ToList();
            //Gợi ý thông minh
            //Bắt đầu
            if (trangthaigoiy == true)
            {
                ViewBag.dotuoi = dotuoi;
                ViewBag.gioitinh = gioitinh;
                ViewBag.sothich = sothich;
                ViewBag.mucchitieu = mucchitieu;
                string phankhuc = "";
                PhanLoaiKNN knn = new PhanLoaiKNN();
                knn.DocDuLieuNhan();
                double[] duLieuKhachHangMoi = new double[] { (double)dotuoi, (double)mucchitieu };
                string nhanDuDoan = knn.DuDoan(duLieuKhachHangMoi);
                if (nhanDuDoan != null && nhanDuDoan != "Khách hàng mới")
                {
                    phankhuc = nhanDuDoan;
                }
                lstsp = LaySanPhamTheoPhanKhucVaSoThich(phankhuc, sothich, gioitinh);
            }
            //Kết thúc
            List<DanhMuc> lstdm = db.DanhMucs.ToList();
            List<SanPham> lstsp2 = db.SanPhams.ToList();
            ViewBag.sp = lstsp2;
            ViewBag.dm = lstdm;
            ViewBag.search = search;
            ViewBag.SortColumn = SortColumn;
            ViewBag.IconClass = IconClass;

            if (SortColumn == "Price")
            {
                lstsp = IconClass == "asc" ? lstsp.OrderBy(row => row.Gia).ToList() : lstsp.OrderByDescending(row => row.Gia).ToList();
            }
            else if (SortColumn == "Name")
            {
                lstsp = IconClass == "asc" ? lstsp.OrderBy(row => row.SanPham.TenSanPham).ToList() : lstsp.OrderByDescending(row => row.SanPham.TenSanPham).ToList();
            }
            // Phân trang
            int NoOfRecordPerPage = 9;
            int NoOfPages = Convert.ToInt32(Math.Ceiling(Convert.ToDouble(lstsp.Count) / Convert.ToDouble(NoOfRecordPerPage)));
            int NoOfRecordToSkip = (page - 1) * NoOfRecordPerPage;
            ViewBag.Page = page;
            ViewBag.NoOfPages = NoOfPages;
            lstsp = lstsp.Skip(NoOfRecordToSkip).Take(NoOfRecordPerPage).ToList();
            if (!string.IsNullOrEmpty(tenDangNhap))
            {
                NguoiDung user = db.NguoiDungs.FirstOrDefault(u => u.TenDangNhap == tenDangNhap);
                if (user != null)
                {
                    List<GioHang> cart = db.GioHangs.Where(g => g.NguoiDungID == user.NguoiDungID).ToList();
                    int totalQuantity = cart.Sum(item => item.SoLuong);
                    ViewBag.SLSP = totalQuantity;
                }
            }
            else
            {
                ViewBag.SLSP = 0;
            }

            return View(lstsp);
        }

        public ActionResult Details(int id)
        {
            LoadKM();
            // Lấy cookie xác thực
            var authCookie = Request.Cookies["auth"];
            string tenDangNhap = authCookie != null ? authCookie.Value : null;

            // Lấy chi tiết sản phẩm (đảm bảo chỉ lấy sản phẩm đang hoạt động hoặc còn hàng)
            List<ChiTietSanPham> pro = db.ChiTietSanPhams.Where(x => x.SanPhamID == id).ToList();

            // Kiểm tra sản phẩm có tồn tại không
            if (pro == null || !pro.Any())
            {
                return HttpNotFound("Không tìm thấy sản phẩm hoặc sản phẩm không khả dụng.");
            }

            // Lấy thông tin người dùng nếu đã đăng nhập
            if (!string.IsNullOrEmpty(tenDangNhap))
            {
                NguoiDung user = db.NguoiDungs.FirstOrDefault(u => u.TenDangNhap == tenDangNhap);
                if (user != null)
                {
                    // Lấy giỏ hàng
                    List<GioHang> cart = db.GioHangs.Where(g => g.NguoiDungID == user.NguoiDungID).ToList();
                    int totalQuantity = cart.Sum(item => item.SoLuong);
                    ViewBag.SLSP = totalQuantity;
                }
            }
            else
            {
                ViewBag.SLSP = 0; // Không có sản phẩm trong giỏ
            }

            // Lấy sản phẩm chính và phản hồi liên quan
            ViewBag.sanpham = pro.OrderBy(x => x.Gia).FirstOrDefault(); // Sản phẩm giá thấp nhất
            ViewBag.phanhoi = db.PhanHois.Where(x => x.SanPhamID == id).ToList();

            // Trả về View với danh sách sản phẩm
            return View(pro);
        }

        [HttpPost]
        public ActionResult UpdateOptions(int? sizeID, int? mauID, int sanPhamID)
        {
            var db = new ShopQuanAoEntities();

            // Tìm giá theo Size và Màu
            var gia = db.ChiTietSanPhams
                        .Where(x => x.SanPhamID == sanPhamID &&
                                    (sizeID == null || x.SizeID == sizeID) &&
                                    (mauID == null || x.MauID == mauID))
                        .Select(x => x.Gia)
                        .FirstOrDefault();

            // Tìm các màu tương ứng với Size đã chọn
            var availableColors = db.ChiTietSanPhams
                                    .Where(x => x.SanPhamID == sanPhamID && (sizeID == null || x.SizeID == sizeID))
                                    .Select(x => x.Mau)
                                    .Distinct()
                                    .ToList();

            // Tìm các size tương ứng với Màu đã chọn
            var availableSizes = db.ChiTietSanPhams
                                   .Where(x => x.SanPhamID == sanPhamID && (mauID == null || x.MauID == mauID))
                                   .Select(x => x.Size)
                                   .Distinct()
                                   .ToList();

            // Truyền giá và các tùy chọn vào ViewBag
            ViewBag.Gia = gia;
            ViewBag.AvailableColors = availableColors;
            ViewBag.AvailableSizes = availableSizes;

            // Render lại view với các giá trị được cập nhật
            return View("ChiTiet", db.ChiTietSanPhams.Where(x => x.SanPhamID == sanPhamID).ToList());
        }
        public JsonResult GetPrice(int sizeID, int colorID, int productID)
        {
            var chiTietSanPham = db.ChiTietSanPhams
                .Where(c => c.SizeID == sizeID && c.MauID == colorID && c.SanPhamID == productID)
                .FirstOrDefault();

            if (chiTietSanPham != null)
            {
                return Json(new { gia = chiTietSanPham.Gia }, JsonRequestBehavior.AllowGet);
            }
            else
            {
                return Json(new { gia = 0 }, JsonRequestBehavior.AllowGet); // Trả về giá 0 nếu không tìm thấy
            }
        }









        //Gợi ý thông minh
        public List<ChiTietSanPham> LaySanPhamTheoPhanKhucVaSoThich(string phanKhucKH, string soThich, string gioiTinh)
        {
            // Lấy giá tối thiểu và tối đa dựa trên phân khúc
            int giaMin = LayGiaTuPhanKhuc(phanKhucKH, true);
            int giaMax = LayGiaTuPhanKhuc(phanKhucKH, false);
            var sanPhamsQuery = db.ChiTietSanPhams
                .Where(sp => sp.Gia >= giaMin && sp.Gia < giaMax && sp.SoLuongTonKho > 0);
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
                    return isMin ? 800000 : int.MaxValue;

                default:
                    return 0;
            }
        }
        public void LoadKM()
        {
            List<ChiTietKhuyenMai> lstctkm = db.ChiTietKhuyenMais.ToList();
            List<ChiTietSanPham> lstsp = db.ChiTietSanPhams.ToList();
            foreach(var a in lstctkm)
            {
                if(a.KhuyenMai.NgayKetThuc <= DateTime.Now && a.DaHetHan != true )
                {
                    a.DaHetHan = true;
                    foreach(var sp in lstsp)
                    {
                        if(a.SanPhamID == sp.SanPhamID)
                        {
                            sp.GiaDuocGiam -= (a.KhuyenMai.MucGiam * (decimal)0.01 * sp.Gia);
                        }    
                    }    
                }    
            }    
        }



    }
}