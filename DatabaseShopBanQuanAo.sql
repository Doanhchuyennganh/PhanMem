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
CREATE TABLE Size (
    SizeID INT PRIMARY KEY IDENTITY(1,1),
    SizeName NVARCHAR(10) NOT NULL
);
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

INSERT INTO DanhMuc (TenDanhMuc) VALUES (N'Thể thao');
INSERT INTO DanhMuc (TenDanhMuc) VALUES (N'Công sở, lịch sự');
INSERT INTO DanhMuc (TenDanhMuc) VALUES (N'Đơn giản, thường ngày');
INSERT INTO DanhMuc (TenDanhMuc) VALUES (N'Thời trang du lịch');
INSERT INTO DanhMuc (TenDanhMuc) VALUES (N'Thời trang hot trend');

INSERT INTO SanPham (TenSanPham, MoTa, SoLuongDaBan, DanhMucID, KichHoat)
VALUES
-- Mức giá 15000-400000
-- Nam
(N'Áo thể thao Nam đa năng', N'Áo thể thao được thiết kế thoáng khí, phù hợp cho các hoạt động ngoài trời và thể thao. Phù hợp với thanh niên.', 0, 1, 1),
(N'Quần thể thao Nam thấm hút mồ hôi', N'Quần thể thao với chất liệu thấm hút mồ hôi, mang lại cảm giác thoải mái khi vận động. Phù hợp với thanh niên.', 0, 1, 1),
(N'Giày thể thao Nam chống trượt', N'Giày thể thao nhẹ, chống trượt, lý tưởng cho chạy bộ và các môn thể thao khác. Phù hợp với thanh niên.', 0, 1, 1),
(N'Quần short thể thao Nam thoáng mát', N'Quần short thể thao thoáng mát, giúp bạn thoải mái hơn trong mọi hoạt động. Phù hợp với thanh niên.', 0, 1, 1),
(N'Mũ lưỡi trai thời trang', N'Mũ lưỡi trai bảo vệ khỏi nắng, phù hợp cho các hoạt động thể thao ngoài trời. Phù hợp với thanh niên.', 0, 1, 1),
-- Nữ
(N'Áo thể thao Nữ năng động', N'Áo thể thao nữ thoáng khí, thiết kế hiện đại cho những cô nàng yêu thể thao. Phù hợp với thanh niên.', 0, 1, 1),
(N'Quần thể thao Nữ thời trang', N'Quần thể thao nữ với kiểu dáng thời trang, dễ phối đồ. Phù hợp với thanh niên.', 0, 1, 1),
(N'Giày thể thao Nữ phong cách', N'Giày thể thao nữ nhẹ, phong cách, giúp bạn tự tin hơn khi tập luyện. Phù hợp với thanh niên.', 0, 1, 1),
(N'Quần short thể thao Nữ chất liệu mềm mại', N'Quần short thể thao nữ với chất liệu mềm mại, tạo sự thoải mái khi vận động. Phù hợp với thanh niên.', 0, 1, 1),
(N'Mũ lưỡi trai Nữ cá tính', N'Mũ lưỡi trai nữ giúp bảo vệ và tạo điểm nhấn cho trang phục thể thao. Phù hợp với thanh niên.', 0, 1, 1),
-- Mức giá 500000-750000
-- Nam
(N'Áo thể thao Nam chất liệu cao cấp', N'Áo thể thao nam với chất liệu cao cấp, thích hợp cho các buổi tập luyện chuyên nghiệp. Phù hợp với thanh niên.', 0, 1, 1),
(N'Quần thể thao Nam thời trang', N'Quần thể thao nam thời trang, tạo nên phong cách năng động. Phù hợp với thanh niên.', 0, 1, 1),
(N'Giày thể thao Nam bảo vệ tốt', N'Giày thể thao nam thiết kế hỗ trợ tốt cho cổ chân, phù hợp với vận động mạnh. Phù hợp với thanh niên.', 0, 1, 1),
(N'Quần short thể thao Nam chất liệu nhẹ', N'Quần short thể thao nam với chất liệu nhẹ, thoáng mát, dễ dàng vận động. Phù hợp với thanh niên.', 0, 1, 1),
(N'Mũ lưỡi trai thời trang Nam', N'Mũ lưỡi trai giúp bảo vệ và tạo phong cách thể thao. Phù hợp với thanh niên.', 0, 1, 1),
-- Nữ
(N'Áo thể thao Nữ chất liệu thấm hút', N'Áo thể thao nữ với chất liệu thấm hút, giúp bạn luôn khô ráo khi tập luyện. Phù hợp với thanh niên.', 0, 1, 1),
(N'Quần thể thao Nữ kiểu dáng hiện đại', N'Quần thể thao nữ kiểu dáng hiện đại, thích hợp cho tập luyện và đi chơi. Phù hợp với thanh niên.', 0, 1, 1),
(N'Giày thể thao Nữ siêu nhẹ', N'Giày thể thao nữ siêu nhẹ, phù hợp với các hoạt động thể thao. Phù hợp với thanh niên.', 0, 1, 1),
(N'Quần short thể thao Nữ thời trang', N'Quần short thể thao nữ với thiết kế thời trang, dễ dàng phối đồ. Phù hợp với thanh niên.', 0, 1, 1),
(N'Mũ lưỡi trai Nữ phong cách', N'Mũ lưỡi trai nữ phong cách, giúp bảo vệ và tạo nét cá tính. Phù hợp với thanh niên.', 0, 1, 1),
-- Mức giá 800000-2000000
-- Nam
(N'Áo thể thao Nam cao cấp', N'Áo thể thao nam cao cấp, mang lại sự thoải mái tối đa khi tập luyện. Phù hợp với thanh niên.', 0, 1, 1),
(N'Quần thể thao Nam cao cấp', N'Quần thể thao nam chất lượng, thiết kế hiện đại cho những ai yêu thích vận động. Phù hợp với thanh niên.', 0, 1, 1),
(N'Giày thể thao Nam đa năng', N'Giày thể thao nam thiết kế đa năng, phục vụ cho nhiều hoạt động thể thao khác nhau. Phù hợp với thanh niên.', 0, 1, 1),
(N'Quần short thể thao Nam cao cấp', N'Quần short thể thao nam cao cấp, thoải mái cho mọi hoạt động. Phù hợp với thanh niên.', 0, 1, 1),
(N'Mũ lưỡi trai Nam thời trang', N'Mũ lưỡi trai nam thời trang, bảo vệ khỏi nắng, dễ phối đồ. Phù hợp với thanh niên.', 0, 1, 1),
-- Nữ
(N'Áo thể thao Nữ cao cấp', N'Áo thể thao nữ cao cấp, thoải mái và phong cách cho các hoạt động thể thao. Phù hợp với thanh niên.', 0, 1, 1),
(N'Quần thể thao Nữ năng động', N'Quần thể thao nữ năng động, lý tưởng cho các hoạt động thể thao và du lịch. Phù hợp với thanh niên.', 0, 1, 1),
(N'Giày thể thao Nữ kiểu dáng đẹp', N'Giày thể thao nữ với thiết kế thời trang, giúp bạn tự tin hơn khi vận động. Phù hợp với thanh niên.', 0, 1, 1),
(N'Quần short thể thao Nữ chất liệu thoáng mát', N'Quần short thể thao nữ thoáng mát, tạo cảm giác dễ chịu trong suốt thời gian vận động. Phù hợp với thanh niên.', 0, 1, 1),
(N'Mũ lưỡi trai Nữ cá tính', N'Mũ lưỡi trai nữ với thiết kế cá tính, phong cách cho mọi cô gái. Phù hợp với thanh niên.', 0, 1, 1);

-- Sản phẩm cho sở thích "Công sở, lịch sự" Thanh niên từ 0 đến 37 tuổi 
INSERT INTO SanPham (TenSanPham, MoTa, SoLuongDaBan, DanhMucID, KichHoat)
VALUES
-- Mức giá 15000-400000
--nam
(N'Áo khoác công sở nam', N'Áo khoác nhẹ nhàng, thoải mái, thích hợp cho đi làm.Phù hợp với thanh niên', 0, 2, 1),
(N'Quần âu nam phong cách', N'Quần âu nam với thiết kế hiện đại, tôn dáng.Phù hợp với thanh niên', 0, 2, 1),
(N'Giày oxford nam sang trọng', N'Giày oxford phù hợp cho các dịp trang trọng.Phù hợp với thanh niên', 0, 2, 1),
(N'Quần tây nam thoải mái', N'Quần tây nam với chất liệu thoáng mát, dễ chịu.Phù hợp với thanh niên', 0, 2, 1),
(N'Giày công sở', N' thời trang', 0, 2, 1),
--nữ
(N'Áo vest công sở nữ', N'Áo vest nữ thanh lịch, dễ phối với nhiều trang phục.Phù hợp với thanh niên', 0, 2, 1),
(N'Chân váy nữ', N'Chân váy xòe nữ tính, hoàn hảo cho công việc.Phù hợp với thanh niên', 0, 2, 1),
(N'Giày cao gót công sở', N'Giày cao gót thời trang, nâng tầm phong cách.Phù hợp với thanh niên', 0, 2, 1),
(N'Quần âu nữ hiện đại', N'Quần âu nữ với thiết kế trẻ trung, thoải mái.Phù hợp với thanh niên', 0, 2, 1),
(N'giày nữ thời trang', N' giúp bạn thêm phần năng động.Phù hợp với thanh niên', 0, 2, 1),

-- Mức giá 500000-750000
--nam
(N'Áo sơ mi công sở nam', N'Áo sơ mi cổ điển, phù hợp cho môi trường làm việc.Phù hợp với thanh niên', 0, 2, 1),
(N'Quần tây nam hiện đại', N'Quần tây với thiết kế trẻ trung, phù hợp cho đi làm.Phù hợp với thanh niên', 0, 2, 1),
(N'Giày tây nam cao cấp', N'Giày tây mang lại vẻ lịch lãm cho phái mạnh.Phù hợp với thanh niên', 0, 2, 1),
(N'Quần Âu công sở nam', N'Quần short với chất liệu thoải mái, phù hợp mùa hè.Phù hợp với thanh niên', 0, 2, 1),
(N'cà vạt', N'cà vạt trai dễ phối đồ, thích hợp cho mọi hoạt động.Phù hợp với thanh niên', 0, 2, 1),
--nữ
(N'Áo sơ mi công sở nữ', N'Áo sơ mi nữ thanh lịch, dễ dàng phối đồ.Phù hợp với thanh niên', 0, 2, 1),
(N'Chân váy pencil công sở', N'Chân váy bút chì tạo dáng, hoàn hảo cho môi trường công sở.Phù hợp với thanh niên', 0, 2, 1),
(N'Giày búp bê công sở', N'Giày búp bê nữ tính, thoải mái cho ngày dài làm việc.Phù hợp với thanh niên', 0, 2, 1),
(N'Quần tây nữ thanh lịch', N'Quần tây với chất liệu cao cấp, phù hợp với mọi dịp.Phù hợp với thanh niên', 0, 2, 1),
(N'cà vạt công sở nữ', N'cà vạt thời trang', 0, 2, 1),
-- Mức giá 800000-2000000
--nam
(N'Áo khoác công sở nam cao cấp', N'Áo khoác giữ ấm với phong cách lịch lãm.Phù hợp với thanh niên', 0, 2, 1),
(N'Quần tây nam cao cấp', N'Quần tây nam thời thượng, mang lại phong cách hoàn hảo.Phù hợp với thanh niên', 0, 2, 1),
(N'Giày lười nam công sở', N'Giày lười thoải mái, thích hợp cho công việc hàng ngày.Phù hợp với thanh niên', 0, 2, 1),
(N'Chân quần midi công sở', N'Chân váy midi thanh lịch, lý tưởng cho buổi hẹn.Phù hợp với thanh niên', 0, 2, 1),
(N'quần công sở', N'sang trọng, tạo điểm nhấn cho trang phục.Phù hợp với thanh niên', 0, 2, 1),
--nữ
(N'Áo tay dài công sở nữ sang trọng', N'Áo khoác nữ thời trang, bảo vệ bạn khỏi cái lạnh.Phù hợp với thanh niên', 0, 2, 1),
(N'Chân váy xòe công sở', N'Chân váy xòe dễ thương, hoàn hảo cho những buổi tiệc.Phù hợp với thanh niên', 0, 2, 1),
(N'Giày cao gót công sở sang trọng', N'Giày cao gót đẹp, làm nổi bật phong cách của bạn.Phù hợp với thanh niên', 0, 2, 1),
(N'Quần tây nữ cao cấp', N'Quần tây với chất liệu cao cấp, ôm sát tạo dáng đẹp.Phù hợp với thanh niên', 0, 2, 1),
(N'cà vạt nữ thời trang', N'cà vạt thời thượng.Phù hợp với thanh niên', 0, 2, 1);
-- Sản phẩm cho sở thích "Đơn giản, thường ngày" Thanh niên từ 0 đến 37 tuổi
INSERT INTO SanPham (TenSanPham, MoTa, SoLuongDaBan, DanhMucID, KichHoat)
VALUES 
-- Mức giá 15000-400000
--nam
(N'Áo polo nam basic', N'Áo polo nam với chất liệu mềm mại, thoáng khí, phù hợp cho những ngày hè.Phù hợp với thanh niên', 0, 3, 1),
(N'Quần kaki nam thanh lịch', N'Quần kaki dáng ôm, dễ phối đồ cho các sự kiện hàng ngày.Phù hợp với thanh niên', 0, 3, 1),
(N'Giày lười nam phong cách', N'Giày lười nam thời trang, tiện lợi cho những buổi đi chơi.Phù hợp với thanh niên', 0, 3, 1),
(N'Quần short nam thoải mái', N'Quần short năng động, lý tưởng cho các hoạt động ngoài trời.Phù hợp với thanh niên', 0, 3, 1),
(N'Mũ lưỡi trai nam', N'Mũ lưỡi trai thời trang giúp bạn bảo vệ khỏi ánh nắng mặt trời.Phù hợp với thanh niên', 0, 3, 1),
--nữ
(N'Áo thun nữ basic', N'Áo thun nữ thoải mái, dễ dàng phối hợp với nhiều kiểu trang phục.Phù hợp với thanh niên', 0, 3, 1),
(N'Quần legging nữ co giãn', N'Quần legging nữ với chất liệu co giãn, thích hợp cho mọi hoạt động.Phù hợp với thanh niên', 0, 3, 1),
(N'Giày bệt nữ thời trang', N'Giày bệt nữ với thiết kế thanh lịch, phù hợp với nhiều phong cách.Phù hợp với thanh niên', 0, 3, 1),
(N'Quần jean nữ', N'Quần jean nữ nhẹ nhàng, lý tưởng cho mùa hè.Phù hợp với thanh niên', 0, 3, 1),
(N'Mũ lưỡi trai nữ', N'Mũ lưỡi trai với nhiều màu sắc trẻ trung, phù hợp với mọi lứa tuổi.Phù hợp với thanh niên', 0, 3, 1),
-- Mức giá 500000-750000
--nam
(N'Áo sơ mi nam trắng', N'Sơ mi nam trắng thanh lịch, phù hợp với các buổi tiệc hoặc đi làm.Phù hợp với thanh niên', 0, 3, 1),
(N'Quần tây nam lịch lãm', N'Quần tây nam với chất liệu cao cấp, phù hợp cho môi trường công sở.Phù hợp với thanh niên', 0, 3, 1),
(N'Giày oxford nam cổ điển', N'Giày oxford nam với thiết kế sang trọng, phù hợp cho các dịp trang trọng.Phù hợp với thanh niên', 0, 3, 1),
(N'Quần boki nam phong cách', N'Quần boki với kiểu dáng hiện đại, phù hợp.Phù hợp với thanh niên', 0, 3, 1),
(N'Mũ snapback nam', N'Mũ snapback thời trang, phù hợp cho mọi phong cách.Phù hợp với thanh niên', 0, 3, 1),
--nữ
(N'Áo sơ mi nữ ', N'Sơ mi nữ thanh lịch, dễ dàng phối hợp với quần và chân váy.Phù hợp với thanh niên', 0, 3, 1),
(N'Quần tây nữ lịch lãm', N'Quần tây nữ với kiểu dáng hiện đại, thích hợp cho công việc và dạo phố.Phù hợp với thanh niên', 0, 3, 1),
(N'Giày cao gót nữ thời trang', N'Giày cao gót với thiết kế tinh tế, tôn dáng chân và phù hợp với nhiều trang phục.Phù hợp với thanh niên', 0, 3, 1),
(N'Váy baki nữ trẻ trung', N'Váy baki nữ với thiết kế trẻ trung, phù hợp cho mùa hè.Phù hợp với thanh niên', 0, 3, 1),
(N'Mũ lưỡi trai nữ cá tính', N'Mũ lưỡi trai với họa tiết độc đáo, làm nổi bật phong cách cá nhân.Phù hợp với thanh niên', 0, 3, 1),
-- Mức giá 800000-2000000
--nam
(N'Áo khoác nam thời trang', N'Áo khoác nam với chất liệu dày dạn, giữ ấm trong mùa đông.Phù hợp với thanh niên', 0, 3, 1),
(N'Quần jeans nam phong cách', N'Quần jeans nam với thiết kế thời trang, phù hợp cho mọi hoạt động.Phù hợp với thanh niên', 0, 3, 1),
(N'Giày thể thao nam cao cấp', N'Giày thể thao nam với đệm êm, tạo cảm giác thoải mái khi vận động.Phù hợp với thanh niên', 0, 3, 1),
(N'Quần jogger nam tiện lợi', N'Quần jogger nam với chất liệu nhẹ, thích hợp cho việc tập luyện.Phù hợp với thanh niên', 0, 3, 1),
(N'Mũ lưỡi trai nam cá tính', N'Mũ lưỡi trai với kiểu dáng hiện đại, phù hợp cho nhiều phong cách.Phù hợp với thanh niên', 0, 3, 1),
(N'Áo khoác nữ thời trang', N'Áo khoác nữ dày dạn, phù hợp với thời tiết lạnh.Phù hợp với thanh niên', 0, 3, 1),
(N'Quần jeans nữ phong cách', N'Quần jeans nữ với thiết kế trẻ trung, thích hợp cho dạo phố.Phù hợp với thanh niên', 0, 3, 1),
(N'Giày thể thao nữ cao cấp', N'Giày thể thao nữ với độ bám tốt, phù hợp cho các hoạt động thể thao.Phù hợp với thanh niên', 0, 3, 1),
(N'Quần jogger nữ tiện lợi', N'Quần jogger nữ với chất liệu nhẹ, thoải mái cho mọi hoạt động.Phù hợp với thanh niên', 0, 3, 1),
(N'Mũ lưỡi trai nữ cá tính', N'Mũ lưỡi trai nữ với thiết kế độc đáo, phù hợp cho phong cách năng động.Phù hợp với thanh niên', 0, 3, 1);

