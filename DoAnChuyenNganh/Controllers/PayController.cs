using DoAnChuyenNganh.Filters;
using DoAnChuyenNganh.Models;
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
        ShopQuanAoEntities2 db = new ShopQuanAoEntities2();

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
                    totalPrice += item.SanPham.Gia * item.SoLuong;
                    totalQuantity += item.SoLuong;
                }
            }
            ViewBag.SLSP = totalQuantity;
            ViewBag.TotalPrice = totalPrice;
            return View(cart);
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
    }
}
