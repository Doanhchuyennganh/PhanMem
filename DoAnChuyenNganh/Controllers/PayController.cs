using DoAnChuyenNganh.Filters;
using DoAnChuyenNganh.Models;
using DoAnChuyenNganh.Services;
using System;
using System.Collections.Generic;
using System.IO;
using System.Linq;
using System.Text;
using System.Web.Mvc;

namespace DoAnChuyenNganh.Controllers
{
    [UserAuthorization]
    public class PayController : Controller
    {
        ShopQuanAoEntities db = new ShopQuanAoEntities();
        private readonly IVnPayServers _vnPayservice;

        public PayController(IVnPayServers vnPayServers)
        {
            _vnPayservice = vnPayServers;
        }
        public ActionResult Index()
        {
            CheckUserLoggedIn();

            int userId = GetCurrentUserId();
            List<GioHang> cart = db.GioHangs.Where(g => g.NguoiDungID == userId).ToList();
            decimal totalPrice = 0;
            int totalQuantity = 0;
            var selectedAddress = GetDefaultOrFirstShippingAddress(userId);
            if (selectedAddress == null)
            {
                ViewBag.HasShippingAddress = false;
                ViewBag.AddAddressLink = Url.Action("Index", "Address");
            }
            else
            {
                ViewBag.HasShippingAddress = true;
                ViewBag.DiaChiGiaoHang = selectedAddress;
            }
            if (cart != null && cart.Any())
            {
                foreach (var item in cart)
                {
                    if (item.SoLuong <= item.ChiTietSanPham.SoLuongTonKho)
                    {
                        totalPrice += item.ChiTietSanPham.Gia * item.SoLuong;
                        totalQuantity += item.SoLuong;
                    }
                    else
                    {
                        TempData["ErrorMessage"] = "Số lượng sản phẩm không hợp lệ, sản phẩm: "
                        + item.ChiTietSanPham.SanPham.TenSanPham.ToString()
                        + " Size: " + item.ChiTietSanPham.Size.SizeName
                        + " Màu: " + item.ChiTietSanPham.Mau.MauName
                        + " Chỉ còn: " + item.ChiTietSanPham.SoLuongTonKho.ToString()
                        + " sản phẩm !!!";


                        return RedirectToAction("Index", "Cart");

                    }

                }
            }
            ViewBag.SLSP = totalQuantity;
            ViewBag.TotalPrice = totalPrice;
            return View(cart);
        }
        [HttpPost]
        public ActionResult Index(string paymentMethod)
        {
            // Thanh toán VNPAY
            if (paymentMethod == "vnpay")
            {
                // Lấy ID người dùng hiện tại
                int userId = GetCurrentUserId();
                NguoiDung nd = db.NguoiDungs.Where(g => g.NguoiDungID == userId).FirstOrDefault();
                // Kiểm tra giỏ hàng
                var cart = db.GioHangs.Where(g => g.NguoiDungID == userId).ToList();
                if (cart == null || !cart.Any())
                {
                    return RedirectToAction("Index"); // Quay lại trang giỏ hàng nếu giỏ hàng trống
                }
                // Kiểm tra địa chỉ giao hàng
                var selectedAddress = GetDefaultOrFirstShippingAddress(userId);
                if (selectedAddress == null)
                {
                    ModelState.AddModelError("DiaChiGiaoHang", "Vui lòng chọn địa chỉ giao hàng.");
                    return RedirectToAction("Index");
                }
                // Tính tổng giá trị đơn hàng
                decimal totalPrice = cart.Sum(item => (item.ChiTietSanPham.Gia - (item.ChiTietSanPham.GiaDuocGiam ?? 0)) * item.SoLuong);
                TempData["PaymentMethod"] = paymentMethod; // Lưu giá trị paymentMethod vào TempData
                int amountToSend = Convert.ToInt32(totalPrice);

                // Lấy thông tin đầy đủ của người dùng
                string fullName = nd != null ? $"{nd.HoTen}" : "Khách hàng không xác định";

                // Mô tả đơn hàng
                string description = $"Thanh toán cho giỏ hàng của bạn, tổng giá trị: {totalPrice:C}";

                // Lấy mã đơn hàng lớn nhất hiện tại trong CSDL và cộng thêm 1
                int lastOrderId = db.DonHangs.OrderByDescending(d => d.DonHangID).Select(d => d.DonHangID).FirstOrDefault();
                int newOrderId = lastOrderId + 1; // Tạo mã đơn hàng mới

                // Tạo đối tượng yêu cầu thanh toán
                var vnPayModel = new VnPaymentRequestModel
                {
                    Amount = amountToSend,
                    CreatedDate = DateTime.Now,
                    Description = description,
                    FullName = fullName,
                    OrderId = newOrderId.ToString() // Sử dụng mã đơn hàng mới
                };

                string text = _vnPayservice.CreatePaymentUrl(HttpContext, vnPayModel);
                // Chuyển hướng đến URL thanh toán VNPay
                return Redirect(text);


            }
            else
            {
                return RedirectToAction("CapNhatDonHang", new { paymentMethod = paymentMethod });
            }
        }