-- Sản phẩm cho sở thích "Thời trang du lịch" Thanh niên từ 0 đến 37 tuổi
INSERT INTO SanPham (TenSanPham, MoTa, SoLuongDaBan, DanhMucID, KichHoat)
VALUES 
-- Mức giá 15000-400000
(N'Áo khoác chống nước nam', N'Tiện lợi khi đi du lịch, chất liệu chống nướcPhù hợp với thanh niên', 0, 4, 1),
(N'Quần dài nam đi trekking', N'Thiết kế gọn nhẹ, co giãn, phù hợp cho các hoạt động ngoài trờiPhù hợp với thanh niên', 0, 4, 1),
(N'Giày thể thao nam chống trượt', N'Đế cao su chống trượt, thoải mái khi vận độngPhù hợp với thanh niên', 0, 4, 1),
(N'Quần short nam du lịch', N'Chất liệu polyester, thoáng khí, phù hợp cho thời tiết nóngPhù hợp với thanh niên', 0, 4, 1),
(N'Nón rộng vành nam', N'Nón che nắng, thích hợp cho các chuyến đi dàiPhù hợp với thanh niên', 0, 4, 1),
(N'Áo thun nữ thoáng mát', N'Áo thun nữ chất liệu cotton, dễ chịu khi mặcPhù hợp với thanh niên', 0, 4, 1),
(N'Quần short nữ đi biển', N'Phong cách thời trang, màu sắc tươi trẻPhù hợp với thanh niên', 0, 4, 1),
(N'Giày chạy bộ nữ nhẹ', N'Thiết kế năng động, phù hợp cho mọi địa hìnhPhù hợp với thanh niên', 0, 4, 1),
(N'Váy maxi nữ đi biển', N'Chất liệu voan mềm mại, thoải mái trong các chuyến đi biểnPhù hợp với thanh niên', 0, 4, 1),
(N'Nón chống nắng nữ', N'Thiết kế đẹp mắt, bảo vệ da khỏi ánh nắngPhù hợp với thanh niên', 0, 4, 1),
-- Mức giá 500000-750000
(N'Áo khoác gió nam', N'Chống nước, giữ ấm, phù hợp cho các chuyến đi xaPhù hợp với thanh niên', 0, 4, 1),
(N'Quần dài nam chống thấm', N'Thiết kế thời trang, chống thấm, thoáng mátPhù hợp với thanh niên', 0, 4, 1),
(N'Giày trekking nam cao cấp', N'Đế chống trượt, thiết kế chắc chắn cho địa hình phức tạpPhù hợp với thanh niên', 0, 4, 1),
(N'Quần short nam đi biển', N'Chất liệu nhanh khô, màu sắc nổi bậtPhù hợp với thanh niên', 0, 4, 1),
(N'Nón bảo vệ nam đa dụng', N'Bảo vệ khỏi gió và ánh nắng mặt trờiPhù hợp với thanh niên', 0, 4, 1),
(N'Áo khoác gió nữ thời trang', N'Chất liệu chống thấm, phong cách năng độngPhù hợp với thanh niên', 0, 4, 1),
(N'Quần dài nữ du lịch', N'Chất liệu co giãn, thoải mái cho các hoạt động ngoài trờiPhù hợp với thanh niên', 0, 4, 1),
(N'Giày thể thao nữ trekking', N'Giày nữ chắc chắn, phù hợp cho mọi loại địa hìnhPhù hợp với thanh niên', 0, 4, 1),
(N'Váy maxi nữ du lịch', N'Phong cách thời trang, thoáng mát, phù hợp cho mùa hèPhù hợp với thanh niên', 0, 4, 1),
(N'Nón nữ đi biển', N'Nón rộng vành, chống nắng tốt cho các hoạt động ngoài trờiPhù hợp với thanh niên', 0, 4, 1),
-- Mức giá 800000-2000000
(N'Áo khoác chống thấm nam cao cấp', N'Áo khoác giữ ấm, chống gió cho những chuyến đi dàiPhù hợp với thanh niên', 0, 4, 1),
(N'Quần dài nam trekking cao cấp', N'Quần chống thấm, co giãn 4 chiều, thoải máiPhù hợp với thanh niên', 0, 4, 1),
(N'Giày trekking nam chuyên nghiệp', N'Thiết kế chuyên nghiệp, độ bám cao, phù hợp cho leo núiPhù hợp với thanh niên', 0, 4, 1),
(N'Quần short trekking nam', N'Chất liệu cao cấp, phù hợp cho thời tiết nóngPhù hợp với thanh niên', 0, 4, 1),
(N'Nón bảo vệ nam cao cấp', N'Nón chống gió và ánh nắng cho các hoạt động ngoài trờiPhù hợp với thanh niên', 0, 4, 1),
(N'Áo khoác nữ loia chuyên nghiệp', N'Áo khoác loia chống gió và thấm nước, thiết kế nhẹ nhàngPhù hợp với thanh niên', 0, 4, 1),
(N'Quần dài nữ trekking', N'Chất liệu cao cấp, co giãn tốt, phù hợp cho mọi địa hìnhPhù hợp với thanh niên', 0, 4, 1),
(N'Giày trekking nữ chuyên nghiệp', N'Giày bền, chống trượt, phù hợp cho các chuyến leo núiPhù hợp với thanh niên', 0, 4, 1),
(N'Quần dài nữ du lịch cao cấp', N'Chất liệu cao cấp, thoáng mát cho các chuyến đi biểnPhù hợp với thanh niên', 0, 4, 1),
(N'Nón chống nắng nữ cao cấp', N'Thiết kế thời trang, bảo vệ tối đa khỏi tia UVPhù hợp với thanh niên', 0, 4, 1);
-- Sản phẩm cho sở thích "Thời trang hot trend" Thanh niên từ 0 đến 37 tuổi
INSERT INTO SanPham (TenSanPham, MoTa, SoLuongDaBan, DanhMucID, KichHoat)
VALUES 
-- Mức giá 15000-400000
(N'Áo khoác thể thao nam đa năng', N'Áo khoác nhẹ, thoáng khí, phù hợp cho mọi hoạt động thể thao.Phù hợp với thanh niên', 0, 5, 1),
(N'Quần jogger nam thời trang', N'Quần jogger thoải mái, phong cách thể thao trẻ trung.Phù hợp với thanh niên', 0, 5, 1),
(N'Giày chạy bộ nam siêu nhẹ', N'Giày chạy bộ với thiết kế siêu nhẹ, hỗ trợ tốt cho chân.Phù hợp với thanh niên', 0, 5, 1),
(N'Quần short thể thao nam chống thấm', N'Quần short thời trang, chất liệu chống thấm nước.Phù hợp với thanh niên', 0, 5, 1),
(N'Mũ lưỡi trai thể thao phong cách', N'Mũ lưỡi trai thời trang, bảo vệ tốt khi ra ngoài.Phù hợp với thanh niên', 0, 5, 1),
(N'Áo khoác thể thao nữ thời trang', N'Áo khoác nữ phong cách, thoải mái cho mùa đông.Phù hợp với thanh niên', 0, 5, 1),
(N'Quần legging nữ thời trang', N'Quần legging co giãn, dễ chịu cho mọi hoạt động.Phù hợp với thanh niên', 0, 5, 1),
(N'Giày thể thao nữ thời trang', N'Giày thể thao nữ phong cách, nhẹ và bền.Phù hợp với thanh niên', 0, 5, 1),
(N'Quần short thể thao nữ trẻ trung', N'Quần short nữ trẻ trung, chất liệu thoáng mát.Phù hợp với thanh niên', 0, 5, 1),
(N'Mũ lưỡi trai nữ phong cách', N'Mũ lưỡi trai nữ thời trang, bảo vệ nắng hiệu quả.Phù hợp với thanh niên', 0, 5, 1),

-- Mức giá 500000-750000

(N'Áo hoodie nam phong cách', N'Áo hoodie nam thời trang, giữ ấm hiệu quả trong mùa lạnh.Phù hợp với thanh niên', 0, 5, 1),
(N'Quần thể thao nam ống rộng', N'Quần thể thao ống rộng, thoải mái cho mọi hoạt động.Phù hợp với thanh niên', 0, 5, 1),
(N'Giày sneaker nam thời trang', N'Giày sneaker nam, thiết kế trẻ trung và hiện đại.Phù hợp với thanh niên', 0, 5, 1),
(N'Quần cargo nam phong cách', N'Quần cargo với nhiều túi tiện dụng, thời trang.Phù hợp với thanh niên', 0, 5, 1),
(N'Mũ bucket nam', N'Mũ bucket phong cách, bảo vệ nắng cho mùa hè.Phù hợp với thanh niên', 0, 5, 1),


(N'Áo khoác bomber nữ', N'Áo khoác bomber thời trang, phù hợp với nhiều trang phục.Phù hợp với thanh niên', 0, 5, 1),
(N'Quần jeans nữ thời trang', N'Quần jeans nữ với kiểu dáng trẻ trung và năng động.Phù hợp với thanh niên', 0, 5, 1),
(N'Giày búp bê nữ thời trang', N'Giày búp bê nữ thoải mái, thích hợp cho nhiều dịp.Phù hợp với thanh niên', 0, 5, 1),
(N'Quần culottes nữ thời trang', N'Quần culottes nữ, phong cách thoáng mát và dễ chịu.Phù hợp với thanh niên', 0, 5, 1),
(N'Mũ lưỡi trai nữ', N'Mũ lưỡi trai phong cách, thời trang và tiện lợi.Phù hợp với thanh niên', 0, 5, 1),

-- Mức giá 800000-2000000
(N'Áo khoác thể thao nam cao cấp', N'Áo khoác thể thao nam, chất liệu tốt, giữ ấm hiệu quả.Phù hợp với thanh niên', 0, 5, 1),
(N'Quần thể thao nam cao cấp', N'Quần thể thao nam chất liệu tốt, thoải mái khi vận động.Phù hợp với thanh niên', 0, 5, 1),
(N'Giày thể thao nam cao cấp', N'Giày thể thao nam với thiết kế cao cấp, hỗ trợ tốt cho chân.Phù hợp với thanh niên', 0, 5, 1),
(N'Quần short thể thao nam cao cấp', N'Quần short nam cao cấp, chất liệu thoáng khí và bền bỉ.Phù hợp với thanh niên', 0, 5, 1),
(N'Mũ lưỡi trai thể thao cao cấp', N'Mũ lưỡi trai chất lượng cao, phù hợp cho mọi hoạt động ngoài trời.Phù hợp với thanh niên', 0, 5, 1),


(N'Áo khoác thể thao nữ cao cấp', N'Áo khoác thể thao nữ, chất liệu tốt, thiết kế thời trang.Phù hợp với thanh niên', 0, 5, 1),
(N'Quần ngắn nữ cao cấp', N'Quần ngắn nữ, chất liệu thoáng khí, phù hợp cho mọi hoạt động.Phù hợp với thanh niên', 0, 5, 1),
(N'Giày cao nữ cao cấp', N'Giày cao nữ chất lượng.Phù hợp với thanh niên', 0, 5, 1),
(N'Áo thể thao nữ năng động', N'Áo thể thao nữ thoáng khí, thiết kế năng động, thoải mái cho mọi hoạt động.Phù hợp với thanh niên', 0, 5, 1),
(N'Áo thể thao nữ năng động', N'Áo thể thao nữ thoáng khí, thiết kế năng động, thoải mái cho mọi hoạt động.Phù hợp với thanh niên', 0, 5, 1);

-- Sản phẩm cho sở thích "Thể thao" Trung niên từ 38 đến 60 tuổi
INSERT INTO SanPham (TenSanPham, MoTa, SoLuongDaBan, DanhMucID, KichHoat)
VALUES 
-- Mức giá 15000-400000
--nam
(N'Áo thể thao nam cổ tròn thoáng mát', N'Áo dành cho nam giới trung niên, chất liệu thoáng khí, phù hợp cho hoạt động thể thao ngoài trời.', 45, 1, 1),
(N'Quần dài thể thao nam co giãn', N'Quần thể thao nam trung niên, chất liệu mềm mại, đàn hồi tốt, lý tưởng cho tập luyện và chạy bộ.', 60, 1, 1),
(N'Giày chạy bộ nam chống trượt', N'Giày thể thao nam trung niên siêu nhẹ , đế chống trượt, phù hợp cho mọi địa hình.', 40, 1, 1),
(N'Áo gió thể thao nam chống nước', N'Áo khoác thể thao nam trung niên, chất liệu chống nước, bảo vệ khi chạy bộ ngoài trời.', 55, 1, 1),
(N'Ba lô thể thao nam nhiều ngăn', N'Ba lô thể thao với nhiều ngăn tiện dụng, chất liệu bền, dành cho nam giới trung niên.', 35, 1, 1),

