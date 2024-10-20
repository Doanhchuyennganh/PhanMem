using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using DoAnChuyenNganh.Models;
using DoAnChuyenNganh.KNN;
using System.Web.Helpers;
using crypto;
using System.Drawing.Drawing2D;
namespace DoAnChuyenNganh.Controllers
{
    public class UserController : Controller
    {
        ShopQuanAoEntities db = new ShopQuanAoEntities();
        // GET: User
        public ActionResult Index()
        {
            return View();
        }
        public ActionResult Register()
        {
            return View();
        }
        [HttpPost]
        public ActionResult Register([Bind(Include = "TenDangNhap,MatKhau,Email,DoTuoi,GioiTinh,MucChiTieu,SoThich")] NguoiDung a)
        {
            if (a != null)
            {
                NguoiDung myUser = new NguoiDung
                {
                    TenDangNhap = a.TenDangNhap,
                    MatKhau = BCrypt.Net.BCrypt.HashPassword(a.MatKhau),
                    Email = a.Email,
                    DoTuoi = a.DoTuoi,
                    GioiTinh = a.GioiTinh,
                    MucChiTieu = a.MucChiTieu,
                    SoThich = a.SoThich,
                    VaiTro = "user",
                    NgayTao = DateTime.Now,
                    KichHoat = true,
                    Train = false
                };
                PhanLoaiKNN knn = new PhanLoaiKNN();
                knn.DocDuLieuNhan();
                double[] duLieuKhachHangMoi = new double[] { (double)myUser.DoTuoi, (double)myUser.MucChiTieu };
                string nhanDuDoan = knn.DuDoan(duLieuKhachHangMoi);
                if (nhanDuDoan != null && nhanDuDoan != "Khách hàng mới")
                {
                    myUser.PhanKhucKH = nhanDuDoan;
                }
                db.NguoiDung.Add(myUser);
                db.SaveChanges();             
            }
            return RedirectToAction("Login", "User");
        }

        public ActionResult Login()
        {
            return View();
        }
        [HttpPost]
        public ActionResult Login(NguoiDung a)
        {
            if (a != null)
            {
                NguoiDung myUser = db.NguoiDung.Where(u => u.TenDangNhap == a.TenDangNhap).FirstOrDefault();
                if (myUser != null)
                {
                    if (BCrypt.Net.BCrypt.Verify(a.MatKhau, myUser.MatKhau) && myUser.VaiTro == "admin")
                    {
                        HttpCookie authCookie = new HttpCookie("auth", myUser.TenDangNhap);
                        HttpCookie roleCookie = new HttpCookie("role", myUser.VaiTro);
                        Response.Cookies.Add(authCookie);
                        Response.Cookies.Add(roleCookie);
                        return RedirectToAction("Index", "Home", new { area = "admin" });
                    }
                    else if (BCrypt.Net.BCrypt.Verify(a.MatKhau, myUser.MatKhau) && myUser.VaiTro == "user")
                    {
                        HttpCookie authCookie = new HttpCookie("auth", myUser.TenDangNhap)
                        {
                            Expires = DateTime.Now.AddDays(1),
                            Path = "/",
                            HttpOnly = true
                        };
                        HttpCookie roleCookie = new HttpCookie("role", myUser.VaiTro);
                        Response.Cookies.Add(authCookie);
                        Response.Cookies.Add(roleCookie);
                    }
                    return RedirectToAction("Index", "Home");
                }
                ModelState.AddModelError("Password", "Invalid username or password !!!");
            }
            return View();
        }

    }
}