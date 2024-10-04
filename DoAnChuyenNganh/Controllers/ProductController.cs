using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;
using DoAnChuyenNganh.Models;
namespace DoAnChuyenNganh.Controllers
{
    public class ProductController : Controller
    {
        // GET: Product
      
        public ActionResult Index(string search = "", string SortColumn = "Price", string IconClass = "fa-sort-asc", int page = 1)
        {
            DoAnChuyenNganhEntities1 db = new DoAnChuyenNganhEntities1();
            List<SanPham> lstsp = db.SanPhams.Where(row=>row.TenSanPham.Contains(search)).ToList();
            List<DanhMuc> lstdm = db.DanhMucs.ToList();
            List<SanPham> lstsp2 = db.SanPhams.ToList();
            ViewBag.sp = lstsp2;
            ViewBag.dm = lstdm;
            ViewBag.search = search;
            //Xắp xếp
            ViewBag.SortColumn = SortColumn;
            ViewBag.IconClass = IconClass;
            if (SortColumn == "Price")
            {
                if (IconClass == "asc")
                {
                    lstsp = lstsp.OrderBy(row => row.Gia).ToList();
                }
                else
                {
                    lstsp = lstsp.OrderByDescending(row => row.Gia).ToList();
                }
            }
            if (SortColumn == "Name")
            {
                if (IconClass == "asc")
                {
                    lstsp = lstsp.OrderBy(row => row.TenSanPham).ToList();
                }
                else
                {
                    lstsp = lstsp.OrderByDescending(row => row.TenSanPham).ToList();
                }
            }
            ViewBag.Sortcolumn = SortColumn;
            ViewBag.IconClass = IconClass;
            // Phân trang
            int NoOfRecordPerPage = 9;
            int NoOfPages = Convert.ToInt32(Math.Ceiling(
                Convert.ToDouble(lstsp.Count) / Convert.ToDouble(NoOfRecordPerPage)));
            int NoOfRecordToSkip = (page - 1) * NoOfRecordPerPage;
            ViewBag.Page = page;
            ViewBag.NoOfPages = NoOfPages;
            lstsp = lstsp.Skip(NoOfRecordToSkip).Take(NoOfRecordPerPage).ToList();
            return View(lstsp);
        }
    }
}