--nữ
(N'Áo thể thao nữ chống nắng', N'Áo thể thao nữ trung niên, chất liệu chống nắng, phù hợp cho tập luyện ngoài trời.', 48, 1, 1),
(N'Quần legging thể thao nữ co giãn', N'Quần legging nữ ôm sát, chất liệu co giãn thoải mái trung niên, lý tưởng cho yoga và chạy bộ.', 52, 1, 1),
(N'Giày thể thao nữ đệm êm chân', N'Giày thể thao nữ với đệm êm ái, phù hợp cho trung niên đi bộ đường dài và chạy bộ.', 60, 1, 1),
(N'Áo khoác thể thao nữ dáng rộng', N'Áo khoác thể thao nữ trung niên, dáng rộng thoải mái, chống gió và chống nước.', 50, 1, 1),
(N'Túi đeo vai thể thao nữ', N'Túi đeo vai thể thao tiện lợi, phù hợp cho các hoạt động ngoài trời, dành cho nữ trung niên.', 40, 1, 1),

-- Mức giá 500000-750000
--nam
(N'Áo khoác gió nam chống tia UV', N'Áo khoác gió nam trung niên, chống tia UV, thích hợp cho các hoạt động ngoài trời.', 45, 1, 1),
(N'Quần short thể thao nam chống thấm', N'Quần short thể thao nam trung niên chất liệu chống thấm nước, phù hợp cho đi bộ đường dài.', 38, 1, 1),
(N'Giày leo núi nam chống trượt', N'Giày leo núi nam trung niên với đế chống trượt, đệm êm chân, phù hợp cho địa hình gồ ghề.', 30, 1, 1),
(N'Ba lô leo núi thể thao nam', N'Ba lô leo núi dung tích lớn, dành cho các chuyến đi dài, thiết kế đặc biệt cho nam trung niên.', 20, 1, 1),
(N'Kính mát thể thao nam chống lóa', N'Kính mát thể thao với khả năng chống lóa và chống tia UV, thích hợp cho nam giới trung niên.', 55, 1, 1),

--nữ
(N'Áo khoác chống tia UV nữ', N'Áo khoác thể thao nữ trung niên, chống tia UV và gió, thích hợp cho đi bộ và leo núi.', 42, 1, 1),
(N'Giày leo núi nữ chống trượt', N'Giày thể thao nữ trung niên dành cho leo núi, đế chống trượt và đệm êm chân, lý tưởng cho hoạt động ngoài trời.', 32, 1, 1),
(N'Quần short thể thao nữ thoáng mát', N'Quần thể thao nữ trung niên, chất liệu thoáng khí, phù hợp cho các hoạt động thể thao.', 50, 1, 1),
(N'Bình nước thể thao nữ', N'Bình nước thể thao tiện lợi, dung tích lớn, giữ nhiệt tốt, dành cho nữ giới trung niên.', 40, 1, 1),
(N'Kính mát thể thao nữ chống UV', N'Kính mát thể thao nữ trung niên với khả năng chống tia UV và chống lóa, phù hợp cho hoạt động ngoài trời.', 50, 1, 1),

-- Mức giá 800000-2000000
--nam
(N'Áo khoác thể thao nam chống gió', N'Áo khoác thể thao nam trung niên, chống gió và nước, lý tưởng cho đi bộ và chạy bộ.', 45, 1, 1),
(N'Giày leo núi nam chuyên dụng', N'Giày leo núi nam trung niên chuyên dụng, chất liệu chống trượt và thấm nước, đệm lót siêu êm.', 35, 1, 1),
(N'Bộ quần áo thể thao nam chất liệu cao cấp', N'Bộ quần áo thể thao với chất liệu cao cấp, đàn hồi tốt, dành cho nam giới trung niên.', 28, 1, 1),
(N'Áo khoác thể thao nam chống nước', N'Áo khoác thể thao nam trung niên, thiết kế chống nước, phù hợp cho các hoạt động thể thao ngoài trời.', 25, 1, 1),
(N'Balo thể thao nam chuyên dụng', N'Ba lô thể thao dung tích lớn, chống nước, chuyên dụng cho các hoạt động leo núi, đi bộ đường dài.trung niên', 18, 1, 1),

--nữ 
(N'Áo khoác thể thao nữ giữ nhiệt', N'Áo khoác thể thao nữ trung niên, giữ nhiệt tốt, phù hợp cho thời tiết lạnh khi chạy bộ.', 40, 1, 1), 
(N'Giày chạy bộ nữ chất lượng cao', N'Giày chạy bộ nữ với thiết kế chuyên dụng, đệm lót êm ái, chống trượt tốt, dành cho nữ trung niên.', 35, 1, 1), 
(N'Quần dài thể thao nữ giữ nhiệt', N'Quần dài thể thao nữ trung niên, chất liệu giữ nhiệt và co giãn, phù hợp cho các hoạt động ngoài trời.', 28, 1, 1), 
(N'áo thể thao nữ chống nước', N'áo thể thao nữ trung niên với khả năng chống nước, thiết kế phù hợp cho các hoạt động leo núi và đi bộ.', 22, 1, 1), 
(N'Balo leo núi nữ chuyên dụng', N'Balo leo núi nữ dung tích lớn, chất liệu bền bỉ, phù hợp trung niên cho các chuyến đi dài.', 15, 1, 1);
-- Sản phẩm cho sở thích "Công sở, lịch sự" Trung niên từ 38 đến 60 tuổi
INSERT INTO SanPham (TenSanPham, MoTa, SoLuongDaBan, DanhMucID, KichHoat)
VALUES 
-- Mức giá 15000-400000
--nam
(N'Áo sơ mi nam dài tay cao cấp', N'Áo sơ mi lịch lãm cho nam trung niên, phù hợp đi làm và gặp gỡ đối tác', 0, 2, 1),
(N'Quần âu nam thanh lịch', N'Quần âu công sở thoải mái cho nam trung niên', 0, 2, 1),
(N'Giày da nam sang trọng', N'Giày da mềm mại, thiết kế tối giản nhưng tinh tế trung niên', 0, 2, 1),
(N'Cà vạt họa tiết sang trọng', N'Cà vạt chất liệu lụa cao cấp, phù hợp với vest nam trung niên', 0, 2, 1),
(N'Túi xách da bò', N'Túi xách công sở nam chất liệu da bò, kiểu dáng sang trọng trung niên', 0, 2, 1),
--Nữ
(N'Áo sơ mi nữ cổ điển', N'Áo sơ mi trắng trung niên thanh lịch, phù hợp đi làm và hội họp', 0, 2, 1),
(N'Quần tây nữ ống đứng', N'Quần tây công sở dành cho nữ trung niên, thiết kế đơn giản mà tinh tế', 0, 2, 1),
(N'Giày cao gót nữ thanh lịch', N'Giày cao gót nữ 5cm phù hợp cho môi trường công sở trung niên', 0, 2, 1),
(N'Túi xách nữ kiểu dáng cổ điển', N'Túi xách công sở nữ thiết kế tinh tế, màu đen sang trọng trung niên', 0, 2, 1),
(N'Áo cổ nữ họa tiết nhẹ nhàng', N'Chất liệu lụa mềm mại, tạo điểm nhấn cho trang phục công sở trung niên', 0, 2, 1),
-- Mức giá 500000-750000
--nam
(N'Áo vest nam phong cách cổ điển', N'Áo vest lịch lãm, kiểu dáng cổ điển dành cho nam trung niên', 0, 2, 1),
(N'Quần âu nam cắt may tinh tế', N'Quần âu cao cấp, form chuẩn cho nam giới trung niên', 0, 2, 1),
(N'Giày lười nam da bò', N'Giày lười da bò mềm mại, sang trọng, phù hợp cho các buổi gặp gỡ công việc trung niên', 0, 2, 1),
(N'Túi xách cao cấp', N'Túi xách nam trung niên, chất liệu da cao cấp, thiết kế sang trọng', 0, 2, 1),
(N'Vest nam', N'Bản to, thiết kế mạnh mẽ cho nam trung niên', 0, 2, 1),
--Nữ
(N'Quần áo nữ cổ điển', N'Công sở dành cho nữ trung niên, kiểu dáng cổ điển', 0, 2, 1),
(N'Váy liền thân dáng ôm', N'Váy công sở dành cho nữ trung niên, dáng ôm tinh tế', 0, 2, 1),
(N'Giày bệt nữ da bò', N'Giày bệt nữ chất liệu da bò mềm, thoải mái nhưng vẫn lịch sự trung niên', 0, 2, 1),
(N'Túi xách nữ da cao cấp', N'Túi xách nữ màu nâu nhạt, thiết kế đơn giản mà tinh tế trung niên', 0, 2, 1),
(N'Áo choàng cổ lụa sang trọng', N'Áo choàng lụa thiết kế họa tiết nhẹ nhàng, mang lại vẻ đẹp thanh lịch trung niên', 0, 2, 1),
-- Mức giá 800000-2000000
--nam
(N'Áo khoác da nam cổ điển', N'Áo khoác da thật, kiểu dáng cổ điển, phong cách lịch sự trung niên' , 0, 2, 1),
(N'Quần tây nam cao cấp', N'Quần tây nam chất liệu cotton thoáng mát, phù hợp với nam trung niên', 0, 2, 1),
(N'Giày Oxford nam', N'Giày Oxford cổ điển cho nam giới, kiểu dáng lịch lãm trung niên', 0, 2, 1),
(N'Túi đựng laptop da bò', N'Túi xách đựng laptop da bò cao cấp, phù hợp với doanh nhân trung niên', 0, 2, 1),
(N'Kính mát nam hàng hiệu', N'Kính mát nam thương hiệu nổi tiếng, mang lại vẻ ngoài sang trọng trung niên', 0, 2, 1),
--Nữ
(N'Áo khoác da nữ thời thượng', N'Áo khoác da cho nữ trung niên, phong cách cổ điển mà hiện đại', 0, 2, 1),
(N'Váy dự tiệc công sở', N'Váy dự tiệc sang trọng, thiết kế tinh tế cho nữ trung niên', 0, 2, 1),
(N'Giày cao gót nữ đế nhọn', N'Giày cao gót đế nhọn 7cm, thiết kế tối giản nhưng sang trọng trung niên', 0, 2, 1),
(N'Túi xách tay nữ cao cấp', N'Túi xách nữ hàng hiệu cao cấp, thiết kế cổ điển và sang trọng trung niên', 0, 2, 1),
(N'Váy hàng hiệu', N'Cao cấp, hàng hiệu nổi tiếng, màu sắc nhẹ nhàng và sang trọng trung niên', 0, 2, 1);
-- Sản phẩm cho sở thích "Đơn giản, thường ngày" Trung niên từ 38 đến 60 tuổi
INSERT INTO SanPham (TenSanPham, MoTa, SoLuongDaBan, DanhMucID, KichHoat) 
VALUES 
-- Mức giá 15000-400000
-- nam
(N'Áo polo nam cotton thoải mái', N'Phong cách thường ngày, phù hợp cho nam giới trung niên', 40, 3, 1),
(N'Quần kaki nam trung niên', N'Chất liệu kaki mềm mại, mặc thoải mái hàng ngày trung niên', 30, 3, 1),
(N'Giày lười da nam trung niên', N'Giày lười tiện lợi, thiết kế đơn giản phù hợp với trung niên', 25, 3, 1),
(N'Áo sơ mi dài tay thoáng mát', N'Sơ mi dài tay, thiết kế cổ điển cho nam trung niên', 20, 3, 1),
(N'Giày quai ngang da thật nam', N'Giày quai ngang thoáng mát, phù hợp cho mùa hè trung niên', 50, 3, 1),
-- nữ
(N'Áo phông nữ tay lỡ', N'Áo phông thiết kế đơn giản, thích hợp mặc thường ngày trung niên', 45, 3, 1),
(N'Váy suông nữ trung niên', N'Váy suông dài cho nữ trung niên, đơn giản mà thanh lịch trung niên', 35, 3, 1),
(N'Dép xỏ ngón nữ thoải mái', N'Dép xỏ ngón nhẹ nhàng, thiết kế tiện lợi trung niên', 40, 3, 1),
(N'Áo khoác len nữ dáng dài', N'Áo khoác len mềm, phù hợp cho những ngày se lạnh trung niên', 15, 3, 1),
(N'Mũ lưỡi trai nữ thời trang', N'Mũ lưỡi trai tiện lợi, phù hợp cho hoạt động ngoài trời trung niên', 25, 3, 1),

-- Mức giá 500000-750000
-- nam

(N'Áo len cổ tròn cao cấp', N'Áo len dành cho mùa thu đông, thiết kế tối giản trung niên', 20, 3, 1),
(N'Quần jeans nam trung niên', N'Quần jeans co giãn tốt, thích hợp mặc hàng ngày trung niên', 30, 3, 1),
(N'Giày da lười nam', N'Giày da cao cấp, thiết kế đơn giản, dễ phối đồ trung niên', 10, 3, 1),
(N'Áo khoác gió nam trung niên', N'Áo khoác gió nhẹ, chống nắng tốt trung niên', 25, 3, 1),
(N'Túi đeo chéo da bò', N'Túi đeo chéo đơn giản, làm từ da bò thật trung niên', 15, 3, 1),
-- nữ
(N'Váy hoa nữ trung niên', N'Váy hoa nhẹ nhàng, dễ mặc và thoải mái trung niên', 12, 3, 1),
(N'Quần vải nữ ', N'Quần vải mềm mại, thích hợp cho nữ trung niên', 25, 3, 1),
(N'Giày bệt nữ trung niên', N'Giày bệt thoải mái, thiết kế đơn giản cho nữ trung niên', 20, 3, 1),
(N'Áo khoác cardigan nữ', N'Áo khoác len mỏng, phù hợp với thời tiết mát mẻ trung niên', 18, 3, 1),
(N'Mũ rộng vành nữ', N'Mũ rộng vành cho nữ, thích hợp cho các chuyến du lịch trung niên', 22, 3, 1),

-- Mức giá 800000-2000000
-- nam
(N'Áo vest nam trung niên', N'Áo vest sang trọng, thiết kế lịch lãm cho nam trung niên', 10, 3, 1),
(N'Quần âu nam trung niên', N'Quần âu chất lượng cao, thiết kế ôm vừa vặn trung niên', 15, 3, 1),
(N'Giày da cao cấp nam', N'Giày da lịch lãm, phù hợp cho các sự kiện quan trọng trung niên', 8, 3, 1),
(N'Áo khoác da nam', N'Áo khoác da thật, bền đẹp với thời gian trung niên', 5, 3, 1),
(N'Túi da nam', N'Túi da cầm tay, phù hợp cho phong cách lịch lãm trung niên', 12, 3, 1),
-- nữ
(N'Áo đơn giản', N'thiết kế tinh tế cho nữ trung niên', 8, 3, 1),
(N'Váy ở nhà', N'tạo sự thoải mái và thanh lịch trung niên', 10, 3, 1),
(N'Quần nữ trung niên', N'vừa phải, thiết kế đơn giản mà đẹp mắt trung niên', 7, 3, 1),
(N'Quần ở nhà', N' gọn, thanh lịch cho nữ trung niên', 5, 3, 1),
(N'Áo khoác dạ nữ', N'Áo khoác dạ ấm áp, thích hợp cho mùa đông trung niên', 12, 3, 1);

-- Sản phẩm cho sở thích "Thời trang du lịch" Trung niên từ 38 đến 60 tuổi 
INSERT INTO SanPham (TenSanPham, MoTa, SoLuongDaBan, DanhMucID, KichHoat) 
VALUES 
-- Mức giá 15000-400000

