CREATE DATABASE ShopQuanAo
USE ShopQuanAo
CREATE TABLE NguoiDung (
    NguoiDungID INT PRIMARY KEY IDENTITY(1,1), 
    TenDangNhap NVARCHAR(50) UNIQUE NOT NULL,   
    MatKhau NVARCHAR(255) NOT NULL,           
    HoTen NVARCHAR(100), --NOT NULL,
    Email NVARCHAR(100), --UNIQUE NOT NULL,
    SoDienThoai NVARCHAR(15),
    DiaChi NVARCHAR(255),
	SoThich NVARCHAR(255),
    VaiTro NVARCHAR(50) DEFAULT 'user', --user/admin
    NgayTao DATETIME DEFAULT GETDATE(),
	PhanKhucKH NVARCHAR(100) DEFAULT N'Khách Hàng Mới',
	Train BIT DEFAULT 1, 
	GioiTinh NVARCHAR(10) NULL,           
    MucChiTieu INT NULL,       
    DoTuoi INT NULL,
    KichHoat BIT DEFAULT 1
);     
CREATE TABLE ThongTinGiaoHang (
    DiaChiID INT PRIMARY KEY IDENTITY(1,1),
    NguoiDungID INT NOT NULL,
    TenNguoiNhan NVARCHAR(100) NOT NULL,
    SoDienThoai NVARCHAR(15) NOT NULL,
    DiaChiGiaoHang NVARCHAR(255) NOT NULL,
    DiaChiMacDinh BIT DEFAULT 0, -- Địa chỉ mặc định
    FOREIGN KEY (NguoiDungID) REFERENCES NguoiDung(NguoiDungID)
);
CREATE TABLE DanhMuc (
    DanhMucID INT PRIMARY KEY IDENTITY(1,1),
    TenDanhMuc NVARCHAR(100) NOT NULL,
);
CREATE TABLE SanPham (
    SanPhamID INT PRIMARY KEY IDENTITY(1,1),
    TenSanPham NVARCHAR(100) NOT NULL,
    MoTa NVARCHAR(MAX),
	SoLuongDaBan INT DEFAULT 0,
	SoSaoTB int Default 0, 
    DanhMucID INT,
    KichHoat BIT DEFAULT 1,
    FOREIGN KEY (DanhMucID) REFERENCES DanhMuc(DanhMucID)
);
-- Tạo bảng Size
CREATE TABLE Size (
    SizeID INT PRIMARY KEY IDENTITY(1,1),
    SizeName NVARCHAR(10) NOT NULL
);
-- Tạo bảng Mau
CREATE TABLE Mau (
    MauID INT PRIMARY KEY IDENTITY(1,1),
    MauName NVARCHAR(20) NOT NULL
);
CREATE TABLE ChiTietSanPham (
    ChiTietSanPhamID INT IDENTITY(1,1) PRIMARY KEY, -- Khóa chính tự tăng
    SanPhamID INT,
    SizeID INT,
    MauID INT,
	Gia DECIMAL(18, 2) NOT NULL,
	GiaDuocGIam DECIMAL(18, 2) DEFAULT 0,
    SoLuongTonKho INT NOT NULL,
	HinhAnhUrl NVARCHAR(255),
	KichHoat BIT DEFAULT 1,
    FOREIGN KEY (SanPhamID) REFERENCES SanPham(SanPhamID),
    FOREIGN KEY (SizeID) REFERENCES Size(SizeID),
    FOREIGN KEY (MauID) REFERENCES Mau(MauID)
);


CREATE TABLE DonHang (
    DonHangID INT PRIMARY KEY IDENTITY(1,1),
    NguoiDungID INT NOT NULL,
	NhanVienID INT,
	DiaChiID INT NOT NULL,
    TongTien DECIMAL(18, 2) NOT NULL,
    TinhTrangDonHang NVARCHAR(50) NOT NULL,
    NgayDatHang DATETIME DEFAULT GETDATE(),
	HinhThucThanhToan NVARCHAR(50) NOT NULL,
    TinhTrangThanhToan NVARCHAR(50) NOT NULL,
    NgayThanhToan DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (NguoiDungID) REFERENCES NguoiDung(NguoiDungID),
	FOREIGN KEY (NhanVienID) REFERENCES NguoiDung(NguoiDungID),
	FOREIGN KEY (DiaChiID) REFERENCES ThongTinGiaoHang(DiaChiID)
);
CREATE TABLE ChiTietDonHang (
    ChiTietDonHangID INT PRIMARY KEY IDENTITY(1,1),
    DonHangID INT NOT NULL,
    SanPhamID INT NOT NULL,
    SoLuong INT NOT NULL,
    DonGia DECIMAL(18, 2) NOT NULL,
	TinhTrangDanhGia int Default 0,
    FOREIGN KEY (DonHangID) REFERENCES DonHang(DonHangID),
    FOREIGN KEY (SanPhamID) REFERENCES ChiTietSanPham(ChiTietSanPhamID)
);
CREATE TABLE GioHang (
    GioHangID INT PRIMARY KEY IDENTITY(1,1),
    NguoiDungID INT NOT NULL,
    SanPhamID INT NOT NULL,
    SoLuong INT NOT NULL,
    FOREIGN KEY (NguoiDungID) REFERENCES NguoiDung(NguoiDungID),
    FOREIGN KEY (SanPhamID) REFERENCES ChiTietSanPham(ChiTietSanPhamID)
);

CREATE TABLE PhanHoi (
    PhanHoiID INT PRIMARY KEY IDENTITY(1,1),
    SanPhamID INT NOT NULL,
    NguoiDungID INT NOT NULL,
    NoiDung NVARCHAR(MAX),
    DanhGia INT CHECK(DanhGia BETWEEN 1 AND 5),
    NgayPhanHoi DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (SanPhamID) REFERENCES SanPham(SanPhamID),
    FOREIGN KEY (NguoiDungID) REFERENCES NguoiDung(NguoiDungID)
);
CREATE TABLE KhuyenMai (
    MaKhuyenMai INT PRIMARY KEY IDENTITY(1,1), 
    TenChuongTrinhKM NVARCHAR(100),
	MucGiam INT,--%
    MoTa NVARCHAR(255),
    NgayBatDau DATE,
    NgayKetThuc DATE
);
CREATE TABLE ChiTietKhuyenMai (
	ChiTietKhuyenMaiID INT PRIMARY KEY IDENTITY(1,1), 
    SanPhamID INT,
    KhuyenMaiID INT,
	DaHetHan bit Default 0,
    FOREIGN KEY (SanPhamID) REFERENCES SanPham(SanPhamID),
    FOREIGN KEY (KhuyenMaiID) REFERENCES KhuyenMai(MaKhuyenMai)
);








