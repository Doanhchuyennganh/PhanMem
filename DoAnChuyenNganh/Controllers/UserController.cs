using System;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using DoAnChuyenNganh.Models;
using BCrypt.Net;
using DoAnChuyenNganh.KNN;

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
        public ActionResult Register([Bind(Include = "TenDangNhap,MatKhau,Email,DoTuoi,GioiTinh,MucChiTieu,SoThich")] NguoiDung newUser)
        {
            if (ModelState.IsValid)
            {
                if (db.NguoiDung.Any(u => u.TenDangNhap == newUser.TenDangNhap))
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

                db.NguoiDung.Add(myUser);
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
            if (ModelState.IsValid)
            {
                NguoiDung myUser = db.NguoiDung.FirstOrDefault(u => u.TenDangNhap == loginUser.TenDangNhap);
                if (myUser != null)
                {
                    if (BCrypt.Net.BCrypt.Verify(loginUser.MatKhau, myUser.MatKhau))
                    {
                        Session["UserID"] = myUser.NguoiDungID;
                        HttpCookie authCookie = new HttpCookie("auth", myUser.TenDangNhap)
                        {
                            Expires = DateTime.Now.AddDays(1),
                            Path = "/",
                            HttpOnly = true
                        };
                        HttpCookie roleCookie = new HttpCookie("role", myUser.VaiTro);
                        Response.Cookies.Add(authCookie);
                        Response.Cookies.Add(roleCookie);

                        return myUser.VaiTro == "admin"
                            ? RedirectToAction("Index", "Home", new { area = "admin" })
                            : RedirectToAction("Index", "Home");
                    }
                }
                ModelState.AddModelError("", "Tên đăng nhập hoặc mật khẩu không hợp lệ.");
            }
            return View(loginUser);
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