(N'Áo gió du lịch nam chống thấm nước', N'Thiết kế năng động, thích hợp cho các chuyến đi trung niên', 0, 4, 1),
(N'Quần ngắn du lịch nam thoáng mát', N'Tiện dụng trong mọi chuyến đi dài ngày trung niên', 0, 4, 1),
(N'Giày lười nam thoáng khí', N'Giày tiện dụng, phong cách cho những buổi dạo phố trung niên', 0, 4, 1),
(N'Mũ chống nắng nam thoáng mát', N'Phù hợp cho các hoạt động ngoài trời trung niên', 0, 4, 1),
(N'Túi đeo chéo nam chống nước', N'Tiện lợi và phong cách cho chuyến du lịch trung niên', 0, 4, 1),

(N'Áo khoác du lịch nữ chống nắng', N'Thiết kế nhẹ, chống nắng hiệu quả trung niên', 0, 4, 1),
(N'Quần vải du lịch nữ co giãn', N'Dễ chịu khi vận động trong các chuyến đi trung niên', 0, 4, 1),
(N'Giày sandal nữ thoáng mát', N'Sandal nhẹ nhàng, phù hợp với nhiều loại địa hình trung niên', 0, 4, 1),
(N'Túi xách', N'Thời trang phù hợp đi dạo trung niên', 0, 4, 1),
(N'Túi đeo chéo nữ chống nước', N'Túi nhỏ gọn nhưng đầy tiện dụng trung niên', 0, 4, 1),

-- Mức giá 500000-750000

(N'Quần áo du lịch nam đa năng', N'Chống gió, chống nước phù hợp mọi địa hình trung niên', 0, 4, 1),
(N'Quần du lịch nam chống nước', N'Thiết kế tiện dụng, chống thấm hiệu quả trung niên', 0, 4, 1),
(N'Giày trekking nam chống trượt', N'Phù hợp cho những chuyến leo núi trung niên', 0, 4, 1),
(N'Mũ vành du lịch nam', N'Chống nắng, thoáng khí cho những chuyến dã ngoại trung niên', 0, 4, 1),
(N'Balo du lịch nam chống nước', N'Thiết kế rộng rãi, dễ dàng di chuyển trung niên', 0, 4, 1),

(N'Áo du lịch nữ chống gió', N'Thiết kế nhẹ, dễ gấp gọn mang theo trung niên', 0, 4, 1),
(N'Quần jean du lịch nữ co giãn', N'Tiện lợi trong các hoạt động ngoài trời trung niên', 0, 4, 1),
(N'Giày thể thao nữ chống trượt', N'Phù hợp mọi địa hình, bảo vệ đôi chân trung niên', 0, 4, 1),
(N'Túi đeo du lịch nữ chống nước', N'Dễ dàng mang theo trong các chuyến đi trung niên', 0, 4, 1),
(N'Mũ chống nắng du lịch nữ', N'Chống nắng tốt, thiết kế nữ tính trung niên', 0, 4, 1),

-- Mức giá 800000-2000000

(N'Áo khoác du lịch cao cấp', N'Chất liệu cao cấp, bảo vệ cơ thể khỏi thời tiết khắc nghiệt trung niên', 0, 4, 1),
(N'Quần trekking nam chuyên dụng', N'Quần chống nước, bảo vệ đôi chân trung niên', 0, 4, 1),
(N'Bình nam cao cấp', N'Chất liệu bền trung niên', 0, 4, 1),
(N'Mũ du lịch nam', N'Bảo vệ đầu trong những chuyến leo núi khó khăn trung niên', 0, 4, 1),
(N'Balo du lịch nam đa năng', N'Balo cỡ lớn, có nhiều ngăn tiện lợi trung niên', 0, 4, 1),

(N'Áo quần du lịch nữ cao cấp', N'Phong cách thời trang trung niên', 0, 4, 1),
(N'Quần trekking nữ co giãn', N'Quần bảo vệ, giúp thoải mái di chuyển trung niên', 0, 4, 1),
(N'Giày nice nữ chống trượt', N'Giày chuyên dụng cho những chuyến leo núi trung niên', 0, 4, 1),
(N'Mũ du lịch nữ thời trang', N'Mũ thiết kế bảo vệ khỏi ánh nắng mặt trời trung niên', 0, 4, 1),
(N'Túi du lịch nữ cao cấp', N'Túi lớn đa năng, thích hợp cho chuyến đi xa trung niên', 0, 4, 1);

-- Sản phẩm cho sở thích "Thời trang hot trend" Trung niên từ 38 đến 60 tuổi
INSERT INTO SanPham (TenSanPham, MoTa, SoLuongDaBan, DanhMucID, KichHoat)
VALUES 
-- Mức giá 15000-400000

(N'Quần vải co giãn', N'Thời trang thoải mái cho hoạt động hàng ngày trung niên', 0, 5, 1),
(N'Quần boki nam trung niên', N'Phong cách trẻ trung nhưng lịch sự trung niên', 0, 5, 1),
(N'kính mắt da nam chống trượt', N'Lịch lãm, phù hợp cho cả công sở và dạo phố trung niên', 0, 5, 1),
(N'Áo khoác nam giữ nhiệt cổ điển', N'Áo len ấm áp cho mùa đông, phong cách cổ điển trung niên', 0, 5, 1),
(N'Mũ nồi nam phong cách retro', N'Thời trang retro, tạo điểm nhấn trung niên', 0, 5, 1),

(N'Áo khoác nữ trung niên dạ tweed', N'Sang trọng, giữ ấm trong mùa đông trung niên', 0, 5, 1),
(N'Quần âu nữ trung niên', N'Phong cách công sở lịch sự, thoải mái trung niên', 0, 5, 1),
(N'Giày cao gót nữ êm chân', N'Giày cao gót dành cho các sự kiện và công sở trung niên', 0, 5, 1),
(N'Áo len nữ mỏng giữ ấm', N'Áo len mỏng, thích hợp cho mùa thu và đông trung niên', 0, 5, 1),
(N'Mũ lưỡi trai nữ phong cách năng động', N'Thời trang đơn giản nhưng năng động trung niên', 0, 5, 1),
-- Mức giá 500000-750000

(N'Áo sơ mi nam trung niên cao cấp', N'Chất liệu cotton cao cấp, thoáng mát trung niên', 0, 5, 1),
(N'Quần kaki nam chống nhăn', N'Phong cách lịch lãm, chống nhăn hiệu quả trung niên', 0, 5, 1),
(N'kính tây nam da thật', N'Lịch lãm cho sự kiện và công việc trung niên', 0, 5, 1),
(N'Áo cashmere nam', N'Chất liệu cashmere mềm mại, sang trọng trung niên', 0, 5, 1),
(N'Mũ cho nam cao cấp', N'Phong cách cổ điển nhưng thời trang trung niên', 0, 5, 1),

(N'Áo sơ mi nữ ren', N'Thời trang nữ trung niên với phong cách sang trọng trung niên', 0, 5, 1),
(N'Quần vải nữ trung niên', N'Quần vải cao cấp, thoải mái và trang nhã trung niên', 0, 5, 1),
(N'Giày cao nữ trung niên cao cấp', N'bền và sang trọng trung niên', 0, 5, 1),
(N'Áo thể thao dệt kim nữ', N'Chất liệu dệt kim thoải mái trung niên', 0, 5, 1),
(N'Mũ nữ thời trang', N'Phù hợp cho đi dạo và nghỉ dưỡng trung niên', 0, 5, 1),

-- Mức giá 800000-2000000

(N'Áo vest nam cao cấp', N'Áo vest phong cách doanh nhân lịch lãm trung niên', 0, 5, 1),
(N'Quần âu nam chống thấm nước', N'Quần âu cao cấp với công nghệ chống thấm trung niên', 0, 5, 1),
(N'Giày lười nam da cao cấp', N'Giày lười da thật, thoải mái và sang trọng trung niên', 0, 5, 1),
(N'Áo dạ nam dài', N'Áo khoác dạ phong cách Hàn Quốc trung niên', 0, 5, 1),
(N'Mũ da cao cấp', N'Thời trang độc đáo và sang trọng trung niên', 0, 5, 1),

(N'Áo thể thao dạ nữ nhanh khô', N'Nhanh khô thoáng mát trung niên', 0, 5, 1),
(N'Quần âu nữ chất liệu cashmere', N'Chất liệu cashmere cao cấp, mềm mại và thoải mái trung niên', 0, 5, 1),
(N'Giày cao gót nữ da thật', N'Giày cao gót da thật, phù hợp cho các dịp đặc biệt trung niên', 0, 5, 1),
(N' cashmere nữ', N'siêu bền trung niên', 0, 5, 1),
(N'Mũ len cao cấp nữ', N'Phù hợp cho mùa đông và các chuyến du lịch trung niên', 0, 5, 1);

-- Sản phẩm cho sở thích "Thể thao" Cao tuổi từ 60 tuổi trở lên
INSERT INTO SanPham (TenSanPham, MoTa, SoLuongDaBan, DanhMucID, KichHoat)
VALUES
-- Mức giá 15000-400000

(N'Áo thể thao Nam thoáng khí', N'Thể thao năng động cao tuổi', 0, 1, 1),
(N'Quần thể thao Nam thoáng khí', N'Thể thao năng động cao tuổi', 0, 1, 1),
(N'Giày thể thao Nam siêu nhẹ', N'Thể thao năng động cao tuổi', 0, 1, 1),
(N'Quần short thể thao nam xuất khẩu Kappa chất liệu polyester cao cấp', N'Thể thao năng động cao tuổi', 0, 1, 1),
(N'Mũ lưỡi trai', N'Thể thao năng động cao tuổi', 0, 1, 1),

(N'Áo thể thao Nữ thoáng khí', N'Thể thao năng động cao tuổi', 0, 1, 1),
(N'Quần thể thao Nữ thoáng khí', N'Thể thao năng động cao tuổi', 0, 1, 1),
(N'Giày thể thao Nữ siêu nhẹ', N'Thể thao năng động cao tuổi', 0, 1, 1),
(N'Quần sort thể thao Nữ xuất khẩu Kappa chất liệu polyester cao cấp', N'Thể thao năng động cao tuổi', 0, 1, 1),
(N'Mũ', N'Thể thao năng động cao tuổi', 0, 1, 1),
-- Mức giá 500000-750000

(N'Áo thể thao Nam cao cấp', N'Thể thao năng động cao tuổi', 0, 1, 1),
(N'Quần thể thao Nam cao cấp', N'Thể thao năng động cao tuổi', 0, 1, 1),
(N'Giày thể thao Nam siêu nhẹ cao cấp', N'Thể thao năng động cao tuổi', 0, 1, 1),
(N'Quần short thể thao nam xuất khẩu Kappa chất liệu polyester cao cấp', N'Thể thao năng động cao tuổi', 0, 1, 1),
(N'Mũ lưỡi trai cao cấp', N'Thể thao năng động cao tuổi', 0, 1, 1),

(N'Áo thể thao Nữ cao cấp', N'Thể thao năng động cao tuổi', 0, 1, 1),
(N'Áo dưỡng sinh thể thao Nữ cao cấp', N'Thể thao năng động cao tuổi', 0, 1, 1),
(N'Giày thể thao Nữ siêu nhẹ cao cấp', N'Thể thao năng động cao tuổi', 0, 1, 1),
(N'Quần áo thể thao Nữ cao cấp', N'Thể thao nhẹ nhàng cao tuổi', 0, 1, 1),
(N'Mũ lưỡi trai Nữ cotton', N'Thể thao năng động cao tuổi', 0, 1, 1),
-- Mức giá 800000-2000000

(N'Áo thể thao Nam cao cấp đặc biệt', N'Thể thao năng động cao tuổi', 0, 1, 1),
(N'Quần áo thể thao Nam cao cấp đặc biệt', N'Thể thao năng động cao tuổi', 0, 1, 1),
(N'Giày thể thao Nam siêu nhẹ đặc biệt', N'Thể thao năng động cao tuổi', 0, 1, 1),
(N'Quần short thể thao nam cao cấp đặc biệt', N'Thể thao vừa phải phù hợp  cao tuổi', 0, 1, 1),
(N'Mũ lưỡi trai đặc biệt', N'Thể thao năng động cao tuổi', 0, 1, 1),

(N'Áo thể thao Nữ cao cấp đặc biệt', N'Thể thao năng động cao tuổi', 0, 1, 1),
(N'Quần áo thể thao Nữ cao cấp đặc biệt', N'Thể thao năng động cao tuổi', 0, 1, 1),
(N'Giày thể thao Nữ siêu nhẹ đặc biệt', N'Thể thao năng động cao tuổi', 0, 1, 1),
(N'Quần dài đặc biệt', N'Thể thao năng động cao tuổi', 0, 1, 1),
(N'Mũ lưỡi trai đặc biệt', N'Thể thao năng động cao tuổi', 0, 1, 1);
-- Sản phẩm cho sở thích "Công sở, lịch sự" Trung niên từ 60 tuổi trở lên
INSERT INTO SanPham (TenSanPham, MoTa, SoLuongDaBan, DanhMucID, KichHoat)
VALUES 
-- Mức giá 15000-400000