-- Dữ liệu train phân khúc khách hàng Thanh niên từ 0 đến 37 tuổi chi tiêu thấp
INSERT INTO NguoiDung (TenDangNhap,MatKhau, DoTuoi, MucChiTieu, SoThich , Train) VALUES 
(N'TDN001','123',23, 19000000, N'Thể thao', 0),
(N'TDN002','123',19, 14000000, N'Công sở, lịch sự', 0),
(N'TDN003','123',32, 20000000, N'Đơn giản, thường ngày', 0),
(N'TDN004','123',27, 5000000, N'Thời trang du lịch', 0),
(N'TDN005','123',28, 20000000, N'Thời trang hot trend', 0),
(N'TDN006','123',24, 9000000, N'Thể thao', 0),
(N'TDN007','123',34, 10000000, N'Công sở, lịch sự', 0),
(N'TDN008','123',22, 19000000, N'Đơn giản, thường ngày', 0),
(N'TDN009','123',22, 12000000, N'Thời trang du lịch', 0),
(N'TDN0010','123',28, 18000000, N'Thời trang hot trend', 0),
(N'TDN0011','123',23, 19000000, N'Thể thao', 0),
(N'TDN0012','123',22, 9000000, N'Công sở, lịch sự', 0),
(N'TDN0013','123',25, 6000000, N'Đơn giản, thường ngày', 0),
(N'TDN0014','123',22, 18000000, N'Thời trang du lịch', 0),
(N'TDN0015','123',21, 10000000, N'Thời trang hot trend', 0),
(N'TDN0016','123',27, 18000000, N'Thể thao', 0),
(N'TDN0017','123',31, 17000000, N'Công sở, lịch sự', 0),
(N'TDN0018','123',19, 6000000, N'Đơn giản, thường ngày', 0),
(N'TDN0019','123',33, 12000000, N'Thời trang du lịch', 0),
(N'TDN0020','123',25, 12000000, N'Thời trang hot trend', 0),
(N'TDN0021','123',26, 15000000, N'Thể thao', 0),
(N'TDN0022','123',32, 14000000, N'Công sở, lịch sự', 0),
(N'TDN0023','123',28, 18000000, N'Đơn giản, thường ngày', 0),
(N'TDN0024','123',18, 16000000, N'Thời trang du lịch', 0),
(N'TDN0025','123',34, 8000000, N'Thời trang hot trend', 0),
(N'TDN0026','123',21, 7000000, N'Thể thao', 0),
(N'TDN0027','123',28, 17000000, N'Công sở, lịch sự', 0),
(N'TDN0028','123',34, 11000000, N'Đơn giản, thường ngày', 0),
(N'TDN0029','123',18, 13000000, N'Thời trang du lịch', 0),
(N'TDN0030','123',26, 9000000, N'Thời trang hot trend', 0),
(N'TDN0031','123',30, 5000000, N'Thể thao', 0),
(N'TDN0032','123',19, 9000000, N'Công sở, lịch sự', 0),
(N'TDN0033','123',20, 9000000, N'Đơn giản, thường ngày', 0),
(N'TDN0034','123',20, 8000000, N'Thời trang du lịch', 0),
(N'TDN0035','123',24, 16000000, N'Thời trang hot trend', 0),
(N'TDN0036','123',28, 17000000, N'Thể thao', 0),
(N'TDN0037','123',31, 10000000, N'Công sở, lịch sự', 0),
(N'TDN0038','123',31, 12000000, N'Đơn giản, thường ngày', 0),
(N'TDN0039','123',18, 14000000, N'Thời trang du lịch', 0),
(N'TDN0040','123',18, 17000000, N'Thời trang hot trend',0);
-- Dữ liệu train phân khúc khách hàng Thanh niên từ 0 đến 37 tuổi chi tiêu vừa phải
INSERT INTO NguoiDung (TenDangNhap,MatKhau, DoTuoi, MucChiTieu, SoThich, Train) VALUES 
(N'TDN0041','123', 18, 38000000, N'Thể thao', 0),
(N'TDN0042','123', 23, 50000000, N'Công sở, lịch sự', 0),
(N'TDN0043','123', 33, 59000000, N'Đơn giản, thường ngày', 0),
(N'TDN0044','123', 22, 45000000, N'Thời trang du lịch', 0),
(N'TDN0045','123', 23, 52000000, N'Thời trang hot trend', 0),
(N'TDN0046','123', 33, 52000000, N'Thể thao', 0),
(N'TDN0047','123', 31, 41000000, N'Công sở, lịch sự', 0),
(N'TDN0048','123', 30, 31000000, N'Đơn giản, thường ngày', 0),
(N'TDN0049','123', 29, 56000000, N'Thời trang du lịch', 0),
(N'TDN0050','123', 26, 39000000, N'Thời trang hot trend', 0),
(N'TDN0051','123', 20, 31000000, N'Thể thao', 0),
(N'TDN0052','123', 31, 49000000, N'Công sở, lịch sự', 0),
(N'TDN0053','123', 19, 35000000, N'Đơn giản, thường ngày', 0),
(N'TDN0054','123', 34, 60000000, N'Thời trang du lịch', 0),
(N'TDN0055','123', 32, 35000000, N'Thời trang hot trend', 0),
(N'TDN0056','123', 20, 44000000, N'Thể thao', 0),
(N'TDN0057','123', 23, 36000000, N'Công sở, lịch sự', 0),
(N'TDN0058','123', 26, 52000000, N'Đơn giản, thường ngày', 0),
(N'TDN0059','123', 30, 32000000, N'Thời trang du lịch', 0),
(N'TDN0060','123', 32, 54000000, N'Thời trang hot trend', 0),
(N'TDN0061','123', 32, 47000000, N'Thể thao', 0),
(N'TDN0062','123', 18, 37000000, N'Công sở, lịch sự', 0),
(N'TDN0063','123', 34, 33000000, N'Đơn giản, thường ngày', 0),
(N'TDN0064','123', 34, 43000000, N'Thời trang du lịch', 0),
(N'TDN0065','123', 21, 38000000, N'Thời trang hot trend', 0),
(N'TDN0066','123', 19, 47000000, N'Thể thao', 0),
(N'TDN0067','123', 30, 37000000, N'Công sở, lịch sự', 0),
(N'TDN0068','123', 26, 38000000, N'Đơn giản, thường ngày', 0),
(N'TDN0069','123', 23, 44000000, N'Thời trang du lịch', 0),
(N'TDN0070','123', 25, 48000000, N'Thời trang hot trend', 0),
(N'TDN0071','123', 25, 45000000, N'Thể thao', 0),
(N'TDN0072','123', 22, 58000000, N'Công sở, lịch sự', 0),
(N'TDN0073','123', 18, 60000000, N'Đơn giản, thường ngày', 0),
(N'TDN0074','123', 34, 54000000, N'Thời trang du lịch', 0),
(N'TDN0075','123', 20, 47000000, N'Thời trang hot trend', 0),
(N'TDN0076','123', 26, 32000000, N'Thể thao', 0),
(N'TDN0077','123', 26, 57000000, N'Công sở, lịch sự', 0),
(N'TDN0078','123', 23, 60000000, N'Đơn giản, thường ngày', 0),
(N'TDN0079','123', 28, 39000000, N'Thời trang du lịch', 0),
(N'TDN0080','123', 27, 50000000, N'Thời trang hot trend',0);
-- Dữ liệu train phân khúc khách hàng Thanh niên từ 0 đến 37 tuổi chi tiêu cao
INSERT INTO NguoiDung (TenDangNhap,MatKhau, DoTuoi, MucChiTieu, SoThich, Train) VALUES 
(N'TDN0081','123', 18, 87000000, N'Thể thao', 0),
(N'TDN0082','123', 34, 77000000, N'Công sở, lịch sự', 0),
(N'TDN0083','123', 25, 92000000, N'Đơn giản, thường ngày', 0),
(N'TDN0084','123', 24, 94000000, N'Thời trang du lịch', 0),
(N'TDN0085','123', 33, 73000000, N'Thời trang hot trend', 0),
(N'TDN0086','123', 19, 83000000, N'Thể thao', 0),
(N'TDN0087','123', 28, 89000000, N'Công sở, lịch sự', 0),
(N'TDN0088','123', 27, 83000000, N'Đơn giản, thường ngày', 0),
(N'TDN0089','123', 34, 74000000, N'Thời trang du lịch', 0),
(N'TDN0090','123', 33, 72000000, N'Thời trang hot trend', 0),
(N'TDN0091','123', 20, 69000000, N'Thể thao', 0),
(N'TDN0092','123', 32, 97000000, N'Công sở, lịch sự', 0),
(N'TDN0093','123', 30, 65000000, N'Đơn giản, thường ngày', 0),
(N'TDN0094','123', 22, 96000000, N'Thời trang du lịch', 0),
(N'TDN0095','123', 23, 86000000, N'Thời trang hot trend', 0),
(N'TDN0096','123', 31, 73000000, N'Thể thao', 0),
(N'TDN0097','123', 22, 87000000, N'Công sở, lịch sự', 0),
(N'TDN0098','123', 23, 84000000, N'Đơn giản, thường ngày', 0),
(N'TDN0099','123', 21, 75000000, N'Thời trang du lịch', 0),
(N'TDN0100','123', 23, 88000000, N'Thời trang hot trend', 0),
(N'TDN0101','123', 24, 92000000, N'Thể thao', 0),
(N'TDN0102','123', 24, 83000000, N'Công sở, lịch sự', 0),
(N'TDN0103','123', 30, 90000000, N'Đơn giản, thường ngày', 0),
(N'TDN0104','123', 20, 72000000, N'Thời trang du lịch', 0),
(N'TDN0105','123', 32, 74000000, N'Thời trang hot trend', 0),
(N'TDN0106','123', 27, 91000000, N'Thể thao', 0),
(N'TDN0107','123', 22, 93000000, N'Công sở, lịch sự', 0),
(N'TDN0108','123', 24, 84000000, N'Đơn giản, thường ngày', 0),
(N'TDN0109','123', 30, 79000000, N'Thời trang du lịch', 0),
(N'TDN0110','123', 20, 100000000, N'Thời trang hot trend', 0),
(N'TDN0111','123', 18, 96000000, N'Thể thao', 0),
(N'TDN0112','123', 23, 84000000, N'Công sở, lịch sự', 0),
(N'TDN0113','123', 20, 89000000, N'Đơn giản, thường ngày', 0),
(N'TDN0114','123', 33, 71000000, N'Thời trang du lịch', 0),
(N'TDN0115','123', 19, 78000000, N'Thời trang hot trend', 0),
(N'TDN0116','123', 19, 90000000, N'Thể thao', 0),
(N'TDN0117','123', 31, 71000000, N'Công sở, lịch sự', 0),
(N'TDN0118','123', 21, 70000000, N'Đơn giản, thường ngày', 0),
(N'TDN0119','123', 32, 96000000, N'Thời trang du lịch', 0),
(N'TDN0120','123', 18, 95000000, N'Thời trang hot trend',0);
-- Dữ liệu train phân khúc khách hàng Trung niên từ 38 đến 60 tuổi chi tiêu thấp
INSERT INTO NguoiDung(TenDangNhap,MatKhau, DoTuoi, MucChiTieu, SoThich, Train) VALUES  
(N'TDN0121','123', 40, 16000000, N'Thể thao', 0), 
(N'TDN0122','123', 55, 13000000, N'Công sở, lịch sự', 0),
(N'TDN0123','123', 48, 15000000, N'Đơn giản, thường ngày', 0),
(N'TDN0124','123', 48, 18000000, N'Thời trang du lịch', 0),
(N'TDN0125','123', 43, 10000000, N'Thời trang hot trend', 0),
(N'TDN0126','123', 50, 8000000, N'Thể thao', 0),
(N'TDN0127','123', 54, 18000000, N'Công sở, lịch sự', 0),
(N'TDN0128','123', 44, 20000000, N'Đơn giản, thường ngày', 0),
(N'TDN0129','123', 49, 5000000, N'Thời trang du lịch', 0),
(N'TDN0130','123', 46, 6000000, N'Thời trang hot trend', 0),
(N'TDN0131','123', 49, 20000000, N'Thể thao', 0),
(N'TDN0132','123', 42, 7000000, N'Công sở, lịch sự', 0),
(N'TDN0133','123', 45, 11000000, N'Đơn giản, thường ngày', 0),
(N'TDN0134','123', 49, 14000000, N'Thời trang du lịch', 0),
(N'TDN0135','123', 49, 6000000, N'Thời trang hot trend', 0),
(N'TDN0136','123', 54, 14000000, N'Thể thao', 0),
(N'TDN0137','123', 50, 17000000, N'Công sở, lịch sự', 0),
(N'TDN0138','123', 44, 11000000, N'Đơn giản, thường ngày', 0),
(N'TDN0139','123', 40, 19000000, N'Thời trang du lịch', 0),
(N'TDN0140','123', 45, 13000000, N'Thời trang hot trend', 0),
(N'TDN0141','123', 50, 9000000, N'Thể thao', 0),
(N'TDN0142','123', 45, 18000000, N'Công sở, lịch sự', 0),
(N'TDN0143','123', 48, 5000000, N'Đơn giản, thường ngày', 0),
(N'TDN0144','123', 40, 17000000, N'Thời trang du lịch', 0),
(N'TDN0145','123', 43, 14000000, N'Thời trang hot trend', 0),
(N'TDN0146','123', 51, 7000000, N'Thể thao', 0),
(N'TDN0147','123', 49, 13000000, N'Công sở, lịch sự', 0),
(N'TDN0148','123', 42, 17000000, N'Đơn giản, thường ngày', 0),
(N'TDN0149','123', 55, 5000000, N'Thời trang du lịch', 0),
(N'TDN0150','123', 48, 17000000, N'Thời trang hot trend', 0),
(N'TDN0151','123', 44, 5000000, N'Thể thao', 0),
(N'TDN0152','123', 50, 9000000, N'Công sở, lịch sự', 0),
(N'TDN0153','123', 47, 8000000, N'Đơn giản, thường ngày', 0),
(N'TDN0154','123', 55, 19000000, N'Thời trang du lịch', 0),
(N'TDN0155','123', 55, 20000000, N'Thời trang hot trend', 0),
(N'TDN0156','123', 40, 12000000, N'Thể thao', 0),
(N'TDN0157','123', 44, 8000000, N'Công sở, lịch sự', 0),
(N'TDN0158','123', 49, 5000000, N'Đơn giản, thường ngày', 0),
(N'TDN0159','123', 55, 16000000, N'Thời trang du lịch', 0),
(N'TDN0160','123', 53, 19000000, N'Thời trang hot trend',0);
-- Dữ liệu train phân khúc khách hàng Trung niên từ 38 đến 60 tuổi chi tiêu vừa phải
INSERT INTO NguoiDung(TenDangNhap,MatKhau, DoTuoi, MucChiTieu, SoThich, Train) VALUES
(N'TDN0161','123', 52, 31000000, N'Thể thao', 0),
(N'TDN0162','123', 46, 46000000, N'Công sở, lịch sự', 0),
(N'TDN0163','123', 52, 60000000, N'Đơn giản, thường ngày', 0),
(N'TDN0164','123', 54, 36000000, N'Thời trang du lịch', 0),
(N'TDN0165','123', 46, 42000000, N'Thời trang hot trend', 0),
(N'TDN0166','123', 45, 42000000, N'Thể thao', 0),
(N'TDN0167','123', 54, 54000000, N'Công sở, lịch sự', 0),
(N'TDN0168','123', 49, 41000000, N'Đơn giản, thường ngày', 0),
(N'TDN0169','123', 52, 48000000, N'Thời trang du lịch', 0),
(N'TDN0170','123', 46, 54000000, N'Thời trang hot trend', 0),
(N'TDN0171','123', 47, 31000000, N'Thể thao', 0),
(N'TDN0172','123', 42, 58000000, N'Công sở, lịch sự', 0),
(N'TDN0173','123', 50, 47000000, N'Đơn giản, thường ngày', 0),
(N'TDN0174','123', 53, 47000000, N'Thời trang du lịch', 0),
(N'TDN0175','123', 53, 42000000, N'Thời trang hot trend', 0),
(N'TDN0176','123', 50, 44000000, N'Thể thao', 0),
(N'TDN0177','123', 41, 55000000, N'Công sở, lịch sự', 0),
(N'TDN0178','123', 54, 58000000, N'Đơn giản, thường ngày', 0),
(N'TDN0179','123', 41, 35000000, N'Thời trang du lịch', 0),
(N'TDN0180','123', 54, 51000000, N'Thời trang hot trend', 0),
(N'TDN0181','123', 43, 58000000, N'Thể thao', 0),
(N'TDN0182','123', 41, 51000000, N'Công sở, lịch sự', 0),
(N'TDN0183','123', 47, 40000000, N'Đơn giản, thường ngày', 0),
(N'TDN0184','123', 44, 49000000, N'Thời trang du lịch', 0),
(N'TDN0185','123', 43, 60000000, N'Thời trang hot trend', 0),
(N'TDN0186','123', 47, 57000000, N'Thể thao', 0),
(N'TDN0187','123', 51, 47000000, N'Công sở, lịch sự', 0),
(N'TDN0188','123', 55, 32000000, N'Đơn giản, thường ngày', 0),
(N'TDN0189','123', 53, 59000000, N'Thời trang du lịch', 0),
(N'TDN0190','123', 40, 40000000, N'Thời trang hot trend', 0),
(N'TDN0191','123', 55, 44000000, N'Thể thao', 0),
(N'TDN0192','123', 52, 32000000, N'Công sở, lịch sự', 0),
(N'TDN0193','123', 44, 43000000, N'Đơn giản, thường ngày', 0),
(N'TDN0194','123', 46, 51000000, N'Thời trang du lịch', 0),
(N'TDN0195','123', 49, 58000000, N'Thời trang hot trend', 0),
(N'TDN0196','123', 47, 35000000, N'Thể thao', 0),
(N'TDN0197','123', 41, 57000000, N'Công sở, lịch sự', 0),
(N'TDN0198','123', 41, 38000000, N'Đơn giản, thường ngày', 0),
(N'TDN0199','123', 48, 55000000, N'Thời trang du lịch', 0),
(N'TDN0200','123', 40, 54000000, N'Thời trang hot trend',0);
-- Dữ liệu train phân khúc khách hàng Trung niên từ 38 đến 60 tuổi chi tiêu cao
INSERT INTO NguoiDung(TenDangNhap,MatKhau, DoTuoi, MucChiTieu, SoThich, Train) VALUES 
(N'TDN0201','123', 52, 92000000, N'Thể thao', 0), 
(N'TDN0202','123', 40, 98000000, N'Công sở, lịch sự', 0),
(N'TDN0203','123', 44, 81000000, N'Đơn giản, thường ngày', 0),
(N'TDN0204','123', 41, 78000000, N'Thời trang du lịch', 0),
(N'TDN0205','123', 52, 65000000, N'Thời trang hot trend', 0),
(N'TDN0206','123', 40, 89000000, N'Thể thao', 0),
(N'TDN0207','123', 52, 71000000, N'Công sở, lịch sự', 0),
(N'TDN0208','123', 47, 83000000, N'Đơn giản, thường ngày', 0),
(N'TDN0209','123', 49, 99000000, N'Thời trang du lịch', 0),
(N'TDN0210','123', 48, 100000000, N'Thời trang hot trend', 0),
(N'TDN0211','123', 42, 85000000, N'Thể thao', 0),
(N'TDN0212','123', 55, 92000000, N'Công sở, lịch sự', 0),
(N'TDN0213','123', 55, 90000000, N'Đơn giản, thường ngày', 0),
(N'TDN0214','123', 45, 83000000, N'Thời trang du lịch', 0),
(N'TDN0215','123', 47, 73000000, N'Thời trang hot trend', 0),
(N'TDN0216','123', 42, 88000000, N'Thể thao', 0),
(N'TDN0217','123', 50, 71000000, N'Công sở, lịch sự', 0),
(N'TDN0218','123', 40, 73000000, N'Đơn giản, thường ngày', 0),
(N'TDN0219','123', 51, 88000000, N'Thời trang du lịch', 0),
(N'TDN0220','123', 52, 68000000, N'Thời trang hot trend', 0),
(N'TDN0221','123', 54, 92000000, N'Thể thao', 0),
(N'TDN0222','123', 47, 96000000, N'Công sở, lịch sự', 0),
(N'TDN0223','123', 49, 80000000, N'Đơn giản, thường ngày', 0),
(N'TDN0224','123', 42, 99000000, N'Thời trang du lịch', 0),
(N'TDN0225','123', 45, 94000000, N'Thời trang hot trend', 0),
(N'TDN0226','123', 49, 95000000, N'Thể thao', 0),
(N'TDN0227','123', 53, 82000000, N'Công sở, lịch sự', 0),
(N'TDN0228','123', 51, 85000000, N'Đơn giản, thường ngày', 0),
(N'TDN0229','123', 55, 83000000, N'Thời trang du lịch', 0),
(N'TDN0230','123', 40, 89000000, N'Thời trang hot trend', 0),
(N'TDN0231','123', 49, 88000000, N'Thể thao', 0),
(N'TDN0232','123', 51, 97000000, N'Công sở, lịch sự', 0),
(N'TDN0233','123', 51, 95000000, N'Đơn giản, thường ngày', 0),
(N'TDN0234','123', 53, 83000000, N'Thời trang du lịch', 0),
(N'TDN0235','123', 51, 99000000, N'Thời trang hot trend', 0),
(N'TDN0236','123', 50, 78000000, N'Thể thao', 0),
(N'TDN0237','123', 42, 96000000, N'Công sở, lịch sự', 0),
(N'TDN0238','123', 52, 99000000, N'Đơn giản, thường ngày', 0),
(N'TDN0239','123', 49, 97000000, N'Thời trang du lịch', 0),
(N'TDN0240','123', 54, 85000000, N'Thời trang hot trend',0);
-- Dữ liệu train phân khúc khách hàng Cao tuổi từ 60 tuổi trở lên chi tiêu thấp
INSERT INTO NguoiDung(TenDangNhap,MatKhau, DoTuoi, MucChiTieu, SoThich, Train) VALUES 
(N'TDN0241','123', 65, 16000000, N'Thể thao', 0), 
(N'TDN0242','123', 72, 15000000, N'Công sở, lịch sự', 0), 
(N'TDN0243','123', 66, 18000000, N'Đơn giản, thường ngày', 0),
(N'TDN0244','123', 65, 19000000, N'Thời trang du lịch', 0),
(N'TDN0245','123', 70, 18000000, N'Thời trang hot trend', 0),
(N'TDN0246','123', 67, 15000000, N'Thể thao', 0),
(N'TDN0247','123', 77, 14000000, N'Công sở, lịch sự', 0),
(N'TDN0248','123', 66, 18000000, N'Đơn giản, thường ngày', 0),
(N'TDN0249','123', 74, 17000000, N'Thời trang du lịch', 0),
(N'TDN0250','123', 71, 18000000, N'Thời trang hot trend', 0),
(N'TDN0251','123', 80, 9000000, N'Thể thao', 0),
(N'TDN0252','123', 65, 16000000, N'Công sở, lịch sự', 0),
(N'TDN0253','123', 73, 13000000, N'Đơn giản, thường ngày', 0),
(N'TDN0254','123', 66, 8000000, N'Thời trang du lịch', 0),
(N'TDN0255','123', 69, 9000000, N'Thời trang hot trend', 0),
(N'TDN0256','123', 68, 14000000, N'Thể thao', 0),
(N'TDN0257','123', 79, 20000000, N'Công sở, lịch sự', 0),
(N'TDN0258','123', 75, 15000000, N'Đơn giản, thường ngày', 0),
(N'TDN0259','123', 74, 16000000, N'Thời trang du lịch', 0),
(N'TDN0260','123', 66, 15000000, N'Thời trang hot trend', 0),
(N'TDN0261','123', 78, 5000000, N'Thể thao', 0),
(N'TDN0262','123', 66, 11000000, N'Công sở, lịch sự', 0),
(N'TDN0263','123', 75, 6000000, N'Đơn giản, thường ngày', 0),
(N'TDN0264','123', 71, 9000000, N'Thời trang du lịch', 0),
(N'TDN0265','123', 73, 16000000, N'Thời trang hot trend', 0),
(N'TDN0266','123', 67, 17000000, N'Thể thao', 0),
(N'TDN0267','123', 69, 10000000, N'Công sở, lịch sự', 0),
(N'TDN0268','123', 78, 8000000, N'Đơn giản, thường ngày', 0),
(N'TDN0269','123', 66, 15000000, N'Thời trang du lịch', 0),
(N'TDN0270','123', 72, 17000000, N'Thời trang hot trend', 0),
(N'TDN0271','123', 65, 17000000, N'Thể thao', 0),
(N'TDN0272','123', 77, 20000000, N'Công sở, lịch sự', 0),
(N'TDN0273','123', 68, 20000000, N'Đơn giản, thường ngày', 0),
(N'TDN0274','123', 65, 8000000, N'Thời trang du lịch', 0),
(N'TDN0275','123', 77, 12000000, N'Thời trang hot trend', 0),
(N'TDN0276','123', 71, 9000000, N'Thể thao', 0),
(N'TDN0277','123', 66, 8000000, N'Công sở, lịch sự', 0),
(N'TDN0278','123', 79, 16000000, N'Đơn giản, thường ngày', 0),
(N'TDN0279','123', 68, 6000000, N'Thời trang du lịch', 0),
(N'TDN0280','123', 65, 10000000, N'Thời trang hot trend',0);
-- Dữ liệu train phân khúc khách hàng Cao tuổi từ 60 tuổi trở lên chi tiêu vừa phải
INSERT INTO NguoiDung(TenDangNhap,MatKhau, DoTuoi, MucChiTieu, SoThich, Train) VALUES
(N'TDN0281','123', 66, 45000000, N'Thể thao', 0),
(N'TDN0282','123', 65, 37000000, N'Công sở, lịch sự', 0),
(N'TDN0283','123', 69, 38000000, N'Đơn giản, thường ngày', 0),
(N'TDN0284','123', 65, 34000000, N'Thời trang du lịch', 0),
(N'TDN0285','123', 68, 34000000, N'Thời trang hot trend', 0),
(N'TDN0286','123', 74, 44000000, N'Thể thao', 0),
(N'TDN0287','123', 75, 39000000, N'Công sở, lịch sự', 0),
(N'TDN0288','123', 72, 58000000, N'Đơn giản, thường ngày', 0),
(N'TDN0289','123', 65, 43000000, N'Thời trang du lịch', 0),
(N'TDN0290','123', 73, 50000000, N'Thời trang hot trend', 0),
(N'TDN0291','123', 69, 53000000, N'Thể thao', 0),
(N'TDN0292','123', 79, 50000000, N'Công sở, lịch sự', 0),
(N'TDN0293','123', 79, 38000000, N'Đơn giản, thường ngày', 0),
(N'TDN0294','123', 67, 60000000, N'Thời trang du lịch', 0),
(N'TDN0295','123', 66, 35000000, N'Thời trang hot trend', 0),
(N'TDN0296','123', 69, 54000000, N'Thể thao', 0),
(N'TDN0297','123', 65, 59000000, N'Công sở, lịch sự', 0),
(N'TDN0298','123', 71, 49000000, N'Đơn giản, thường ngày', 0),
(N'TDN0299', '123',70, 48000000, N'Thời trang du lịch', 0),
(N'TDN0300','123', 68, 58000000, N'Thời trang hot trend', 0),
(N'TDN0301','123', 80, 56000000, N'Thể thao', 0),
(N'TDN0302', '123',79, 47000000, N'Công sở, lịch sự', 0),
(N'TDN0303', '123',67, 37000000, N'Đơn giản, thường ngày', 0),
(N'TDN0304', '123',72, 40000000, N'Thời trang du lịch', 0),
(N'TDN0305','123', 80, 53000000, N'Thời trang hot trend', 0),
(N'TDN0306','123', 71, 41000000, N'Thể thao', 0),
(N'TDN0307','123', 67, 40000000, N'Công sở, lịch sự', 0),
(N'TDN0308','123', 68, 35000000, N'Đơn giản, thường ngày', 0),
(N'TDN0309','123', 79, 32000000, N'Thời trang du lịch', 0),
(N'TDN0310','123', 69, 40000000, N'Thời trang hot trend', 0),
(N'TDN0311','123', 68, 49000000, N'Thể thao', 0),
(N'TDN0312','123', 76, 55000000, N'Công sở, lịch sự', 0),
(N'TDN0313','123', 66, 53000000, N'Đơn giản, thường ngày', 0),
(N'TDN0314','123', 65, 38000000, N'Thời trang du lịch', 0),
(N'TDN0315','123', 79, 35000000, N'Thời trang hot trend', 0),
(N'TDN0316','123', 80, 36000000, N'Thể thao', 0),
(N'TDN0317','123', 67, 60000000, N'Công sở, lịch sự', 0),
(N'TDN0318','123', 71, 59000000, N'Đơn giản, thường ngày', 0),
(N'TDN0319','123', 79, 43000000, N'Thời trang du lịch', 0),
(N'TDN0320','123', 73, 34000000, N'Thời trang hot trend',0);
-- Dữ liệu train phân khúc Cao tuổi từ 60 tuổi trở lên chi tiêu cao
INSERT INTO NguoiDung(TenDangNhap, MatKhau, DoTuoi, MucChiTieu, SoThich, Train) VALUES
(N'TDN0321', '123', 67, 88000000, N'Thể thao', 0),
(N'TDN0322', '123', 77, 71000000, N'Công sở, lịch sự', 0),
(N'TDN0323', '123', 75, 73000000, N'Đơn giản, thường ngày', 0),
(N'TDN0324', '123', 65, 80000000, N'Thời trang du lịch', 0),
(N'TDN0325', '123', 80, 72000000, N'Thời trang hot trend', 0),
(N'TDN0326', '123', 78, 92000000, N'Thể thao', 0),
(N'TDN0327', '123', 74, 80000000, N'Công sở, lịch sự', 0),
(N'TDN0328', '123', 75, 82000000, N'Đơn giản, thường ngày', 0),
(N'TDN0329', '123', 69, 88000000, N'Thời trang du lịch', 0),
(N'TDN0330', '123', 67, 95000000, N'Thời trang hot trend', 0),
(N'TDN0331', '123', 78, 96000000, N'Thể thao', 0),
(N'TDN0332', '123', 80, 85000000, N'Công sở, lịch sự', 0),
(N'TDN0333', '123', 68, 90000000, N'Đơn giản, thường ngày', 0),
(N'TDN0334', '123', 67, 93000000, N'Thời trang du lịch', 0),
(N'TDN0335', '123', 72, 94000000, N'Thời trang hot trend', 0),
(N'TDN0336', '123', 80, 92000000, N'Thể thao', 0),
(N'TDN0337', '123', 68, 95000000, N'Công sở, lịch sự', 0),
(N'TDN0338', '123', 70, 96000000, N'Đơn giản, thường ngày', 0),
(N'TDN0339', '123', 76, 87000000, N'Thời trang du lịch', 0),
(N'TDN0340', '123', 67, 99000000, N'Thời trang hot trend', 0),
(N'TDN0341', '123', 65, 88000000, N'Thể thao', 0),
(N'TDN0342', '123', 77, 97000000, N'Công sở, lịch sự', 0),
(N'TDN0343', '123', 70, 90000000, N'Đơn giản, thường ngày', 0),
(N'TDN0344', '123', 79, 88000000, N'Thời trang du lịch', 0),
(N'TDN0345', '123', 65, 85000000, N'Thời trang hot trend', 0),
(N'TDN0346', '123', 73, 81000000, N'Thể thao', 0),
(N'TDN0347', '123', 66, 93000000, N'Công sở, lịch sự', 0),
(N'TDN0348', '123', 68, 88000000, N'Đơn giản, thường ngày', 0),
(N'TDN0349', '123', 74, 91000000, N'Thời trang du lịch', 0),
(N'TDN0350', '123', 71, 88000000, N'Thời trang hot trend', 0),
(N'TDN0351', '123', 76, 82000000, N'Thể thao', 0),
(N'TDN0352', '123', 80, 80000000, N'Công sở, lịch sự', 0),
(N'TDN0353', '123', 75, 78000000, N'Đơn giản, thường ngày', 0),
(N'TDN0354', '123', 67, 86000000, N'Thời trang du lịch', 0),
(N'TDN0355', '123', 66, 92000000, N'Thời trang hot trend', 0),
(N'TDN0356', '123', 80, 87000000, N'Thể thao', 0),
(N'TDN0357', '123', 77, 95000000, N'Công sở, lịch sự', 0),
(N'TDN0358', '123', 66, 90000000, N'Đơn giản, thường ngày', 0),
(N'TDN0359', '123', 74, 89000000, N'Thời trang du lịch', 0),
(N'TDN0360', '123', 80, 95000000, N'Thời trang hot trend', 0);

