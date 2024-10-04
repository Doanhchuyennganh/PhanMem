using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using DoAnChuyenNganh.Models;
namespace DoAnChuyenNganh.Controllers
{
    public class UserController : Controller
    {
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
        public ActionResult Register([Bind(Include = "TenDangNhap,MatKhau,HoTen,Email,DoTuoi,GioiTinh,MucChiTieu,SoDienThoai,DiaChi,SoThich")] NguoiDung a)
        {
            DoAnChuyenNganhEntities1 db = new DoAnChuyenNganhEntities1();
            NguoiDung myUser = new NguoiDung();
            myUser.TenDangNhap = a.TenDangNhap;//
            myUser.MatKhau = a.MatKhau;//
            myUser.HoTen =a.HoTen;//
            myUser.Email =a.Email;//
            myUser.DoTuoi =a.DoTuoi;
            myUser.GioiTinh =a.GioiTinh;
            myUser.MucChiTieu =a.MucChiTieu;
            myUser.SoDienThoai =a.SoDienThoai;//
            myUser.DiaChi =a.DiaChi;//
            myUser.SoThich =a.SoThich;
            myUser.VaiTro = "user";
            myUser.NgayTao = DateTime.Now;
            myUser.KichHoat = true;
            myUser.PhanKhucKH = "Khách hàng mới";
            myUser.Train = false;
            db.NguoiDungs.Add(myUser);
            db.SaveChanges();   
            return View();
        }
    }
}