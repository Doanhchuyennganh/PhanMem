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
        ShopQuanAoEntities2 db = new ShopQuanAoEntities2();

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
            List<GioHang> cart = db.GioHangs.Where(g => g.NguoiDungID == userId).ToList();
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
                    totalPrice += item.SanPham.Gia * item.SoLuong;
                    totalQuantity += item.SoLuong;
                }
            }

            ViewBag.SLSP = totalQuantity;
            ViewBag.TotalPrice = totalPrice;
            return View(cart);
        }

        // Thêm sản phẩm vào giỏ hàng
        public ActionResult Add(int? id, string returnUrl)
        {
            var checkLoginResult = CheckUserLoggedIn();
            if (checkLoginResult != null)
            {
                return checkLoginResult;
            }

            if (id.HasValue)
            {
                var product = db.SanPhams.FirstOrDefault(p => p.SanPhamID == id);
                if (product == null)
                {
                    ModelState.AddModelError("", "Sản phẩm không tồn tại.");
                    return RedirectToAction("Index", "Product");
                }

                int userId = GetCurrentUserId();
                GioHang cartItem = db.GioHangs.FirstOrDefault(row => row.GioHangID == id && row.NguoiDungID == userId);
                if (cartItem != null)
                {
                    cartItem.SoLuong += 1;
                }
                else
                {
                    GioHang newCartItem = new GioHang
                    {
                        SanPhamID = (int)id,
                        SoLuong = 1,
                        NguoiDungID = userId
                    };
                    db.GioHangs.Add(newCartItem);
                }

                db.SaveChanges();
            }
            if (!string.IsNullOrEmpty(returnUrl))
            {
                return Redirect(returnUrl);
            }
            return RedirectToAction("Index", "Home");
        }


        // Cập nhật số lượng sản phẩm trong giỏ hàng
        public ActionResult UpdateQuantity(int quan, int proid)
        {
            CheckUserLoggedIn();

            if (quan > 0)
            {
                int userId = GetCurrentUserId();
                GioHang cartItem = db.GioHangs.FirstOrDefault(row => row.GioHangID == proid && row.NguoiDungID == userId);

                if (cartItem != null)
                {
                    cartItem.SoLuong = quan;
                    db.SaveChanges();
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