-- Thêm dữ liệu train
INSERT INTO NguoiDung (TenDangNhap, MatKhau, DoTuoi, MucChiTieu, SoThich, Train, PhanKhucKH) VALUES 
(N'TDN5000', '123', 37, 30000000, N'Thể thao', 0, N'Thanh niên từ 0 đến 37 tuổi chi tiêu thấp'),
(N'TDN5001', '123', 37, 30000000,  N'Công sở, lịch sự', 0, N'Thanh niên từ 0 đến 37 tuổi chi tiêu thấp'),
(N'TDN5002', '123', 37, 29999999, N'Đơn giản, thường ngày', 0, N'Thanh niên từ 0 đến 37 tuổi chi tiêu thấp'),
(N'TDN5003', '123', 37, 29999997, N'Đơn giản, thường ngày', 0, N'Thanh niên từ 0 đến 37 tuổi chi tiêu thấp'),
(N'TDN5004', '123', 37, 29999995, N'Thể thao', 0, N'Thanh niên từ 0 đến 37 tuổi chi tiêu thấp'),
(N'TDN5005', '123', 37, 31000000, N'Thể thao', 0, N'Thanh niên từ 0 đến 37 tuổi chi tiêu vừa phải'),
(N'TDN5006', '123', 37, 31000000, N'Thể thao', 0, N'Thanh niên từ 0 đến 37 tuổi chi tiêu vừa phải'),
(N'TDN5007', '123', 37, 300000001, N'Thể thao', 0, N'Thanh niên từ 0 đến 37 tuổi chi tiêu vừa phải'),
(N'TDN5008', '123', 37, 300000003, N'Thể thao', 0, N'Thanh niên từ 0 đến 37 tuổi chi tiêu vừa phải'),
(N'TDN5009', '123', 37, 300000005, N'Thể thao', 0, N'Thanh niên từ 0 đến 37 tuổi chi tiêu vừa phải'),
(N'TDN5010', '123', 37, 60000000, N'Thể thao', 0, N'Thanh niên từ 0 đến 37 tuổi chi tiêu vừa phải'),
(N'TDN5011', '123', 37, 60000000, N'Thể thao', 0, N'Thanh niên từ 0 đến 37 tuổi chi tiêu vừa phải'),
(N'TDN5012', '123', 37, 600000001, N'Thể thao', 0, N'Thanh niên từ 0 đến 37 tuổi chi tiêu vừa phải'),
(N'TDN5013', '123', 37, 600000003, N'Đơn giản, thường ngày', 0, N'Thanh niên từ 0 đến 37 tuổi chi tiêu vừa phải'),
(N'TDN5014', '123', 37, 600000005, N'Thể thao', 0, N'Thanh niên từ 0 đến 37 tuổi chi tiêu vừa phải'),
(N'TDN5015', '123', 37, 61000000, N'Thể thao', 0, N'Thanh niên từ 0 đến 37 tuổi chi tiêu vừa cao'),
(N'TDN5016', '123', 37, 61000000, N'Thể thao', 0, N'Thanh niên từ 0 đến 37 tuổi chi tiêu vừa cao'),
(N'TDN5017', '123', 37, 600000001, N'Thể thao', 0, N'Thanh niên từ 0 đến 37 tuổi chi tiêu vừa cao'),
(N'TDN5018', '123', 37, 610000003, N'Đơn giản, thường ngày', 0, N'Thanh niên từ 0 đến 37 tuổi chi tiêu vừa cao'),
(N'TDN5019', '123', 37, 610000005, N'Thể thao', 0, N'Thanh niên từ 0 đến 37 tuổi chi tiêu vừa cao'),
(N'TDN5020', '123', 37, 60000000, N'Thể thao', 0, N'Thanh niên từ 0 đến 37 tuổi chi tiêu vừa cao');
INSERT INTO NguoiDung (TenDangNhap, MatKhau, DoTuoi, MucChiTieu, SoThich, Train, PhanKhucKH) VALUES 
(N'TDN5021', '123', 38, 30000000, N'Thể thao', 0, N'Trung niên từ 38 đến 60 tuổi chi tiêu thấp'),
(N'TDN5022', '123', 38, 30000000, N'Thể thao', 0, N'Trung niên từ 38 đến 60 tuổi chi tiêu thấp'),
(N'TDN5023', '123', 38, 29999999, N'Thể thao', 0, N'Trung niên từ 38 đến 60 tuổi chi tiêu thấp'),
(N'TDN5024', '123', 38, 29999997, N'Thể thao', 0, N'Trung niên từ 38 đến 60 tuổi chi tiêu thấp'),
(N'TDN5025', '123', 38, 29999995, N'Thể thao', 0, N'Trung niên từ 38 đến 60 tuổi chi tiêu thấp'),
(N'TDN5026', '123', 38, 31000000, N'Thể thao', 0, N'Trung niên từ 38 đến 60 tuổi chi tiêu vừa phải'),
(N'TDN5027', '123', 38, 31000000, N'Thể thao', 0, N'Trung niên từ 38 đến 60 tuổi chi tiêu vừa phải'),
(N'TDN5028', '123', 38, 300000001, N'Thể thao', 0, N'Trung niên từ 38 đến 60 tuổi chi tiêu vừa phải'),
(N'TDN5029', '123', 38, 300000003, N'Thể thao', 0, N'Trung niên từ 38 đến 60 tuổi chi tiêu vừa phải'),
(N'TDN5030', '123', 38, 300000005, N'Thể thao', 0, N'Trung niên từ 38 đến 60 tuổi chi tiêu vừa phải'),
(N'TDN5031', '123', 38, 60000000, N'Thể thao', 0, N'Trung niên từ 38 đến 60 tuổi chi tiêu vừa phải'),
(N'TDN5032', '123', 38, 60000000, N'Thể thao', 0, N'Trung niên từ 38 đến 60 tuổi chi tiêu vừa phải'),
(N'TDN5033', '123', 38, 600000001, N'Thể thao', 0, N'Trung niên từ 38 đến 60 tuổi chi tiêu vừa phải'),
(N'TDN5034', '123', 38, 600000003, N'Thể thao', 0, N'Trung niên từ 38 đến 60 tuổi chi tiêu vừa phải'),
(N'TDN5035', '123', 38, 600000005, N'Thể thao', 0, N'Trung niên từ 38 đến 60 tuổi chi tiêu vừa phải'),
(N'TDN5036', '123', 38, 61000000, N'Thể thao', 0, N'Trung niên từ 38 đến 60 tuổi chi tiêu vừa cao'),
(N'TDN5037', '123', 38, 61000000, N'Thể thao', 0, N'Trung niên từ 38 đến 60 tuổi chi tiêu vừa cao'),
(N'TDN5038', '123', 38, 600000001, N'Thể thao', 0, N'Trung niên từ 38 đến 60 tuổi chi tiêu vừa cao'),
(N'TDN5039', '123', 38, 610000003, N'Đơn giản, thường ngày', 0, N'Trung niên từ 38 đến 60 tuổi chi tiêu vừa cao'),
(N'TDN5040', '123', 38, 610000005, N'Thể thao', 0, N'Trung niên từ 38 đến 60 tuổi chi tiêu vừa cao');

INSERT INTO NguoiDung (TenDangNhap, MatKhau, DoTuoi, MucChiTieu, SoThich, Train, PhanKhucKH) VALUES 
(N'TDN5042', '123', 60, 30000000, N'Thể thao', 0, N'Cao tuổi từ 60 trở lên tuổi chi tiêu thấp'),
(N'TDN5043', '123', 60, 30000000,  N'Công sở, lịch sự', 0, N'Cao tuổi từ 60 trở lên tuổi chi tiêu thấp'),
(N'TDN5044', '123', 60, 29999999, N'Đơn giản, thường ngày', 0, N'Cao tuổi từ 60 trở lên tuổi chi tiêu thấp'),
(N'TDN5045', '123', 60, 29999997, N'Đơn giản, thường ngày', 0, N'Cao tuổi từ 60 trở lên tuổi chi tiêu thấp'),
(N'TDN5046', '123', 60, 29999995, N'Thể thao', 0, N'Cao tuổi từ 60 trở lên tuổi chi tiêu thấp'),
(N'TDN5047', '123', 60, 31000000, N'Thể thao', 0, N'Cao tuổi từ 60 trở lên tuổi chi tiêu vừa phải'),
(N'TDN5048', '123', 60, 31000000, N'Thể thao', 0, N'Cao tuổi từ 60 trở lên tuổi chi tiêu vừa phải'),
(N'TDN5049', '123', 60, 300000001, N'Thể thao', 0, N'Cao tuổi từ 60 trở lên tuổi chi tiêu vừa phải'),
(N'TDN5050', '123', 60, 300000003, N'Thể thao', 0, N'Cao tuổi từ 60 trở lên tuổi chi tiêu vừa phải'),
(N'TDN5051', '123', 60, 300000005, N'Thể thao', 0, N'Cao tuổi từ 60 trở lên tuổi chi tiêu vừa phải'),
(N'TDN5052', '123', 60, 60000000, N'Thể thao', 0, N'Cao tuổi từ 60 trở lên tuổi chi tiêu vừa phải'),
(N'TDN5053', '123', 60, 60000000, N'Thể thao', 0, N'Cao tuổi từ 60 trở lên tuổi chi tiêu vừa phải'),
(N'TDN5054', '123', 60, 600000001, N'Thể thao', 0, N'Cao tuổi từ 60 trở lên tuổi chi tiêu vừa phải'),
(N'TDN5055', '123', 60, 600000003, N'Đơn giản, thường ngày', 0, N'Cao tuổi từ 60 trở lên tuổi chi tiêu vừa phải'),
(N'TDN5056', '123', 60, 600000005, N'Thể thao', 0, N'Cao tuổi từ 60 trở lên tuổi chi tiêu vừa phải'),
(N'TDN5057', '123', 60, 60000000, N'Thể thao', 0, N'Cao tuổi từ 60 trở lên tuổi chi tiêu vừa cao'),
(N'TDN5058', '123', 60, 60000000, N'Thể thao', 0, N'Cao tuổi từ 60 trở lên tuổi chi tiêu vừa cao'),
(N'TDN5059', '123', 60, 600000001, N'Thể thao', 0, N'Cao tuổi từ 60 trở lên tuổi chi tiêu vừa cao'),
(N'TDN5060', '123', 60, 600000003, N'Đơn giản, thường ngày', 0, N'Cao tuổi từ 60 trở lên tuổi chi tiêu vừa cao'),
(N'TDN5061', '123', 60, 600000005, N'Thể thao', 0, N'Cao tuổi từ 60 trở lên tuổi chi tiêu vừa cao'),
(N'TDN5062', '123', 60, 60000000, N'Thể thao', 0, N'Cao tuổi từ 60 trở lên tuổi chi tiêu vừa cao');


INSERT INTO NguoiDung (TenDangNhap, MatKhau, DoTuoi, MucChiTieu, SoThich, Train, PhanKhucKH) VALUES 
(N'TDN6000', '123', 30, 30000000, N'Thể thao', 0, N'Thanh niên từ 0 đến 37 tuổi chi tiêu thấp'),
(N'TDN6001', '123', 30, 30000000,  N'Công sở, lịch sự', 0, N'Thanh niên từ 0 đến 37 tuổi chi tiêu thấp'),
(N'TDN6002', '123', 30, 29999999, N'Đơn giản, thường ngày', 0, N'Thanh niên từ 0 đến 37 tuổi chi tiêu thấp'),
(N'TDN6003', '123', 30, 29999997, N'Đơn giản, thường ngày', 0, N'Thanh niên từ 0 đến 37 tuổi chi tiêu thấp'),
(N'TDN6004', '123', 30, 29999995, N'Thể thao', 0, N'Thanh niên từ 0 đến 37 tuổi chi tiêu thấp');
INSERT INTO NguoiDung (TenDangNhap, MatKhau, DoTuoi, MucChiTieu, SoThich, Train, PhanKhucKH) VALUES 
(N'TDN6021', '123', 59, 30000000, N'Thể thao', 0, N'Trung niên từ 38 đến 60 tuổi chi tiêu thấp'),
(N'TDN6022', '123', 59, 30000000, N'Thể thao', 0, N'Trung niên từ 38 đến 60 tuổi chi tiêu thấp'),
(N'TDN6023', '123', 59, 29999999, N'Thể thao', 0, N'Trung niên từ 38 đến 60 tuổi chi tiêu thấp'),
(N'TDN6024', '123', 59, 29999997, N'Thể thao', 0, N'Trung niên từ 38 đến 60 tuổi chi tiêu thấp'),
(N'TDN6025', '123', 59, 29999995, N'Thể thao', 0, N'Trung niên từ 38 đến 60 tuổi chi tiêu thấp'),
(N'TDN6026', '123', 59, 31000000, N'Thể thao', 0, N'Trung niên từ 38 đến 60 tuổi chi tiêu vừa phải'),
(N'TDN6027', '123', 59, 31000000, N'Thể thao', 0, N'Trung niên từ 38 đến 60 tuổi chi tiêu vừa phải'),
(N'TDN6028', '123', 59, 300000001, N'Thể thao', 0, N'Trung niên từ 38 đến 60 tuổi chi tiêu vừa phải'),
(N'TDN6029', '123', 59, 300000003, N'Thể thao', 0, N'Trung niên từ 38 đến 60 tuổi chi tiêu vừa phải'),
(N'TDN6030', '123', 59, 300000005, N'Thể thao', 0, N'Trung niên từ 38 đến 60 tuổi chi tiêu vừa phải'),
(N'TDN6031', '123', 59, 60000000, N'Thể thao', 0, N'Trung niên từ 38 đến 60 tuổi chi tiêu vừa phải'),
(N'TDN6032', '123', 59, 60000000, N'Thể thao', 0, N'Trung niên từ 38 đến 60 tuổi chi tiêu vừa phải'),
(N'TDN6033', '123', 59, 600000001, N'Thể thao', 0, N'Trung niên từ 38 đến 60 tuổi chi tiêu vừa phải'),
(N'TDN6034', '123', 59, 600000003, N'Thể thao', 0, N'Trung niên từ 38 đến 60 tuổi chi tiêu vừa phải'),
(N'TDN6035', '123', 59, 600000005, N'Thể thao', 0, N'Trung niên từ 38 đến 60 tuổi chi tiêu vừa phải'),
(N'TDN6036', '123', 59, 61000000, N'Thể thao', 0, N'Trung niên từ 38 đến 60 tuổi chi tiêu vừa cao'),
(N'TDN6037', '123', 59, 61000000, N'Thể thao', 0, N'Trung niên từ 38 đến 60 tuổi chi tiêu vừa cao'),
(N'TDN6059', '123', 59, 600000001, N'Thể thao', 0, N'Trung niên từ 38 đến 60 tuổi chi tiêu vừa cao'),
(N'TDN6039', '123', 59, 610000003, N'Đơn giản, thường ngày', 0, N'Trung niên từ 38 đến 60 tuổi chi tiêu vừa cao'),
(N'TDN6040', '123', 59, 610000005, N'Thể thao', 0, N'Trung niên từ 38 đến 60 tuổi chi tiêu vừa cao'),
(N'TDN6041', '123', 59, 60000000, N'Thể thao', 0, N'Trung niên từ 38 đến 60 tuổi chi tiêu vừa cao');

INSERT INTO DanhMuc (TenDanhMuc) VALUES (N'Thể thao');
INSERT INTO DanhMuc (TenDanhMuc) VALUES (N'Công sở, lịch sự');
INSERT INTO DanhMuc (TenDanhMuc) VALUES (N'Đơn giản, thường ngày');
INSERT INTO DanhMuc (TenDanhMuc) VALUES (N'Thời trang du lịch');
INSERT INTO DanhMuc (TenDanhMuc) VALUES (N'Thời trang hot trend');
-- Sản phẩm cho sở thích "Thể thao" Thanh niên từ 0 đến 37 tuổi
INSERT INTO SanPham (TenSanPham, MoTa, SoLuongDaBan, DanhMucID, KichHoat)
-- Mức giá 15000-400000
--nam
VALUES
(N'Áo thể thao Nam đa năng', N'Áo thể thao được thiết kế thoáng khí, phù hợp cho các hoạt động ngoài trời và thể thao', 0, 1, 1),
(N'Quần thể thao Nam thấm hút mồ hôi', N'Quần thể thao với chất liệu thấm hút mồ hôi, mang lại cảm giác thoải mái khi vận động', 0, 1, 1),
(N'Giày thể thao Nam chống trượt', N'Giày thể thao nhẹ, chống trượt, lý tưởng cho chạy bộ và các môn thể thao khác', 0, 1, 1),
(N'Quần short thể thao Nam thoáng mát', N'Quần short thể thao thoáng mát, giúp bạn thoải mái hơn trong mọi hoạt động', 0, 1, 1),
(N'Mũ lưỡi trai thời trang', N'Mũ lưỡi trai bảo vệ khỏi nắng, phù hợp cho các hoạt động thể thao ngoài trời', 0, 1, 1),
--nữ
(N'Áo thể thao Nữ năng động', N'Áo thể thao nữ thoáng khí, thiết kế hiện đại cho những cô nàng yêu thể thao', 0, 1, 1),
(N'Quần thể thao Nữ thời trang', N'Quần thể thao nữ với kiểu dáng thời trang, dễ phối đồ', 0, 1, 1),
(N'Giày thể thao Nữ phong cách', N'Giày thể thao nữ nhẹ, phong cách, giúp bạn tự tin hơn khi tập luyện', 0, 1, 1),
(N'Quần short thể thao Nữ chất liệu mềm mại', N'Quần short thể thao nữ với chất liệu mềm mại, tạo sự thoải mái khi vận động', 0, 1, 1),
(N'Mũ lưỡi trai Nữ cá tính', N'Mũ lưỡi trai nữ giúp bảo vệ và tạo điểm nhấn cho trang phục thể thao', 0, 1, 1),
-- Mức giá 500000-750000
--nam
(N'Áo thể thao Nam chất liệu cao cấp', N'Áo thể thao nam với chất liệu cao cấp, thích hợp cho các buổi tập luyện chuyên nghiệp', 0, 1, 1),
(N'Quần thể thao Nam thời trang', N'Quần thể thao nam thời trang, tạo nên phong cách năng động', 0, 1, 1),
(N'Giày thể thao Nam bảo vệ tốt', N'Giày thể thao nam thiết kế hỗ trợ tốt cho cổ chân, phù hợp với vận động mạnh', 0, 1, 1),
(N'Quần short thể thao Nam chất liệu nhẹ', N'Quần short thể thao nam với chất liệu nhẹ, thoáng mát, dễ dàng vận động', 0, 1, 1),
(N'Mũ lưỡi trai thời trang Nam', N'Mũ lưỡi trai giúp bảo vệ và tạo phong cách thể thao', 0, 1, 1),
--nữ
(N'Áo thể thao Nữ chất liệu thấm hút', N'Áo thể thao nữ với chất liệu thấm hút, giúp bạn luôn khô ráo khi tập luyện', 0, 1, 1),
(N'Quần thể thao Nữ kiểu dáng hiện đại', N'Quần thể thao nữ kiểu dáng hiện đại, thích hợp cho tập luyện và đi chơi', 0, 1, 1),
(N'Giày thể thao Nữ siêu nhẹ', N'Giày thể thao nữ siêu nhẹ, phù hợp với các hoạt động thể thao', 0, 1, 1),
(N'Quần short thể thao Nữ thời trang', N'Quần short thể thao nữ với thiết kế thời trang, dễ dàng phối đồ', 0, 1, 1),
(N'Mũ lưỡi trai Nữ phong cách', N'Mũ lưỡi trai nữ phong cách, giúp bảo vệ và tạo nét cá tính', 0, 1, 1),
-- Mức giá 800000-2000000
--Nam
(N'Áo thể thao Nam cao cấp', N'Áo thể thao nam cao cấp, mang lại sự thoải mái tối đa khi tập luyện', 0, 1, 1),
(N'Quần thể thao Nam cao cấp', N'Quần thể thao nam chất lượng, thiết kế hiện đại cho những ai yêu thích vận động', 0, 1, 1),
(N'Giày thể thao Nam đa năng', N'Giày thể thao nam thiết kế đa năng, phục vụ cho nhiều hoạt động thể thao khác nhau', 0, 1, 1),
(N'Quần short thể thao Nam cao cấp', N'Quần short thể thao nam cao cấp, thoải mái cho mọi hoạt động', 0, 1, 1),
(N'Mũ lưỡi trai Nam thời trang', N'Mũ lưỡi trai nam thời trang, bảo vệ khỏi nắng, dễ phối đồ', 0, 1, 1),
--nữ
(N'Áo thể thao Nữ cao cấp', N'Áo thể thao nữ cao cấp, thoải mái và phong cách cho các hoạt động thể thao', 0, 1, 1),
(N'Quần thể thao Nữ năng động', N'Quần thể thao nữ năng động, lý tưởng cho các hoạt động thể thao và du lịch', 0, 1, 1),
(N'Giày thể thao Nữ kiểu dáng đẹp', N'Giày thể thao nữ với thiết kế thời trang, giúp bạn tự tin hơn khi vận động', 0, 1, 1),
(N'Quần short thể thao Nữ chất liệu thoáng mát', N'Quần short thể thao nữ thoáng mát, tạo cảm giác dễ chịu trong suốt thời gian vận động', 0, 1, 1),
(N'Mũ lưỡi trai Nữ cá tính', N'Mũ lưỡi trai nữ với thiết kế cá tính, phong cách cho mọi cô gái', 0, 1, 1);
-- Sản phẩm cho sở thích "Công sở, lịch sự" Thanh niên từ 0 đến 37 tuổi 
INSERT INTO SanPham (TenSanPham, MoTa, SoLuongDaBan, DanhMucID, KichHoat)
VALUES
-- Mức giá 15000-400000
--nam
(N'Áo khoác công sở nam', N'Áo khoác nhẹ nhàng, thoải mái, thích hợp cho đi làm.', 0, 2, 1),
(N'Quần âu nam phong cách', N'Quần âu nam với thiết kế hiện đại, tôn dáng.', 0, 2, 1),
(N'Giày oxford nam sang trọng', N'Giày oxford phù hợp cho các dịp trang trọng.', 0, 2, 1),
(N'Quần tây nam thoải mái', N'Quần tây nam với chất liệu thoáng mát, dễ chịu.', 0, 2, 1),
(N'Giày công sở', N' thời trang', 0, 2, 1),
--Nữ
(N'Áo vest công sở nữ', N'Áo vest nữ thanh lịch, dễ phối với nhiều trang phục.', 0, 2, 1),
(N'Chân váy nữ', N'Chân váy xòe nữ tính, hoàn hảo cho công việc.', 0, 2, 1),
(N'Giày cao gót công sở', N'Giày cao gót thời trang, nâng tầm phong cách.', 0, 2, 1),
(N'Quần âu nữ hiện đại', N'Quần âu nữ với thiết kế trẻ trung, thoải mái.', 0, 2, 1),
(N'giày nữ thời trang', N' giúp bạn thêm phần năng động.', 0, 2, 1),

