using DoAnChuyenNganh.Filters;
using DoAnChuyenNganh.Models;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Web.Mvc;

namespace DoAnChuyenNganh.Areas.Admin.Controllers
{
    [AdminAuthorization]
    public class PhanKhucKhachHangController : Controller
    {
        ShopQuanAoEntities db = new ShopQuanAoEntities();
        // GET: Admin/PhanKhucKhachHang
        public ActionResult Index()
        {
            string duongDanFile = @"D:\HK7\DoAnCHuyenNganh\DoAnChuyenNganh_ChinhThuc\PhienBan5\PhanMem\DoAnChuyenNganh\KNN\train_data.txt";
            List<string> danhSachPhanKhuc = new List<string>();

            try
            {
                // Đọc toàn bộ file
                if (System.IO.File.Exists(duongDanFile))
                {
                    var tatCaDong = System.IO.File.ReadAllLines(duongDanFile);

                    // Lấy nội dung sau dấu phẩy cuối cùng cho từng dòng
                    foreach (var dong in tatCaDong)
                    {
                        var phanTu = dong.Split(',');
                        if (phanTu.Length > 0)
                        {
                            danhSachPhanKhuc.Add(phanTu[phanTu.Length - 1].Trim());
                        }
                    }
                }
                else
                {
                    ViewBag.ThongBao = "File không tồn tại.";
                }
            }
            catch (Exception ex)
            {
                ViewBag.ThongBao = "Lỗi khi đọc file: " + ex.Message;
            }

            // Truyền danh sách phân khúc khách hàng sang View
            ViewBag.DanhSachPhanKhuc = danhSachPhanKhuc;
            return View();
        }

        public ActionResult SanPham(string phankhuc,int page = 1,string search = "")
        {
            ViewBag.phankhuc = phankhuc;
            List<ChiTietSanPham> sanPhams = new List<ChiTietSanPham>();
            sanPhams = LaySanPhamTheoPhanKhuc(phankhuc);
            sanPhams = sanPhams.Where(x=>x.SanPham.TenSanPham.Contains(search))
             .GroupBy(row => row.SanPham.SanPhamID)
             .Select(group => group.OrderBy(row => row.Gia).FirstOrDefault())
             .ToList();
            int NoOfRecordPerPage = 9;
            int NoOfPages = Convert.ToInt32(Math.Ceiling(Convert.ToDouble(sanPhams.Count) / Convert.ToDouble(NoOfRecordPerPage)));
            int NoOfRecordToSkip = (page - 1) * NoOfRecordPerPage;
            ViewBag.Page = page;
            ViewBag.NoOfPages = NoOfPages;
            ViewBag.search = search;
            sanPhams = sanPhams.Skip(NoOfRecordToSkip).Take(NoOfRecordPerPage).ToList();
            return View(sanPhams);
        }
        public ActionResult details(int id)
        {
            List<ChiTietSanPham> pro = db.ChiTietSanPhams.Where(x => x.SanPhamID == id).ToList();
            // Kiểm tra sản phẩm có tồn tại không
            if (pro == null || !pro.Any())
            {
                return HttpNotFound("Không tìm thấy sản phẩm hoặc sản phẩm không khả dụng.");
            }
            ViewBag.sanpham = pro.OrderBy(x => x.Gia).FirstOrDefault(); // Sản phẩm giá thấp nhất
            return View(pro);
        }
        public List<ChiTietSanPham> LaySanPhamTheoPhanKhuc(string phanKhucKH)
        {
            // Lấy giá tối thiểu và tối đa dựa trên phân khúc
            int giaMin = LayGiaTuPhanKhuc(phanKhucKH, true);
            int giaMax = LayGiaTuPhanKhuc(phanKhucKH, false);
            var sanPhamsQuery = db.ChiTietSanPhams
                .Where(sp => sp.Gia >= giaMin && sp.Gia < giaMax && sp.SoLuongTonKho > 0);
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
    }
}
