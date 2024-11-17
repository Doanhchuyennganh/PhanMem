using DoAnChuyenNganh.Filters;
using DoAnChuyenNganh.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace DoAnChuyenNganh.Areas.Admin.Controllers
{
    [AdminAuthorization]
    public class OrderController : Controller
    {
        ShopQuanAoEntities db = new ShopQuanAoEntities();
        // GET: Admin/Order
        public ActionResult Index()
        {
            List<DonHang> lst = db.DonHangs.ToList();
            return View(lst);
        }
        public ActionResult Cancel(int id)
        {
            var order = db.DonHangs.Find(id);
                // Xử lý hủy đơn hàng
                order.TinhTrangDonHang = "Đã Hủy"; // Hoặc trạng thái phù hợp
                db.SaveChanges();

            return RedirectToAction("Index");
        }
        public ActionResult ShipOrder(int id)
        {
            var order = db.DonHangs.Find(id);
                // Xử lý hủy đơn hàng
                order.TinhTrangDonHang = "Đang Vận Chuyển"; // Hoặc trạng thái phù hợp
                db.SaveChanges();
            return RedirectToAction("Index");
        }
        public ActionResult ConfirmOrder(int id)
        {
            var order = db.DonHangs.Find(id);
            // Xử lý hủy đơn hàng
            order.TinhTrangDonHang = "Đã Xác Nhận"; // Hoặc trạng thái phù hợp
            db.SaveChanges();
            return RedirectToAction("Index");
        }
        public ActionResult Details(int id)
        {
            // Lấy thông tin đơn hàng của người dùng
            var order = db.DonHangs
                          .Where(o => o.DonHangID == id)
                          .FirstOrDefault();
            if (order == null)
            {
                return HttpNotFound();
            }

            List<ChiTietDonHang> orderDetails = db.ChiTietDonHangs.Where(x => x.DonHangID == id).ToList();
            ViewBag.Order = order;
            return View(orderDetails);
        }
    }
}