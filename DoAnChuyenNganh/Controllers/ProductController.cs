using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using DoAnChuyenNganh.Models;
using DoAnChuyenNganh.Filters;
namespace DoAnChuyenNganh.Controllers
{
    [UserAuthorization]
    public class ProductController : Controller
    {
        // GET: Product
        ShopQuanAoEntities2 db = new ShopQuanAoEntities2();
        public ActionResult Index(string search = "", string SortColumn = "Price", string IconClass = "fa-sort-asc", int page = 1)
        {
            var authCookie = Request.Cookies["auth"];
            string tenDangNhap = authCookie != null ? authCookie.Value : null;
            List<SanPham> lstsp = db.SanPhams.Where(row => row.TenSanPham.Contains(search)).ToList();
            List<DanhMuc> lstdm = db.DanhMucs.ToList();
            List<SanPham> lstsp2 = db.SanPhams.ToList();
            ViewBag.sp = lstsp2;
            ViewBag.dm = lstdm;
            ViewBag.search = search;
            ViewBag.SortColumn = SortColumn;
            ViewBag.IconClass = IconClass;
            if (SortColumn == "Price")
            {
                lstsp = IconClass == "asc" ? lstsp.OrderBy(row => row.Gia).ToList() : lstsp.OrderByDescending(row => row.Gia).ToList();
            }
            else if (SortColumn == "Name")
            {
                lstsp = IconClass == "asc" ? lstsp.OrderBy(row => row.TenSanPham).ToList() : lstsp.OrderByDescending(row => row.TenSanPham).ToList();
            }
            // Phân trang
            int NoOfRecordPerPage = 9;
            int NoOfPages = Convert.ToInt32(Math.Ceiling(Convert.ToDouble(lstsp.Count) / Convert.ToDouble(NoOfRecordPerPage)));
            int NoOfRecordToSkip = (page - 1) * NoOfRecordPerPage;
            ViewBag.Page = page;
            ViewBag.NoOfPages = NoOfPages;
            lstsp = lstsp.Skip(NoOfRecordToSkip).Take(NoOfRecordPerPage).ToList();
            if (!string.IsNullOrEmpty(tenDangNhap))
            {
                NguoiDung user = db.NguoiDungs.FirstOrDefault(u => u.TenDangNhap == tenDangNhap);
                if (user != null)
                {
                    List<GioHang> cart = db.GioHangs.Where(g => g.NguoiDungID == user.NguoiDungID).ToList();
                    int totalQuantity = cart.Sum(item => item.SoLuong);
                    ViewBag.SLSP = totalQuantity;
                }
            }
            else
            {
                ViewBag.SLSP = 0;
            }
            return View(lstsp);
        }

        public ActionResult Details(int id)
        {
            SanPham pro = db.SanPhams.Where(x => x.SanPhamID == id).FirstOrDefault();
            int temp = 0;
            if (db.GioHangs != null)
            {
                foreach (var a in db.GioHangs)
                {
                    temp += a.SoLuong;
                }
            }
            ViewBag.SLSP = temp;
            return View(pro);
        }
    }
}