        public ActionResult CapNhatDonHang(string paymentMethod)
        {
            // Lấy ID người dùng hiện tại
            int userId = GetCurrentUserId();
            NguoiDung nd = db.NguoiDungs.Where(g => g.NguoiDungID == userId).FirstOrDefault();
            // Kiểm tra giỏ hàng
            var cart = db.GioHangs.Where(g => g.NguoiDungID == userId).ToList();
            if (cart == null || !cart.Any())
            {
                TempData["ErrorMessage"] = "Giỏ hàng của bạn trống!";
                return RedirectToAction("Index"); // Quay lại trang giỏ hàng nếu giỏ hàng trống
            }

            // Kiểm tra địa chỉ giao hàng
            var selectedAddress = GetDefaultOrFirstShippingAddress(userId);
            if (selectedAddress == null)
            {
                ModelState.AddModelError("DiaChiGiaoHang", "Vui lòng chọn địa chỉ giao hàng.");
                return RedirectToAction("Index");
            }

            // Tính tổng giá trị đơn hàng
            decimal totalPrice = cart.Sum(item => (item.ChiTietSanPham.Gia - (item.ChiTietSanPham.GiaDuocGiam ?? 0)) * item.SoLuong);
            // Tạo đơn hàng mới
            var newOrder = new DonHang
            {
                NguoiDungID = userId,
                DiaChiID = selectedAddress.DiaChiID,
                TongTien = totalPrice,
                TinhTrangDonHang = "Đang xử lý", // Trạng thái ban đầu của đơn hàng
                HinhThucThanhToan = paymentMethod,
                TinhTrangThanhToan = paymentMethod == "vnpay" ? "Đã thanh toán" : "Chưa thanh toán",
                NgayThanhToan = paymentMethod == "vnpay" ? DateTime.Now : (DateTime?)null,
                NgayDatHang = DateTime.Now
            };

            db.DonHangs.Add(newOrder);
            db.SaveChanges(); // Lưu để có ID cho đơn hàng

            // Lưu chi tiết đơn hàng
            foreach (var item in cart)
            {
                var orderDetail = new ChiTietDonHang
                {
                    DonHangID = newOrder.DonHangID,
                    SanPhamID = item.SanPhamID,
                    SoLuong = item.SoLuong,
                    DonGia = item.ChiTietSanPham.Gia - (item.ChiTietSanPham.GiaDuocGiam ?? 0)
                };
                db.ChiTietDonHangs.Add(orderDetail);

                // Cập nhật số lượng sản phẩm đã bán và tồn kho
                var product = db.ChiTietSanPhams.Find(item.SanPhamID);
                product.SoLuongTonKho -= item.SoLuong;
                product.SanPham.SoLuongDaBan += item.SoLuong;
            }
            db.SaveChanges();




            // Gửi email xác nhận đơn hàng
            try
            {
                var mail = new System.Net.Mail.MailMessage();
                mail.From = new System.Net.Mail.MailAddress("huythang1306@gmail.com");
                mail.To.Add(nd.Email);
                mail.Subject = "Xác nhận đơn hàng";

                // Tạo nội dung chi tiết đơn hàng
                var orderDetails = "Cảm ơn bạn đã đặt hàng! Mã đơn hàng của bạn là: " + newOrder.DonHangID + ".\n";
                orderDetails += "Dưới đây là thông tin chi tiết đơn hàng của bạn:\n\n";

                foreach (var item in cart)
                {
                    orderDetails += $"- Sản phẩm: {item.ChiTietSanPham.SanPham.TenSanPham}\n";
                    orderDetails += $"  Size: {item.ChiTietSanPham.Size.SizeName}\n";
                    orderDetails += $"  Màu: {item.ChiTietSanPham.Mau.MauName}\n";
                    orderDetails += $"  Số lượng: {item.SoLuong}\n";
                    orderDetails += $"  Đơn giá: {item.ChiTietSanPham.Gia - (item.ChiTietSanPham.GiaDuocGiam ?? 0):C}\n"; // Lấy giá từ ChiTietSanPham
                    orderDetails += $"  Thành tiền: {(item.ChiTietSanPham.Gia - (item.ChiTietSanPham.GiaDuocGiam ?? 0)) * item.SoLuong:C}\n\n"; // Tính thành tiền
                }


                orderDetails += $"Tổng tiền: {totalPrice:C}\n";
                orderDetails += "Cảm ơn bạn đã mua sắm tại cửa hàng chúng tôi!";

                mail.Body = orderDetails;

                var smtp = new System.Net.Mail.SmtpClient("smtp.gmail.com")
                {
                    Port = 587,
                    Credentials = new System.Net.NetworkCredential("huythang1306@gmail.com", "tkis metb fjre ailo"),
                    EnableSsl = true
                };

                smtp.Send(mail);
            }
            catch (Exception ex)
            {
                // Ghi log lỗi hoặc hiện thông báo chi tiết lỗi ra console
                Console.WriteLine("Không thể gửi email: " + ex.Message);
            }

            // Xóa giỏ hàng sau khi đặt hàng thành công
            db.GioHangs.RemoveRange(cart);
            db.SaveChanges();
            // Thông báo đặt hàng thành công
            TempData["SuccessMessage"] = "Đơn hàng của bạn đã được tạo thành công!";
            return RedirectToAction("success");
        }


