using DoAnChuyenNganh.Models;
using Grpc.Core;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;
using System.Text;

namespace DoAnChuyenNganh.KNN
{
    public class PhanLoaiKNN
    {
        public PhanLoaiKNN() { }
        private List<double[]> x_huanLuyen = new List<double[]>();
        private List<string> y_huanLuyen = new List<string>();
        public void DocDuLieuHuanLuyen()
        {
            string duongDanFile = @"D:\HK7\DoAnCHuyenNganh\KhuVucLamViec\PhanMem\DoAnChuyenNganh\KNN\train_data.txt";
            if (!File.Exists(duongDanFile))
                throw new FileNotFoundException($"File không tồn tại: {duongDanFile}");
            var cacDong = File.ReadAllLines(duongDanFile);
            foreach (var dong in cacDong)
            {
                var phanTu = dong.Split(',');
                if (phanTu.Length != 5)
                    continue;
                double tuoi = double.Parse(phanTu[0]);
                double chiTieu = double.Parse(phanTu[1]);
                double chuanHoaTuoi = double.Parse(phanTu[2], CultureInfo.InvariantCulture);
                double chuanHoaChiTieu = double.Parse(phanTu[3], CultureInfo.InvariantCulture);
                var nhan = phanTu[4].Trim();
                x_huanLuyen.Add(new[] { tuoi, chiTieu, chuanHoaTuoi, chuanHoaChiTieu });
                y_huanLuyen.Add(nhan);
            }
        }
        public string DuDoan(double[] danhSachNguoiDung, int k = 9)
        {
            var khoangCach = new List<(double KhoangCach, string Nhan)>();
            for (int i = 0; i < x_huanLuyen.Count; i++)
            {
                double dist = KhoangCachEuclidean(danhSachNguoiDung, x_huanLuyen[i]);
                khoangCach.Add((dist, y_huanLuyen[i]));
            }
            var khoangCachDaSapXep = khoangCach.OrderBy(d => d.KhoangCach).ToList();
            var hangXomGanNhat = khoangCachDaSapXep.Take(k).ToList();
            var demNhan = hangXomGanNhat
                .GroupBy(nn => nn.Nhan)
                .Select(g => new { Nhan = g.Key, SoLuong = g.Count() })
                .OrderByDescending(c => c.SoLuong)
                .ToList();
            return demNhan.First().Nhan;
        }
        private static double KhoangCachEuclidean(double[] diem1, double[] diem2)
        {
            double tong = 0.0;
            for (int d = 0; d < diem1.Length; d++)
            {
                double hieu = diem1[d] - diem2[d];
                tong += hieu * hieu;
            }
            return Math.Sqrt(tong);
        }

        public void DocDuLieuTuCSDL()
        {
            using (var db = new ShopQuanAoEntities())
            {
                var danhSachKhachHang = db.NguoiDungs.Where(nd => nd.Train == false).ToList();
                foreach (var kh in danhSachKhachHang)
                {
                    double tuoi = kh.DoTuoi ?? 0;
                    double chiTieu = kh.MucChiTieu ?? 0;
                    double chuanHoaTuoi = (tuoi - 0) / ( 100 - 0);
                    double chuanHoaChiTieu = (chiTieu - 0) / (100000000 - 0);
                    string nhanDuDoan = DuDoan(new[] { tuoi, chiTieu, chuanHoaTuoi, chuanHoaChiTieu });
                    kh.PhanKhucKH = nhanDuDoan;
                }
                db.SaveChanges();
            }
        }

        public void DocDuLieuNhan()
        {
            using (var db = new ShopQuanAoEntities())
            {
                var danhSachKhachHangMau = db.NguoiDungs
                    .Where(nd => nd.Train == false)
                    .Take(360)
                    .ToList();
                foreach (var kh in danhSachKhachHangMau)
                {
                    double tuoi = kh.DoTuoi ?? 0;
                    double chiTieu = kh.MucChiTieu ?? 0;
                    double chuanHoaTuoi = (tuoi - 0) / (100 - 0);
                    double chuanHoaChiTieu = (chiTieu - 0) / (100000000 - 0);
                    x_huanLuyen.Add(new[] { tuoi, chiTieu, chuanHoaTuoi, chuanHoaChiTieu });
                    y_huanLuyen.Add(kh.PhanKhucKH);
                }
            }
        }


    }
}
