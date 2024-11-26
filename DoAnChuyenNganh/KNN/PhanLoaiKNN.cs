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
            string duongDanFile = @"D:\DoAnTotNghiep\Code\PhanMem\DoAnChuyenNganh\KNN\train_data.txt";
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

            // Tính khoảng cách Euclidean
            for (int i = 0; i < x_huanLuyen.Count; i++)
            {
                double dist = KhoangCachEuclidean(danhSachNguoiDung, x_huanLuyen[i]);
                khoangCach.Add((dist, y_huanLuyen[i]));
            }

            // Sắp xếp khoảng cách tăng dần
            var khoangCachDaSapXep = khoangCach.OrderBy(d => d.KhoangCach).ToList();

            // Lấy k láng giềng gần nhất
            var hangXomGanNhat = khoangCachDaSapXep.Take(k).ToList();

            // Tính trọng số dựa trên khoảng cách
            var trongSo = hangXomGanNhat
                .Select(nn => (nn.Nhan, Weight: 1.0 / (nn.KhoangCach + 1e-5))) // Tránh chia 0
                .GroupBy(nn => nn.Nhan)
                .Select(g => new { Nhan = g.Key, TongTrongSo = g.Sum(nn => nn.Weight) })
                .OrderByDescending(c => c.TongTrongSo)
                .ToList();

            // Kiểm tra các nhóm nhãn có trọng số bằng nhau
            var nhomCoTrongSoCaoNhat = trongSo.Where(c => c.TongTrongSo == trongSo.First().TongTrongSo).ToList();

            // Nếu chỉ có 1 nhóm trọng số cao nhất, trả về nhãn
            if (nhomCoTrongSoCaoNhat.Count == 1)
            {
                return nhomCoTrongSoCaoNhat.First().Nhan;
            }

            // Trường hợp trọng số bằng nhau, tính trung bình mật độ và khoảng cách
            // Tính mật độ trung bình và khoảng cách trung bình chỉ khi các nhãn có trọng số bằng nhau
            var matDoTrungBinh = hangXomGanNhat
                .Where(hx => nhomCoTrongSoCaoNhat.Any(n => n.Nhan == hx.Nhan)) // Chỉ xét các nhãn có trọng số bằng nhau
                .GroupBy(hx => hx.Nhan)
                .Select(g => new
                {
                    Nhan = g.Key,
                    TrungBinhMatDo = g.Average(nn => 1.0 / (nn.KhoangCach + 1e-5)), // Tính trung bình mật độ
                    TrungBinhKhoangCach = g.Average(nn => nn.KhoangCach) // Tính trung bình khoảng cách
                })
                .OrderByDescending(c => c.TrungBinhMatDo) // Chọn nhóm có mật độ trung bình cao nhất
                .ThenBy(c => c.TrungBinhKhoangCach) // Nếu mật độ bằng nhau, chọn nhóm có khoảng cách trung bình nhỏ nhất
                .ToList();

            // Kiểm tra nếu matDoTrungBinh có phần tử trước khi gọi First()
            if (!matDoTrungBinh.Any())
            {
                // Nếu không có phần tử, xử lý theo cách khác (trả về nhãn mặc định hoặc thông báo lỗi)
                return "Không thể dự đoán";
            }

            // Trả về nhãn có mật độ trung bình cao nhất và khoảng cách trung bình nhỏ nhất
            var nhomDuDoan = matDoTrungBinh.First();

            // Trả về nhãn của nhóm với mật độ trung bình cao nhất, nếu cần, nhóm có khoảng cách trung bình nhỏ nhất
            return nhomDuDoan.Nhan;
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
                var danhSachKhachHang = db.NguoiDungs.Where(nd => nd.Train == true).ToList();
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
                    .Where(nd => nd.Train == true)
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