--nam
(N'Áo sơ mi nam thoáng khí', N'Phong cách công sở, dễ chịu cho người cao tuổi', 0, 2, 1),
(N'Quần tây nam công sở', N'Sang trọng và thoải mái cho mọi dịp cao tuổi', 0, 2, 1),
(N'Giày da nam lịch lãm', N'Giày da mềm mại, phù hợp cho người cao tuổi', 0, 2, 1),
(N'Giày nam lịch sự', N'Mẫu giày thời trang cho công sở cao tuổi', 0, 2, 1),
(N'Cặp tài liệu', N'Bảo vệ tốt tài liệu và phong cách cho người cao tuổi', 0, 2, 1),
--nữ
(N'Áo blouse nữ thoáng khí', N'Phong cách thanh lịch, thoải mái cho người cao tuổi', 0, 2, 1),
(N'Quần tây nữ công sở', N'Sang trọng và dễ chịu, phù hợp với mọi vóc dáng cao tuổi', 0, 2, 1),
(N'Giày cao gót nữ thoải mái', N'Giày thời trang giúp tôn dáng cho người cao tuổi', 0, 2, 1),
(N'Váy nữ lịch sự', N'Mẫu váy năng động nhưng vẫn thanh lịch cao tuổi', 0, 2, 1),
(N'Balo thời trang nữ', N'Sản phẩm bảo vệ tốt và thời trang cho người cao tuổi', 0, 2, 1),
-- Mức giá 500000-750000
--nam
(N'Áo vest nam cao cấp', N'Sản phẩm sang trọng dành cao tuổi cho những dịp quan trọng', 0, 2, 1),
(N'Quần tây nam cao cấp', N'Mẫu quần tây được thiết kế tinh tế cao tuổi', 0, 2, 1),
(N'Giày da nam cao cấp', N'Giày lịch lãm, phong cách cho người cao tuổi', 0, 2, 1),
(N'cà vạt nam công sở', N'Mẫu cà vạt thời trang cho người cao tuổi', 0, 2, 1),
(N'Cà vạt nam cao cấp', N'Sản phẩm thời trang cho phong cách công sở cao tuổi', 0, 2, 1),
--nữ
(N'Áo vest nữ cao cấp', N'Sang trọng, phù hợp với mọi dịp gặp mặt cao tuổi', 0, 2, 1),
(N'Quần tây nữ cao cấp', N'Mẫu quần tây thiết kế đẹp, thoải mái cao tuổi', 0, 2, 1),
(N'Giày cao gót nữ cao cấp', N'Giày thanh lịch, dễ đi cho người cao tuổi', 0, 2, 1),
(N'Cà vạt nữ công sở', N'Phong cách và thoải mái cao tuổi', 0, 2, 1),
(N'Giày công sở', N'Sản phẩm thời trang, bảo vệ tốt cho người cao tuổi', 0, 2, 1),
-- Mức giá 800000-2000000
--nam
(N'Áo vest nam đặc biệt', N'Sản phẩm cao cấp cho những sự kiện đặc biệt cao tuổi', 0, 2, 1),
(N'Vest tây nam đặc biệt', N'Mẫu vest tây lịch lãm cho người cao tuổi', 0, 2, 1),
(N'Giày da nam đặc biệt', N'Giày phong cách và thoải mái cho người cao tuổi', 0, 2, 1),
(N'Balo đeo nam đặc biệt', N'Thời trang cho mùa hè cao tuổi', 0, 2, 1),
(N'Giày nam đặc biệt', N'Giúp bảo vệ và thêm phần phong cách cho người cao tuổi', 0, 2, 1),
--nữ
(N'Váy nữ đặc biệt', N'Phong cách sang trọng, phù hợp cho những sự kiện đặc biệt cao tuổi', 0, 2, 1),
(N'Quần tây nữ đặc biệt', N'Mẫu quần tây thanh lịch cho người cao tuổi', 0, 2, 1),
(N'Vest nữ đặc biệt', N'Lịch lãm, tôn dáng cho người cao tuổi', 0, 2, 1),
(N'Vest nữ thời trang', N'Mẫu thời trang cho mùa hè cao tuổi', 0, 2, 1),
(N'Giày búp bê', N'Thời trang và bảo vệ tốt cho người cao tuổi', 0, 2, 1);
-- Sản phẩm cho sở thích "Đơn giản, thường ngày" Cao tuổi từ 60 tuổi trở lên
INSERT INTO SanPham (TenSanPham, MoTa, SoLuongDaBan, DanhMucID, KichHoat) 
VALUES 
-- Mức giá 15000-400000
-- nam
(N'Áo cotton trung niên', N'Áo cotton mềm mại, thoáng mát, phù hợp cho nam cao tuổi', 50, 3, 1),
(N'Quần  đùi nam', N'Quần kaki thoải mái, dễ chịu cho các hoạt động hàng ngày cao tuổi', 35, 3, 1),
(N'Giày thể thao cao cấp nam', N'Giày thể thao nhẹ nhàng, đơn giản và bền bỉ cho nam cao tuổi', 28, 3, 1),
(N'Áo dài tay nam', N'Áo thun giữ ấm tốt, phù hợp mặc vào mùa thu đông cao tuổi', 18, 3, 1),
(N'Dép da thoáng khí', N'Dép da thoáng khí, nhẹ nhàng phù hợp với thời tiết nóng cao tuổi', 45, 3, 1),
-- nữ
(N'Áo khoác nhẹ nữ', N'Áo khoác nhẹ, dễ dàng phối đồ, phù hợp với thời tiết mát mẻ cao tuổi', 32, 3, 1),
(N'Váy dài trung niên', N'Váy dài nhẹ nhàng, phù hợp với phong cách thanh lịch của nữ cao tuổi', 20, 3, 1),
(N'Dép bệt nữ', N'Dép bệt nữ thoải mái, dễ dàng mang đi dạo hay ở nhà cao tuổi', 38, 3, 1),
(N'Áo thun nhẹ', N'Áo thun mềm mỏng cho nữ cao tuổi, phù hợp khi thời tiết hè', 22, 3, 1),
(N'Mũ len nữ cao tuổi', N'Mũ len mềm mại, giữ ấm tốt vào mùa đông cao tuổi', 25, 3, 1),

-- Mức giá 500000-750000
-- nam
(N'Áo ấm nam cao cấp', N'Áo ấm cao cấp, phù hợp cho thời tiết lạnh, thiết kế cổ điển cao tuổi', 20, 3, 1),
(N'Quần đen nam', N'Quần cho nam giới, dễ chịu, bền bỉ cao tuổi', 27, 3, 1),
(N'Giày thể thao nam đơn giản', N'Giày thể thao nhẹ nhàng, thoáng khí, phù hợp cho người cao tuổi', 12, 3, 1),
(N'Áo khoác mỏng gió nam', N'Áo khoác gió nhẹ, chống nắng và bảo vệ sức khỏe tốt cao tuổi', 18, 3, 1),
(N'Áo có cổ nam nhỏ gọn', N'mềm mại, kích thước vừa phải, phù hợp cho nam cao tuổi', 15, 3, 1),
-- nữ
(N'áo suông họa tiết', N'Váy suông với họa tiết nhẹ nhàng, đơn giản nhưng trang nhã cao tuổi', 18, 3, 1),
(N'Quần vải nữ', N'Quần vải mềm, thoáng mát cho nữ cao tuổi', 22, 3, 1),
(N'Dép  lười nữ', N'Dép lười tiện lợi, nhẹ nhàng và thoải mái cao tuổi', 14, 3, 1),
(N'Áo cardigan  nữ', N'Áo  cardigan đơn giản, phù hợp mặc trong mùa thu cao tuổi', 10, 3, 1),
(N'Khăn len ấm áp', N'khăn len giữ ấm, thiết kế gọn nhẹ, dễ sử dụng cao tuổi', 25, 3, 1),

-- Mức giá 800000-2000000
-- nam
(N'Áo thun trung niên cao cấp', N'Áo thun cao cấp, phù hợp cho các dịp trang trọng cao tuổi', 7, 3, 1),
(N'Quần âu cao cấp nam', N'Quần âu vừa vặn, làm từ chất liệu cao cấp, thoải mái cao tuổi', 18, 3, 1),
(N'Dép sang trọng', N'  thiết kế tối giản, phù hợp với nhiều phong cách cao tuổi', 5, 3, 1),
(N'Áo khoác da thật', N'Áo khoác da sang trọng, bền bỉ với thời gian cao tuổi', 8, 3, 1),
(N'kính sang trọng', N' phù hợp cho phong cách lịch lãm cao tuổi', 10, 3, 1),
-- nữ
(N'Áo vest nữ cao cấp', N'Áo vest nữ với chất liệu cao cấp, thiết kế tối giản mà tinh tế cao tuổi', 5, 3, 1),
(N'Váy công sở nữ', N'Váy công sở cao cấp, thoải mái và sang trọng cao tuổi', 8, 3, 1),
(N'Dép nhập khẩu', N'dép nhập khẩu thoải mái, phù hợp cho nữ cao tuổi', 9, 3, 1),
(N'Áo khoác len nữ', N'Áo khoác len sang trọng, ấm áp và dễ dàng phối đồ cao tuổi', 15, 3, 1), 
(N'Túi da nữ sang trọng', N'Túi da nhỏ gọn, phù hợp với phong cách nữ cao tuổi', 12, 3, 1);
-- Sản phẩm cho sở thích "Thời trang du lịch" Cao tuổi từ 60 tuổi trở lên
INSERT INTO SanPham (TenSanPham, MoTa, SoLuongDaBan, DanhMucID, KichHoat)
VALUES 
-- Mức giá 150000-400000
-- nam
(N'Áo khoác du lịch chống nắng Nam', N'Áo khoác nhẹ, thoáng khí, bảo vệ khỏi nắng, thích hợp cho cao tuổi các chuyến đi ngắn ngày.', 50, 4, 1),
(N'Quần dài du lịch Nam co giãn', N'Quần dài với khả năng co giãn, thoải mái cho người cao tuổi khi di chuyển.', 50, 4, 1),
(N'Áo du lịch Nam thoáng khí', N'Dễ mang, thích hợp cho người cao tuổi trong các chuyến đi dạo.', 50, 4, 1),
(N'Mũ du lịch Nam', N'Mũ rộng vành, bảo vệ khỏi nắng và dễ dàng mang theo khi di chuyển.cao tuổi', 50, 4, 1),
(N'Bộ du lịch Nam', N'Dành cho người cao tuổi', 50, 4, 1),
-- nữ
(N'Áo khoác gió du lịch Nữ', N'Áo khoác nhẹ, phù hợp cho cao tuổi các chuyến đi đường dài với khả năng chống gió tốt.', 50, 4, 1),
(N'Quần áo du lịch Nữ có lót ấm', N'Quần có lót giữ ấm bên trong, lý tưởng cho người cao tuổi khi đi du lịch vào mùa lạnh.', 50, 4, 1),
(N'Giày bệt du lịch Nữ thoải mái', N'Giày bệt với lớp lót mềm mại, giúp đôi chân thoải mái trong các chuyến đi dài. cao tuổi', 50, 4, 1),
(N'Mũ du và quần áo lịch Nữ chống nắng', N'Mũ rộng vành, chống nắng tốt, tiện lợi cho người cao tuổi khi tham gia các hoạt động ngoài trời.', 50, 4, 1),
(N'Túi xách du lịch Nữ thời trang', N'Túi xách nhỏ gọn, kiểu dáng thanh lịch, phù hợp cho người cao tuổi trong các chuyến đi.', 50, 4, 1),
-- Mức giá 500000-750000
-- nam
(N'Áo chống thấm nước Nam', N'Áo chống thấm nước, giữ ấm tốt, phù hợp cho các chuyến du lịch dài ngày.cao tuổi', 50, 4, 1),
(N'Giày trekking Nam chống nước', N'Trekking, chống thấm tốt, co giãn thoải mái khi leo núi.cao tuổi', 50, 4, 1),
(N'Giày trekking Nam cao cấp', N'Giày trekking chống nước, phù hợp cho địa hình gồ ghề và điều kiện thời tiết khắc nghiệt.cao tuổi', 50, 4, 1),
(N'Mũ du lịch Nam cao cấp', N'Mũ thời trang, bảo vệ tốt khỏi ánh nắng, phù hợp cho mọi chuyến đi xa.cao tuổi', 50, 4, 1),
(N'Giày Nam cao cấp', N'Giày chống nước, phù hợp cho địa hình gồ ghề và điều kiện thời tiết khắc nghiệt.cao tuổi', 50, 4, 1),
-- nữ
(N'Áo quần c Nữ', N'Áo khoác tốt, lý tưởng cho các chuyến du lịch dài ngày.cao tuổi', 50, 4, 1),
(N'Quần trekking Nữ chống thấm', N'Quần trekking chống thấm, co giãn và thoải mái khi di chuyển trên các địa hình phức tạp.cao tuổi', 50, 4, 1),
(N'Giày trekking Nữ cao cấp', N'Giày trekking thiết kế nhẹ, chống trơn trượt, phù hợp cho các hoạt động ngoài trời.', 50, 4, 1),
(N'Túi xách du lịch Nữ thời trang cao cấp', N'Túi xách với thiết kế cao cấp, tiện lợi và thời trang.cao tuổi', 50, 4, 1),
(N'Túi du lịch Nữ thời trang cao cấp', N'Túi xách với thiết kế cao cấp, tiện lợi và thời trang.cao tuổi', 50, 4, 1),
-- Mức giá 800000-2000000
-- nam
(N'Áo khoác du lịch chống gió Nam cao cấp', N'Áo khoác cao cấp, giữ ấm tốt và chống gió, thích hợp cho người cao tuổi.', 50, 4, 1),
(N'Quần trekking Nam chất liệu cao cấp', N'Quần trekking chống nước, thoải mái và bền bỉ cho các chuyến đi dài.cao tuổi', 50, 4, 1),
(N'Giày trekking Nam cao cấp chính hãng', N'Giày chính hãng, hỗ trợ di chuyển trên các địa hình khó khăn.cao tuổi', 50, 4, 1),
(N'Áo len du lịch chống gió Nam cao cấp', N'Áo khoác cao cấp, giữ ấm tốt và chống gió, thích hợp cho người cao tuổi.', 50, 4, 1),
(N'Áo du lịch chống gió Nam cao cấp', N'Áo khoác cao cấp, giữ ấm tốt và chống gió, thích hợp cho người cao tuổi.', 50, 4, 1),
-- nữ
(N'Áo khoác giữ nhiệt Nữ', N'Áo khoác giữ nhiệt, lý tưởng cho người cao tuổi khi đi du lịch trong thời tiết lạnh.', 50, 4, 1),
(N'Giày trekking Nữ chất liệu cao cấp', N'Giày trekking với thiết kế hỗ trợ đôi chân, bền bỉ và chống trơn trượt.cao tuổi', 50, 4, 1),
(N'Áo du lịch Nữ chống nước', N'Áo du lịch nhẹ, chống nước, giúp bảo vệ đồ dùng cá nhân trong các chuyến đi.cao tuổi', 50, 4, 1),
(N'Bộ quần áo du lịch Nữ', N'Du lịch nhẹ, giúp bảo vệ đồ dùng cá nhân trong các chuyến đi.cao tuổi', 50, 4, 1),
(N'Túi du lịch Nữ chống nước', N'Túi du lịch nhẹ, chống nước, giúp bảo vệ đồ dùng cá nhân trong các chuyến đi.cao tuổi', 50, 4, 1);
-- Sản phẩm cho sở thích "Thời trang hot trend" Cao tuổi từ 60 tuổi trở lên
INSERT INTO SanPham (TenSanPham, MoTa, SoLuongDaBan, DanhMucID, KichHoat)
VALUES 
-- Mức giá 15000-400000
-- nam
(N'Áo vest trung niên phong cách', N'Phong cách lịch lãm, phù hợp cho cao tuổi các buổi gặp gỡ và du lịch.', 50, 5, 1),
(N'Quần dài kaki nam trung niên', N'Tạo cảm giác thoải mái, phù hợp cho cao tuổi mọi hoạt động hàng ngày.', 50, 5, 1),
(N'Giày da nam thời trang', N'Mang lại sự thoải mái và vẻ ngoài tinh tế trong những buổi gặp mặt.cao tuổi', 50, 5, 1),
(N'Áo sơ mi nam cao cấp', N'Mềm mại và thoáng mát, phù hợp cho khí hậu nhiệt đới.cao tuổi', 50, 5, 1),
(N'Mũ sendo nam', N'Giúp bảo vệ khỏi nắng và tạo điểm nhấn trẻ trung cho người cao tuổi.', 50, 5, 1),
-- nữ
(N'Áo khoác mỏng nữ', N'Thiết kế gọn nhẹ, dễ phối đồ, phù hợp khi đi dạo phố.cao tuổi', 50, 5, 1),
(N'Quần dài nữ trung niên sang trọng', N'Mềm mại, dễ chịu, mang lại sự thoải mái tối đa.cao tuổi', 50, 5, 1),
(N'Giày cao gót nữ thời trang', N'Nhẹ nhàng, phù hợp cho mọi hoạt động hằng ngày.cao tuổi', 50, 5, 1),
(N'Áo Kháoc nữ đơn giản', N'Thời trang và tiện lợi, dễ dàng phối hợp trong các hoạt động ngoài trời.cao tuổi', 50, 5, 1),
(N'Mũ vành', N'Thời trang và bảo vệ tốt khi đi dưới trời nắng.cao tuổi', 50, 5, 1),
 -- Mức giá 500000-750000

(N'Áo somi nam trung niên cao cấp', N'Thiết kế sang trọng, phù hợp với các dịp đặc biệt. cao tuổi', 50, 5, 1),
(N'Quần áo thể thao nam cao cấp', N'Chất liệu bền bỉ, thích hợp cho các chuyến đi xa. cao tuổi', 50, 5, 1),
(N'Giày da nam cao cấp chính hãng', N'Giày dép mang lại phong cách và sự thoải mái. cao tuổi', 50, 5, 1),
(N'kính cho lớn tuổi nam', N'Thời trang và thanh lịch, phù hợp cho môi trường công sở. cao tuổi', 50, 5, 1),
(N'Mũ lưỡi trai cao cấp nam', N'Tiện dụng và thời trang, bảo vệ khỏi ánh nắng mặt trời. cao tuổi', 50, 5, 1),

