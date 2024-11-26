using System;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using DoAnChuyenNganh.Models;
using BCrypt.Net;
using DoAnChuyenNganh.KNN;
using DoAnChuyenNganh.Filters;
using System.Net.Mail;
using System.Net;
using Microsoft.Owin.Security;
using System.Security.Claims;
using Microsoft.AspNet.Identity;

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
        [MyAuthenFilter]
        public ActionResult ThongTinCaNhan()
        {
            int ndid = GetCurrentUserId();
            NguoiDung nd = db.NguoiDungs.Where(x=>x.NguoiDungID == ndid).FirstOrDefault();
            return View(nd);
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
        [HttpPost]
        public ActionResult ThongTinCaNhan(NguoiDung nd)
        {
            try
            {
                // Lấy thông tin người dùng từ cơ sở dữ liệu
                NguoiDung ndung = db.NguoiDungs.FirstOrDefault(x => x.NguoiDungID == nd.NguoiDungID);
                if (ndung != null)
                {
                    ndung.HoTen = nd.HoTen;
                    ndung.Email = nd.Email;
                    ndung.SoDienThoai = nd.SoDienThoai;
                    ndung.DiaChi = nd.DiaChi;
                    ndung.SoThich = nd.SoThich;
                    ndung.GioiTinh = nd.GioiTinh;
                    ndung.MucChiTieu = nd.MucChiTieu;
                    ndung.DoTuoi = nd.DoTuoi;
                    PhanLoaiKNN knn = new PhanLoaiKNN();
                    knn.DocDuLieuNhan();
                    double[] duLieuKhachHangMoi = new double[] { (double)nd.DoTuoi, (double)nd.MucChiTieu };
                    string nhanDuDoan = knn.DuDoan(duLieuKhachHangMoi);
                    ndung.PhanKhucKH = nhanDuDoan;
                    db.SaveChanges();
                    ViewBag.Message = "Cập nhật thông tin cá nhân thành công!";
                }
                else
                {
                    ViewBag.Message = "Không tìm thấy người dùng!";
                }
            }
            catch (Exception ex)
            {
                ViewBag.Message = "Đã xảy ra lỗi: " + ex.Message;
            }

            return View(nd);
        }
        public ActionResult XacThuc()
        {
            int ndid = GetCurrentUserId();
            var ndung = db.NguoiDungs.FirstOrDefault(x => x.NguoiDungID == ndid);

            if (ndung == null)
            {
                return RedirectToAction("Index", "Home");
            }

            string email = ndung.Email;

            // Tạo mã xác thực ngẫu nhiên
            var maXacThuc = GenerateVerificationCode();

            // Lưu mã xác thực và thời gian tạo mã vào Session
            Session["MaXacThuc"] = maXacThuc;
            Session["MaXacThucTimestamp"] = DateTime.Now;

            // Gửi mã xác thực qua email
            SendVerificationCodeToEmail(email, maXacThuc);

            return View();
        }


        [HttpPost]
        public ActionResult XacThuc(string maXacThuc)
        {
            // Lấy mã xác thực và thời gian tạo mã từ Session
            var maXacThucSession = Session["MaXacThuc"] as string;
            var timestampSession = Session["MaXacThucTimestamp"] as DateTime?;

            if (maXacThucSession == null || timestampSession == null)
            {
                ViewBag.ErrorMessage = "Mã xác thực không hợp lệ.";
                return View();
            }

            // Kiểm tra mã xác thực
            if (maXacThuc == maXacThucSession)
            {
                // Kiểm tra xem mã xác thực có hết hạn hay không
                var elapsedTime = DateTime.Now - timestampSession.Value;
                if (elapsedTime.TotalSeconds > 30)
                {
                    ViewBag.ErrorMessage = "Mã xác thực đã hết hạn.";
                    return View();
                }

                // Nếu mã xác thực đúng và chưa hết hạn, chuyển đến trang đổi mật khẩu
                return RedirectToAction("DoiMatKhau");
            }
            else
            {
                // Nếu mã xác thực sai
                ViewBag.ErrorMessage = "Mã xác thực không đúng!";
                return View();
            }
        }

        [XacThucFilter]
        public ActionResult DoiMatKhau()
        {
            //xóa mã xác thực khỏi Session
            Session["MaXacThuc"] = null;
            Session["MaXacThucTimestamp"] = null;
            return View();
        }
        [HttpPost]
        public ActionResult DoiMatKhau(string NewPassword, string ConfirmPassword)
        {
            int id = GetCurrentUserId();
            NguoiDung ndung = db.NguoiDungs.FirstOrDefault(x => x.NguoiDungID == id);
            if (ndung != null)
            {
                ndung.MatKhau = BCrypt.Net.BCrypt.HashPassword(NewPassword);
            }
            db.SaveChanges();
            return RedirectToAction("DoiMatKhauThanhCong");
        }


        private string GenerateVerificationCode()
        {
            // Tạo mã xác thực ngẫu nhiên (ví dụ, 6 chữ số)
            Random rand = new Random();
            return rand.Next(100000, 999999).ToString();
        }

        private void SendVerificationCodeToEmail(string email, string verificationCode)
        {
            var mail = new System.Net.Mail.MailMessage();
            mail.From = new System.Net.Mail.MailAddress("huythang1306@gmail.com");
            mail.To.Add(email);
            mail.Subject = "Mã Xác Thực";

            mail.Body = "" + verificationCode;

            var smtp = new System.Net.Mail.SmtpClient("smtp.gmail.com")
            {
                Port = 587,
                Credentials = new System.Net.NetworkCredential("huythang1306@gmail.com", "tkis metb fjre ailo"),
                EnableSsl = true
            };

            smtp.Send(mail);
        }
        public ActionResult DoiMatKhauThanhCong()
        {
            return View();
        }

        public ActionResult GuiLaiMaXacThuc()
        {
            return RedirectToAction("XacThuc");
        }





        //Đăng nhập bằng google
        private IAuthenticationManager AuthenticationManager
        {
            get { return HttpContext.GetOwinContext().Authentication; }
        }

        // Phương thức đăng nhập

        // Phương thức xử lý đăng nhập qua Google
        public ActionResult ExternalLogin(string provider)
        {
            return new ChallengeResult(provider, Url.Action("LoginCallback", "User"));
        }

        // Phương thức xử lý callback sau khi đăng nhập thành công qua Google
        public ActionResult LoginCallback()
        {
            // Lấy thông tin từ Google sau khi xác thực
            var loginInfo = AuthenticationManager.GetExternalLoginInfo();

            // Kiểm tra nếu loginInfo là null
            if (loginInfo == null)
            {
                TempData["Error"] = "Quá trình đăng nhập bị hủy hoặc xảy ra lỗi. Vui lòng thử lại.";
                return RedirectToAction("Login");
            }

            // Tìm kiếm người dùng dựa trên email
            var myUser = db.NguoiDungs.FirstOrDefault(u => u.Email == loginInfo.Email);

            if (myUser == null)
            {
                // Nếu không tìm thấy người dùng, tạo tài khoản mới
                myUser = new NguoiDung
                {
                    TenDangNhap = loginInfo.DefaultUserName,
                    Email = loginInfo.Email,
                    VaiTro = "user",
                    NgayTao = DateTime.Now,
                    KichHoat = true
                };
                db.NguoiDungs.Add(myUser);
                db.SaveChanges();
            }

            // Tạo ClaimsIdentity từ thông tin đăng nhập
            var identity = new ClaimsIdentity(DefaultAuthenticationTypes.ApplicationCookie);

            // Thêm các claim từ thông tin đăng nhập
            identity.AddClaim(new Claim(ClaimTypes.Name, myUser.TenDangNhap));
            identity.AddClaim(new Claim(ClaimTypes.Email, myUser.Email));
            identity.AddClaim(new Claim(ClaimTypes.Role, myUser.VaiTro));

            // Đăng nhập và tạo cookie
            AuthenticationManager.SignIn(new AuthenticationProperties { IsPersistent = false }, identity);

            // Lưu vào session
            Session["UserID"] = myUser.NguoiDungID;

            // Thêm cookie cho người dùng đã đăng nhập
            HttpCookie authCookie = new HttpCookie("auth", myUser.TenDangNhap)
            {
                Expires = DateTime.Now.AddDays(1),
                Path = "/",
                HttpOnly = true
            };
            HttpCookie roleCookie = new HttpCookie("role", myUser.VaiTro);
            Response.Cookies.Add(authCookie);
            Response.Cookies.Add(roleCookie);

            // Chuyển hướng đến trang chính của người dùng
            if (myUser.VaiTro == "admin")
            {
                return RedirectToAction("Index", "Home", new { area = "admin" });
            }
            else if (myUser.VaiTro == "user")
            {
                return RedirectToAction("Index", "Home");
            }

            // Mặc định, chuyển hướng đến trang đăng nhập nếu có lỗi
            TempData["Error"] = "Có lỗi xảy ra. Vui lòng thử lại.";
            return RedirectToAction("Login");
        }

    }
    public class ChallengeResult : HttpUnauthorizedResult
    {
        public ChallengeResult(string provider, string redirectUri)
        {
            LoginProvider = provider;
            RedirectUri = redirectUri;
        }

        public string LoginProvider { get; set; }
        public string RedirectUri { get; set; }

        public override void ExecuteResult(ControllerContext context)
        {
            var properties = new AuthenticationProperties { RedirectUri = RedirectUri };
            context.HttpContext.GetOwinContext().Authentication.Challenge(properties, LoginProvider);
        }
    }
}