-- Mức giá 500000-750000
--nam-- xong
(N'Áo sơ mi công sở nam', N'Áo sơ mi cổ điển, phù hợp cho môi trường làm việc.', 0, 2, 1),
(N'Quần tây nam hiện đại', N'Quần tây với thiết kế trẻ trung, phù hợp cho đi làm.', 0, 2, 1),
(N'Giày tây nam cao cấp', N'Giày tây mang lại vẻ lịch lãm cho phái mạnh.', 0, 2, 1),
(N'Quần Âu công sở nam', N'Quần short với chất liệu thoải mái, phù hợp mùa hè.', 0, 2, 1),
(N'cà vạt', N'cà vạt trai dễ phối đồ, thích hợp cho mọi hoạt động.', 0, 2, 1),
--Nữ
(N'Áo sơ mi công sở nữ', N'Áo sơ mi nữ thanh lịch, dễ dàng phối đồ.', 0, 2, 1),
(N'Chân váy pencil công sở', N'Chân váy bút chì tạo dáng, hoàn hảo cho môi trường công sở.', 0, 2, 1),
(N'Giày búp bê công sở', N'Giày búp bê nữ tính, thoải mái cho ngày dài làm việc.', 0, 2, 1),
(N'Quần tây nữ thanh lịch', N'Quần tây với chất liệu cao cấp, phù hợp với mọi dịp.', 0, 2, 1),
(N'cà vạt công sở nữ', N'cà vạt thời trang', 0, 2, 1),
-- Mức giá 800000-2000000
--nam
(N'Áo khoác công sở nam cao cấp', N'Áo khoác giữ ấm với phong cách lịch lãm.', 0, 2, 1),
(N'Quần tây nam cao cấp', N'Quần tây nam thời thượng, mang lại phong cách hoàn hảo.', 0, 2, 1),
(N'Giày lười nam công sở', N'Giày lười thoải mái, thích hợp cho công việc hàng ngày.', 0, 2, 1),
(N'Chân quần midi công sở', N'Chân váy midi thanh lịch, lý tưởng cho buổi hẹn.', 0, 2, 1),
(N'quần công sở', N'sang trọng, tạo điểm nhấn cho trang phục.', 0, 2, 1),
--Nũ
(N'Áo tay dài công sở nữ sang trọng', N'Áo khoác nữ thời trang, bảo vệ bạn khỏi cái lạnh.', 0, 2, 1),
(N'Chân váy xòe công sở', N'Chân váy xòe dễ thương, hoàn hảo cho những buổi tiệc.', 0, 2, 1),
(N'Giày cao gót công sở sang trọng', N'Giày cao gót đẹp, làm nổi bật phong cách của bạn.', 0, 2, 1),
(N'Quần tây nữ cao cấp', N'Quần tây với chất liệu cao cấp, ôm sát tạo dáng đẹp.', 0, 2, 1),
(N'cà vạt nữ thời trang', N'cà vạt thời thượng.', 0, 2, 1);
-- Sản phẩm cho sở thích "Đơn giản, thường ngày" Thanh niên từ 0 đến 37 tuổi
INSERT INTO SanPham (TenSanPham, MoTa, SoLuongDaBan, DanhMucID, KichHoat)
VALUES 
-- Mức giá 15000-400000
-- nam
(N'Áo polo nam basic', N'Áo polo nam với chất liệu mềm mại, thoáng khí, phù hợp cho những ngày hè.', 0, 3, 1),
(N'Quần kaki nam thanh lịch', N'Quần kaki dáng ôm, dễ phối đồ cho các sự kiện hàng ngày.', 0, 3, 1),
(N'Giày lười nam phong cách', N'Giày lười nam thời trang, tiện lợi cho những buổi đi chơi.', 0, 3, 1),
(N'Quần short nam thoải mái', N'Quần short năng động, lý tưởng cho các hoạt động ngoài trời.', 0, 3, 1),
(N'Mũ lưỡi trai nam', N'Mũ lưỡi trai thời trang giúp bạn bảo vệ khỏi ánh nắng mặt trời.', 0, 3, 1),
-- nữ
(N'Áo thun nữ basic', N'Áo thun nữ thoải mái, dễ dàng phối hợp với nhiều kiểu trang phục.', 0, 3, 1),
(N'Quần legging nữ co giãn', N'Quần legging nữ với chất liệu co giãn, thích hợp cho mọi hoạt động.', 0, 3, 1),
(N'Giày bệt nữ thời trang', N'Giày bệt nữ với thiết kế thanh lịch, phù hợp với nhiều phong cách.', 0, 3, 1),
(N'Quần jean nữ', N'Quần jean nữ nhẹ nhàng, lý tưởng cho mùa hè.', 0, 3, 1),
(N'Mũ lưỡi trai nữ', N'Mũ lưỡi trai với nhiều màu sắc trẻ trung, phù hợp với mọi lứa tuổi.', 0, 3, 1),
-- Mức giá 500000-750000
-- nam
(N'Áo sơ mi nam trắng', N'Sơ mi nam trắng thanh lịch, phù hợp với các buổi tiệc hoặc đi làm.', 0, 3, 1),
(N'Quần tây nam lịch lãm', N'Quần tây nam với chất liệu cao cấp, phù hợp cho môi trường công sở.', 0, 3, 1),
(N'Giày oxford nam cổ điển', N'Giày oxford nam với thiết kế sang trọng, phù hợp cho các dịp trang trọng.', 0, 3, 1),
(N'Quần boki nam phong cách', N'Quần boki với kiểu dáng hiện đại, phù hợp.', 0, 3, 1),
(N'Mũ snapback nam', N'Mũ snapback thời trang, phù hợp cho mọi phong cách.', 0, 3, 1),
-- nữ
(N'Áo sơ mi nữ ', N'Sơ mi nữ thanh lịch, dễ dàng phối hợp với quần và chân váy.', 0, 3, 1),
(N'Quần tây nữ lịch lãm', N'Quần tây nữ với kiểu dáng hiện đại, thích hợp cho công việc và dạo phố.', 0, 3, 1),
(N'Giày cao gót nữ thời trang', N'Giày cao gót với thiết kế tinh tế, tôn dáng chân và phù hợp với nhiều trang phục.', 0, 3, 1),
(N'Váy baki nữ trẻ trung', N'Váy baki nữ với thiết kế trẻ trung, phù hợp cho mùa hè.', 0, 3, 1),
(N'Mũ lưỡi trai nữ cá tính', N'Mũ lưỡi trai với họa tiết độc đáo, làm nổi bật phong cách cá nhân.', 0, 3, 1),
-- Mức giá 800000-2000000
(N'Áo khoác nam thời trang', N'Áo khoác nam với chất liệu dày dạn, giữ ấm trong mùa đông.', 0, 3, 1),
(N'Quần jeans nam phong cách', N'Quần jeans nam với thiết kế thời trang, phù hợp cho mọi hoạt động.', 0, 3, 1),
(N'Giày thể thao nam cao cấp', N'Giày thể thao nam với đệm êm, tạo cảm giác thoải mái khi vận động.', 0, 3, 1),
(N'Quần jogger nam tiện lợi', N'Quần jogger nam với chất liệu nhẹ, thích hợp cho việc tập luyện.', 0, 3, 1),
(N'Mũ lưỡi trai nam cá tính', N'Mũ lưỡi trai với kiểu dáng hiện đại, phù hợp cho nhiều phong cách.', 0, 3, 1),
-- nữ
(N'Áo khoác nữ thời trang', N'Áo khoác nữ dày dạn, phù hợp với thời tiết lạnh.', 0, 3, 1),
(N'Quần jeans nữ phong cách', N'Quần jeans nữ với thiết kế trẻ trung, thích hợp cho dạo phố.', 0, 3, 1),
(N'Giày thể thao nữ cao cấp', N'Giày thể thao nữ với độ bám tốt, phù hợp cho các hoạt động thể thao.', 0, 3, 1),
(N'Quần jogger nữ tiện lợi', N'Quần jogger nữ với chất liệu nhẹ, thoải mái cho mọi hoạt động.', 0, 3, 1),
(N'Mũ lưỡi trai nữ cá tính', N'Mũ lưỡi trai nữ với thiết kế độc đáo, phù hợp cho phong cách năng động.', 0, 3, 1);
-- Sản phẩm cho sở thích "Thời trang du lịch" Thanh niên từ 0 đến 37 tuổi
INSERT INTO SanPham (TenSanPham, MoTa, SoLuongDaBan, DanhMucID, KichHoat)
VALUES 
-- Mức giá 15000-400000
--nam
(N'Áo khoác chống nước nam', N'Tiện lợi khi đi du lịch, chất liệu chống nước', 0, 4, 1),
(N'Quần dài nam đi trekking', N'Thiết kế gọn nhẹ, co giãn, phù hợp cho các hoạt động ngoài trời', 0, 4, 1),
(N'Giày thể thao nam chống trượt', N'Đế cao su chống trượt, thoải mái khi vận động', 0, 4, 1),
(N'Quần short nam du lịch', N'Chất liệu polyester, thoáng khí, phù hợp cho thời tiết nóng', 0, 4, 1),
(N'Nón rộng vành nam', N'Nón che nắng, thích hợp cho các chuyến đi dài', 0, 4, 1),
--nữ
(N'Áo thun nữ thoáng mát', N'Áo thun nữ chất liệu cotton, dễ chịu khi mặc', 0, 4, 1),
(N'Quần short nữ đi biển', N'Phong cách thời trang, màu sắc tươi trẻ', 0, 4, 1),
(N'Giày chạy bộ nữ nhẹ', N'Thiết kế năng động, phù hợp cho mọi địa hình', 0, 4, 1),
(N'Váy maxi nữ đi biển', N'Chất liệu voan mềm mại, thoải mái trong các chuyến đi biển', 0, 4, 1),
(N'Nón chống nắng nữ', N'Thiết kế đẹp mắt, bảo vệ da khỏi ánh nắng', 0, 4, 1),
-- Mức giá 500000-750000
--nam
(N'Áo khoác gió nam', N'Chống nước, giữ ấm, phù hợp cho các chuyến đi xa', 0, 4, 1),
(N'Quần dài nam chống thấm', N'Thiết kế thời trang, chống thấm, thoáng mát', 0, 4, 1),
(N'Giày trekking nam cao cấp', N'Đế chống trượt, thiết kế chắc chắn cho địa hình phức tạp', 0, 4, 1),
(N'Quần short nam đi biển', N'Chất liệu nhanh khô, màu sắc nổi bật', 0, 4, 1),
(N'Nón bảo vệ nam đa dụng', N'Bảo vệ khỏi gió và ánh nắng mặt trời', 0, 4, 1),
--nữ
(N'Áo khoác gió nữ thời trang', N'Chất liệu chống thấm, phong cách năng động', 0, 4, 1),
(N'Quần dài nữ du lịch', N'Chất liệu co giãn, thoải mái cho các hoạt động ngoài trời', 0, 4, 1),
(N'Giày thể thao nữ trekking', N'Giày nữ chắc chắn, phù hợp cho mọi loại địa hình', 0, 4, 1),
(N'Váy maxi nữ du lịch', N'Phong cách thời trang, thoáng mát, phù hợp cho mùa hè', 0, 4, 1),
(N'Nón nữ đi biển', N'Nón rộng vành, chống nắng tốt cho các hoạt động ngoài trời', 0, 4, 1),
-- Mức giá 800000-2000000
--nam
(N'Áo khoác chống thấm nam cao cấp', N'Áo khoác giữ ấm, chống gió cho những chuyến đi dài', 0, 4, 1),
(N'Quần dài nam trekking cao cấp', N'Quần chống thấm, co giãn 4 chiều, thoải mái', 0, 4, 1),
(N'Giày trekking nam chuyên nghiệp', N'Thiết kế chuyên nghiệp, độ bám cao, phù hợp cho leo núi', 0, 4, 1),
(N'Quần short trekking nam', N'Chất liệu cao cấp, phù hợp cho thời tiết nóng', 0, 4, 1),
(N'Nón bảo vệ nam cao cấp', N'Nón chống gió và ánh nắng cho các hoạt động ngoài trời', 0, 4, 1),
--nữ
(N'Áo khoác nữ loia chuyên nghiệp', N'Áo khoác loia chống gió và thấm nước, thiết kế nhẹ nhàng', 0, 4, 1),
(N'Quần dài nữ trekking', N'Chất liệu cao cấp, co giãn tốt, phù hợp cho mọi địa hình', 0, 4, 1),
(N'Giày trekking nữ chuyên nghiệp', N'Giày bền, chống trượt, phù hợp cho các chuyến leo núi', 0, 4, 1),
(N'Quần dài nữ du lịch cao cấp', N'Chất liệu cao cấp, thoáng mát cho các chuyến đi biển', 0, 4, 1),
(N'Nón chống nắng nữ cao cấp', N'Thiết kế thời trang, bảo vệ tối đa khỏi tia UV', 0, 4, 1);
-- Sản phẩm cho sở thích "Thời trang hot trend" Thanh niên từ 0 đến 37 tuổi
INSERT INTO SanPham (TenSanPham, MoTa, SoLuongDaBan, DanhMucID, KichHoat)
VALUES 
-- Mức giá 15000-400000
-- nam
(N'Áo khoác thể thao nam đa năng', N'Áo khoác nhẹ, thoáng khí, phù hợp cho mọi hoạt động thể thao.', 0, 5, 1),
(N'Quần jogger nam thời trang', N'Quần jogger thoải mái, phong cách thể thao trẻ trung.', 0, 5, 1),
(N'Giày chạy bộ nam siêu nhẹ', N'Giày chạy bộ với thiết kế siêu nhẹ, hỗ trợ tốt cho chân.', 0, 5, 1),
(N'Quần short thể thao nam chống thấm', N'Quần short thời trang, chất liệu chống thấm nước.', 0, 5, 1),
(N'Mũ lưỡi trai thể thao phong cách', N'Mũ lưỡi trai thời trang, bảo vệ tốt khi ra ngoài.', 0, 5, 1),

-- nữ
(N'Áo khoác thể thao nữ thời trang', N'Áo khoác nữ phong cách, thoải mái cho mùa đông.', 0, 5, 1),
(N'Quần legging nữ thời trang', N'Quần legging co giãn, dễ chịu cho mọi hoạt động.', 0, 5, 1),
(N'Giày thể thao nữ thời trang', N'Giày thể thao nữ phong cách, nhẹ và bền.', 0, 5, 1),
(N'Quần short thể thao nữ trẻ trung', N'Quần short nữ trẻ trung, chất liệu thoáng mát.', 0, 5, 1),
(N'Mũ lưỡi trai nữ phong cách', N'Mũ lưỡi trai nữ thời trang, bảo vệ nắng hiệu quả.', 0, 5, 1),

-- Mức giá 500000-750000
-- nam
(N'Áo hoodie nam phong cách', N'Áo hoodie nam thời trang, giữ ấm hiệu quả trong mùa lạnh.', 0, 5, 1),
(N'Quần thể thao nam ống rộng', N'Quần thể thao ống rộng, thoải mái cho mọi hoạt động.', 0, 5, 1),
(N'Giày sneaker nam thời trang', N'Giày sneaker nam, thiết kế trẻ trung và hiện đại.', 0, 5, 1),
(N'Quần cargo nam phong cách', N'Quần cargo với nhiều túi tiện dụng, thời trang.', 0, 5, 1),
(N'Mũ bucket nam', N'Mũ bucket phong cách, bảo vệ nắng cho mùa hè.', 0, 5, 1),

-- nữ
(N'Áo khoác bomber nữ', N'Áo khoác bomber thời trang, phù hợp với nhiều trang phục.', 0, 5, 1),
(N'Quần jeans nữ thời trang', N'Quần jeans nữ với kiểu dáng trẻ trung và năng động.', 0, 5, 1),
(N'Giày búp bê nữ thời trang', N'Giày búp bê nữ thoải mái, thích hợp cho nhiều dịp.', 0, 5, 1),
(N'Quần culottes nữ thời trang', N'Quần culottes nữ, phong cách thoáng mát và dễ chịu.', 0, 5, 1),
(N'Mũ lưỡi trai nữ', N'Mũ lưỡi trai phong cách, thời trang và tiện lợi.', 0, 5, 1),

-- Mức giá 800000-2000000
(N'Áo khoác thể thao nam cao cấp', N'Áo khoác thể thao nam, chất liệu tốt, giữ ấm hiệu quả.', 0, 5, 1),
(N'Quần thể thao nam cao cấp', N'Quần thể thao nam chất liệu tốt, thoải mái khi vận động.', 0, 5, 1),
(N'Giày thể thao nam cao cấp', N'Giày thể thao nam với thiết kế cao cấp, hỗ trợ tốt cho chân.', 0, 5, 1),
(N'Quần short thể thao nam cao cấp', N'Quần short nam cao cấp, chất liệu thoáng khí và bền bỉ.', 0, 5, 1),
(N'Mũ lưỡi trai thể thao cao cấp', N'Mũ lưỡi trai chất lượng cao, phù hợp cho mọi hoạt động ngoài trời.', 0, 5, 1),

-- nữ
(N'Áo khoác thể thao nữ cao cấp', N'Áo khoác thể thao nữ, chất liệu tốt, thiết kế thời trang.', 0, 5, 1),
(N'Quần ngắn nữ cao cấp', N'Quần ngắn nữ, chất liệu thoáng khí, phù hợp cho mọi hoạt động.', 0, 5, 1),
(N'Giày cao nữ cao cấp', N'Giày cao nữ chất lượng.', 0, 5, 1),
(N'Áo thể thao nữ năng động', N'Áo thể thao nữ thoáng khí, thiết kế năng động, thoải mái cho mọi hoạt động.', 0, 5, 1),
(N'Áo thể thao nữ năng động', N'Áo thể thao nữ thoáng khí, thiết kế năng động, thoải mái cho mọi hoạt động.', 0, 5, 1);
-- Sản phẩm cho sở thích "Thể thao" Trung niên từ 38 đến 60 tuổi
INSERT INTO SanPham (TenSanPham, MoTa, SoLuongDaBan, DanhMucID, KichHoat)
VALUES 
-- Mức giá 15000-400000
--nam
(N'Áo thể thao nam cổ tròn thoáng mát', N'Áo dành cho nam giới trung niên, chất liệu thoáng khí, phù hợp cho hoạt động thể thao ngoài trời.', 45, 1, 1),
(N'Quần dài thể thao nam co giãn', N'Quần thể thao nam, chất liệu mềm mại, đàn hồi tốt, lý tưởng cho tập luyện và chạy bộ.', 60, 1, 1),
(N'Giày chạy bộ nam chống trượt', N'Giày thể thao nam siêu nhẹ, đế chống trượt, phù hợp cho mọi địa hình.', 40, 1, 1),
(N'Áo gió thể thao nam chống nước', N'Áo khoác thể thao nam, chất liệu chống nước, bảo vệ khi chạy bộ ngoài trời.', 55, 1, 1),
(N'Ba lô thể thao nam nhiều ngăn', N'Ba lô thể thao với nhiều ngăn tiện dụng, chất liệu bền, dành cho nam giới trung niên.', 35, 1, 1),

--nữ
(N'Áo thể thao nữ chống nắng', N'Áo thể thao nữ trung niên, chất liệu chống nắng, phù hợp cho tập luyện ngoài trời.', 48, 1, 1),
(N'Quần legging thể thao nữ co giãn', N'Quần legging nữ ôm sát, chất liệu co giãn thoải mái, lý tưởng cho yoga và chạy bộ.', 52, 1, 1),
(N'Giày thể thao nữ đệm êm chân', N'Giày thể thao nữ với đệm êm ái, phù hợp cho đi bộ đường dài và chạy bộ.', 60, 1, 1),
(N'Áo khoác thể thao nữ dáng rộng', N'Áo khoác thể thao nữ trung niên, dáng rộng thoải mái, chống gió và chống nước.', 50, 1, 1),
(N'Túi đeo vai thể thao nữ', N'Túi đeo vai thể thao tiện lợi, phù hợp cho các hoạt động ngoài trời, dành cho nữ trung niên.', 40, 1, 1),

-- Mức giá 500000-750000
--nam
(N'Áo khoác gió nam chống tia UV', N'Áo khoác gió nam trung niên, chống tia UV, thích hợp cho các hoạt động ngoài trời.', 45, 1, 1),
(N'Quần short thể thao nam chống thấm', N'Quần short thể thao nam chất liệu chống thấm nước, phù hợp cho đi bộ đường dài.', 38, 1, 1),
(N'Giày leo núi nam chống trượt', N'Giày leo núi nam với đế chống trượt, đệm êm chân, phù hợp cho địa hình gồ ghề.', 30, 1, 1),
(N'Ba lô leo núi thể thao nam', N'Ba lô leo núi dung tích lớn, dành cho các chuyến đi dài, thiết kế đặc biệt cho nam trung niên.', 20, 1, 1),
(N'Kính mát thể thao nam chống lóa', N'Kính mát thể thao với khả năng chống lóa và chống tia UV, thích hợp cho nam giới trung niên.', 55, 1, 1),

--nữ
(N'Áo khoác chống tia UV nữ', N'Áo khoác thể thao nữ trung niên, chống tia UV và gió, thích hợp cho đi bộ và leo núi.', 42, 1, 1),
(N'Giày leo núi nữ chống trượt', N'Giày thể thao nữ dành cho leo núi, đế chống trượt và đệm êm chân, lý tưởng cho hoạt động ngoài trời.', 32, 1, 1),
(N'Quần short thể thao nữ thoáng mát', N'Quần thể thao nữ trung niên, chất liệu thoáng khí, phù hợp cho các hoạt động thể thao.', 50, 1, 1),
(N'Bình nước thể thao nữ', N'Bình nước thể thao tiện lợi, dung tích lớn, giữ nhiệt tốt, dành cho nữ giới trung niên.', 40, 1, 1),
(N'Kính mát thể thao nữ chống UV', N'Kính mát thể thao nữ với khả năng chống tia UV và chống lóa, phù hợp cho hoạt động ngoài trời.', 50, 1, 1),