(N'Áo vest nữ trung niên thanh lịch', N'Phong cách nhẹ nhàng, dễ dàng phối đồ với váy hoặc quần. cao tuổi', 50, 5, 1),
(N'Quần dài nữ cao cấp', N'Chất liệu cao cấp, bền đẹp và mềm mại. cao tuổi', 50, 5, 1),
(N'Áo nữ chính hãng', N'Đem lại phong cách quyến rũ và tự tin trong mọi bước chân. cao tuổi', 50, 5, 1),
(N'Áo phông nữ cao cấp', N'Vải cao cấp, tạo sự thoải mái trong các hoạt động hằng ngày. cao tuổi', 50, 5, 1),
(N'Mũ trùm lớn tuổi', N'Thời trang và tiện lợi, hoàn hảo cho các chuyến du lịch. cao tuổi', 50, 5, 1),
-- Mức giá 800000-2000000

(N'Mũ mỏ vịt trung niên chất liệu cao cấp', N'Chất liệu bền bỉ, phong cách sang trọng cho các sự kiện. cao tuổi', 50, 5, 1),
(N'Kính mắt mát mẻ trung niên cao cấp', N'Thiết kế thoáng mát, giúp bạn luôn thoải mái trong các hoạt động. cao tuổi', 50, 5, 1),
(N'Giày tây nam cao cấp chính hãng', N'Phong cách lịch lãm, kết hợp hoàn hảo giữa sự thoải mái và thời trang. cao tuổi', 50, 5, 1),
(N'Quần short nam chất liệu cao cấp', N'Thích hợp cho mùa hè, tạo cảm giác thoải mái nhất. cao tuổi', 50, 5, 1),
(N'Mũ kaor vành nam cao cấp', N'Phong cách thời thượng và bảo vệ hiệu quả dưới nắng. cao tuổi', 50, 5, 1),

(N'Áo nhập khẩu trung quốc nữ chất liệu cao cấp', N'Chống nắng, tạo phong cách sang trọng. cao tuổi', 50, 5, 1),
(N'Quần dài nữ chất liệu cao cấp', N'Đem lại sự thoải mái tối đa trong mọi hoạt động. cao tuổi', 50, 5, 1),
(N'áo ba lỗ nữ cao cấp chính hãng', N'Thiết kế sang trọng, tạo phong cách nổi bật khi thể thao. cao tuổi', 50, 5, 1), 
(N'Váy nữ chất liệu cao cấp', N'Combo dạ hội. cao tuổi', 50, 5, 1),
(N'Mũ vải len', N'Thời trang và bảo vệ tốt nhất trong những chuyến đi. cao tuổi', 50, 5, 1);


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

