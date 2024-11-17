using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using DoAnChuyenNganh.Filters;
using DoAnChuyenNganh.Models;
namespace DoAnChuyenNganh.Areas.Admin.Controllers
{
    [AdminAuthorization]
    public class UserController : Controller
    {
        ShopQuanAoEntities db = new ShopQuanAoEntities();
        // GET: Admin/User
        public ActionResult Index(string search = "", string IconClass = "fa-sort-asc", int page = 1)
        {
            List<NguoiDung> users = db.NguoiDungs.Where(row => row.TenDangNhap.Contains(search)).Where(x=>x.Train == true).ToList();
            // Phân trang
            int NoOfRecordPerPage = 5;
            int NoOfPages = Convert.ToInt32(Math.Ceiling(Convert.ToDouble(users.Count) / Convert.ToDouble(NoOfRecordPerPage)));
            int NoOfRecordToSkip = (page - 1) * NoOfRecordPerPage;
            ViewBag.Page = page;
            ViewBag.NoOfPages = NoOfPages;
            users = users.Skip(NoOfRecordToSkip).Take(NoOfRecordPerPage).ToList();
            return View(users);
        }
        public ActionResult Create()
        {
            ViewBag.User = db.NguoiDungs.ToList();
            return View();
        }
        [HttpPost]
        public ActionResult Create(NguoiDung user, string retypePassword)
        {
            if (!ModelState.IsValid)
            {
                return View();
            }
            if (user.MatKhau != retypePassword)
            {
                ModelState.AddModelError("retypePassword", "Passwords do not match.");
                return View();
            }
            NguoiDung myUser = db.NguoiDungs.Where(u => u.TenDangNhap == user.TenDangNhap).FirstOrDefault();
            if (myUser != null)
            {
                ModelState.AddModelError("UserName", "UserName already exist.");
                return View();
            }
            myUser = db.NguoiDungs.Where(u => u.Email == user.Email).FirstOrDefault();
            if (myUser != null)
            {
                ModelState.AddModelError("EmailAddress", "EmailAddress already exist.");
                return View();
            }
            myUser = new NguoiDung();
            myUser.TenDangNhap = user.TenDangNhap;
            myUser.MatKhau = BCrypt.Net.BCrypt.HashPassword(user.MatKhau);
            myUser.Email = user.Email;
            myUser.KichHoat = true;
            myUser.VaiTro = "admin";
            myUser.Train = true;
            db.NguoiDungs.Add(myUser);
            db.SaveChanges();
            return RedirectToAction("Index");
        }
        public ActionResult VoHieuKichHoat(int id, int kichHoat)
        {
            NguoiDung userToUpdate = db.NguoiDungs.Where(row => row.NguoiDungID == id).FirstOrDefault();
            if(kichHoat == 1)
            {
                userToUpdate.KichHoat = true;
            }else
            {
                userToUpdate.KichHoat = false;
            }
            db.SaveChanges();
            return RedirectToAction("Index");
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