-- Mức giá 800000-2000000
--nam
(N'Áo khoác thể thao nam chống gió', N'Áo khoác thể thao nam trung niên, chống gió và nước, lý tưởng cho đi bộ và chạy bộ.', 45, 1, 1),
(N'Giày leo núi nam chuyên dụng', N'Giày leo núi nam chuyên dụng, chất liệu chống trượt và thấm nước, đệm lót siêu êm.', 35, 1, 1),
(N'Bộ quần áo thể thao nam chất liệu cao cấp', N'Bộ quần áo thể thao với chất liệu cao cấp, đàn hồi tốt, dành cho nam giới trung niên.', 28, 1, 1),
(N'Áo khoác thể thao nam chống nước', N'Áo khoác thể thao nam, thiết kế chống nước, phù hợp cho các hoạt động thể thao ngoài trời.', 25, 1, 1),
(N'Balo thể thao nam chuyên dụng', N'Ba lô thể thao dung tích lớn, chống nước, chuyên dụng cho các hoạt động leo núi, đi bộ đường dài.', 18, 1, 1),

--nữ 
(N'Áo khoác thể thao nữ giữ nhiệt', N'Áo khoác thể thao nữ trung niên, giữ nhiệt tốt, phù hợp cho thời tiết lạnh khi chạy bộ.', 40, 1, 1), 
(N'Giày chạy bộ nữ chất lượng cao', N'Giày chạy bộ nữ với thiết kế chuyên dụng, đệm lót êm ái, chống trượt tốt, dành cho nữ trung niên.', 35, 1, 1), 
(N'Quần dài thể thao nữ giữ nhiệt', N'Quần dài thể thao nữ, chất liệu giữ nhiệt và co giãn, phù hợp cho các hoạt động ngoài trời.', 28, 1, 1), 
(N'áo thể thao nữ chống nước', N'áo thể thao nữ với khả năng chống nước, thiết kế phù hợp cho các hoạt động leo núi và đi bộ.', 22, 1, 1), 
(N'Balo leo núi nữ chuyên dụng', N'Balo leo núi nữ dung tích lớn, chất liệu bền bỉ, phù hợp cho các chuyến đi dài.', 15, 1, 1);
-- Sản phẩm cho sở thích "Công sở, lịch sự" Trung niên từ 38 đến 60 tuổi
INSERT INTO SanPham (TenSanPham, MoTa, SoLuongDaBan, DanhMucID, KichHoat)
VALUES 
-- Mức giá 15000-400000
--nam
(N'Áo sơ mi nam dài tay cao cấp', N'Áo sơ mi lịch lãm cho nam trung niên, phù hợp đi làm và gặp gỡ đối tác', 0, 2, 1),
(N'Quần âu nam thanh lịch', N'Quần âu công sở thoải mái cho nam trung niên', 0, 2, 1),
(N'Giày da nam sang trọng', N'Giày da mềm mại, thiết kế tối giản nhưng tinh tế', 0, 2, 1),
(N'Cà vạt họa tiết sang trọng', N'Cà vạt chất liệu lụa cao cấp, phù hợp với vest nam trung niên', 0, 2, 1),
(N'Túi xách da bò', N'Túi xách công sở nam chất liệu da bò, kiểu dáng sang trọng', 0, 2, 1),
--Nữ
(N'Áo sơ mi nữ cổ điển', N'Áo sơ mi trắng thanh lịch, phù hợp đi làm và hội họp', 0, 2, 1),
(N'Quần tây nữ ống đứng', N'Quần tây công sở dành cho nữ trung niên, thiết kế đơn giản mà tinh tế', 0, 2, 1),
(N'Giày cao gót nữ thanh lịch', N'Giày cao gót nữ 5cm phù hợp cho môi trường công sở', 0, 2, 1),
(N'Túi xách nữ kiểu dáng cổ điển', N'Túi xách công sở nữ thiết kế tinh tế, màu đen sang trọng', 0, 2, 1),
(N'Áo cổ nữ họa tiết nhẹ nhàng', N'Chất liệu lụa mềm mại, tạo điểm nhấn cho trang phục công sở', 0, 2, 1),
-- Mức giá 500000-750000
--nam
(N'Áo vest nam phong cách cổ điển', N'Áo vest lịch lãm, kiểu dáng cổ điển dành cho nam trung niên', 0, 2, 1),
(N'Quần âu nam cắt may tinh tế', N'Quần âu cao cấp, form chuẩn cho nam giới trung niên', 0, 2, 1),
(N'Giày lười nam da bò', N'Giày lười da bò mềm mại, sang trọng, phù hợp cho các buổi gặp gỡ công việc', 0, 2, 1),
(N'Túi xách cao cấp', N'Túi xách nam trung niên, chất liệu da cao cấp, thiết kế sang trọng', 0, 2, 1),
(N'Vest nam', N'Bản to, thiết kế mạnh mẽ cho nam trung niên', 0, 2, 1),
--Nữ
(N'Quần áo nữ cổ điển', N'Công sở dành cho nữ trung niên, kiểu dáng cổ điển', 0, 2, 1),
(N'Váy liền thân dáng ôm', N'Váy công sở dành cho nữ trung niên, dáng ôm tinh tế', 0, 2, 1),
(N'Giày bệt nữ da bò', N'Giày bệt nữ chất liệu da bò mềm, thoải mái nhưng vẫn lịch sự', 0, 2, 1),
(N'Túi xách nữ da cao cấp', N'Túi xách nữ màu nâu nhạt, thiết kế đơn giản mà tinh tế', 0, 2, 1),
(N'Áo choàng cổ lụa sang trọng', N'Áo choàng lụa thiết kế họa tiết nhẹ nhàng, mang lại vẻ đẹp thanh lịch', 0, 2, 1),
-- Mức giá 800000-2000000
--nam
(N'Áo khoác da nam cổ điển', N'Áo khoác da thật, kiểu dáng cổ điển, phong cách lịch sự', 0, 2, 1),
(N'Quần tây nam cao cấp', N'Quần tây nam chất liệu cotton thoáng mát, phù hợp với nam trung niên', 0, 2, 1),
(N'Giày Oxford nam', N'Giày Oxford cổ điển cho nam giới, kiểu dáng lịch lãm', 0, 2, 1),
(N'Túi đựng laptop da bò', N'Túi xách đựng laptop da bò cao cấp, phù hợp với doanh nhân trung niên', 0, 2, 1),
(N'Kính mát nam hàng hiệu', N'Kính mát nam thương hiệu nổi tiếng, mang lại vẻ ngoài sang trọng', 0, 2, 1),
--Nữ
(N'Áo khoác da nữ thời thượng', N'Áo khoác da cho nữ trung niên, phong cách cổ điển mà hiện đại', 0, 2, 1),
(N'Váy dự tiệc công sở', N'Váy dự tiệc sang trọng, thiết kế tinh tế cho nữ trung niên', 0, 2, 1),
(N'Giày cao gót nữ đế nhọn', N'Giày cao gót đế nhọn 7cm, thiết kế tối giản nhưng sang trọng', 0, 2, 1),
(N'Túi xách tay nữ cao cấp', N'Túi xách nữ hàng hiệu cao cấp, thiết kế cổ điển và sang trọng', 0, 2, 1),
(N'Váy hàng hiệu', N'Cao cấp, hàng hiệu nổi tiếng, màu sắc nhẹ nhàng và sang trọng', 0, 2, 1);
-- Sản phẩm cho sở thích "Đơn giản, thường ngày" Trung niên từ 38 đến 60 tuổi
INSERT INTO SanPham (TenSanPham, MoTa, SoLuongDaBan, DanhMucID, KichHoat) 
VALUES 
-- Mức giá 15000-400000
-- nam
(N'Áo polo nam cotton thoải mái', N'Phong cách thường ngày, phù hợp cho nam giới trung niên', 40, 3, 1),
(N'Quần kaki nam trung niên', N'Chất liệu kaki mềm mại, mặc thoải mái hàng ngày', 30, 3, 1),
(N'Giày lười da nam trung niên', N'Giày lười tiện lợi, thiết kế đơn giản phù hợp với mọi lứa tuổi', 25, 3, 1),
(N'Áo sơ mi dài tay thoáng mát', N'Sơ mi dài tay, thiết kế cổ điển cho nam trung niên', 20, 3, 1),
(N'Giày quai ngang da thật nam', N'Giày quai ngang thoáng mát, phù hợp cho mùa hè', 50, 3, 1),
-- nữ
(N'Áo phông nữ tay lỡ', N'Áo phông thiết kế đơn giản, thích hợp mặc thường ngày', 45, 3, 1),
(N'Váy suông nữ trung niên', N'Váy suông dài cho nữ trung niên, đơn giản mà thanh lịch', 35, 3, 1),
(N'Dép xỏ ngón nữ thoải mái', N'Dép xỏ ngón nhẹ nhàng, thiết kế tiện lợi', 40, 3, 1),
(N'Áo khoác len nữ dáng dài', N'Áo khoác len mềm, phù hợp cho những ngày se lạnh', 15, 3, 1),
(N'Mũ lưỡi trai nữ thời trang', N'Mũ lưỡi trai tiện lợi, phù hợp cho hoạt động ngoài trời', 25, 3, 1),

-- Mức giá 500000-750000
-- nam

(N'Áo len cổ tròn cao cấp', N'Áo len dành cho mùa thu đông, thiết kế tối giản', 20, 3, 1),
(N'Quần jeans nam trung niên', N'Quần jeans co giãn tốt, thích hợp mặc hàng ngày', 30, 3, 1),
(N'Giày da lười nam', N'Giày da cao cấp, thiết kế đơn giản, dễ phối đồ', 10, 3, 1),
(N'Áo khoác gió nam trung niên', N'Áo khoác gió nhẹ, chống nắng tốt', 25, 3, 1),
(N'Túi đeo chéo da bò', N'Túi đeo chéo đơn giản, làm từ da bò thật', 15, 3, 1),
-- nữ
(N'Váy hoa nữ trung niên', N'Váy hoa nhẹ nhàng, dễ mặc và thoải mái', 12, 3, 1),
(N'Quần vải nữ ', N'Quần vải mềm mại, thích hợp cho nữ trung niên', 25, 3, 1),
(N'Giày bệt nữ trung niên', N'Giày bệt thoải mái, thiết kế đơn giản cho nữ', 20, 3, 1),
(N'Áo khoác cardigan nữ', N'Áo khoác len mỏng, phù hợp với thời tiết mát mẻ', 18, 3, 1),
(N'Mũ rộng vành nữ', N'Mũ rộng vành cho nữ, thích hợp cho các chuyến du lịch', 22, 3, 1),

-- Mức giá 800000-2000000
-- nam
(N'Áo vest nam trung niên', N'Áo vest sang trọng, thiết kế lịch lãm cho nam', 10, 3, 1),
(N'Quần âu nam trung niên', N'Quần âu chất lượng cao, thiết kế ôm vừa vặn', 15, 3, 1),
(N'Giày da cao cấp nam', N'Giày da lịch lãm, phù hợp cho các sự kiện quan trọng', 8, 3, 1),
(N'Áo khoác da nam', N'Áo khoác da thật, bền đẹp với thời gian', 5, 3, 1),
(N'Túi da nam', N'Túi da cầm tay, phù hợp cho phong cách lịch lãm', 12, 3, 1),
-- nữ
(N'Áo đơn giản', N'thiết kế tinh tế cho nữ trung niên', 8, 3, 1),
(N'Váy ở nhà', N'tạo sự thoải mái và thanh lịch', 10, 3, 1),
(N'Quần nữ trung niên', N'vừa phải, thiết kế đơn giản mà đẹp mắt', 7, 3, 1),
(N'Quần ở nhà', N' gọn, thanh lịch cho nữ', 5, 3, 1),
(N'Áo khoác dạ nữ', N'Áo khoác dạ ấm áp, thích hợp cho mùa đông', 12, 3, 1);
-- Sản phẩm cho sở thích "Thời trang du lịch" Trung niên từ 38 đến 60 tuổi 
INSERT INTO SanPham (TenSanPham, MoTa, SoLuongDaBan, DanhMucID, KichHoat) 
VALUES 
-- Mức giá 15000-400000
--nam
(N'Áo gió du lịch nam chống thấm nước', N'Thiết kế năng động, thích hợp cho các chuyến đi', 0, 4, 1),
(N'Quần ngắn du lịch nam thoáng mát', N'Tiện dụng trong mọi chuyến đi dài ngày', 0, 4, 1),
(N'Giày lười nam thoáng khí', N'Giày tiện dụng, phong cách cho những buổi dạo phố', 0, 4, 1),
(N'Mũ chống nắng nam thoáng mát', N'Phù hợp cho các hoạt động ngoài trời', 0, 4, 1),
(N'Túi đeo chéo nam chống nước', N'Tiện lợi và phong cách cho chuyến du lịch', 0, 4, 1),
--nữ
(N'Áo khoác du lịch nữ chống nắng', N'Thiết kế nhẹ, chống nắng hiệu quả', 0, 4, 1),
(N'Quần vải du lịch nữ co giãn', N'Dễ chịu khi vận động trong các chuyến đi', 0, 4, 1),
(N'Giày sandal nữ thoáng mát', N'Sandal nhẹ nhàng, phù hợp với nhiều loại địa hình', 0, 4, 1),
(N'Túi xách', N'Thời trang phù hợp đi dạo', 0, 4, 1),
(N'Túi đeo chéo nữ chống nước', N'Túi nhỏ gọn nhưng đầy tiện dụng', 0, 4, 1),

-- Mức giá 500000-750000
--nam
(N'Quần áo du lịch nam đa năng', N'Chống gió, chống nước phù hợp mọi địa hình', 0, 4, 1),
(N'Quần du lịch nam chống nước', N'Thiết kế tiện dụng, chống thấm hiệu quả', 0, 4, 1),
(N'Giày trekking nam chống trượt', N'Phù hợp cho những chuyến leo núi', 0, 4, 1),
(N'Mũ vành du lịch nam', N'Chống nắng, thoáng khí cho những chuyến dã ngoại', 0, 4, 1),
(N'Balo du lịch nam chống nước', N'Thiết kế rộng rãi, dễ dàng di chuyển', 0, 4, 1),
--nữ
(N'Áo du lịch nữ chống gió', N'Thiết kế nhẹ, dễ gấp gọn mang theo', 0, 4, 1),
(N'Quần jean du lịch nữ co giãn', N'Tiện lợi trong các hoạt động ngoài trời', 0, 4, 1),
(N'Giày thể thao nữ chống trượt', N'Phù hợp mọi địa hình, bảo vệ đôi chân', 0, 4, 1),
(N'Túi đeo du lịch nữ chống nước', N'Dễ dàng mang theo trong các chuyến đi', 0, 4, 1),
(N'Mũ chống nắng du lịch nữ', N'Chống nắng tốt, thiết kế nữ tính', 0, 4, 1),

-- Mức giá 800000-2000000
--nam
(N'Áo khoác du lịch cao cấp', N'Chất liệu cao cấp, bảo vệ cơ thể khỏi thời tiết khắc nghiệt', 0, 4, 1),
(N'Quần trekking nam chuyên dụng', N'Quần chống nước, bảo vệ đôi chân', 0, 4, 1),
(N'Bình nam cao cấp', N'Chất liệu bền', 0, 4, 1),
(N'Mũ du lịch nam', N'Bảo vệ đầu trong những chuyến leo núi khó khăn', 0, 4, 1),
(N'Balo du lịch nam đa năng', N'Balo cỡ lớn, có nhiều ngăn tiện lợi', 0, 4, 1),
--nữ
(N'Áo quần du lịch nữ cao cấp', N'Phong cách thời trang', 0, 4, 1),
(N'Quần trekking nữ co giãn', N'Quần bảo vệ, giúp thoải mái di chuyển', 0, 4, 1),
(N'Giày nice nữ chống trượt', N'Giày chuyên dụng cho những chuyến leo núi', 0, 4, 1),
(N'Mũ du lịch nữ thời trang', N'Mũ thiết kế bảo vệ khỏi ánh nắng mặt trời', 0, 4, 1),
(N'Túi du lịch nữ cao cấp', N'Túi lớn đa năng, thích hợp cho chuyến đi xa', 0, 4, 1);
-- Sản phẩm cho sở thích "Thời trang hot trend" Trung niên từ 38 đến 60 tuổi
INSERT INTO SanPham (TenSanPham, MoTa, SoLuongDaBan, DanhMucID, KichHoat)
VALUES 
-- Mức giá 15000-400000
--nam
(N'Quần vải co giãn', N'Thời trang thoải mái cho hoạt động hàng ngày', 0, 5, 1),
(N'Quần boki nam trung niên', N'Phong cách trẻ trung nhưng lịch sự', 0, 5, 1),
(N'kính mắt da nam chống trượt', N'Lịch lãm, phù hợp cho cả công sở và dạo phố', 0, 5, 1),
(N'Áo khoác nam giữ nhiệt cổ điển', N'Áo len ấm áp cho mùa đông, phong cách cổ điển', 0, 5, 1),
(N'Mũ nồi nam phong cách retro', N'Thời trang retro, tạo điểm nhấn', 0, 5, 1),
--Nữ
(N'Áo khoác nữ trung niên dạ tweed', N'Sang trọng, giữ ấm trong mùa đông', 0, 5, 1),
(N'Quần âu nữ trung niên', N'Phong cách công sở lịch sự, thoải mái', 0, 5, 1),
(N'Giày cao gót nữ êm chân', N'Giày cao gót dành cho các sự kiện và công sở', 0, 5, 1),
(N'Áo len nữ mỏng giữ ấm', N'Áo len mỏng, thích hợp cho mùa thu và đông', 0, 5, 1),
(N'Mũ lưỡi trai nữ phong cách năng động', N'Thời trang đơn giản nhưng năng động', 0, 5, 1),
-- Mức giá 500000-750000
--nam
(N'Áo sơ mi nam trung niên cao cấp', N'Chất liệu cotton cao cấp, thoáng mát', 0, 5, 1),
(N'Quần kaki nam chống nhăn', N'Phong cách lịch lãm, chống nhăn hiệu quả', 0, 5, 1),
(N'kính tây nam da thật', N'Lịch lãm cho sự kiện và công việc', 0, 5, 1),
(N'Áo cashmere nam', N'Chất liệu cashmere mềm mại, sang trọng', 0, 5, 1),
(N'Mũ cho nam cao cấp', N'Phong cách cổ điển nhưng thời trang', 0, 5, 1),
--Nữ
(N'Áo sơ mi nữ ren', N'Thời trang nữ trung niên với phong cách sang trọng', 0, 5, 1),
(N'Quần vải nữ trung niên', N'Quần vải cao cấp, thoải mái và trang nhã', 0, 5, 1),
(N'Giày cao nữ trung niên cao cấp', N'bền và sang trọng', 0, 5, 1),
(N'Áo thể thao dệt kim nữ', N'Chất liệu dệt kim thoải mái', 0, 5, 1),
(N'Mũ nữ thời trang', N'Phù hợp cho đi dạo và nghỉ dưỡng', 0, 5, 1),