        private List<ThongTinGiaoHang> GetShippingAddresses(int userId)
        {
            return db.ThongTinGiaoHangs.Where(addr => addr.NguoiDungID == userId).ToList();
        }
        public ThongTinGiaoHang GetDefaultOrFirstShippingAddress(int userId)
        {
            var addresses = GetShippingAddresses(userId);
            var defaultAddress = addresses.FirstOrDefault(addr => addr.DiaChiMacDinh);
            return defaultAddress ?? addresses.FirstOrDefault();
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
        public ActionResult fail()
        {
            return View();
        }
        public ActionResult success()
        {
            return View();
        }
        public ActionResult PaymentCallBack()
        {
            var hashSecret = System.Configuration.ConfigurationManager.AppSettings["VnPay:HashSecret"];
            var response = _vnPayservice.PaymentExecute(Request.QueryString, hashSecret);

            if (response == null)
            {
                TempData["Message"] = "Lỗi thanh toán VN Pay: Phản hồi không hợp lệ hoặc chữ ký không hợp lệ.";
                return RedirectToAction("fail");
            }
            else if (response.VnPayResponseCode != "00")
            {
                TempData["Message"] = $"Lỗi thanh toán VN Pay: {response.VnPayResponseCode}";
                return RedirectToAction("fail");
            }
            else
            {
                // Lấy giá trị paymentMethod từ TempData
                string paymentMethod = TempData["PaymentMethod"] as string;
                return RedirectToAction("CapNhatDonHang", new { paymentMethod = paymentMethod });
            }
        }

    }
}
