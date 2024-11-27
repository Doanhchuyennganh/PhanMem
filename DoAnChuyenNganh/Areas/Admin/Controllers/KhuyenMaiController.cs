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
    public class KhuyenMaiController : Controller
    {
        // GET: Admin/KhuyenMai
        ShopQuanAoEntities db = new ShopQuanAoEntities();
        public ActionResult Index(string search = "", int page = 1)
        {
            List<KhuyenMai> km = db.KhuyenMais.Where(x=>x.TenChuongTrinhKM.Contains(search)).ToList();

            int NoOfRecordPerPage = 5;
            int NoOfPages = Convert.ToInt32(Math.Ceiling(Convert.ToDouble(km.Count) / NoOfRecordPerPage));
            int NoOfRecordToSkip = (page - 1) * NoOfRecordPerPage;
            ViewBag.Page = page;
            ViewBag.NoOfPages = NoOfPages;
            ViewBag.search = search;
            km = km.Skip(NoOfRecordToSkip).Take(NoOfRecordPerPage).ToList();
            return View(km);
        }
        public ActionResult Create()
        {
            return View();
        }
        [HttpPost]
        public ActionResult Create(KhuyenMai km)
        {
            if (ModelState.IsValid)
            {
                db.KhuyenMais.Add(km);
                db.SaveChanges();
                return RedirectToAction("Index");
            }
            return View(km);
        }
        public ActionResult Edit(int id)
        {
            KhuyenMai km = db.KhuyenMais.FirstOrDefault(row => row.MaKhuyenMai == id);
            if (km == null) return HttpNotFound();
            ViewBag.ChiTietKhuyenMai = db.ChiTietKhuyenMais.Where(x => x.KhuyenMaiID == id).ToList();
            return View(km);
        }

        [HttpPost]
        public ActionResult Edit(KhuyenMai pro)
        {
            KhuyenMai km = db.KhuyenMais.FirstOrDefault(row => row.MaKhuyenMai == pro.MaKhuyenMai);
            if (km == null) return HttpNotFound();

            km.TenChuongTrinhKM = pro.TenChuongTrinhKM;
            km.MoTa = pro.MoTa;
            km.MucGiam = pro.MucGiam;
            km.NgayBatDau = pro.NgayBatDau;
            km.NgayKetThuc = pro.NgayKetThuc;
            db.SaveChanges();
            LoadKM();
            return RedirectToAction("Index");
        }

        public ActionResult AddSPKhuyenMai(int id, string search = "", int page = 1)
        {
            // Lấy danh sách sản phẩm chưa thuộc chương trình khuyến mãi
            var lstsp = db.SanPhams
                          .Where(sp => !db.ChiTietKhuyenMais.Any(ctkm => ctkm.SanPhamID == sp.SanPhamID && ctkm.KhuyenMaiID == id))
                          .ToList();
            lstsp = lstsp.Where(x => x.TenSanPham.Contains(search)).ToList();
            int NoOfRecordPerPage = 5;
            int NoOfPages = Convert.ToInt32(Math.Ceiling(Convert.ToDouble(lstsp.Count) / NoOfRecordPerPage));
            int NoOfRecordToSkip = (page - 1) * NoOfRecordPerPage;
            ViewBag.Page = page;
            ViewBag.NoOfPages = NoOfPages;
            lstsp = lstsp.Skip(NoOfRecordToSkip).Take(NoOfRecordPerPage).ToList();
            ViewBag.IdKhuyenMai = id;
            ViewBag.search = search;
            return View(lstsp);
        }
        [HttpPost]
        public ActionResult AddSPKhuyenMai(int idKhuyenMai, List<int> sanPhamIds)
        {
            KhuyenMai km = db.KhuyenMais.Where(x => x.MaKhuyenMai == idKhuyenMai).FirstOrDefault();
            List<ChiTietSanPham> lstctsp = db.ChiTietSanPhams.ToList();
            if (sanPhamIds != null && sanPhamIds.Any())
            {
                foreach (var sanPhamId in sanPhamIds)
                {
                    foreach(var scsp in lstctsp)
                    {
                        if(scsp.SanPhamID == sanPhamId && km.NgayKetThuc >= DateTime.Now)
                        {
                            decimal giaduocgiam = (decimal)(km.MucGiam * (decimal)0.01* scsp.Gia);
                            scsp.GiaDuocGiam += giaduocgiam;
                        }    
                    }
                    // Kiểm tra nếu sản phẩm đã được thêm trước đó
                    if (!db.ChiTietKhuyenMais.Any(ctkm => ctkm.SanPhamID == sanPhamId && ctkm.KhuyenMaiID == idKhuyenMai))
                    {
                        var chiTietKhuyenMai = new ChiTietKhuyenMai
                        {
                            KhuyenMaiID = idKhuyenMai,
                            SanPhamID = sanPhamId
                        };

                        db.ChiTietKhuyenMais.Add(chiTietKhuyenMai);
                    }
                }

                db.SaveChanges();
            }

            return RedirectToAction("Edit", new { id = idKhuyenMai });
        }
        public ActionResult XoaSanPhamKhoiKhuyenMai(int id, int idKhuyenMai)
        {
            // Tìm chi tiết khuyến mãi theo id và idKhuyenMai
            ChiTietKhuyenMai chiTietKhuyenMai = db.ChiTietKhuyenMais.Where(x => x.ChiTietKhuyenMaiID == id).FirstOrDefault();

            List<ChiTietSanPham> lstctsp = db.ChiTietSanPhams.ToList();
            foreach (var scsp in lstctsp)
            {
                if (scsp.SanPhamID == chiTietKhuyenMai.SanPhamID)
                {
                    decimal giaduocgiam = (decimal)(chiTietKhuyenMai.KhuyenMai.MucGiam * (decimal)0.01 * scsp.Gia);
                    scsp.GiaDuocGiam -= giaduocgiam;
                }
            }
           
            if (chiTietKhuyenMai != null)
            {
                // Xóa chi tiết sản phẩm khỏi chương trình khuyến mãi
                db.ChiTietKhuyenMais.Remove(chiTietKhuyenMai);
                db.SaveChanges();
            }

            // Sau khi xóa, chuyển hướng về trang "Edit" của chương trình khuyến mãi
            return RedirectToAction("Edit", new { id = idKhuyenMai });
        }
        public void LoadKM()
        {
            List<ChiTietKhuyenMai> lstctkm = db.ChiTietKhuyenMais.ToList();
            List<ChiTietSanPham> lstsp = db.ChiTietSanPhams.ToList();
            foreach (var a in lstctkm)
            {
                if (a.KhuyenMai.NgayKetThuc <= DateTime.Now && a.DaHetHan != true)
                {
                    a.DaHetHan = true;
                    foreach (var sp in lstsp)
                    {
                        if (a.SanPhamID == sp.SanPhamID)
                        {
                            sp.GiaDuocGiam -= (a.KhuyenMai.MucGiam * (decimal)0.01 * sp.Gia);
                        }
                    }
                }else
                {
                    a.DaHetHan = false;
                    foreach (var sp in lstsp)
                    {
                        if (a.SanPhamID == sp.SanPhamID)
                        {
                            sp.GiaDuocGiam += (a.KhuyenMai.MucGiam * (decimal)0.01 * sp.Gia);
                        }
                    }
                }    
            }

        }



    }
}