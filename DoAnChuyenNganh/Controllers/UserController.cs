using System;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using DoAnChuyenNganh.Models;
using BCrypt.Net;
using DoAnChuyenNganh.KNN;
using DoAnChuyenNganh.Filters;

namespace DoAnChuyenNganh.Controllers
{
    [UserAuthorization]
    public class UserController : Controller
    {
        ShopQuanAoEntities2 db = new ShopQuanAoEntities2();

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
        public ActionResult Register([Bind(Include = "TenDangNhap,MatKhau,Email,DoTuoi,GioiTinh,MucChiTieu,SoThich")] NguoiDung newUser)
        {
            if (ModelState.IsValid)
            {
                if (db.NguoiDungs.Any(u => u.TenDangNhap == newUser.TenDangNhap))
                {
                    ModelState.AddModelError("TenDangNhap", "Tên đăng nhập đã tồn tại.");
                    return View(newUser);
                }

                // Khởi tạo đối tượng người dùng mới
                NguoiDung myUser = new NguoiDung
                {
                    TenDangNhap = newUser.TenDangNhap,
                    MatKhau = BCrypt.Net.BCrypt.HashPassword(newUser.MatKhau),
                    Email = newUser.Email,
                    DoTuoi = newUser.DoTuoi,
                    GioiTinh = newUser.GioiTinh,
                    MucChiTieu = newUser.MucChiTieu,
                    SoThich = newUser.SoThich,
                    VaiTro = "user",
                    NgayTao = DateTime.Now,
                    KichHoat = true,
                    Train = true
                };

                // Phân loại khách hàng mới
                PhanLoaiKNN knn = new PhanLoaiKNN();
                knn.DocDuLieuNhan();
                double[] duLieuKhachHangMoi = new double[] { (double)myUser.DoTuoi, (double)myUser.MucChiTieu };
                string nhanDuDoan = knn.DuDoan(duLieuKhachHangMoi);
                if (nhanDuDoan != null && nhanDuDoan != "Khách hàng mới")
                {
                    myUser.PhanKhucKH = nhanDuDoan;
                }

                db.NguoiDungs.Add(myUser);
                db.SaveChanges();
                return RedirectToAction("Login", "User");
            }
            return View(newUser);
        }

        public ActionResult Login()
        {
            return View();
        }

        [HttpPost]
        public ActionResult Login(NguoiDung loginUser)
        {
            if (loginUser != null)
            {
                ShopQuanAoEntities2 db = new ShopQuanAoEntities2();
                NguoiDung myUser = db.NguoiDungs.Where(u => u.TenDangNhap == loginUser.TenDangNhap).FirstOrDefault();
                if (myUser != null)
                {
                    if (BCrypt.Net.BCrypt.Verify(loginUser.MatKhau, myUser.MatKhau) && myUser.VaiTro == "admin")
                    {
                        HttpCookie authCookie = new HttpCookie("auth", myUser.TenDangNhap);
                        HttpCookie roleCookie = new HttpCookie("role", myUser.VaiTro);
                        Response.Cookies.Add(authCookie);
                        Response.Cookies.Add(roleCookie);
                        return RedirectToAction("Index", "Home", new { area = "admin" });
                    }
                    else if (BCrypt.Net.BCrypt.Verify(loginUser.MatKhau, myUser.MatKhau) && myUser.VaiTro == "user")
                    {
                        HttpCookie authCookie = new HttpCookie("auth", myUser.TenDangNhap);
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

        public ActionResult Logout()
        {
            if (Request.Cookies["auth"] != null)
            {
                var cookie = new HttpCookie("auth")
                {
                    Expires = DateTime.Now.AddDays(-1)
                };
                Response.Cookies.Add(cookie);
            }
            Session.Clear(); // Xóa tất cả Session
            return RedirectToAction("Index", "Home");
        }
    }
}