-- Dữ liệu train phân khúc khách hàng Thanh niên từ 0 đến 37 tuổi chi tiêu thấp
INSERT INTO NguoiDung (TenDangNhap,MatKhau, DoTuoi, MucChiTieu, SoThich , Train) VALUES 
(N'TDNN001','123',23, 19000000, N'Thể thao', 1),
(N'TDNN002','123',19, 14000000, N'Công sở, lịch sự', 1),
(N'TDNN003','123',32, 20000000, N'Đơn giản, thường ngày', 1),
(N'TDNN004','123',27, 5000000, N'Thời trang du lịch', 1),
(N'TDNN005','123',28, 20000000, N'Thời trang hot trend', 1),
(N'TDNN006','123',24, 9000000, N'Thể thao', 1),
(N'TDNN007','123',34, 10000000, N'Công sở, lịch sự', 1),
(N'TDNN008','123',22, 19000000, N'Đơn giản, thường ngày', 1),
(N'TDNN009','123',22, 12000000, N'Thời trang du lịch', 1),
(N'TDNN0010','123',28, 18000000, N'Thời trang hot trend', 1),
(N'TDNN0011','123',23, 19000000, N'Thể thao', 1),
(N'TDNN0012','123',22, 9000000, N'Công sở, lịch sự', 1),
(N'TDNN0013','123',25, 6000000, N'Đơn giản, thường ngày', 1),
(N'TDNN0014','123',22, 18000000, N'Thời trang du lịch', 1),
(N'TDNN0015','123',21, 10000000, N'Thời trang hot trend', 1),
(N'TDNN0016','123',27, 18000000, N'Thể thao', 1),
(N'TDNN0017','123',31, 17000000, N'Công sở, lịch sự', 1),
(N'TDNN0018','123',19, 6000000, N'Đơn giản, thường ngày', 1),
(N'TDNN0019','123',33, 12000000, N'Thời trang du lịch', 1),
(N'TDNN0020','123',25, 12000000, N'Thời trang hot trend', 1),
(N'TDNN0021','123',26, 15000000, N'Thể thao', 1),
(N'TDNN0022','123',32, 14000000, N'Công sở, lịch sự', 1),
(N'TDNN0023','123',28, 18000000, N'Đơn giản, thường ngày', 1),
(N'TDNN0024','123',18, 16000000, N'Thời trang du lịch', 1),
(N'TDNN0025','123',34, 8000000, N'Thời trang hot trend', 1),
(N'TDNN0026','123',21, 7000000, N'Thể thao', 1),
(N'TDNN0027','123',28, 17000000, N'Công sở, lịch sự', 1),
(N'TDNN0028','123',34, 11000000, N'Đơn giản, thường ngày', 1),
(N'TDNN0029','123',18, 13000000, N'Thời trang du lịch', 1),
(N'TDNN0030','123',26, 9000000, N'Thời trang hot trend', 1),
(N'TDNN0031','123',30, 5000000, N'Thể thao', 1),
(N'TDNN0032','123',19, 9000000, N'Công sở, lịch sự', 1),
(N'TDNN0033','123',20, 9000000, N'Đơn giản, thường ngày', 1),
(N'TDNN0034','123',20, 8000000, N'Thời trang du lịch', 1),
(N'TDNN0035','123',24, 16000000, N'Thời trang hot trend', 1),
(N'TDNN0036','123',28, 17000000, N'Thể thao', 1),
(N'TDNN0037','123',31, 10000000, N'Công sở, lịch sự', 1),
(N'TDNN0038','123',31, 12000000, N'Đơn giản, thường ngày', 1),
(N'TDNN0039','123',18, 14000000, N'Thời trang du lịch', 1),
(N'TDNN0040','123',18, 17000000, N'Thời trang hot trend',1);
-- Dữ liệu train phân khúc khách hàng Thanh niên từ 0 đến 37 tuổi chi tiêu vừa phải
INSERT INTO NguoiDung (TenDangNhap,MatKhau, DoTuoi, MucChiTieu, SoThich, Train) VALUES 
(N'TDNN0041','123', 18, 38000000, N'Thể thao', 1),
(N'TDNN0042','123', 23, 50000000, N'Công sở, lịch sự', 1),
(N'TDNN0043','123', 33, 59000000, N'Đơn giản, thường ngày', 1),
(N'TDNN0044','123', 22, 45000000, N'Thời trang du lịch', 1),
(N'TDNN0045','123', 23, 52000000, N'Thời trang hot trend', 1),
(N'TDNN0046','123', 33, 52000000, N'Thể thao', 1),
(N'TDNN0047','123', 31, 41000000, N'Công sở, lịch sự', 1),
(N'TDNN0048','123', 30, 31000000, N'Đơn giản, thường ngày', 1),
(N'TDNN0049','123', 29, 56000000, N'Thời trang du lịch', 1),
(N'TDNN0050','123', 26, 39000000, N'Thời trang hot trend', 1),
(N'TDNN0051','123', 20, 31000000, N'Thể thao', 1),
(N'TDNN0052','123', 31, 49000000, N'Công sở, lịch sự', 1),
(N'TDNN0053','123', 19, 35000000, N'Đơn giản, thường ngày', 1),
(N'TDNN0054','123', 34, 60000000, N'Thời trang du lịch', 1),
(N'TDNN0055','123', 32, 35000000, N'Thời trang hot trend', 1),
(N'TDNN0056','123', 20, 44000000, N'Thể thao', 1),
(N'TDNN0057','123', 23, 36000000, N'Công sở, lịch sự', 1),
(N'TDNN0058','123', 26, 52000000, N'Đơn giản, thường ngày', 1),
(N'TDNN0059','123', 30, 32000000, N'Thời trang du lịch', 1),
(N'TDNN0060','123', 32, 54000000, N'Thời trang hot trend', 1),
(N'TDNN0061','123', 32, 47000000, N'Thể thao', 1),
(N'TDNN0062','123', 18, 37000000, N'Công sở, lịch sự', 1),
(N'TDNN0063','123', 34, 33000000, N'Đơn giản, thường ngày', 1),
(N'TDNN0064','123', 34, 43000000, N'Thời trang du lịch', 1),
(N'TDNN0065','123', 21, 38000000, N'Thời trang hot trend', 1),
(N'TDNN0066','123', 19, 47000000, N'Thể thao', 1),
(N'TDNN0067','123', 30, 37000000, N'Công sở, lịch sự', 1),
(N'TDNN0068','123', 26, 38000000, N'Đơn giản, thường ngày', 1),
(N'TDNN0069','123', 23, 44000000, N'Thời trang du lịch', 1),
(N'TDNN0070','123', 25, 48000000, N'Thời trang hot trend', 1),
(N'TDNN0071','123', 25, 45000000, N'Thể thao', 1),
(N'TDNN0072','123', 22, 58000000, N'Công sở, lịch sự', 1),
(N'TDNN0073','123', 18, 60000000, N'Đơn giản, thường ngày', 1),
(N'TDNN0074','123', 34, 54000000, N'Thời trang du lịch', 1),
(N'TDNN0075','123', 20, 47000000, N'Thời trang hot trend', 1),
(N'TDNN0076','123', 26, 32000000, N'Thể thao', 1),
(N'TDNN0077','123', 26, 57000000, N'Công sở, lịch sự', 1),
(N'TDNN0078','123', 23, 60000000, N'Đơn giản, thường ngày', 1),
(N'TDNN0079','123', 28, 39000000, N'Thời trang du lịch', 1),
(N'TDNN0080','123', 27, 50000000, N'Thời trang hot trend',1);
-- Dữ liệu train phân khúc khách hàng Thanh niên từ 0 đến 37 tuổi chi tiêu cao
INSERT INTO NguoiDung (TenDangNhap,MatKhau, DoTuoi, MucChiTieu, SoThich, Train) VALUES 
(N'TDNN0081','123', 18, 87000000, N'Thể thao', 1),
(N'TDNN0082','123', 34, 77000000, N'Công sở, lịch sự', 1),
(N'TDNN0083','123', 25, 92000000, N'Đơn giản, thường ngày', 1),
(N'TDNN0084','123', 24, 94000000, N'Thời trang du lịch', 1),
(N'TDNN0085','123', 33, 73000000, N'Thời trang hot trend', 1),
(N'TDNN0086','123', 19, 83000000, N'Thể thao', 1),
(N'TDNN0087','123', 28, 89000000, N'Công sở, lịch sự', 1),
(N'TDNN0088','123', 27, 83000000, N'Đơn giản, thường ngày', 1),
(N'TDNN0089','123', 34, 74000000, N'Thời trang du lịch', 1),
(N'TDNN0090','123', 33, 72000000, N'Thời trang hot trend', 1),
(N'TDNN0091','123', 20, 69000000, N'Thể thao', 1),
(N'TDNN0092','123', 32, 97000000, N'Công sở, lịch sự', 1),
(N'TDNN0093','123', 30, 65000000, N'Đơn giản, thường ngày', 1),
(N'TDNN0094','123', 22, 96000000, N'Thời trang du lịch', 1),
(N'TDNN0095','123', 23, 86000000, N'Thời trang hot trend', 1),
(N'TDNN0096','123', 31, 73000000, N'Thể thao', 1),
(N'TDNN0097','123', 22, 87000000, N'Công sở, lịch sự', 1),
(N'TDNN0098','123', 23, 84000000, N'Đơn giản, thường ngày', 1),
(N'TDNN0099','123', 21, 75000000, N'Thời trang du lịch', 1),
(N'TDNN0100','123', 23, 88000000, N'Thời trang hot trend', 1),
(N'TDNN0101','123', 24, 92000000, N'Thể thao', 1),
(N'TDNN0102','123', 24, 83000000, N'Công sở, lịch sự', 1),
(N'TDNN0103','123', 30, 90000000, N'Đơn giản, thường ngày', 1),
(N'TDNN0104','123', 20, 72000000, N'Thời trang du lịch', 1),
(N'TDNN0105','123', 32, 74000000, N'Thời trang hot trend', 1),
(N'TDNN0106','123', 27, 91000000, N'Thể thao', 1),
(N'TDNN0107','123', 22, 93000000, N'Công sở, lịch sự', 1),
(N'TDNN0108','123', 24, 84000000, N'Đơn giản, thường ngày', 1),
(N'TDNN0109','123', 30, 79000000, N'Thời trang du lịch', 1),
(N'TDNN0110','123', 20, 100000000, N'Thời trang hot trend', 1),
(N'TDNN0111','123', 18, 96000000, N'Thể thao', 1),
(N'TDNN0112','123', 23, 84000000, N'Công sở, lịch sự', 1),
(N'TDNN0113','123', 20, 89000000, N'Đơn giản, thường ngày', 1),
(N'TDNN0114','123', 33, 71000000, N'Thời trang du lịch', 1),
(N'TDNN0115','123', 19, 78000000, N'Thời trang hot trend', 1),
(N'TDNN0116','123', 19, 90000000, N'Thể thao', 1),
(N'TDNN0117','123', 31, 71000000, N'Công sở, lịch sự', 1),
(N'TDNN0118','123', 21, 70000000, N'Đơn giản, thường ngày', 1),
(N'TDNN0119','123', 32, 96000000, N'Thời trang du lịch', 1),
(N'TDNN0120','123', 18, 95000000, N'Thời trang hot trend',1);
-- Dữ liệu train phân khúc khách hàng Trung niên từ 38 đến 60 tuổi chi tiêu thấp
INSERT INTO NguoiDung(TenDangNhap,MatKhau, DoTuoi, MucChiTieu, SoThich, Train) VALUES  
(N'TDNN0121','123', 40, 16000000, N'Thể thao', 1), 
(N'TDNN0122','123', 55, 13000000, N'Công sở, lịch sự', 1),
(N'TDNN0123','123', 48, 15000000, N'Đơn giản, thường ngày', 1),
(N'TDNN0124','123', 48, 18000000, N'Thời trang du lịch', 1),
(N'TDNN0125','123', 43, 10000000, N'Thời trang hot trend', 1),
(N'TDNN0126','123', 50, 8000000, N'Thể thao', 1),
(N'TDNN0127','123', 54, 18000000, N'Công sở, lịch sự', 1),
(N'TDNN0128','123', 44, 20000000, N'Đơn giản, thường ngày', 1),
(N'TDNN0129','123', 49, 5000000, N'Thời trang du lịch', 1),
(N'TDNN0130','123', 46, 6000000, N'Thời trang hot trend', 1),
(N'TDNN0131','123', 49, 20000000, N'Thể thao', 1),
(N'TDNN0132','123', 42, 7000000, N'Công sở, lịch sự', 1),
(N'TDNN0133','123', 45, 11000000, N'Đơn giản, thường ngày', 1),
(N'TDNN0134','123', 49, 14000000, N'Thời trang du lịch', 1),
(N'TDNN0135','123', 49, 6000000, N'Thời trang hot trend', 1),
(N'TDNN0136','123', 54, 14000000, N'Thể thao', 1),
(N'TDNN0137','123', 50, 17000000, N'Công sở, lịch sự', 1),
(N'TDNN0138','123', 44, 11000000, N'Đơn giản, thường ngày', 1),
(N'TDNN0139','123', 40, 19000000, N'Thời trang du lịch', 1),
(N'TDNN0140','123', 45, 13000000, N'Thời trang hot trend', 1),
(N'TDNN0141','123', 50, 9000000, N'Thể thao', 1),
(N'TDNN0142','123', 45, 18000000, N'Công sở, lịch sự', 1),
(N'TDNN0143','123', 48, 5000000, N'Đơn giản, thường ngày', 1),
(N'TDNN0144','123', 40, 17000000, N'Thời trang du lịch', 1),
(N'TDNN0145','123', 43, 14000000, N'Thời trang hot trend', 1),
(N'TDNN0146','123', 51, 7000000, N'Thể thao', 1),
(N'TDNN0147','123', 49, 13000000, N'Công sở, lịch sự', 1),
(N'TDNN0148','123', 42, 17000000, N'Đơn giản, thường ngày', 1),
(N'TDNN0149','123', 55, 5000000, N'Thời trang du lịch', 1),
(N'TDNN0150','123', 48, 17000000, N'Thời trang hot trend', 1),
(N'TDNN0151','123', 44, 5000000, N'Thể thao', 1),
(N'TDNN0152','123', 50, 9000000, N'Công sở, lịch sự', 1),
(N'TDNN0153','123', 47, 8000000, N'Đơn giản, thường ngày', 1),
(N'TDNN0154','123', 55, 19000000, N'Thời trang du lịch', 1),
(N'TDNN0155','123', 55, 20000000, N'Thời trang hot trend', 1),
(N'TDNN0156','123', 40, 12000000, N'Thể thao', 1),
(N'TDNN0157','123', 44, 8000000, N'Công sở, lịch sự', 1),
(N'TDNN0158','123', 49, 5000000, N'Đơn giản, thường ngày', 1),
(N'TDNN0159','123', 55, 16000000, N'Thời trang du lịch', 1),
(N'TDNN0160','123', 53, 19000000, N'Thời trang hot trend',1);
-- Dữ liệu train phân khúc khách hàng Trung niên từ 38 đến 60 tuổi chi tiêu vừa phải
INSERT INTO NguoiDung(TenDangNhap,MatKhau, DoTuoi, MucChiTieu, SoThich, Train) VALUES
(N'TDNN0161','123', 52, 31000000, N'Thể thao', 1),
(N'TDNN0162','123', 46, 46000000, N'Công sở, lịch sự', 1),
(N'TDNN0163','123', 52, 60000000, N'Đơn giản, thường ngày', 1),
(N'TDNN0164','123', 54, 36000000, N'Thời trang du lịch', 1),
(N'TDNN0165','123', 46, 42000000, N'Thời trang hot trend', 1),
(N'TDNN0166','123', 45, 42000000, N'Thể thao', 1),
(N'TDNN0167','123', 54, 54000000, N'Công sở, lịch sự', 1),
(N'TDNN0168','123', 49, 41000000, N'Đơn giản, thường ngày', 1),
(N'TDNN0169','123', 52, 48000000, N'Thời trang du lịch', 1),
(N'TDNN0170','123', 46, 54000000, N'Thời trang hot trend', 1),
(N'TDNN0171','123', 47, 31000000, N'Thể thao', 1),
(N'TDNN0172','123', 42, 58000000, N'Công sở, lịch sự', 1),
(N'TDNN0173','123', 50, 47000000, N'Đơn giản, thường ngày', 1),
(N'TDNN0174','123', 53, 47000000, N'Thời trang du lịch', 1),
(N'TDNN0175','123', 53, 42000000, N'Thời trang hot trend', 1),
(N'TDNN0176','123', 50, 44000000, N'Thể thao', 1),
(N'TDNN0177','123', 41, 55000000, N'Công sở, lịch sự', 1),
(N'TDNN0178','123', 54, 58000000, N'Đơn giản, thường ngày', 1),
(N'TDNN0179','123', 41, 35000000, N'Thời trang du lịch', 1),
(N'TDNN0180','123', 54, 51000000, N'Thời trang hot trend', 1),
(N'TDNN0181','123', 43, 58000000, N'Thể thao', 1),
(N'TDNN0182','123', 41, 51000000, N'Công sở, lịch sự', 1),
(N'TDNN0183','123', 47, 40000000, N'Đơn giản, thường ngày', 1),
(N'TDNN0184','123', 44, 49000000, N'Thời trang du lịch', 1),
(N'TDNN0185','123', 43, 60000000, N'Thời trang hot trend', 1),
(N'TDNN0186','123', 47, 57000000, N'Thể thao', 1),
(N'TDNN0187','123', 51, 47000000, N'Công sở, lịch sự', 1),
(N'TDNN0188','123', 55, 32000000, N'Đơn giản, thường ngày', 1),
(N'TDNN0189','123', 53, 59000000, N'Thời trang du lịch', 1),
(N'TDNN0190','123', 40, 40000000, N'Thời trang hot trend', 1),
(N'TDNN0191','123', 55, 44000000, N'Thể thao', 1),
(N'TDNN0192','123', 52, 32000000, N'Công sở, lịch sự', 1),
(N'TDNN0193','123', 44, 43000000, N'Đơn giản, thường ngày', 1),
(N'TDNN0194','123', 46, 51000000, N'Thời trang du lịch', 1),
(N'TDNN0195','123', 49, 58000000, N'Thời trang hot trend', 1),
(N'TDNN0196','123', 47, 35000000, N'Thể thao', 1),
(N'TDNN0197','123', 41, 57000000, N'Công sở, lịch sự', 1),
(N'TDNN0198','123', 41, 38000000, N'Đơn giản, thường ngày', 1),
(N'TDNN0199','123', 48, 55000000, N'Thời trang du lịch', 1),
(N'TDNN0200','123', 40, 54000000, N'Thời trang hot trend',1);
-- Dữ liệu train phân khúc khách hàng Trung niên từ 38 đến 60 tuổi chi tiêu cao
INSERT INTO NguoiDung(TenDangNhap,MatKhau, DoTuoi, MucChiTieu, SoThich, Train) VALUES 
(N'TDNN0201','123', 52, 92000000, N'Thể thao', 1), 
(N'TDNN0202','123', 40, 98000000, N'Công sở, lịch sự', 1),
(N'TDNN0203','123', 44, 81000000, N'Đơn giản, thường ngày', 1),
(N'TDNN0204','123', 41, 78000000, N'Thời trang du lịch', 1),
(N'TDNN0205','123', 52, 65000000, N'Thời trang hot trend', 1),
(N'TDNN0206','123', 40, 89000000, N'Thể thao', 1),
(N'TDNN0207','123', 52, 71000000, N'Công sở, lịch sự', 1),
(N'TDNN0208','123', 47, 83000000, N'Đơn giản, thường ngày', 1),
(N'TDNN0209','123', 49, 99000000, N'Thời trang du lịch', 1),
(N'TDNN0210','123', 48, 100000000, N'Thời trang hot trend', 1),
(N'TDNN0211','123', 42, 85000000, N'Thể thao', 1),
(N'TDNN0212','123', 55, 92000000, N'Công sở, lịch sự', 1),
(N'TDNN0213','123', 55, 90000000, N'Đơn giản, thường ngày', 1),
(N'TDNN0214','123', 45, 83000000, N'Thời trang du lịch', 1),
(N'TDNN0215','123', 47, 73000000, N'Thời trang hot trend', 1),
(N'TDNN0216','123', 42, 88000000, N'Thể thao', 1),
(N'TDNN0217','123', 50, 71000000, N'Công sở, lịch sự', 1),
(N'TDNN0218','123', 40, 73000000, N'Đơn giản, thường ngày', 1),
(N'TDNN0219','123', 51, 88000000, N'Thời trang du lịch', 1),
(N'TDNN0220','123', 52, 68000000, N'Thời trang hot trend', 1),
(N'TDNN0221','123', 54, 92000000, N'Thể thao', 1),
(N'TDNN0222','123', 47, 96000000, N'Công sở, lịch sự', 1),
(N'TDNN0223','123', 49, 80000000, N'Đơn giản, thường ngày', 1),
(N'TDNN0224','123', 42, 99000000, N'Thời trang du lịch', 1),
(N'TDNN0225','123', 45, 94000000, N'Thời trang hot trend', 1),
(N'TDNN0226','123', 49, 95000000, N'Thể thao', 1),
(N'TDNN0227','123', 53, 82000000, N'Công sở, lịch sự', 1),
(N'TDNN0228','123', 51, 85000000, N'Đơn giản, thường ngày', 1),
(N'TDNN0229','123', 55, 83000000, N'Thời trang du lịch', 1),
(N'TDNN0230','123', 40, 89000000, N'Thời trang hot trend', 1),
(N'TDNN0231','123', 49, 88000000, N'Thể thao', 1),
(N'TDNN0232','123', 51, 97000000, N'Công sở, lịch sự', 1),
(N'TDNN0233','123', 51, 95000000, N'Đơn giản, thường ngày', 1),
(N'TDNN0234','123', 53, 83000000, N'Thời trang du lịch', 1),
(N'TDNN0235','123', 51, 99000000, N'Thời trang hot trend', 1),
(N'TDNN0236','123', 50, 78000000, N'Thể thao', 1),
(N'TDNN0237','123', 42, 96000000, N'Công sở, lịch sự', 1),
(N'TDNN0238','123', 52, 99000000, N'Đơn giản, thường ngày', 1),
(N'TDNN0239','123', 49, 97000000, N'Thời trang du lịch', 1),
(N'TDNN0240','123', 54, 85000000, N'Thời trang hot trend',1);
-- Dữ liệu train phân khúc khách hàng Cao tuổi từ 60 tuổi trở lên chi tiêu thấp
INSERT INTO NguoiDung(TenDangNhap,MatKhau, DoTuoi, MucChiTieu, SoThich, Train) VALUES 
(N'TDNN0241','123', 65, 16000000, N'Thể thao', 1), 
(N'TDNN0242','123', 72, 15000000, N'Công sở, lịch sự', 1), 
(N'TDNN0243','123', 66, 18000000, N'Đơn giản, thường ngày', 1),
(N'TDNN0244','123', 65, 19000000, N'Thời trang du lịch', 1),
(N'TDNN0245','123', 70, 18000000, N'Thời trang hot trend', 1),
(N'TDNN0246','123', 67, 15000000, N'Thể thao', 1),
(N'TDNN0247','123', 77, 14000000, N'Công sở, lịch sự', 1),
(N'TDNN0248','123', 66, 18000000, N'Đơn giản, thường ngày', 1),
(N'TDNN0249','123', 74, 17000000, N'Thời trang du lịch', 1),
(N'TDNN0250','123', 71, 18000000, N'Thời trang hot trend', 1),
(N'TDNN0251','123', 80, 9000000, N'Thể thao', 1),
(N'TDNN0252','123', 65, 16000000, N'Công sở, lịch sự', 1),
(N'TDNN0253','123', 73, 13000000, N'Đơn giản, thường ngày', 1),
(N'TDNN0254','123', 66, 8000000, N'Thời trang du lịch', 1),
(N'TDNN0255','123', 69, 9000000, N'Thời trang hot trend', 1),
(N'TDNN0256','123', 68, 14000000, N'Thể thao', 1),
(N'TDNN0257','123', 79, 20000000, N'Công sở, lịch sự', 1),
(N'TDNN0258','123', 75, 15000000, N'Đơn giản, thường ngày', 1),
(N'TDNN0259','123', 74, 16000000, N'Thời trang du lịch', 1),
(N'TDNN0260','123', 66, 15000000, N'Thời trang hot trend', 1),
(N'TDNN0261','123', 78, 5000000, N'Thể thao', 1),
(N'TDNN0262','123', 66, 11000000, N'Công sở, lịch sự', 1),
(N'TDNN0263','123', 75, 6000000, N'Đơn giản, thường ngày', 1),
(N'TDNN0264','123', 71, 9000000, N'Thời trang du lịch', 1),
(N'TDNN0265','123', 73, 16000000, N'Thời trang hot trend', 1),
(N'TDNN0266','123', 67, 17000000, N'Thể thao', 1),
(N'TDNN0267','123', 69, 10000000, N'Công sở, lịch sự', 1),
(N'TDNN0268','123', 78, 8000000, N'Đơn giản, thường ngày', 1),
(N'TDNN0269','123', 66, 15000000, N'Thời trang du lịch', 1),
(N'TDNN0270','123', 72, 17000000, N'Thời trang hot trend', 1),
(N'TDNN0271','123', 65, 17000000, N'Thể thao', 1),
(N'TDNN0272','123', 77, 20000000, N'Công sở, lịch sự', 1),
(N'TDNN0273','123', 68, 20000000, N'Đơn giản, thường ngày', 1),
(N'TDNN0274','123', 65, 8000000, N'Thời trang du lịch', 1),
(N'TDNN0275','123', 77, 12000000, N'Thời trang hot trend', 1),
(N'TDNN0276','123', 71, 9000000, N'Thể thao', 1),
(N'TDNN0277','123', 66, 8000000, N'Công sở, lịch sự', 1),
(N'TDNN0278','123', 79, 16000000, N'Đơn giản, thường ngày', 1),
(N'TDNN0279','123', 68, 6000000, N'Thời trang du lịch', 1),
(N'TDNN0280','123', 65, 10000000, N'Thời trang hot trend',1);
-- Dữ liệu train phân khúc khách hàng Cao tuổi từ 60 tuổi trở lên chi tiêu vừa phải
INSERT INTO NguoiDung(TenDangNhap,MatKhau, DoTuoi, MucChiTieu, SoThich, Train) VALUES
(N'TDNN0281','123', 66, 45000000, N'Thể thao', 1),
(N'TDNN0282','123', 65, 37000000, N'Công sở, lịch sự', 1),
(N'TDNN0283','123', 69, 38000000, N'Đơn giản, thường ngày', 1),
(N'TDNN0284','123', 65, 34000000, N'Thời trang du lịch', 1),
(N'TDNN0285','123', 68, 34000000, N'Thời trang hot trend', 1),
(N'TDNN0286','123', 74, 44000000, N'Thể thao', 1),
(N'TDNN0287','123', 75, 39000000, N'Công sở, lịch sự', 1),
(N'TDNN0288','123', 72, 58000000, N'Đơn giản, thường ngày', 1),
(N'TDNN0289','123', 65, 43000000, N'Thời trang du lịch', 1),
(N'TDNN0290','123', 73, 50000000, N'Thời trang hot trend', 1),
(N'TDNN0291','123', 69, 53000000, N'Thể thao', 1),
(N'TDNN0292','123', 79, 50000000, N'Công sở, lịch sự', 1),
(N'TDNN0293','123', 79, 38000000, N'Đơn giản, thường ngày', 1),
(N'TDNN0294','123', 67, 60000000, N'Thời trang du lịch', 1),
(N'TDNN0295','123', 66, 35000000, N'Thời trang hot trend', 1),
(N'TDNN0296','123', 69, 54000000, N'Thể thao', 1),
(N'TDNN0297','123', 65, 59000000, N'Công sở, lịch sự', 1),
(N'TDNN0298','123', 71, 49000000, N'Đơn giản, thường ngày', 1),
(N'TDNN0299', '123',70, 48000000, N'Thời trang du lịch', 1),
(N'TDNN0300','123', 68, 58000000, N'Thời trang hot trend', 1),
(N'TDNN0301','123', 80, 56000000, N'Thể thao', 1),
(N'TDNN0302', '123',79, 47000000, N'Công sở, lịch sự', 1),
(N'TDNN0303', '123',67, 37000000, N'Đơn giản, thường ngày', 1),
(N'TDNN0304', '123',72, 40000000, N'Thời trang du lịch', 1),
(N'TDNN0305','123', 80, 53000000, N'Thời trang hot trend', 1),
(N'TDNN0306','123', 71, 41000000, N'Thể thao', 1),
(N'TDNN0307','123', 67, 40000000, N'Công sở, lịch sự', 1),
(N'TDNN0308','123', 68, 35000000, N'Đơn giản, thường ngày', 1),
(N'TDNN0309','123', 79, 32000000, N'Thời trang du lịch', 1),
(N'TDNN0310','123', 69, 40000000, N'Thời trang hot trend', 1),
(N'TDNN0311','123', 68, 49000000, N'Thể thao', 1),
(N'TDNN0312','123', 76, 55000000, N'Công sở, lịch sự', 1),
(N'TDNN0313','123', 66, 53000000, N'Đơn giản, thường ngày', 1),
(N'TDNN0314','123', 65, 38000000, N'Thời trang du lịch', 1),
(N'TDNN0315','123', 79, 35000000, N'Thời trang hot trend', 1),
(N'TDNN0316','123', 80, 36000000, N'Thể thao', 1),
(N'TDNN0317','123', 67, 60000000, N'Công sở, lịch sự', 1),
(N'TDNN0318','123', 71, 59000000, N'Đơn giản, thường ngày', 1),
(N'TDNN0319','123', 79, 43000000, N'Thời trang du lịch', 1),
(N'TDNN0320','123', 73, 34000000, N'Thời trang hot trend',1);
-- Dữ liệu train phân khúc Cao tuổi từ 60 tuổi trở lên chi tiêu cao
INSERT INTO NguoiDung(TenDangNhap, MatKhau, DoTuoi, MucChiTieu, SoThich, Train) VALUES
(N'TDNN0321', '123', 67, 88000000, N'Thể thao', 1),
(N'TDNN0322', '123', 77, 71000000, N'Công sở, lịch sự', 1),
(N'TDNN0323', '123', 75, 73000000, N'Đơn giản, thường ngày', 1),
(N'TDNN0324', '123', 65, 80000000, N'Thời trang du lịch', 1),
(N'TDNN0325', '123', 80, 72000000, N'Thời trang hot trend', 1),
(N'TDNN0326', '123', 78, 92000000, N'Thể thao', 1),
(N'TDNN0327', '123', 74, 80000000, N'Công sở, lịch sự', 1),
(N'TDNN0328', '123', 75, 82000000, N'Đơn giản, thường ngày', 1),
(N'TDNN0329', '123', 69, 88000000, N'Thời trang du lịch', 1),
(N'TDNN0330', '123', 67, 95000000, N'Thời trang hot trend', 1),
(N'TDNN0331', '123', 78, 96000000, N'Thể thao', 1),
(N'TDNN0332', '123', 80, 85000000, N'Công sở, lịch sự', 1),
(N'TDNN0333', '123', 68, 90000000, N'Đơn giản, thường ngày', 1),
(N'TDNN0334', '123', 67, 93000000, N'Thời trang du lịch', 1),
(N'TDNN0335', '123', 72, 94000000, N'Thời trang hot trend', 1),
(N'TDNN0336', '123', 80, 92000000, N'Thể thao', 1),
(N'TDNN0337', '123', 68, 95000000, N'Công sở, lịch sự', 1),
(N'TDNN0338', '123', 70, 96000000, N'Đơn giản, thường ngày', 1),
(N'TDNN0339', '123', 76, 87000000, N'Thời trang du lịch', 1),
(N'TDNN0340', '123', 67, 99000000, N'Thời trang hot trend', 1),
(N'TDNN0341', '123', 65, 88000000, N'Thể thao', 1),
(N'TDNN0342', '123', 77, 97000000, N'Công sở, lịch sự', 1),
(N'TDNN0343', '123', 70, 90000000, N'Đơn giản, thường ngày', 1),
(N'TDNN0344', '123', 79, 88000000, N'Thời trang du lịch', 1),
(N'TDNN0345', '123', 65, 85000000, N'Thời trang hot trend', 1),
(N'TDNN0346', '123', 73, 81000000, N'Thể thao', 1),
(N'TDNN0347', '123', 66, 93000000, N'Công sở, lịch sự', 1),
(N'TDNN0348', '123', 68, 88000000, N'Đơn giản, thường ngày', 1),
(N'TDNN0349', '123', 74, 91000000, N'Thời trang du lịch', 1),
(N'TDNN0350', '123', 71, 88000000, N'Thời trang hot trend', 1),
(N'TDNN0351', '123', 76, 82000000, N'Thể thao', 1),
(N'TDNN0352', '123', 80, 80000000, N'Công sở, lịch sự', 1),
(N'TDNN0353', '123', 75, 78000000, N'Đơn giản, thường ngày', 1),
(N'TDNN0354', '123', 67, 86000000, N'Thời trang du lịch', 1),
(N'TDNN0355', '123', 66, 92000000, N'Thời trang hot trend', 1),
(N'TDNN0356', '123', 80, 87000000, N'Thể thao', 1),
(N'TDNN0357', '123', 77, 95000000, N'Công sở, lịch sự', 1),
(N'TDNN0358', '123', 66, 90000000, N'Đơn giản, thường ngày', 1),
(N'TDNN0359', '123', 74, 89000000, N'Thời trang du lịch', 1),
(N'TDNN0360', '123', 80, 95000000, N'Thời trang hot trend', 1);

