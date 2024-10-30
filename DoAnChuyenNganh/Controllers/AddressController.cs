using DoAnChuyenNganh.Models;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace DoAnChuyenNganh.Controllers
{
    public class AddressController : Controller
    {
        private readonly ShopQuanAoEntities db = new ShopQuanAoEntities();

        public ActionResult Index()
        {
            int userId = GetCurrentUserId();
            var addresses = GetShippingAddresses(userId);
            return View(addresses);
        }

        // Lấy danh sách địa chỉ giao hàng của người dùng
        private List<ThongTinGiaoHang> GetShippingAddresses(int userId)
        {
            return db.ThongTinGiaoHang.Where(addr => addr.NguoiDungID == userId).ToList();
        }

        public ActionResult AddShippingAddress()
        {
            return View(); // Bạn có thể để trang này để thêm địa chỉ
        }

        // Thêm địa chỉ giao hàng
        [HttpPost]
        public ActionResult AddShippingAddress(ThongTinGiaoHang address)
        {
            if (!ModelState.IsValid)
            {
                // Nếu không hợp lệ, trả về danh sách địa chỉ để hiển thị lỗi
                var addresses = GetShippingAddresses(GetCurrentUserId());
                return View("Index", addresses); // Trả về view Index với danh sách địa chỉ
            }

            int userId = GetCurrentUserId();
            address.NguoiDungID = userId;

            // Nếu địa chỉ được chọn làm mặc định
            if (address.DiaChiMacDinh)
            {
                // Bỏ mặc định tất cả các địa chỉ khác
                SetDefaultShippingAddress(userId, address.DiaChiID);
            }

            db.ThongTinGiaoHang.Add(address);
            db.SaveChanges();
            return RedirectToAction("Index");
        }

        public ActionResult EditShippingAddress(int id)
        {
            var address = db.ThongTinGiaoHang.Find(id);
            if (address == null)
            {
                return HttpNotFound();
            }

            // Trả về view với địa chỉ hiện tại
            return View(address); // Trả về đối tượng address cho view
        }

        [HttpPost]
        public ActionResult EditShippingAddress(ThongTinGiaoHang updatedAddress)
        {
            if (!ModelState.IsValid)
            {
                // Nếu có lỗi xác thực, trả về form với dữ liệu đã nhập
                return View(updatedAddress); // Trả về đối tượng updatedAddress cho view
            }

            var existingAddress = db.ThongTinGiaoHang.Find(updatedAddress.DiaChiID);
            if (existingAddress != null)
            {
                existingAddress.TenNguoiNhan = updatedAddress.TenNguoiNhan;
                existingAddress.SoDienThoai = updatedAddress.SoDienThoai;
                existingAddress.DiaChiGiaoHang = updatedAddress.DiaChiGiaoHang;
                if (updatedAddress.DiaChiMacDinh)
                {
                    SetDefaultShippingAddress(existingAddress.NguoiDungID, existingAddress.DiaChiID);
                }

                existingAddress.DiaChiMacDinh = updatedAddress.DiaChiMacDinh; // Cập nhật cờ mặc định
                db.SaveChanges();
            }

            // Quay về danh sách địa chỉ
            var addressesAfterEdit = GetShippingAddresses(existingAddress.NguoiDungID);
            return View("Index", addressesAfterEdit);
        }


        // Phương thức thiết lập địa chỉ mặc định
        [HttpPost]
        public ActionResult SetDefaultShippingAddress(int userId, int diaChiId)
        {
            // Bỏ thiết lập tất cả địa chỉ khác là mặc định
            var otherAddresses = db.ThongTinGiaoHang
                .Where(addr => addr.NguoiDungID == userId && addr.DiaChiID != diaChiId)
                .ToList();

            foreach (var addr in otherAddresses)
            {
                addr.DiaChiMacDinh = false; // Đặt các địa chỉ khác thành không mặc định
            }

            // Đặt địa chỉ được chọn làm mặc định
            var addressToSetDefault = db.ThongTinGiaoHang.Find(diaChiId);
            if (addressToSetDefault != null)
            {
                addressToSetDefault.DiaChiMacDinh = true; // Đặt địa chỉ thành mặc định
            }

            db.SaveChanges();
            return RedirectToAction("Index");
        }

        // Phương thức thiết lập địa chỉ mặc định mới
        private void SetNewDefaultAddress(int userId)
        {
            var remainingAddress = db.ThongTinGiaoHang
                .Where(addr => addr.NguoiDungID == userId && !addr.DiaChiMacDinh)
                .FirstOrDefault();

            if (remainingAddress != null)
            {
                remainingAddress.DiaChiMacDinh = true;
                db.SaveChanges();
            }
        }

        // Xóa địa chỉ giao hàng
        [HttpPost]
        public ActionResult DeleteShippingAddress(int id)
        {
            var address = db.ThongTinGiaoHang.Find(id);
            if (address != null)
            {
                db.ThongTinGiaoHang.Remove(address);
                db.SaveChanges();

                // Thiết lập địa chỉ mới mặc định nếu địa chỉ bị xóa là địa chỉ mặc định
                if (address.DiaChiMacDinh)
                {
                    SetNewDefaultAddress(address.NguoiDungID);
                }
            }
            return RedirectToAction("Index");
        }

        // Phương thức phụ để lấy ID người dùng hiện tại
        private int GetCurrentUserId()
        {
            var authCookie = Request.Cookies["auth"];
            if (authCookie != null)
            {
                string tenDangNhap = authCookie.Value;
                var user = db.NguoiDung.FirstOrDefault(u => u.TenDangNhap == tenDangNhap);
                if (user != null)
                {
                    return user.NguoiDungID;
                }
            }
            return 0;
        }
    }
}
