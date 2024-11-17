using DoAnChuyenNganh.Filters;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using DoAnChuyenNganh.Models;
namespace DoAnChuyenNganh.Controllers
{
    [UserAuthorization]
    public class OrderController : Controller
    {
        // GET: Order
        private readonly ShopQuanAoEntities db = new ShopQuanAoEntities();

        // GET: Order
        public ActionResult Index()
        {
            if (Session["UserId"] == null)
            {
                return RedirectToAction("Login", "User");
            }

            int userId = (int)Session["UserId"];
            List<DonHang> lst = db.DonHangs.Where(x => x.NguoiDungID == userId).ToList();
            return View(lst);
        }
        public ActionResult Details(int id)
        {
            if (Session["UserId"] == null)
            {
                return RedirectToAction("Login", "User");
            }


            // Lấy thông tin đơn hàng của người dùng
            var order = db.DonHangs
                          .Where(o => o.DonHangID == id)
                          .FirstOrDefault();

            if (order == null)
            {
                return HttpNotFound();
            }

            // Lấy chi tiết đơn hàng
            List<ChiTietDonHang> orderDetails = db.ChiTietDonHangs.Where(x=>x.DonHangID == id).ToList();

            // Trả lại view cùng với thông tin đơn hàng và chi tiết đơn hàng
            ViewBag.Order = order;
            return View(orderDetails);
        }
        public ActionResult Cancel(int id)
        {
            var order = db.DonHangs.Find(id);
            if (order != null && order.TinhTrangDonHang != "Đã Xác Nhận")
            {
                // Xử lý hủy đơn hàng
                order.TinhTrangDonHang = "Đã Hủy"; // Hoặc trạng thái phù hợp
                db.SaveChanges();
            }
            return RedirectToAction("Index");
        }


    }
}