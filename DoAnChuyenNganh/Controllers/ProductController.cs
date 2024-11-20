using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using DoAnChuyenNganh.Models;
using DoAnChuyenNganh.Filters;
namespace DoAnChuyenNganh.Controllers
{
    [UserAuthorization]
    public class ProductController : Controller
    {
        // GET: Product
        ShopQuanAoEntities db = new ShopQuanAoEntities();
        public ActionResult Index(string search = "", string SortColumn = "Price", string IconClass = "fa-sort-asc", int page = 1)
        {
            var authCookie = Request.Cookies["auth"];
            string tenDangNhap = authCookie != null ? authCookie.Value : null;
            List<ChiTietSanPham> lstsp = db.ChiTietSanPhams
             .Where(row => row.SanPham.TenSanPham.Contains(search) && row.SoLuongTonKho > 0 && row.KichHoat == true)
             .GroupBy(row => row.SanPham.SanPhamID)
             .Select(group => group.OrderBy(row => row.Gia).FirstOrDefault())
             .ToList();
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



    }
}