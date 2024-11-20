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

-- Thêm dữ liệu vào bảng DanhMuc cho các danh mục quần áo
INSERT INTO DanhMuc (TenDanhMuc) VALUES 
(N'Áo thun'),
(N'Quần jean'),
(N'Áo khoác'),
(N'Váy'),
(N'Phụ kiện thời trang');

-- Thêm dữ liệu vào bảng SanPham cho mỗi danh mục quần áo
INSERT INTO SanPham (TenSanPham, MoTa, DanhMucID) VALUES 
-- Áo thun (Danh mục 1)
(N'Áo thun trắng', N'Áo thun chất liệu cotton, màu trắng', 1),
(N'Áo thun đen', N'Áo thun chất liệu cotton, màu đen', 1),
(N'Áo thun xanh', N'Áo thun chất liệu cotton, màu xanh', 1),
(N'Áo thun đỏ', N'Áo thun chất liệu cotton, màu đỏ', 1),
(N'Áo thun vàng', N'Áo thun chất liệu cotton, màu vàng', 1),

-- Quần jean (Danh mục 2)
(N'Quần jean xanh', N'Quần jean ống suông, màu xanh', 2),
(N'Quần jean đen', N'Quần jean bó, màu đen', 2),
(N'Quần jean trắng', N'Quần jean rách, màu trắng', 2),
(N'Quần jean lưng cao', N'Quần jean lưng cao, màu xanh nhạt', 2),
(N'Quần jean rách', N'Quần jean rách thời trang', 2),

-- Áo khoác (Danh mục 3)
(N'Áo khoác da', N'Áo khoác da phong cách, màu đen', 3),
(N'Áo khoác bomber', N'Áo khoác bomber thời trang', 3),
(N'Áo khoác gió', N'Áo khoác gió chống nước', 3),
(N'Áo khoác dạ', N'Áo khoác dạ giữ ấm', 3),
(N'Áo khoác jean', N'Áo khoác jean phong cách', 3),

-- Váy (Danh mục 4)
(N'Váy maxi', N'Váy dài phong cách maxi, chất liệu lụa', 4),
(N'Váy ngắn', N'Váy ngắn phong cách, chất liệu cotton', 4),
(N'Váy xòe', N'Váy xòe dễ thương', 4),
(N'Váy dạ hội', N'Váy dài dự tiệc', 4),
(N'Váy ôm', N'Váy ôm sát cơ thể', 4),

-- Phụ kiện thời trang (Danh mục 5)
(N'Khăn quàng cổ', N'Khăn quàng cổ lụa', 5),
(N'Nón lưỡi trai', N'Nón lưỡi trai thể thao', 5),
(N'Thắt lưng da', N'Thắt lưng da cao cấp', 5),
(N'Kính râm', N'Kính râm thời trang', 5),
(N'Túi xách', N'Túi xách da thời trang', 5);

-- Thêm dữ liệu vào bảng Size (các kích thước thông thường cho quần áo)
INSERT INTO Size (SizeName) VALUES 
(N'S'),
(N'M'),
(N'L'),
(N'XL'),
(N'XXL');

-- Thêm dữ liệu vào bảng Mau (các màu sắc thông dụng)
INSERT INTO Mau (MauName) VALUES 
(N'Đỏ'),
(N'Xanh'),
(N'Vàng'),
(N'Đen'),
(N'Tráng'),
(N'Hồng');


-- Ví dụ cho sản phẩm có ID từ 1 đến 5, mỗi sản phẩm có 4 chi tiết sản phẩm với giá khác nhau

-- Sản phẩm 1 với 4 chi tiết sản phẩm, giá khác nhau
INSERT INTO ChiTietSanPham (SanPhamID, SizeID, MauID, Gia, SoLuongTonKho, HinhAnhUrl) VALUES
(1, 1, 1, 299.99, 50, N'hinh1.jpg'),
(1, 2, 2, 309.99, 45, N'hinh2.jpg'),
(1, 3, 3, 319.99, 40, N'hinh3.jpg'),
(1, 4, 4, 329.99, 35, N'hinh4.jpg');

-- Sản phẩm 2 với 4 chi tiết sản phẩm, giá khác nhau
INSERT INTO ChiTietSanPham (SanPhamID, SizeID, MauID, Gia, SoLuongTonKho, HinhAnhUrl) VALUES
(2, 1, 1, 399.99, 50, N'hinh5.jpg'),
(2, 2, 2, 409.99, 45, N'hinh6.jpg'),
(2, 3, 3, 419.99, 40, N'hinh7.jpg'),
(2, 4, 4, 429.99, 35, N'hinh8.jpg');

-- Sản phẩm 3 với 4 chi tiết sản phẩm, giá khác nhau
INSERT INTO ChiTietSanPham (SanPhamID, SizeID, MauID, Gia, SoLuongTonKho, HinhAnhUrl) VALUES
(3, 1, 1, 499.99, 50, N'hinh9.jpg'),
(3, 2, 2, 509.99, 45, N'hinh10.jpg'),
(3, 3, 3, 519.99, 40, N'hinh11.jpg'),
(3, 4, 4, 529.99, 35, N'hinh12.jpg');

-- Sản phẩm 4 với 4 chi tiết sản phẩm, giá khác nhau
INSERT INTO ChiTietSanPham (SanPhamID, SizeID, MauID, Gia, SoLuongTonKho, HinhAnhUrl) VALUES
(4, 1, 1, 599.99, 50, N'hinh13.jpg'),
(4, 2, 2, 609.99, 45, N'hinh14.jpg'),
(4, 3, 3, 619.99, 40, N'hinh15.jpg'),
(4, 4, 4, 629.99, 35, N'hinh16.jpg');

-- Sản phẩm 5 với 4 chi tiết sản phẩm, giá khác nhau
INSERT INTO ChiTietSanPham (SanPhamID, SizeID, MauID, Gia, SoLuongTonKho, HinhAnhUrl) VALUES
(5, 1, 1, 699.99, 50, N'hinh17.jpg'),
(5, 2, 2, 709.99, 45, N'hinh18.jpg'),
(5, 3, 3, 719.99, 40, N'hinh19.jpg'),
(5, 4, 4, 729.99, 35, N'hinh20.jpg');
DELETE FROM ChiTietSanPham;




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


select * from NguoiDung
select * from SanPham
select * from ChiTietSanPham
select * from GioHang
select * from DonHang
select * from ChiTietDonHang