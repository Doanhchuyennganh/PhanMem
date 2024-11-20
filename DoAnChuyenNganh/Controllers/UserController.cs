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
                if (db.NguoiDungs.Any(u => u.TenDangNhap == newUser.TenDangNhap))
                {
                    ModelState.AddModelError("TenDangNhap", "Tên đăng nhập đã tồn tại.");
                    return View(newUser);
                }
                if (db.NguoiDungs.Any(u => u.Email == newUser.Email))
                {
                    ModelState.AddModelError("Email", "Email đã tồn tại.");
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
            // Kiểm tra tính hợp lệ của model (bao gồm các validation nếu có)
            if (ModelState.IsValid)
            {
                // Tìm người dùng theo tên đăng nhập
                NguoiDung myUser = db.NguoiDungs.FirstOrDefault(u => u.TenDangNhap == loginUser.TenDangNhap);

                // Kiểm tra nếu không tìm thấy người dùng với tên đăng nhập
                if (myUser == null)
                {
                    // Nếu không tìm thấy người dùng, thêm lỗi vào ModelState
                    ModelState.AddModelError("TenDangNhap", "Tên đăng nhập không tồn tại.");
                    return View(loginUser);
                }
                if (myUser.MatKhau == null)
                {
                    // Nếu không tìm thấy người dùng, thêm lỗi vào ModelState
                    ModelState.AddModelError("MatKhau", "Mật khẩu không được để trống.");
                    return View(loginUser);
                }
                // Kiểm tra mật khẩu
                if (!BCrypt.Net.BCrypt.Verify(loginUser.MatKhau, myUser.MatKhau))
                {
                    // Nếu mật khẩu không đúng, thêm lỗi vào ModelState
                    ModelState.AddModelError("MatKhau", "Mật khẩu không chính xác.");
                    return View(loginUser);
                }

                // Nếu tên đăng nhập và mật khẩu đúng, lưu thông tin người dùng vào Session và Cookies
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

                // Kiểm tra vai trò người dùng và chuyển hướng đến trang tương ứng
                if (myUser.VaiTro == "admin")
                {
                    return RedirectToAction("Index", "Home", new { area = "admin" });
                }
                else if (myUser.VaiTro == "user")
                {
                    return RedirectToAction("Index", "Home");
                }
            }
            else
            {
                ModelState.AddModelError("", "Tên đăng nhập hoặc mật khẩu không đúng.");
            }
            // Trả về view với các lỗi nếu có
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

        [HttpPost]
        public JsonResult CheckExists(string TenDangNhap, string Email)
        {
            // Kiểm tra trong cơ sở dữ liệu
            bool isUsernameExists = db.NguoiDungs.Any(u => u.TenDangNhap == TenDangNhap);
            bool isEmailExists = db.NguoiDungs.Any(u => u.Email == Email);

            if (isUsernameExists)
            {
                return Json(new { isValid = false, errorField = "TenDangNhap" });
            }
            if (isEmailExists)
            {
                return Json(new { isValid = false, errorField = "Email" });
            }

            return Json(new { isValid = true });
        }

    }
}