-- Mức giá 800000-2000000
--nam
(N'Áo vest nam cao cấp', N'Áo vest phong cách doanh nhân lịch lãm', 0, 5, 1),
(N'Quần âu nam chống thấm nước', N'Quần âu cao cấp với công nghệ chống thấm', 0, 5, 1),
(N'Giày lười nam da cao cấp', N'Giày lười da thật, thoải mái và sang trọng', 0, 5, 1),
(N'Áo dạ nam dài', N'Áo khoác dạ phong cách Hàn Quốc', 0, 5, 1),
(N'Mũ da cao cấp', N'Thời trang độc đáo và sang trọng', 0, 5, 1),
--Nữ
(N'Áo thể thao dạ nữ nhanh khô', N'Nhanh khô thoáng mát', 0, 5, 1),
(N'Quần âu nữ chất liệu cashmere', N'Chất liệu cashmere cao cấp, mềm mại và thoải mái', 0, 5, 1),
(N'Giày cao gót nữ da thật', N'Giày cao gót da thật, phù hợp cho các dịp đặc biệt', 0, 5, 1),
(N' cashmere nữ', N'siêu bền', 0, 5, 1),
(N'Mũ len cao cấp nữ', N'Phù hợp cho mùa đông và các chuyến du lịch', 0, 5, 1);
-- Sản phẩm cho sở thích "Thể thao" Cao tuổi từ 60 tuổi trở lên
INSERT INTO SanPham (TenSanPham, MoTa, SoLuongDaBan, DanhMucID, KichHoat)
VALUES
-- Mức giá 15000-400000
--nam
(N'Áo thể thao Nam thoáng khí', N'Thể thao năng động', 0, 1, 1),
(N'Quần thể thao Nam thoáng khí', N'Thể thao năng động', 0, 1, 1),
(N'Giày thể thao Nam siêu nhẹ', N'Thể thao năng động', 0, 1, 1),
(N'Quần short thể thao nam xuất khẩu Kappa chất liệu polyester cao cấp', N'Thể thao năng động', 0, 1, 1),
(N'Mũ lưỡi trai', N'Thể thao năng động', 0, 1, 1),
--nữ
(N'Áo thể thao Nữ thoáng khí', N'Thể thao năng động', 0, 1, 1),
(N'Quần thể thao Nữ thoáng khí', N'Thể thao năng động', 0, 1, 1),
(N'Giày thể thao Nữ siêu nhẹ', N'Thể thao năng động', 0, 1, 1),
(N'Quần sort thể thao Nữ xuất khẩu Kappa chất liệu polyester cao cấp', N'Thể thao năng động', 0, 1, 1),
(N'Mũ', N'Thể thao năng động', 0, 1, 1),
-- Mức giá 500000-750000
--nam
(N'Áo thể thao Nam cao cấp', N'Thể thao năng động', 0, 1, 1),
(N'Quần thể thao Nam cao cấp', N'Thể thao năng động', 0, 1, 1),
(N'Giày thể thao Nam siêu nhẹ cao cấp', N'Thể thao năng động', 0, 1, 1),
(N'Quần short thể thao nam xuất khẩu Kappa chất liệu polyester cao cấp', N'Thể thao năng động', 0, 1, 1),
(N'Mũ lưỡi trai cao cấp', N'Thể thao năng động', 0, 1, 1),
--nữ
(N'Áo thể thao Nữ cao cấp', N'Thể thao năng động', 0, 1, 1),
(N'Áo dưỡng sinh thể thao Nữ cao cấp', N'Thể thao năng động', 0, 1, 1),
(N'Giày thể thao Nữ siêu nhẹ cao cấp', N'Thể thao năng động', 0, 1, 1),
(N'Quần áo thể thao Nữ cao cấp', N'Thể thao nhẹ nhàng', 0, 1, 1),
(N'Mũ lưỡi trai Nữ cotton', N'Thể thao năng động', 0, 1, 1),
-- Mức giá 800000-2000000
--nam
(N'Áo thể thao Nam cao cấp đặc biệt', N'Thể thao năng động', 0, 1, 1),
(N'Quần áo thể thao Nam cao cấp đặc biệt', N'Thể thao năng động', 0, 1, 1),
(N'Giày thể thao Nam siêu nhẹ đặc biệt', N'Thể thao năng động', 0, 1, 1),
(N'Quần short thể thao nam cao cấp đặc biệt', N'Thể thao vừa phải phù hợp cao tuổi', 0, 1, 1),
(N'Mũ lưỡi trai đặc biệt', N'Thể thao năng động', 0, 1, 1),
--nữ
(N'Áo thể thao Nữ cao cấp đặc biệt', N'Thể thao năng động', 0, 1, 1),
(N'Quần áo thể thao Nữ cao cấp đặc biệt', N'Thể thao năng động', 0, 1, 1),
(N'Giày thể thao Nữ siêu nhẹ đặc biệt', N'Thể thao năng động', 0, 1, 1),
(N'Quần dài đặc biệt', N'Thể thao năng động', 0, 1, 1),
(N'Mũ lưỡi trai đặc biệt', N'Thể thao năng động', 0, 1, 1);
-- Sản phẩm cho sở thích "Công sở, lịch sự" Trung niên từ 60 tuổi trở lên
INSERT INTO SanPham (TenSanPham, MoTa, SoLuongDaBan, DanhMucID, KichHoat)
VALUES 
-- Mức giá 15000-400000
--nam
(N'Áo sơ mi nam thoáng khí', N'Phong cách công sở, dễ chịu cho người cao tuổi', 0, 2, 1),
(N'Quần tây nam công sở', N'Sang trọng và thoải mái cho mọi dịp', 0, 2, 1),
(N'Giày da nam lịch lãm', N'Giày da mềm mại, phù hợp cho người cao tuổi', 0, 2, 1),
(N'Giày nam lịch sự', N'Mẫu giày thời trang cho công sở', 0, 2, 1),
(N'Cặp tài liệu', N'Bảo vệ tốt tài liệu và phong cách cho người cao tuổi', 0, 2, 1),
--nữ
(N'Áo blouse nữ thoáng khí', N'Phong cách thanh lịch, thoải mái cho người cao tuổi', 0, 2, 1),
(N'Quần tây nữ công sở', N'Sang trọng và dễ chịu, phù hợp với mọi vóc dáng', 0, 2, 1),
(N'Giày cao gót nữ thoải mái', N'Giày thời trang giúp tôn dáng cho người lớn tuổi', 0, 2, 1),
(N'Váy nữ lịch sự', N'Mẫu váy năng động nhưng vẫn thanh lịch', 0, 2, 1),
(N'Balo thời trang nữ', N'Sản phẩm bảo vệ tốt và thời trang cho người cao tuổi', 0, 2, 1),
-- Mức giá 500000-750000
--nam
(N'Áo vest nam cao cấp', N'Sản phẩm sang trọng dành cho những dịp quan trọng', 0, 2, 1),
(N'Quần tây nam cao cấp', N'Mẫu quần tây được thiết kế tinh tế', 0, 2, 1),
(N'Giày da nam cao cấp', N'Giày lịch lãm, phong cách cho người lớn tuổi', 0, 2, 1),
(N'cà vạt nam công sở', N'Mẫu cà vạt thời trang cho người cao tuổi', 0, 2, 1),
(N'Cà vạt nam cao cấp', N'Sản phẩm thời trang cho phong cách công sở', 0, 2, 1),
--nữ
(N'Áo vest nữ cao cấp', N'Sang trọng, phù hợp với mọi dịp gặp mặt', 0, 2, 1),
(N'Quần tây nữ cao cấp', N'Mẫu quần tây thiết kế đẹp, thoải mái', 0, 2, 1),
(N'Giày cao gót nữ cao cấp', N'Giày thanh lịch, dễ đi cho người lớn tuổi', 0, 2, 1),
(N'Cà vạt nữ công sở', N'Phong cách và thoải mái', 0, 2, 1),
(N'Giày công sở', N'Sản phẩm thời trang, bảo vệ tốt cho người cao tuổi', 0, 2, 1),
-- Mức giá 800000-2000000
--nam
(N'Áo vest nam đặc biệt', N'Sản phẩm cao cấp cho những sự kiện đặc biệt', 0, 2, 1),
(N'Vest tây nam đặc biệt', N'Mẫu vest tây lịch lãm cho người lớn tuổi', 0, 2, 1),
(N'Giày da nam đặc biệt', N'Giày phong cách và thoải mái cho người cao tuổi', 0, 2, 1),
(N'Balo đeo nam đặc biệt', N'Thời trang cho mùa hè', 0, 2, 1),
(N'Giày nam đặc biệt', N'Giúp bảo vệ và thêm phần phong cách cho người cao tuổi', 0, 2, 1),
--nữ
(N'Váy nữ đặc biệt', N'Phong cách sang trọng, phù hợp cho những sự kiện đặc biệt', 0, 2, 1),
(N'Quần tây nữ đặc biệt', N'Mẫu quần tây thanh lịch cho người lớn tuổi', 0, 2, 1),
(N'Vest nữ đặc biệt', N'Lịch lãm, tôn dáng cho người lớn tuổi', 0, 2, 1),
(N'Vest nữ thời trang', N'Mẫu thời trang cho mùa hè', 0, 2, 1),
(N'Giày búp bê', N'Thời trang và bảo vệ tốt cho người cao tuổi', 0, 2, 1);
-- Sản phẩm cho sở thích "Đơn giản, thường ngày" Cao tuổi từ 60 tuổi trở lên
INSERT INTO SanPham (TenSanPham, MoTa, SoLuongDaBan, DanhMucID, KichHoat) 
VALUES 
-- Mức giá 15000-400000
-- nam
(N'Áo cotton trung niên', N'Áo cotton mềm mại, thoáng mát, phù hợp cho nam cao tuổi', 50, 3, 1),
(N'Quần  đùi nam', N'Quần kaki thoải mái, dễ chịu cho các hoạt động hàng ngày', 35, 3, 1),
(N'Giày thể thao cao cấp nam', N'Giày thể thao nhẹ nhàng, đơn giản và bền bỉ cho nam giới', 28, 3, 1),
(N'Áo dài tay nam', N'Áo thun giữ ấm tốt, phù hợp mặc vào mùa thu đông', 18, 3, 1),
(N'Dép da thoáng khí', N'Dép da thoáng khí, nhẹ nhàng phù hợp với thời tiết nóng', 45, 3, 1),
-- nữ
(N'Áo khoác nhẹ nữ', N'Áo khoác nhẹ, dễ dàng phối đồ, phù hợp với thời tiết mát mẻ', 32, 3, 1),
(N'Váy dài trung niên', N'Váy dài nhẹ nhàng, phù hợp với phong cách thanh lịch của nữ cao tuổi', 20, 3, 1),
(N'Dép bệt nữ', N'Dép bệt nữ thoải mái, dễ dàng mang đi dạo hay ở nhà', 38, 3, 1),
(N'Áo thun nhẹ', N'Áo thun mềm mỏng cho nữ, phù hợp khi thời tiết hè', 22, 3, 1),
(N'Mũ len nữ cao tuổi', N'Mũ len mềm mại, giữ ấm tốt vào mùa đông', 25, 3, 1),

-- Mức giá 500000-750000
-- nam
(N'Áo ấm nam cao cấp', N'Áo ấm cao cấp, phù hợp cho thời tiết lạnh, thiết kế cổ điển', 20, 3, 1),
(N'Quần đen nam', N'Quần cho nam giới, dễ chịu, bền bỉ', 27, 3, 1),
(N'Giày thể thao nam đơn giản', N'Giày thể thao nhẹ nhàng, thoáng khí, phù hợp cho người cao tuổi', 12, 3, 1),
(N'Áo khoác mỏng gió nam', N'Áo khoác gió nhẹ, chống nắng và bảo vệ sức khỏe tốt', 18, 3, 1),
(N'Áo có cổ nam nhỏ gọn', N'mềm mại, kích thước vừa phải, phù hợp cho nam giới', 15, 3, 1),
-- nữ
(N'áo suông họa tiết', N'Váy suông với họa tiết nhẹ nhàng, đơn giản nhưng trang nhã', 18, 3, 1),
(N'Quần vải nữ', N'Quần vải mềm, thoáng mát cho nữ trung niên', 22, 3, 1),
(N'Dép  lười nữ', N'Dép lười tiện lợi, nhẹ nhàng và thoải mái', 14, 3, 1),
(N'Áo cardigan  nữ', N'Áo  cardigan đơn giản, phù hợp mặc trong mùa thu', 10, 3, 1),
(N'Khăn len ấm áp', N'khăn len giữ ấm, thiết kế gọn nhẹ, dễ sử dụng', 25, 3, 1),

-- Mức giá 800000-2000000
-- nam
(N'Áo thun trung niên cao cấp', N'Áo thun cao cấp, phù hợp cho các dịp trang trọng', 7, 3, 1),
(N'Quần âu cao cấp nam', N'Quần âu vừa vặn, làm từ chất liệu cao cấp, thoải mái', 18, 3, 1),
(N'Dép sang trọng', N'  thiết kế tối giản, phù hợp với nhiều phong cách', 5, 3, 1),
(N'Áo khoác da thật', N'Áo khoác da sang trọng, bền bỉ với thời gian', 8, 3, 1),
(N'kính sang trọng', N' phù hợp cho phong cách lịch lãm', 10, 3, 1),
-- nữ
(N'Áo vest nữ cao cấp', N'Áo vest nữ với chất liệu cao cấp, thiết kế tối giản mà tinh tế', 5, 3, 1),
(N'Váy công sở nữ', N'Váy công sở cao cấp, thoải mái và sang trọng', 8, 3, 1),
(N'Dép nhập khẩu', N'dép nhập khẩu thoải mái, phù hợp cho nữ trung niên', 9, 3, 1),
(N'Áo khoác len nữ', N'Áo khoác len sang trọng, ấm áp và dễ dàng phối đồ', 15, 3, 1), 
(N'Túi da nữ sang trọng', N'Túi da nhỏ gọn, phù hợp với phong cách nữ trung niên', 12, 3, 1);
-- Sản phẩm cho sở thích "Thời trang du lịch" Cao tuổi từ 60 tuổi trở lên
INSERT INTO SanPham (TenSanPham, MoTa, SoLuongDaBan, DanhMucID, KichHoat)
VALUES 
-- Mức giá 150000-400000
-- nam
(N'Áo khoác du lịch chống nắng Nam', N'Áo khoác nhẹ, thoáng khí, bảo vệ khỏi nắng, thích hợp cho các chuyến đi ngắn ngày.', 50, 4, 1),
(N'Quần dài du lịch Nam co giãn', N'Quần dài với khả năng co giãn, thoải mái cho người lớn tuổi khi di chuyển.', 50, 4, 1),
(N'Áo du lịch Nam thoáng khí', N'Dễ mang, thích hợp cho người lớn tuổi trong các chuyến đi dạo.', 50, 4, 1),
(N'Mũ du lịch Nam', N'Mũ rộng vành, bảo vệ khỏi nắng và dễ dàng mang theo khi di chuyển.', 50, 4, 1),
(N'Bộ du lịch Nam', N'Dành cho người lớn tuổi', 50, 4, 1),
-- nữ
(N'Áo khoác gió du lịch Nữ', N'Áo khoác nhẹ, phù hợp cho các chuyến đi đường dài với khả năng chống gió tốt.', 50, 4, 1),
(N'Quần áo du lịch Nữ có lót ấm', N'Quần có lót giữ ấm bên trong, lý tưởng cho người cao tuổi khi đi du lịch vào mùa lạnh.', 50, 4, 1),
(N'Giày bệt du lịch Nữ thoải mái', N'Giày bệt với lớp lót mềm mại, giúp đôi chân thoải mái trong các chuyến đi dài.', 50, 4, 1),
(N'Mũ du và quần áo lịch Nữ chống nắng', N'Mũ rộng vành, chống nắng tốt, tiện lợi cho người lớn tuổi khi tham gia các hoạt động ngoài trời.', 50, 4, 1),
(N'Túi xách du lịch Nữ thời trang', N'Túi xách nhỏ gọn, kiểu dáng thanh lịch, phù hợp cho người cao tuổi trong các chuyến đi.', 50, 4, 1),
-- Mức giá 500000-750000
-- nam
(N'Áo chống thấm nước Nam', N'Áo chống thấm nước, giữ ấm tốt, phù hợp cho các chuyến du lịch dài ngày.', 50, 4, 1),
(N'Giày trekking Nam chống nước', N'Trekking, chống thấm tốt, co giãn thoải mái khi leo núi.', 50, 4, 1),
(N'Giày trekking Nam cao cấp', N'Giày trekking chống nước, phù hợp cho địa hình gồ ghề và điều kiện thời tiết khắc nghiệt.', 50, 4, 1),
(N'Mũ du lịch Nam cao cấp', N'Mũ thời trang, bảo vệ tốt khỏi ánh nắng, phù hợp cho mọi chuyến đi xa.', 50, 4, 1),
(N'Giày Nam cao cấp', N'Giày chống nước, phù hợp cho địa hình gồ ghề và điều kiện thời tiết khắc nghiệt.', 50, 4, 1),
-- nữ
(N'Áo quần c Nữ', N'Áo khoác tốt, lý tưởng cho các chuyến du lịch dài ngày.', 50, 4, 1),
(N'Quần trekking Nữ chống thấm', N'Quần trekking chống thấm, co giãn và thoải mái khi di chuyển trên các địa hình phức tạp.', 50, 4, 1),
(N'Giày trekking Nữ cao cấp', N'Giày trekking thiết kế nhẹ, chống trơn trượt, phù hợp cho các hoạt động ngoài trời.', 50, 4, 1),
(N'Túi xách du lịch Nữ thời trang cao cấp', N'Túi xách với thiết kế cao cấp, tiện lợi và thời trang.', 50, 4, 1),
(N'Túi du lịch Nữ thời trang cao cấp', N'Túi xách với thiết kế cao cấp, tiện lợi và thời trang.', 50, 4, 1),
-- Mức giá 800000-2000000
-- nam
(N'Áo khoác du lịch chống gió Nam cao cấp', N'Áo khoác cao cấp, giữ ấm tốt và chống gió, thích hợp cho người cao tuổi.', 50, 4, 1),
(N'Quần trekking Nam chất liệu cao cấp', N'Quần trekking chống nước, thoải mái và bền bỉ cho các chuyến đi dài.', 50, 4, 1),
(N'Giày trekking Nam cao cấp chính hãng', N'Giày chính hãng, hỗ trợ di chuyển trên các địa hình khó khăn.', 50, 4, 1),
(N'Áo len du lịch chống gió Nam cao cấp', N'Áo khoác cao cấp, giữ ấm tốt và chống gió, thích hợp cho người cao tuổi.', 50, 4, 1),
(N'Áo du lịch chống gió Nam cao cấp', N'Áo khoác cao cấp, giữ ấm tốt và chống gió, thích hợp cho người cao tuổi.', 50, 4, 1),
-- nữ
(N'Áo khoác giữ nhiệt Nữ', N'Áo khoác giữ nhiệt, lý tưởng cho người cao tuổi khi đi du lịch trong thời tiết lạnh.', 50, 4, 1),
(N'Giày trekking Nữ chất liệu cao cấp', N'Giày trekking với thiết kế hỗ trợ đôi chân, bền bỉ và chống trơn trượt.', 50, 4, 1),
(N'Áo du lịch Nữ chống nước', N'Áo du lịch nhẹ, chống nước, giúp bảo vệ đồ dùng cá nhân trong các chuyến đi.', 50, 4, 1),
(N'Bộ quần áo du lịch Nữ', N'Du lịch nhẹ, giúp bảo vệ đồ dùng cá nhân trong các chuyến đi.', 50, 4, 1),
(N'Túi du lịch Nữ chống nước', N'Túi du lịch nhẹ, chống nước, giúp bảo vệ đồ dùng cá nhân trong các chuyến đi.', 50, 4, 1);
-- Sản phẩm cho sở thích "Thời trang hot trend" Cao tuổi từ 60 tuổi trở lên
INSERT INTO SanPham (TenSanPham, MoTa, SoLuongDaBan, DanhMucID, KichHoat)
VALUES 
-- Mức giá 15000-400000
-- nam
(N'Áo vest trung niên phong cách', N'Phong cách lịch lãm, phù hợp cho các buổi gặp gỡ và du lịch.', 50, 5, 1),
(N'Quần dài kaki nam trung niên', N'Tạo cảm giác thoải mái, phù hợp cho mọi hoạt động hàng ngày.', 50, 5, 1),
(N'Giày da nam thời trang', N'Mang lại sự thoải mái và vẻ ngoài tinh tế trong những buổi gặp mặt.', 50, 5, 1),
(N'Áo sơ mi nam cao cấp', N'Mềm mại và thoáng mát, phù hợp cho khí hậu nhiệt đới.', 50, 5, 1),
(N'Mũ sendo nam', N'Giúp bảo vệ khỏi nắng và tạo điểm nhấn trẻ trung cho người lớn.', 50, 5, 1),
-- nữ
(N'Áo khoác mỏng nữ', N'Thiết kế gọn nhẹ, dễ phối đồ, phù hợp khi đi dạo phố.', 50, 5, 1),
(N'Quần dài nữ trung niên sang trọng', N'Mềm mại, dễ chịu, mang lại sự thoải mái tối đa.', 50, 5, 1),
(N'Giày cao gót nữ thời trang', N'Nhẹ nhàng, phù hợp cho mọi hoạt động hằng ngày.', 50, 5, 1),
(N'Áo Kháoc nữ đơn giản', N'Thời trang và tiện lợi, dễ dàng phối hợp trong các hoạt động ngoài trời.', 50, 5, 1),
(N'Mũ vành', N'Thời trang và bảo vệ tốt khi đi dưới trời nắng.', 50, 5, 1),
-- Mức giá 500000-750000
-- nam
(N'Áo somi nam trung niên cao cấp', N'Thiết kế sang trọng, phù hợp với các dịp đặc biệt.', 50, 5, 1),
(N'Quần áo thể thao nam cao cấp', N'Chất liệu bền bỉ, thích hợp cho các chuyến đi xa.', 50, 5, 1),
(N'Giày da nam cao cấp chính hãng', N'Giày dép mang lại phong cách và sự thoải mái.', 50, 5, 1),
(N'kính cho lớn tuổi nam', N'Thời trang và thanh lịch, phù hợp cho môi trường công sở.', 50, 5, 1),
(N'Mũ lưỡi trai cao cấp nam', N'Tiện dụng và thời trang, bảo vệ khỏi ánh nắng mặt trời.', 50, 5, 1),
-- nữ
(N'Áo vest nữ trung niên thanh lịch', N'Phong cách nhẹ nhàng, dễ dàng phối đồ với váy hoặc quần.', 50, 5, 1),
(N'Quần dài nữ cao cấp', N'Chất liệu cao cấp, bền đẹp và mềm mại.', 50, 5, 1),
(N'Áo nữ chính hãng', N'Đem lại phong cách quyến rũ và tự tin trong mọi bước chân.', 50, 5, 1),
(N'Áo phông nữ cao cấp', N'Vải cao cấp, tạo sự thoải mái trong các hoạt động hằng ngày.', 50, 5, 1),
(N'Mũ trùm lớn tuổi', N'Thời trang và tiện lợi, hoàn hảo cho các chuyến du lịch.', 50, 5, 1),
-- Mức giá 800000-2000000
-- nam
(N'Mũ mỏ vịt trung niên chất liệu cao cấp', N'Chất liệu bền bỉ, phong cách sang trọng cho các sự kiện.', 50, 5, 1),
(N'Kính mắt mát mẻ trung niên cao cấp', N'Thiết kế thoáng mát, giúp bạn luôn thoải mái trong các hoạt động.', 50, 5, 1),
(N'Giày tây nam cao cấp chính hãng', N'Phong cách lịch lãm, kết hợp hoàn hảo giữa sự thoải mái và thời trang.', 50, 5, 1),
(N'Quần short nam chất liệu cao cấp', N'Thích hợp cho mùa hè, tạo cảm giác thoải mái nhất.', 50, 5, 1),
(N'Mũ kaor vành nam cao cấp', N'Phong cách thời thượng và bảo vệ hiệu quả dưới nắng.', 50, 5, 1),
-- nữ
(N'Áo nhập khẩu trung quốc nữ chất liệu cao cấp', N'Chống nắng, tạo phong cách sang trọng.', 50, 5, 1),
(N'Quần dài nữ chất liệu cao cấp', N'Đem lại sự thoải mái tối đa trong mọi hoạt động.', 50, 5, 1),
(N'áo ba lỗ nữ cao cấp chính hãng', N'Thiết kế sang trọng, tạo phong cách nổi bật khi thể thao.', 50, 5, 1), 
(N'Váy nữ chất liệu cao cấp', N'Combo dạ hội.', 50, 5, 1),
(N'Mũ vải len', N'Thời trang và bảo vệ tốt nhất trong những chuyến đi.', 50, 5, 1);


