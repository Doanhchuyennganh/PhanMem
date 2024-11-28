using System;
using System.Data.Entity;
using System.Globalization;
using System.Linq;
using System.Web.Mvc;
using DoAnChuyenNganh.Models;

namespace DoAnChuyenNganh.Areas.Admin.Controllers
{
    public class ThongKeController : Controller
    {
        ShopQuanAoEntities db = new ShopQuanAoEntities();

        public ActionResult Index()
        {
            var ngayHienTai = DateTime.Now;

            // Doanh thu theo ngày
            var doanhThuTheoNgay = db.DonHangs
                .Where(d => DbFunctions.TruncateTime(d.NgayDatHang) == DbFunctions.TruncateTime(ngayHienTai) && d.TinhTrangDonHang == "Hoàn Thành")
                .Sum(d => (decimal?)d.TongTien) ?? 0;

            // Doanh thu theo tuần
            var ngayTuanTruoc = ngayHienTai.AddDays(-7);
            var doanhThuTheoTuan = db.DonHangs
                .Where(d => d.NgayDatHang >= ngayTuanTruoc && d.TinhTrangDonHang == "Hoàn Thành")
                .Sum(d => (decimal?)d.TongTien) ?? 0;

            // Doanh thu theo tháng
            var doanhThuTheoThang = db.DonHangs
                .Where(d => DbFunctions.TruncateTime(d.NgayDatHang).Value.Month == ngayHienTai.Month && DbFunctions.TruncateTime(d.NgayDatHang).Value.Year == ngayHienTai.Year && d.TinhTrangDonHang == "Hoàn Thành")
                .Sum(d => (decimal?)d.TongTien) ?? 0;

            // Doanh thu theo năm
            var doanhThuTheoNam = db.DonHangs
                .Where(d => DbFunctions.TruncateTime(d.NgayDatHang).Value.Year == ngayHienTai.Year && d.TinhTrangDonHang == "Hoàn Thành")
                .Sum(d => (decimal?)d.TongTien) ?? 0;

            // Số đơn hàng đã bán
            var soDonHang = db.DonHangs
                .Where(d => d.TinhTrangDonHang == "Hoàn Thành")
                .Count();

            // Số người mua
            var soNguoiMua = db.DonHangs
                .Where(d => d.TinhTrangDonHang == "Hoàn Thành")
                .Select(d => d.NguoiDungID)
                .Distinct()
                .Count();

            // Số sản phẩm bán được
            var soSanPhamBanDuoc = db.ChiTietDonHangs
                .Where(c => c.DonHang.TinhTrangDonHang == "Hoàn Thành")
                .Sum(c => (int?)c.SoLuong) ?? 0;

            // Đưa dữ liệu vào ViewBag để hiển thị trong View
            var cultureInfo = new CultureInfo("vi-VN");

            ViewBag.DoanhThuTheoNgay = doanhThuTheoNgay.ToString("#,0", cultureInfo) + " VNĐ";
            ViewBag.DoanhThuTheoTuan = doanhThuTheoTuan.ToString("#,0", cultureInfo) + " VNĐ";
            ViewBag.DoanhThuTheoThang = doanhThuTheoThang.ToString("#,0", cultureInfo) + " VNĐ";
            ViewBag.DoanhThuTheoNam = doanhThuTheoNam.ToString("#,0", cultureInfo) + " VNĐ";
            ViewBag.SoDonHang = soDonHang;
            ViewBag.SoNguoiMua = soNguoiMua;
            ViewBag.SoSanPhamBanDuoc = soSanPhamBanDuoc;

            // Doanh thu từng ngày trong tuần
            var ngayBatDauTuan = ngayHienTai.AddDays(-(int)ngayHienTai.DayOfWeek + 1); // Tính ngày Thứ 2
            var ngayTrongTuan = Enumerable.Range(0, 7)
                .Select(i => ngayBatDauTuan.AddDays(i))
                .ToList(); // Danh sách các ngày trong tuần (Thứ 2 -> Chủ nhật)

            var doanhThuTungNgayTrongTuan = ngayTrongTuan
                .Select(ngay => db.DonHangs
                    .Where(d => DbFunctions.TruncateTime(d.NgayDatHang) == ngay.Date && d.TinhTrangDonHang == "Hoàn Thành")
                    .Sum(d => (decimal?)d.TongTien) ?? 0)
                .ToList(); // Doanh thu cho từng ngày

            ViewBag.DoanhThuTungNgay = doanhThuTungNgayTrongTuan;

            return View();
        }

    }
}
