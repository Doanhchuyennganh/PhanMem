using DoAnChuyenNganh.Filters;
using DoAnChuyenNganh.Models;
using System;
using System.Collections.Generic;
using System.Data.Entity;
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
            CheckUserLoggedIn(); // Ensure the user is logged in

            int userId = GetCurrentUserId();
            var cart = db.GioHangs
                .Where(g => g.NguoiDungID == userId)
                .Include(g => g.ChiTietSanPham)
                .ToList();

            decimal totalPrice = 0;
            int totalQuantity = 0;
            bool hasOutOfStock = false;

            // Check if the cart is empty
            if (cart == null || !cart.Any())
            {
                ModelState.AddModelError("", "Vui lòng chọn đơn hàng muốn thanh toán.");
                ViewBag.HasOutOfStock = true;
                ViewBag.IsValid = false;
                ViewBag.SLSP = 0;
                ViewBag.TotalPrice = 0;
                return View(cart); // Don't redirect to avoid losing state
            }

            // Check for out-of-stock products
            foreach (var item in cart)
            {
                var product = db.ChiTietSanPhams.Find(item.SanPhamID);

                if (product == null || product.KichHoat == null || product.SoLuongTonKho <= 0)
                {
                    // Mark out-of-stock products
                    hasOutOfStock = true;
                    db.Entry(item).State = EntityState.Modified;
                }
                else
                {
                    // Calculate total price and quantity for products that are in stock
                    totalPrice += product.Gia * item.SoLuong;
                    totalQuantity += item.SoLuong;
                }
            }

            // Save changes to the cart
            db.SaveChanges();

            // Set ViewBag values for the view
            ViewBag.SLSP = totalQuantity;
            ViewBag.TotalPrice = totalPrice;
            ViewBag.HasOutOfStock = hasOutOfStock;
            ViewBag.IsValid = !hasOutOfStock; // If there are out-of-stock products, it's invalid for checkout

            return View(cart);
        }




        // Thêm sản phẩm vào giỏ hàng
        public ActionResult Add(int? id, int? sizeID, int? colorID, string returnUrl)
        {
            CheckUserLoggedIn();
            int userId = GetCurrentUserId();
            // Tìm sản phẩm trong bảng ChiTietSanPham với SanPhamID, SizeID và MauID
            var productDetail = db.ChiTietSanPhams
                .FirstOrDefault(p => p.SanPhamID == id && p.SizeID == sizeID && p.MauID == colorID);
            // Kiểm tra xem sản phẩm đã có trong giỏ hàng chưa
            var cartItem = db.GioHangs.FirstOrDefault(row =>
                row.ChiTietSanPham.ChiTietSanPhamID == productDetail.ChiTietSanPhamID &&
                row.NguoiDungID == userId);
            if (id.HasValue && sizeID.HasValue && colorID.HasValue)
            {
                if (productDetail == null)
                {
                    ModelState.AddModelError("", "Sản phẩm với kích thước và màu sắc này không tồn tại.");
                    return RedirectToAction("Index", "Product");
                }

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
            int userId = GetCurrentUserId();

            // Find the cart item for the user and product
            GioHang cartItem = db.GioHangs.FirstOrDefault(row => row.GioHangID == proid && row.NguoiDungID == userId);
            if (quan > 0)
            {

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

        // Xóa nhiều sản phẩm 
        [HttpPost]
        public JsonResult DeleteSelected(List<int> selectedItems)
        {
            if (selectedItems != null && selectedItems.Any())
            {
                var itemsToDelete = db.GioHangs.Where(g => selectedItems.Contains(g.GioHangID)).ToList();
                db.GioHangs.RemoveRange(itemsToDelete);
                db.SaveChanges();
                return Json(new { success = true });
            }
            return Json(new { success = false });
        }


    }
}