-- Thêm các kích thước (Size)
-- Tắt IDENTITY_INSERT cho bảng DanhMuc nếu nó đang bật


INSERT INTO Size (SizeName) VALUES (N'S');
INSERT INTO Size (SizeName) VALUES (N'M');
INSERT INTO Size (SizeName) VALUES (N'L');



INSERT INTO Mau (MauName) VALUES (N'Trắng');
INSERT INTO Mau (MauName) VALUES (N'Đen');

-- Sản phẩm cho sở thích "Thể thao" Thanh niên từ 0 đến 37 tuổi
INSERT INTO ChiTietSanPham (SanPhamID, SizeID, MauID, Gia, SoLuongTonKho, HinhAnhUrl) 
VALUES 

-- Mức giá 15000-400000
-- Nam
(1, 1, 1, 180000, 50, N'hinh1.jpg'),
(2, 2, 2, 350000, 50, N'hinh2.jpg'),
(3, 3, 1, 200000, 50, N'hinh3.jpg'),
(4, 1, 2, 300000, 50, N'hinh4.jpg'),
(5, 2, 1, 250000, 50, N'hinh5.jpg'),

-- Nữ
(6, 3, 1, 150000, 50, N'hinh6.jpg'),
(7, 1, 2, 170000, 50, N'hinh7.jpg'),
(8, 2, 1, 190000, 50, N'hinh8.jpg'),
(9, 3, 2, 220000, 50, N'hinh9.jpg'),
(10, 1, 1, 260000, 50, N'hinh10.jpg'),

-- Mức giá 500000-750000
-- Nam
(11, 2, 2, 520000, 50, N'hinh11.jpg'),
(12, 3, 1, 600000, 50, N'hinh12.jpg'),
(13, 1, 2, 730000, 50, N'hinh13.jpg'),
(14, 2, 1, 650000, 50, N'hinh14.jpg'),
(15, 3, 2, 590000, 50, N'hinh15.jpg'),

-- Nữ
(16, 1, 1, 560000, 50, N'hinh16.jpg'),
(17, 2, 2, 700000, 50, N'hinh17.jpg'),
(18, 3, 1, 680000, 50, N'hinh18.jpg'),
(19, 1, 2, 750000, 50, N'hinh19.jpg'),
(20, 2, 1, 640000, 50, N'hinh20.jpg'),

-- Mức giá 800000-2000000
-- Nam
(21, 3, 2, 900000, 50, N'hinh21.jpg'),
(22, 1, 1, 1200000, 50, N'hinh22.jpg'),
(23, 2, 2, 1800000, 50, N'hinh23.jpg'),
(24, 3, 1, 2000000, 50, N'hinh24.jpg'),
(25, 1, 2, 1500000, 50, N'hinh25.jpg'),

-- Nữ
(26, 2, 1, 950000, 50, N'hinh26.jpg'),
(27, 3, 2, 1250000, 50, N'hinh27.jpg'),
(28, 1, 1, 1400000, 50, N'hinh28.jpg'),
(29, 2, 2, 1600000, 50, N'hinh29.jpg'),
(30, 3, 1, 1800000, 50, N'hinh30.jpg');
--Dữ liệu cho sở thích "Công sở, lịch sự" Thanh niên từ 0 đến 37 tuổi
INSERT INTO ChiTietSanPham (SanPhamID, SizeID, MauID, Gia, SoLuongTonKho, HinhAnhUrl) 
VALUES 

-- Mức giá 15000-400000
-- Nam
(31, 1, 1, 150000, 50, N'hinh31.jpg'),
(32, 2, 2, 200000, 50, N'hinh32.jpg'),
(33, 3, 1, 180000, 50, N'hinh33.jpg'),
(34, 1, 2, 300000, 50, N'hinh34.jpg'),
(35, 2, 1, 350000, 50, N'hinh35.jpg'),

-- Nữ
(36, 3, 2, 270000, 50, N'hinh36.jpg'),
(37, 1, 1, 330000, 50, N'hinh37.jpg'),
(38, 2, 2, 290000, 50, N'hinh38.jpg'),
(39, 3, 1, 340000, 50, N'hinh39.jpg'),
(40, 1, 2, 250000, 50, N'hinh40.jpg'),

-- Mức giá 500000-750000
-- Nam
(41, 2, 1, 500000, 50, N'hinh41.jpg'),
(42, 3, 2, 620000, 50, N'hinh42.jpg'),
(43, 1, 1, 700000, 50, N'hinh43.jpg'),
(44, 2, 2, 680000, 50, N'hinh44.jpg'),
(45, 3, 1, 650000, 50, N'hinh45.jpg'),

-- Nữ
(46, 1, 2, 580000, 50, N'hinh46.jpg'),
(47, 2, 1, 720000, 50, N'hinh47.jpg'),
(48, 3, 2, 750000, 50, N'hinh48.jpg'),
(49, 1, 1, 700000, 50, N'hinh49.jpg'),
(50, 2, 2, 690000, 50, N'hinh50.jpg'),

-- Mức giá 800000-2000000
-- Nam
(51, 3, 1, 800000, 50, N'hinh51.jpg'),
(52, 1, 2, 950000, 50, N'hinh52.jpg'),
(53, 2, 1, 1500000, 50, N'hinh53.jpg'),
(54, 3, 2, 1900000, 50, N'hinh54.jpg'),
(55, 1, 1, 2000000, 50, N'hinh55.jpg'),

-- Nữ
(56, 2, 2, 1200000, 50, N'hinh56.jpg'),
(57, 3, 1, 1800000, 50, N'hinh57.jpg'),
(58, 1, 2, 1300000, 50, N'hinh58.jpg'),
(59, 2, 1, 1700000, 50, N'hinh59.jpg'),
(60, 3, 2, 1500000, 50, N'hinh60.jpg');
-- Sản phẩm cho sở thích "Đơn giản, thường ngày" Thanh niên từ 0 đến 37 tuổi
INSERT INTO ChiTietSanPham (SanPhamID, SizeID, MauID, Gia, SoLuongTonKho, HinhAnhUrl) 
VALUES 
-- Mức giá 15000-400000
--nam
(61, 1, 1, 125000, 50, N'hinh61.jpg'),
(62, 2, 2, 220000, 40, N'hinh62.jpg'),
(63, 3, 1, 350000, 30, N'hinh63.jpg'),
(64, 1, 1, 180000, 45, N'hinh64.jpg'),
(65, 2, 2, 320000, 55, N'hinh65.jpg'),

--Nữ
(66, 3, 2, 170000, 35, N'hinh66.jpg'),
(67, 1, 1, 250000, 60, N'hinh67.jpg'),
(68, 2, 1, 145000, 50, N'hinh68.jpg'),
(69, 3, 2, 300000, 40, N'hinh69.jpg'),
(70, 1, 1, 275000, 45, N'hinh70.jpg'),

-- Mức giá 500000-750000
--nam
(71, 2, 1, 550000, 60, N'hinh71.jpg'),
(72, 1, 2, 650000, 30, N'hinh72.jpg'),
(73, 3, 1, 700000, 55, N'hinh73.jpg'),
(74, 2, 2, 500000, 50, N'hinh74.jpg'),
(75, 1, 1, 720000, 40, N'hinh75.jpg'),

--nữ
(76, 3, 2, 680000, 45, N'hinh76.jpg'),
(77, 2, 1, 700000, 35, N'hinh77.jpg'),
(78, 1, 2, 650000, 60, N'hinh78.jpg'),
(79, 2, 1, 580000, 50, N'hinh79.jpg'),
(80, 3, 2, 500000, 55, N'hinh80.jpg'),

-- Mức giá 800000-2000000
--Nam
(81, 1, 2, 1200000, 50, N'hinh81.jpg'),
(82, 2, 1, 950000, 45, N'hinh82.jpg'),
(83, 3, 2, 1600000, 35, N'hinh83.jpg'),
(84, 1, 1, 1800000, 55, N'hinh84.jpg'),
(85, 2, 2, 1400000, 40, N'hinh85.jpg'),

--Nữ
(86, 3, 1, 2000000, 60, N'hinh86.jpg'),
(87, 1, 2, 1750000, 50, N'hinh87.jpg'),
(88, 2, 1, 850000, 30, N'hinh88.jpg'),
(89, 3, 2, 900000, 55, N'hinh89.jpg'),
(90, 1, 1, 1500000, 45, N'hinh90.jpg');
-- Sản phẩm cho sở thích "Thời trang du lịch" Thanh niên từ 0 đến 37 tuổi
INSERT INTO ChiTietSanPham (SanPhamID, SizeID, MauID, Gia, SoLuongTonKho, HinhAnhUrl) 
VALUES 

-- Mức giá 150000-400000
-- Nam
(91, 2, 1, 150000, 50, N'hinh91.jpg'),
(92, 1, 1, 200000, 50, N'hinh92.jpg'),
(93, 3, 1, 180000, 50, N'hinh93.jpg'),
(94, 2, 1, 350000, 50, N'hinh94.jpg'),
(95, 1, 1, 300000, 50, N'hinh95.jpg'),
-- Nữ
(96, 3, 2, 200000, 50, N'hinh96.jpg'),
(97, 2, 2, 180000, 50, N'hinh97.jpg'),
(98, 1, 2, 220000, 50, N'hinh98.jpg'),
(99, 3, 2, 350000, 50, N'hinh99.jpg'),
(100, 1, 2, 300000, 50, N'hinh100.jpg'),

-- Mức giá 500000-750000
-- Nam
(101, 1, 1, 550000, 50, N'hinh101.jpg'),
(102, 2, 1, 600000, 50, N'hinh102.jpg'),
(103, 3, 1, 700000, 50, N'hinh103.jpg'),
(104, 1, 1, 750000, 50, N'hinh104.jpg'),
(105, 2, 1, 500000, 50, N'hinh105.jpg'),
-- Nữ
(106, 3, 2, 650000, 50, N'hinh106.jpg'),
(107, 2, 2, 700000, 50, N'hinh107.jpg'),
(108, 1, 2, 750000, 50, N'hinh108.jpg'),
(109, 3, 2, 500000, 50, N'hinh109.jpg'),
(110, 2, 2, 600000, 50, N'hinh110.jpg'),

-- Mức giá 800000-2000000
-- Nam
(111, 1, 1, 1500000, 50, N'hinh111.jpg'),
(112, 3, 1, 1800000, 50, N'hinh112.jpg'),
(113, 2, 1, 1500000, 50, N'hinh113.jpg'),
(114, 1, 1, 1200000, 50, N'hinh114.jpg'),
(115, 2, 1, 2000000, 50, N'hinh115.jpg'),
-- Nữ
(116, 1, 2, 1600000, 50, N'hinh116.jpg'),
(117, 3, 2, 1800000, 50, N'hinh117.jpg'),
(118, 2, 2, 2000000, 50, N'hinh118.jpg'),
(119, 1, 2, 1500000, 50, N'hinh119.jpg'),
(120, 2, 2, 1200000, 50, N'hinh120.jpg');
-- Sản phẩm cho sở thích "Thời trang hot trend" Thanh niên từ 0 đến 37 tuổi
INSERT INTO ChiTietSanPham (SanPhamID, SizeID, MauID, Gia, SoLuongTonKho, HinhAnhUrl) 
VALUES 

-- Mức giá 150000-400000
-- Nam
(121, 2, 1, 150000, 50, N'hinh121.jpg'),
(122, 3, 1, 200000, 50, N'hinh122.jpg'),
(123, 1, 1, 180000, 50, N'hinh123.jpg'),
(124, 2, 1, 350000, 50, N'hinh124.jpg'),
(125, 1, 1, 300000, 50, N'hinh125.jpg'),
-- Nữ
(126, 3, 2, 250000, 50, N'hinh126.jpg'),
(127, 2, 2, 220000, 50, N'hinh127.jpg'),
(128, 1, 2, 350000, 50, N'hinh128.jpg'),
(129, 3, 2, 300000, 50, N'hinh129.jpg'),
(130, 2, 2, 280000, 50, N'hinh130.jpg'),

-- Mức giá 500000-750000
-- Nam
(131, 2, 1, 650000, 50, N'hinh131.jpg'),
(132, 1, 1, 700000, 50, N'hinh132.jpg'),
(133, 3, 1, 750000, 50, N'hinh133.jpg'),
(134, 1, 1, 600000, 50, N'hinh134.jpg'),
(135, 3, 1, 500000, 50, N'hinh135.jpg'),
-- Nữ
(136, 2, 2, 600000, 50, N'hinh136.jpg'),
(137, 3, 2, 750000, 50, N'hinh137.jpg'),
(138, 1, 2, 650000, 50, N'hinh138.jpg'),
(139, 2, 2, 500000, 50, N'hinh139.jpg'),
(140, 3, 2, 700000, 50, N'hinh140.jpg'),

-- Mức giá 800000-2000000
-- Nam
(141, 2, 1, 1500000, 50, N'hinh141.jpg'),
(142, 1, 1, 1800000, 50, N'hinh142.jpg'),
(143, 3, 1, 2000000, 50, N'hinh143.jpg'),
(144, 2, 1, 1200000, 50, N'hinh144.jpg'),
(145, 1, 1, 1800000, 50, N'hinh145.jpg'),
-- Nữ
(146, 3, 2, 1600000, 50, N'hinh146.jpg'),
(147, 1, 2, 1800000, 50, N'hinh147.jpg'),
(148, 2, 2, 2000000, 50, N'hinh148.jpg'),
(149, 3, 2, 1500000, 50, N'hinh149.jpg'),
(150, 2, 2, 1200000, 50, N'hinh150.jpg');



-- Sản phẩm cho sở thích "Thể thao" Trung niên từ 38 đến 60 tuổi
INSERT INTO ChiTietSanPham (SanPhamID, SizeID, MauID, Gia, SoLuongTonKho, HinhAnhUrl) 
VALUES 
-- Mức giá 150000 - 400000
-- Nam
(151, 1, 1, 150000, 50, N'hinh151.jpg'),
(152, 3, 1, 220000, 50, N'hinh152.jpg'),
(153, 2, 1, 180000, 50, N'hinh153.jpg'),
(154, 1, 1, 350000, 50, N'hinh154.jpg'),
(155, 3, 1, 300000, 50, N'hinh155.jpg'),
-- Nữ
(156, 2, 2, 250000, 50, N'hinh156.jpg'),
(157, 3, 2, 200000, 50, N'hinh157.jpg'),
(158, 1, 2, 350000, 50, N'hinh158.jpg'),
(159, 2, 2, 300000, 50, N'hinh159.jpg'),
(160, 1, 2, 280000, 50, N'hinh160.jpg'),

-- Mức giá 500000 - 750000
-- Nam
(161, 3, 1, 650000, 50, N'hinh161.jpg'),
(162, 2, 1, 700000, 50, N'hinh162.jpg'),
(163, 1, 1, 750000, 50, N'hinh163.jpg'),
(164, 2, 1, 600000, 50, N'hinh164.jpg'),
(165, 3, 1, 550000, 50, N'hinh165.jpg'),
-- Nữ
(166, 2, 2, 500000, 50, N'hinh166.jpg'),
(167, 1, 2, 600000, 50, N'hinh167.jpg'),
(168, 3, 2, 700000, 50, N'hinh168.jpg'),
(169, 2, 2, 650000, 50, N'hinh169.jpg'),
(170, 1, 2, 720000, 50, N'hinh170.jpg'),

-- Mức giá 800000 - 2000000
-- Nam
(171, 2, 1, 1500000, 50, N'hinh171.jpg'),
(172, 3, 1, 1800000, 50, N'hinh172.jpg'),
(173, 1, 1, 2000000, 50, N'hinh173.jpg'),
(174, 2, 1, 1200000, 50, N'hinh174.jpg'),
(175, 3, 1, 1700000, 50, N'hinh175.jpg'),
-- Nữ
(176, 1, 2, 1600000, 50, N'hinh176.jpg'),
(177, 2, 2, 1800000, 50, N'hinh177.jpg'),
(178, 3, 2, 2000000, 50, N'hinh178.jpg'),
(179, 2, 2, 1200000, 50, N'hinh179.jpg'),
(180, 1, 2, 1400000, 50, N'hinh180.jpg');
-- Sản phẩm cho sở thích "Công sở, lịch sự" Trung niên từ 38 đến 60 tuổi
INSERT INTO ChiTietSanPham (SanPhamID, SizeID, MauID, Gia, SoLuongTonKho, HinhAnhUrl) 
VALUES
-- Sản phẩm cho sở thích "Công sở, lịch sự" Trung niên từ 38 đến 60 tuổi
-- Mức giá 150000 - 400000
-- Nam
(181, 1, 1, 150000, 50, N'hinh181.jpg'),
(182, 2, 1, 180000, 50, N'hinh182.jpg'),
(183, 3, 1, 220000, 50, N'hinh183.jpg'),
(184, 1, 1, 300000, 50, N'hinh184.jpg'),
(185, 3, 1, 350000, 50, N'hinh185.jpg'),
-- Nữ
(186, 2, 2, 200000, 50, N'hinh186.jpg'),
(187, 1, 2, 250000, 50, N'hinh187.jpg'),
(188, 3, 2, 320000, 50, N'hinh188.jpg'),
(189, 2, 2, 280000, 50, N'hinh189.jpg'),
(190, 1, 2, 350000, 50, N'hinh190.jpg'),

-- Mức giá 500000 - 750000
-- Nam
(191, 1, 1, 550000, 50, N'hinh191.jpg'),
(192, 2, 1, 600000, 50, N'hinh192.jpg'),
(193, 3, 1, 700000, 50, N'hinh193.jpg'),
(194, 2, 1, 750000, 50, N'hinh194.jpg'),
(195, 3, 1, 680000, 50, N'hinh195.jpg'),
-- Nữ
(196, 1, 2, 520000, 50, N'hinh196.jpg'),
(197, 2, 2, 600000, 50, N'hinh197.jpg'),
(198, 3, 2, 680000, 50, N'hinh198.jpg'),
(199, 1, 2, 700000, 50, N'hinh199.jpg'),
(200, 2, 2, 740000, 50, N'hinh200.jpg'),

