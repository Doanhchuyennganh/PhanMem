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