-- Thêm dữ liệu train từ 0 - 100 tuổi 
DECLARE @Age INT = 0;
DECLARE @IDPrefix NVARCHAR(50);

WHILE @Age <= 100
BEGIN
    SET @IDPrefix = CONCAT(N'TDNK', @Age);

    INSERT INTO NguoiDung (TenDangNhap, MatKhau, DoTuoi, MucChiTieu, SoThich, Train)
    SELECT 
        CONCAT(@IDPrefix, RIGHT('00' + CAST(ROW_NUMBER() OVER (ORDER BY (SELECT NULL)) AS NVARCHAR), 3)) AS TenDangNhap,
        '123' AS MatKhau,
        @Age AS DoTuoi,
        MucChiTieu,
        N'Thể thao' AS SoThich,
        1 AS Train
    FROM (
        SELECT TOP (100) (ROW_NUMBER() OVER (ORDER BY (SELECT NULL))) * 1000000 AS MucChiTieu
        FROM master.dbo.spt_values
    ) AS Spending(MucChiTieu);

    SET @Age = @Age + 1;
END;

select * from NguoiDung


-- Dữ liệu test
INSERT INTO NguoiDung (TenDangNhap, MatKhau, DoTuoi, MucChiTieu, SoThich, Train) VALUES
('user1', 'password1', 5, 15000000, N'Thể thao', 0),
('user2', 'password2', 23, 30000000, N'Công sở, lịch sự', 0),
('user3', 'password3', 45, 55000000, N'Đơn giản, thường ngày', 0),
('user4', 'password4', 18, 75000000, N'Thời trang du lịch', 0),
('user5', 'password5', 33, 20000000, N'Thời trang hot trend', 0),
('user6', 'password6', 60, 5000000, N'Thể thao', 0),
('user7', 'password7', 12, 1000000, N'Công sở, lịch sự', 0),
('user8', 'password8', 28, 88000000, N'Đơn giản, thường ngày', 0),
('user9', 'password9', 37, 72000000, N'Thời trang du lịch', 0),
('user10', 'password10', 49, 34000000, N'Thời trang hot trend', 0),
('user11', 'password11', 55, 12000000, N'Thể thao', 0),
('user12', 'password12', 70, 45000000, N'Công sở, lịch sự', 0),
('user13', 'password13', 9, 800000, N'Đơn giản, thường ngày', 0),
('user14', 'password14', 19, 25000000, N'Thời trang du lịch', 0),
('user15', 'password15', 26, 93000000, N'Thời trang hot trend', 0),
('user16', 'password16', 40, 30000000, N'Thể thao', 0),
('user17', 'password17', 8, 600000, N'Công sở, lịch sự', 0),
('user18', 'password18', 50, 78000000, N'Đơn giản, thường ngày', 0),
('user19', 'password19', 35, 66000000, N'Thời trang du lịch', 0),
('user20', 'password20', 62, 15000000, N'Thời trang hot trend', 0),
('user21', 'password21', 14, 1200000, N'Thể thao', 0),
('user22', 'password22', 24, 40000000, N'Công sở, lịch sự', 0),
('user23', 'password23', 18, 25000000, N'Đơn giản, thường ngày', 0),
('user24', 'password24', 38, 85000000, N'Thời trang du lịch', 0),
('user25', 'password25', 48, 29000000, N'Thời trang hot trend', 0),
('user26', 'password26', 67, 8000000, N'Thể thao', 0),
('user27', 'password27', 55, 54000000, N'Công sở, lịch sự', 0),
('user28', 'password28', 34, 36000000, N'Đơn giản, thường ngày', 0),
('user29', 'password29', 42, 72000000, N'Thời trang du lịch', 0),
('user30', 'password30', 25, 49000000, N'Thời trang hot trend', 0),
('user31', 'password31', 60, 23000000, N'Thể thao', 0),
('user32', 'password32', 19, 7000000, N'Công sở, lịch sự', 0),
('user33', 'password33', 39, 43000000, N'Đơn giản, thường ngày', 0),
('user34', 'password34', 45, 61000000, N'Thời trang du lịch', 0),
('user35', 'password35', 52, 35000000, N'Thời trang hot trend', 0),
('user36', 'password36', 27, 19000000, N'Thể thao', 0),
('user37', 'password37', 61, 68000000, N'Công sở, lịch sự', 0),
('user38', 'password38', 33, 34000000, N'Đơn giản, thường ngày', 0),
('user39', 'password39', 44, 78000000, N'Thời trang du lịch', 0),
('user40', 'password40', 17, 41000000, N'Thời trang hot trend', 0),
('user41', 'password41', 21, 24000000, N'Thể thao', 0),
('user42', 'password42', 59, 13000000, N'Công sở, lịch sự', 0),
('user43', 'password43', 22, 49000000, N'Đơn giản, thường ngày', 0),
('user44', 'password44', 30, 89000000, N'Thời trang du lịch', 0),
('user45', 'password45', 63, 70000000, N'Thời trang hot trend', 0),
('user46', 'password46', 14, 20000000, N'Thể thao', 0),
('user47', 'password47', 54, 5000000, N'Công sở, lịch sự', 0),
('user48', 'password48', 32, 66000000, N'Đơn giản, thường ngày', 0),
('user49', 'password49', 46, 56000000, N'Thời trang du lịch', 0),
('user50', 'password50', 35, 78000000, N'Thời trang hot trend', 0),
('user51', 'password51', 49, 90000000, N'Thể thao', 0),
('user52', 'password52', 27, 31000000, N'Công sở, lịch sự', 0),
('user53', 'password53', 56, 42000000, N'Đơn giản, thường ngày', 0),
('user54', 'password54', 36, 25000000, N'Thời trang du lịch', 0),
('user55', 'password55', 60, 81000000, N'Thời trang hot trend', 0),
('user56', 'password56', 31, 55000000, N'Thể thao', 0),
('user57', 'password57', 58, 1000000, N'Công sở, lịch sự', 0),
('user58', 'password58', 29, 36000000, N'Đơn giản, thường ngày', 0),
('user59', 'password59', 41, 87000000, N'Thời trang du lịch', 0),
('user60', 'password60', 53, 14000000, N'Thời trang hot trend', 0),
('user61', 'password61', 15, 23000000, N'Thể thao', 0),
('user62', 'password62', 47, 72000000, N'Công sở, lịch sự', 0),
('user63', 'password63', 38, 49000000, N'Đơn giản, thường ngày', 0),
('user64', 'password64', 40, 80000000, N'Thời trang du lịch', 0),
('user65', 'password65', 62, 57000000, N'Thời trang hot trend', 0),
('user66', 'password66', 26, 35000000, N'Thể thao', 0),
('user67', 'password67', 18, 44000000, N'Công sở, lịch sự', 0),
('user68', 'password68', 57, 93000000, N'Đơn giản, thường ngày', 0),
('user69', 'password69', 28, 31000000, N'Thời trang du lịch', 0),
('user70', 'password70', 43, 6000000, N'Thời trang hot trend', 0),
('user71', 'password71', 50, 42000000, N'Thể thao', 0),
('user72', 'password72', 19, 86000000, N'Công sở, lịch sự', 0),
('user73', 'password73', 46, 25000000, N'Đơn giản, thường ngày', 0),
('user74', 'password74', 39, 49000000, N'Thời trang du lịch', 0),
('user75', 'password75', 37, 87000000, N'Thời trang hot trend', 0),
('user76', 'password76', 42, 34000000, N'Thể thao', 0),
('user77', 'password77', 33, 13000000, N'Công sở, lịch sự', 0),
('user78', 'password78', 34, 66000000, N'Đơn giản, thường ngày', 0),
('user79', 'password79', 24, 78000000, N'Thời trang du lịch', 0),
('user80', 'password80', 31, 41000000, N'Thời trang hot trend', 0),
('user81', 'password81', 14, 20000000, N'Thể thao', 0),
('user82', 'password82', 45, 31000000, N'Công sở, lịch sự', 0),
('user83', 'password83', 52, 49000000, N'Đơn giản, thường ngày', 0),
('user84', 'password84', 29, 67000000, N'Thời trang du lịch', 0),
('user85', 'password85', 35, 78000000, N'Thời trang hot trend', 0),
('user86', 'password86', 21, 90000000, N'Thể thao', 0),
('user87', 'password87', 32, 43000000, N'Công sở, lịch sự', 0),
('user88', 'password88', 30, 55000000, N'Đơn giản, thường ngày', 0),
('user89', 'password89', 36, 86000000, N'Thời trang du lịch', 0),
('user90', 'password90', 58, 23000000, N'Thời trang hot trend', 0),
('user91', 'password91', 27, 67000000, N'Thể thao', 0),
('user92', 'password92', 19, 30000000, N'Công sở, lịch sự', 0),
('user93', 'password93', 54, 41000000, N'Đơn giản, thường ngày', 0),
('user94', 'password94', 42, 78000000, N'Thời trang du lịch', 0),
('user95', 'password95', 34, 81000000, N'Thời trang hot trend', 0),
('user96', 'password96', 31, 66000000, N'Thể thao', 0),
('user97', 'password97', 39, 42000000, N'Công sở, lịch sự', 0),
('user98', 'password98', 29, 19000000, N'Đơn giản, thường ngày', 0),
('user99', 'password99', 55, 93000000, N'Thời trang du lịch', 0),
('user100', 'password100', 43, 14000000, N'Thời trang hot trend', 0);

SELECT * FROM DanhMuc;

SELECT * FROM Size;

SELECT * FROM Mau;

SELECT * FROM SanPham;

SELECT * FROM ChiTietSanPham;

SELECT * FROM NguoiDung;

SELECT * FROM DonHang;

SELECT * FROM ChiTietDonHang;

SELECT * FROM GioHang;

SELECT * FROM PhanHoi;
SELECT * FROM ThongTinGiaoHang;


-- Backup toàn bộ database
BACKUP DATABASE [TenDatabase]
TO DISK = 'D:\Backup\TenDatabase.bak'
WITH FORMAT, INIT, 
     NAME = 'TenDatabase-Full Backup',
     SKIP, NOREWIND, NOUNLOAD, STATS = 10;
-- Restore từ file backup vào database mới
RESTORE DATABASE [TenDatabaseMoi]
FROM DISK = 'D:\Backup\TenDatabase.bak'
WITH MOVE 'TenDatabase' TO 'D:\Data\TenDatabaseMoi.mdf',
     MOVE 'TenDatabase_log' TO 'D:\Data\TenDatabaseMoi_log.ldf',
     REPLACE,
     STATS = 10;
-- Restore đè lên database hiện tại
RESTORE DATABASE [TenDatabase]
FROM DISK = 'D:\Backup\TenDatabase.bak'
WITH REPLACE,
     STATS = 10;
--3. Ghi chú
--Phân quyền: Người dùng phải có quyền sysadmin hoặc db_owner để thực hiện backup/restore.
--Kiểm tra trước khi restore: Nếu database đang được sử dụng, bạn cần đặt nó ở chế độ SINGLE_USER:
ALTER DATABASE [TenDatabase]
SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
--Sau khi restore xong, đưa lại về chế độ MULTI_USER:
ALTER DATABASE [TenDatabase]
SET MULTI_USER;