-- Mức giá 800000 - 2000000
-- Nam
(201, 1, 1, 1000000, 50, N'hinh201.jpg'),
(202, 2, 1, 1300000, 50, N'hinh202.jpg'),
(203, 3, 1, 1500000, 50, N'hinh203.jpg'),
(204, 1, 1, 1800000, 50, N'hinh204.jpg'),
(205, 2, 1, 1700000, 50, N'hinh205.jpg'),
-- Nữ
(206, 3, 2, 1200000, 50, N'hinh206.jpg'),
(207, 1, 2, 1500000, 50, N'hinh207.jpg'),
(208, 2, 2, 1600000, 50, N'hinh208.jpg'),
(209, 3, 2, 1800000, 50, N'hinh209.jpg'),
(210, 1, 2, 1400000, 50, N'hinh210.jpg');
-- Sản phẩm cho sở thích "Đơn giản, thường ngày" Trung niên từ 38 đến 60 tuổi
INSERT INTO ChiTietSanPham (SanPhamID, SizeID, MauID, Gia, SoLuongTonKho, HinhAnhUrl) 
VALUES 
-- Mức giá 150000-400000
--Nam
(211, 1, 1, 180000, 50, N'hinh211.jpg'),
(212, 2, 1, 200000, 50, N'hinh212.jpg'),
(213, 3, 1, 220000, 50, N'hinh213.jpg'),
(214, 1, 1, 270000, 50, N'hinh214.jpg'),
(215, 2, 1, 350000, 50, N'hinh215.jpg'),
--Nữ
(216, 1, 2, 190000, 50, N'hinh216.jpg'),
(217, 2, 2, 230000, 50, N'hinh217.jpg'),
(218, 3, 2, 250000, 50, N'hinh218.jpg'),
(219, 1, 2, 300000, 50, N'hinh219.jpg'),
(220, 2, 2, 350000, 50, N'hinh220.jpg'),

-- Mức giá 500000-750000
--Nam
(221, 3, 1, 550000, 50, N'hinh221.jpg'),
(222, 1, 1, 600000, 50, N'hinh222.jpg'),
(223, 2, 1, 700000, 50, N'hinh223.jpg'),
(224, 3, 1, 750000, 50, N'hinh224.jpg'),
(225, 1, 1, 720000, 50, N'hinh225.jpg'),
--Nữ
(226, 2, 2, 600000, 50, N'hinh226.jpg'),
(227, 3, 2, 680000, 50, N'hinh227.jpg'),
(228, 1, 2, 700000, 50, N'hinh228.jpg'),
(229, 2, 2, 750000, 50, N'hinh229.jpg'),
(230, 3, 2, 740000, 50, N'hinh230.jpg'),

-- Mức giá 800000-2000000
--Nam
(231, 1, 1, 1000000, 50, N'hinh231.jpg'),
(232, 2, 1, 1300000, 50, N'hinh232.jpg'),
(233, 3, 1, 1500000, 50, N'hinh233.jpg'),
(234, 1, 1, 1700000, 50, N'hinh234.jpg'),
(235, 2, 1, 1800000, 50, N'hinh235.jpg'),
--Nữ
(236, 3, 2, 900000, 50, N'hinh236.jpg'),
(237, 1, 2, 1200000, 50, N'hinh237.jpg'),
(238, 2, 2, 1500000, 50, N'hinh238.jpg'),
(239, 3, 2, 1600000, 50, N'hinh239.jpg'),
(240, 1, 2, 1800000, 50, N'hinh240.jpg');
-- Sản phẩm cho sở thích "Thời trang du lịch" Trung niên từ 38 đến 60 tuổi
INSERT INTO ChiTietSanPham (SanPhamID, SizeID, MauID, Gia, SoLuongTonKho, HinhAnhUrl) 
VALUES 
-- Mức giá 150000-400000
--Nam
(241, 2, 1, 150000, 50, N'hinh241.jpg'),
(242, 3, 1, 180000, 50, N'hinh242.jpg'),
(243, 1, 1, 220000, 50, N'hinh243.jpg'),
(244, 2, 1, 250000, 50, N'hinh244.jpg'),
(245, 3, 1, 300000, 50, N'hinh245.jpg'),
--Nữ
(246, 1, 2, 170000, 50, N'hinh246.jpg'),
(247, 2, 2, 200000, 50, N'hinh247.jpg'),
(248, 3, 2, 220000, 50, N'hinh248.jpg'),
(249, 1, 2, 280000, 50, N'hinh249.jpg'),
(250, 2, 2, 320000, 50, N'hinh250.jpg'),

-- Mức giá 500000-750000
--Nam
(251, 3, 1, 550000, 50, N'hinh251.jpg'),
(252, 1, 1, 600000, 50, N'hinh252.jpg'),
(253, 2, 1, 700000, 50, N'hinh253.jpg'),
(254, 3, 1, 750000, 50, N'hinh254.jpg'),
(255, 1, 1, 720000, 50, N'hinh255.jpg'),
--Nữ
(256, 2, 2, 520000, 50, N'hinh256.jpg'),
(257, 3, 2, 600000, 50, N'hinh257.jpg'),
(258, 1, 2, 680000, 50, N'hinh258.jpg'),
(259, 2, 2, 720000, 50, N'hinh259.jpg'),
(260, 3, 2, 740000, 50, N'hinh260.jpg'),

-- Mức giá 800000-2000000
--Nam
(261, 1, 1, 1000000, 50, N'hinh261.jpg'),
(262, 2, 1, 1300000, 50, N'hinh262.jpg'),
(263, 3, 1, 1500000, 50, N'hinh263.jpg'),
(264, 1, 1, 1700000, 50, N'hinh264.jpg'),
(265, 2, 1, 1800000, 50, N'hinh265.jpg'),
--Nữ
(266, 3, 2, 900000, 50, N'hinh266.jpg'),
(267, 1, 2, 1200000, 50, N'hinh267.jpg'),
(268, 2, 2, 1500000, 50, N'hinh268.jpg'),
(269, 3, 2, 1600000, 50, N'hinh269.jpg'),
(270, 1, 2, 1800000, 50, N'hinh270.jpg');
-- Sản phẩm cho sở thích "Thời trang hot trend" Trung niên từ 38 đến 60 tuổi
INSERT INTO ChiTietSanPham (SanPhamID, SizeID, MauID, Gia, SoLuongTonKho, HinhAnhUrl) 
VALUES 
-- Mức giá 15,000 - 400,000
--Nam
(271, 1, 1, 150000, 50, N'hinh271.jpg'),
(272, 3, 1, 350000, 50, N'hinh272.jpg'),
(273, 2, 1, 300000, 50, N'hinh273.jpg'),
(274, 1, 1, 200000, 50, N'hinh274.jpg'),
(275, 2, 1, 250000, 50, N'hinh275.jpg'),
--Nữ
(276, 3, 2, 180000, 50, N'hinh276.jpg'),
(277, 1, 2, 350000, 50, N'hinh277.jpg'),
(278, 2, 2, 300000, 50, N'hinh278.jpg'),
(279, 1, 2, 220000, 50, N'hinh279.jpg'),
(280, 3, 2, 280000, 50, N'hinh280.jpg'),

-- Mức giá 500,000 - 750,000
--Nam
(281, 2, 1, 650000, 50, N'hinh281.jpg'),
(282, 3, 1, 700000, 50, N'hinh282.jpg'),
(283, 1, 1, 600000, 50, N'hinh283.jpg'),
(284, 2, 1, 550000, 50, N'hinh284.jpg'),
(285, 3, 1, 720000, 50, N'hinh285.jpg'),
--Nữ
(286, 1, 2, 620000, 50, N'hinh286.jpg'),
(287, 2, 2, 740000, 50, N'hinh287.jpg'),
(288, 3, 2, 680000, 50, N'hinh288.jpg'),
(289, 1, 2, 580000, 50, N'hinh289.jpg'),
(290, 2, 2, 710000, 50, N'hinh290.jpg'),

-- Mức giá 800,000 - 2,000,000
--Nam
(291, 3, 1, 1200000, 50, N'hinh291.jpg'),
(292, 1, 1, 1400000, 50, N'hinh292.jpg'),
(293, 2, 1, 1300000, 50, N'hinh293.jpg'),
(294, 3, 1, 1800000, 50, N'hinh294.jpg'),
(295, 1, 1, 2000000, 50, N'hinh295.jpg'),
--Nữ
(296, 2, 2, 1100000, 50, N'hinh296.jpg'),
(297, 3, 2, 1400000, 50, N'hinh297.jpg'),
(298, 1, 2, 1600000, 50, N'hinh298.jpg'),
(299, 2, 2, 1800000, 50, N'hinh299.jpg'),
(300, 3, 2, 2000000, 50, N'hinh300.jpg');




-- Sản phẩm cho sở thích "Thể thao" Cao tuổi từ 60 tuổi trở lên
INSERT INTO ChiTietSanPham (SanPhamID, SizeID, MauID, Gia, SoLuongTonKho, HinhAnhUrl) 
VALUES 

-- Mức giá 15000-400000
-- Nam
(301, 1, 1, 350000, 50, N'hinh301.jpg'),
(302, 2, 1, 300000, 50, N'hinh302.jpg'),
(303, 3, 1, 150000, 50, N'hinh303.jpg'),
(304, 1, 1, 200000, 50, N'hinh304.jpg'),
(305, 2, 1, 250000, 50, N'hinh305.jpg'),

-- Nữ
(306, 3, 2, 180000, 50, N'hinh306.jpg'),
(307, 1, 2, 280000, 50, N'hinh307.jpg'),
(308, 2, 2, 350000, 50, N'hinh308.jpg'),
(309, 3, 2, 220000, 50, N'hinh309.jpg'),
(310, 1, 2, 150000, 50, N'hinh310.jpg'),

-- Mức giá 500000-750000
-- Nam
(311, 3, 1, 620000, 50, N'hinh311.jpg'),
(312, 1, 1, 670000, 50, N'hinh312.jpg'),
(313, 2, 1, 550000, 50, N'hinh313.jpg'),
(314, 3, 1, 720000, 50, N'hinh314.jpg'),
(315, 1, 1, 700000, 50, N'hinh315.jpg'),

-- Nữ
(316, 2, 2, 600000, 50, N'hinh316.jpg'),
(317, 3, 2, 740000, 50, N'hinh317.jpg'),
(318, 1, 2, 650000, 50, N'hinh318.jpg'),
(319, 2, 2, 680000, 50, N'hinh319.jpg'),
(320, 3, 2, 720000, 50, N'hinh320.jpg'),

-- Mức giá 800000-2000000
-- Nam
(321, 1, 1, 1300000, 50, N'hinh321.jpg'),
(322, 2, 1, 1400000, 50, N'hinh322.jpg'),
(323, 3, 1, 1200000, 50, N'hinh323.jpg'),
(324, 1, 1, 1800000, 50, N'hinh324.jpg'),
(325, 2, 1, 2000000, 50, N'hinh325.jpg'),

-- Nữ
(326, 3, 2, 1500000, 50, N'hinh326.jpg'),
(327, 1, 2, 1700000, 50, N'hinh327.jpg'),
(328, 2, 2, 1600000, 50, N'hinh328.jpg'),
(329, 3, 2, 1800000, 50, N'hinh329.jpg'),
(330, 1, 2, 2000000, 50, N'hinh330.jpg');
-- Sản phẩm cho sở thích "Công sở, lịch sự" Trung niên từ 60 tuổi trở lên
INSERT INTO ChiTietSanPham (SanPhamID, SizeID, MauID, Gia, SoLuongTonKho, HinhAnhUrl) 
VALUES 

-- Mức giá 15000-400000
-- nam
(331, 1, 1, 350000, 50, N'hinh331.jpg'),
(332, 2, 1, 250000, 50, N'hinh332.jpg'),
(333, 3, 1, 150000, 50, N'hinh333.jpg'),
(334, 1, 1, 220000, 50, N'hinh334.jpg'),
(335, 2, 1, 180000, 50, N'hinh335.jpg'),

-- Nữ
(336, 3, 2, 170000, 50, N'hinh336.jpg'),
(337, 1, 2, 250000, 50, N'hinh337.jpg'),
(338, 2, 2, 300000, 50, N'hinh338.jpg'),
(339, 3, 2, 150000, 50, N'hinh339.jpg'),
(340, 1, 2, 200000, 50, N'hinh340.jpg'),

-- Mức giá 500000-750000
-- nam
(341, 3, 1, 600000, 50, N'hinh341.jpg'),
(342, 1, 1, 550000, 50, N'hinh342.jpg'),
(343, 2, 1, 670000, 50, N'hinh343.jpg'),
(344, 3, 1, 710000, 50, N'hinh344.jpg'),
(345, 1, 1, 680000, 50, N'hinh345.jpg'),

-- Nữ
(346, 2, 2, 740000, 50, N'hinh346.jpg'),
(347, 3, 2, 620000, 50, N'hinh347.jpg'),
(348, 1, 2, 650000, 50, N'hinh348.jpg'),
(349, 2, 2, 550000, 50, N'hinh349.jpg'),
(350, 3, 2, 720000, 50, N'hinh350.jpg'),

-- Mức giá 800000-2000000
-- Nam
(351, 1, 1, 1200000, 50, N'hinh351.jpg'),
(352, 2, 1, 1500000, 50, N'hinh352.jpg'),
(353, 3, 1, 1400000, 50, N'hinh353.jpg'),
(354, 1, 1, 1800000, 50, N'hinh354.jpg'),
(355, 2, 1, 2000000, 50, N'hinh355.jpg'),

-- Nữ
(356, 2, 2, 1600000, 50, N'hinh356.jpg'),
(357, 3, 2, 1800000, 50, N'hinh357.jpg'),
(358, 1, 2, 1700000, 50, N'hinh358.jpg'),
(359, 2, 2, 1500000, 50, N'hinh359.jpg'),
(360, 3, 2, 2000000, 50, N'hinh360.jpg');
-- Sản phẩm cho sở thích "Đơn giản, thường ngày" Thanh niên từ 0 đến 37 tuổi
INSERT INTO ChiTietSanPham (SanPhamID, SizeID, MauID, Gia, SoLuongTonKho, HinhAnhUrl) 
VALUES 

-- Mức giá 15000-400000
-- Nam
(361, 2, 1, 250000, 50, N'hinh361.jpg'),
(362, 1, 1, 300000, 50, N'hinh362.jpg'),
(363, 3, 1, 180000, 50, N'hinh363.jpg'),
(364, 1, 2, 350000, 50, N'hinh364.jpg'),
(365, 2, 2, 250000, 50, N'hinh365.jpg'),

-- Nữ
(366, 3, 1, 200000, 50, N'hinh366.jpg'),
(367, 1, 1, 150000, 50, N'hinh367.jpg'),
(368, 2, 2, 350000, 50, N'hinh368.jpg'),
(369, 3, 2, 300000, 50, N'hinh369.jpg'),
(370, 1, 2, 250000, 50, N'hinh370.jpg'),

-- Mức giá 500000-750000
-- Nam
(371, 2, 1, 650000, 50, N'hinh371.jpg'),
(372, 1, 2, 700000, 50, N'hinh372.jpg'),
(373, 3, 1, 550000, 50, N'hinh373.jpg'),
(374, 2, 1, 750000, 50, N'hinh374.jpg'),
(375, 1, 2, 600000, 50, N'hinh375.jpg'),

-- Nữ
(376, 1, 2, 600000, 50, N'hinh376.jpg'),
(377, 2, 1, 700000, 50, N'hinh377.jpg'),
(378, 3, 1, 650000, 50, N'hinh378.jpg'),
(379, 2, 2, 550000, 50, N'hinh379.jpg'),
(380, 1, 1, 750000, 50, N'hinh380.jpg'),

-- Mức giá 800000-2000000
-- Nam
(381, 1, 1, 1500000, 50, N'hinh381.jpg'),
(382, 2, 2, 1800000, 50, N'hinh382.jpg'),
(383, 3, 1, 1200000, 50, N'hinh383.jpg'),
(384, 1, 2, 2000000, 50, N'hinh384.jpg'),
(385, 2, 1, 1300000, 50, N'hinh385.jpg'),

-- Nữ
(386, 3, 2, 1500000, 50, N'hinh386.jpg'),
(387, 1, 1, 1700000, 50, N'hinh387.jpg'),
(388, 2, 2, 1800000, 50, N'hinh388.jpg'),
(389, 3, 1, 1600000, 50, N'hinh389.jpg'),
(390, 1, 1, 1900000, 50, N'hinh390.jpg');
-- Sản phẩm cho sở thích "Thời trang du lịch" Cao tuổi từ 60 tuổi trở lên
INSERT INTO ChiTietSanPham (SanPhamID, SizeID, MauID, Gia, SoLuongTonKho, HinhAnhUrl) 
VALUES 

-- Mức giá 15000-400000
-- Nam
(391, 2, 1, 350000, 50, N'hinh391.jpg'),
(392, 1, 2, 300000, 50, N'hinh392.jpg'),
(393, 3, 1, 250000, 50, N'hinh393.jpg'),
(394, 2, 1, 400000, 50, N'hinh394.jpg'),
(395, 1, 2, 300000, 50, N'hinh395.jpg'),
-- Nữ
(396, 3, 1, 150000, 50, N'hinh396.jpg'),
(397, 1, 2, 350000, 50, N'hinh397.jpg'),
(398, 2, 1, 250000, 50, N'hinh398.jpg'),
(399, 1, 2, 200000, 50, N'hinh399.jpg'),
(400, 3, 1, 300000, 50, N'hinh400.jpg'),

-- Mức giá 500000-750000
-- Nam
(401, 1, 2, 700000, 50, N'hinh401.jpg'),
(402, 2, 1, 650000, 50, N'hinh402.jpg'),
(403, 3, 1, 550000, 50, N'hinh403.jpg'),
(404, 2, 1, 750000, 50, N'hinh404.jpg'),
(405, 1, 2, 600000, 50, N'hinh405.jpg'),
-- Nữ
(406, 3, 1, 650000, 50, N'hinh406.jpg'),
(407, 1, 2, 600000, 50, N'hinh407.jpg'),
(408, 2, 1, 700000, 50, N'hinh408.jpg'),
(409, 3, 1, 750000, 50, N'hinh409.jpg'),
(410, 1, 2, 650000, 50, N'hinh410.jpg'),

-- Mức giá 800000-2000000
-- Nam
(411, 2, 1, 1800000, 50, N'hinh411.jpg'),
(412, 1, 2, 2000000, 50, N'hinh412.jpg'),
(413, 3, 1, 1600000, 50, N'hinh413.jpg'),
(414, 2, 1, 1500000, 50, N'hinh414.jpg'),
(415, 1, 2, 1700000, 50, N'hinh415.jpg'),
-- Nữ
(416, 3, 1, 1800000, 50, N'hinh416.jpg'),
(417, 1, 2, 1600000, 50, N'hinh417.jpg'),
(418, 2, 1, 1500000, 50, N'hinh418.jpg'),
(419, 3, 1, 2000000, 50, N'hinh419.jpg'),
(420, 1, 2, 1900000, 50, N'hinh420.jpg');
-- Sản phẩm cho sở thích "Thời trang hot trend" Cao tuổi từ 60 tuổi trở lên
INSERT INTO ChiTietSanPham (SanPhamID, SizeID, MauID, Gia, SoLuongTonKho, HinhAnhUrl) 
VALUES 

-- Mức giá 15000-400000
-- Nam
(421, 3, 1, 350000, 50, N'hinh421.jpg'),
(422, 2, 2, 300000, 50, N'hinh422.jpg'),
(423, 1, 1, 250000, 50, N'hinh423.jpg'),
(424, 2, 1, 400000, 50, N'hinh424.jpg'),
(425, 3, 1, 350000, 50, N'hinh425.jpg'),
-- Nữ
(426, 1, 2, 300000, 50, N'hinh426.jpg'),
(427, 2, 1, 250000, 50, N'hinh427.jpg'),
(428, 3, 2, 350000, 50, N'hinh428.jpg'),
(429, 1, 2, 300000, 50, N'hinh429.jpg'),
(430, 2, 1, 250000, 50, N'hinh430.jpg'),

-- Mức giá 500000-750000
-- Nam
(431, 2, 1, 650000, 50, N'hinh431.jpg'),
(432, 3, 2, 700000, 50, N'hinh432.jpg'),
(433, 1, 2, 750000, 50, N'hinh433.jpg'),
(434, 2, 1, 600000, 50, N'hinh434.jpg'),
(435, 3, 1, 650000, 50, N'hinh435.jpg'),
-- Nữ
(436, 1, 2, 700000, 50, N'hinh436.jpg'),
(437, 3, 1, 650000, 50, N'hinh437.jpg'),
(438, 2, 2, 550000, 50, N'hinh438.jpg'),
(439, 1, 1, 750000, 50, N'hinh439.jpg'),
(440, 3, 1, 650000, 50, N'hinh440.jpg'),

-- Mức giá 800000-2000000
-- Nam
(441, 1, 1, 1500000, 50, N'hinh441.jpg'),
(442, 3, 2, 1800000, 50, N'hinh442.jpg'),
(443, 2, 1, 1600000, 50, N'hinh443.jpg'),
(444, 1, 2, 2000000, 50, N'hinh444.jpg'),
(445, 3, 1, 1700000, 50, N'hinh445.jpg'),
-- Nữ
(446, 1, 1, 1500000, 50, N'hinh446.jpg'),
(447, 3, 2, 2000000, 50, N'hinh447.jpg'),
(448, 2, 1, 1700000, 50, N'hinh448.jpg'),
(449, 1, 2, 1800000, 50, N'hinh449.jpg'),
(450, 3, 1, 1600000, 50, N'hinh450.jpg');

