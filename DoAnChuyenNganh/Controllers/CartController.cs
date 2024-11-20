using DoAnChuyenNganh.Filters;
using DoAnChuyenNganh.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web.Mvc;

namespace DoAnChuyenNganh.Controllers
{
    [UserAuthorization]
    public class CartController : Controller
    {
        ShopQuanAoEntities db = new ShopQuanAoEntities();

        // Lấy ID người dùng hiện tại từ Session
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

        // GET: Giỏ hàng
        public ActionResult Index()
        {
            CheckUserLoggedIn();

            int userId = GetCurrentUserId();
            List<GioHang> cart = db.GioHangs.Where(g => g.NguoiDungID == userId && g.ChiTietSanPham.SoLuongTonKho > 0).ToList();
            decimal totalPrice = 0;
            int totalQuantity = 0;
            if (cart == null || !cart.Any())
            {
                ViewBag.SLSP = 0;
            }
            if (cart.Any())
            {
                foreach (var item in cart)
                {
                    totalPrice += item.ChiTietSanPham.Gia * item.SoLuong;
                    totalQuantity += item.SoLuong;
                }
            }
            else
            {
                ViewBag.Message = "Giỏ hàng của bạn trống hoặc sản phẩm trong giỏ đã hết hàng.";
            }
            ViewBag.SLSP = totalQuantity;
            ViewBag.TotalPrice = totalPrice;
            return View(cart);
        }

        // Thêm sản phẩm vào giỏ hàng
        public ActionResult Add(int? id, int? sizeID, int? colorID, string returnUrl)
        {
            var checkLoginResult = CheckUserLoggedIn();
            if (checkLoginResult != null)
            {
                return checkLoginResult;
            }

            if (id.HasValue && sizeID.HasValue && colorID.HasValue)
            {
                // Tìm sản phẩm trong bảng ChiTietSanPham với SanPhamID, SizeID và MauID
                var productDetail = db.ChiTietSanPhams
                    .FirstOrDefault(p => p.SanPhamID == id && p.SizeID == sizeID && p.MauID == colorID);

                if (productDetail == null)
                {
                    ModelState.AddModelError("", "Sản phẩm với kích thước và màu sắc này không tồn tại.");
                    return RedirectToAction("Index", "Product");
                }

                int userId = GetCurrentUserId();

                // Kiểm tra xem sản phẩm đã có trong giỏ hàng chưa
                var cartItem = db.GioHangs.FirstOrDefault(row =>
                    row.ChiTietSanPham.ChiTietSanPhamID == productDetail.ChiTietSanPhamID &&
                    row.NguoiDungID == userId);

                if (cartItem != null)
                {
                    cartItem.SoLuong += 1;
                }
                else
                {
                    GioHang newCartItem = new GioHang
                    {
                        SanPhamID = productDetail.ChiTietSanPhamID, // Sử dụng ChiTietSanPhamID cho mục giỏ hàng
                        SoLuong = 1,
                        NguoiDungID = userId
                    };
                    db.GioHangs.Add(newCartItem);
                }

                db.SaveChanges();
            }
            else
            {
                ModelState.AddModelError("", "Vui lòng chọn kích thước và màu sắc.");
                return RedirectToAction("Details", "Product", new { id = id }); // Redirect lại trang chi tiết sản phẩm nếu thiếu size hoặc màu
            }

            if (!string.IsNullOrEmpty(returnUrl))
            {
                return Redirect(returnUrl);
            }
            return RedirectToAction("Index", "Product");
        }



        // Cập nhật số lượng sản phẩm trong giỏ hàng
        public ActionResult UpdateQuantity(int quan, int proid)
        {
            CheckUserLoggedIn();

            if (quan > 0)
            {
                int userId = GetCurrentUserId();

                // Find the cart item for the user and product
                GioHang cartItem = db.GioHangs.FirstOrDefault(row => row.GioHangID == proid && row.NguoiDungID == userId);

                if (cartItem != null)
                {
                    // Get the product associated with the cart item
                    ChiTietSanPham product = db.ChiTietSanPhams.FirstOrDefault(p => p.ChiTietSanPhamID == cartItem.SanPhamID);

                    if (product != null)
                    {
                        // Check if the requested quantity is less than or equal to the available stock
                        if (quan <= product.SoLuongTonKho)
                        {
                            cartItem.SoLuong = quan;
                            db.SaveChanges();
                        }
                        else
                        {
                            TempData["ErrorMessage"] = $"Số lượng yêu cầu vượt quá số lượng tồn kho (Tồn kho: {product.SoLuongTonKho}).";
                            TempData["ProductId"] = proid;
                        }
                    }
                }
            }

            return RedirectToAction("Index");
        }

        // Xóa sản phẩm khỏi giỏ hàng
        public ActionResult DeleteQuantity(int proid)
        {
            CheckUserLoggedIn();

            int userId = GetCurrentUserId();
            GioHang cartItem = db.GioHangs.FirstOrDefault(row => row.GioHangID == proid && row.NguoiDungID == userId);

            if (cartItem != null)
            {
                db.GioHangs.Remove(cartItem);
                db.SaveChanges();
            }
            return RedirectToAction("Index");
        }
    }
}
