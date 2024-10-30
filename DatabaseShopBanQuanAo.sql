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
    VaiTro NVARCHAR(50) DEFAULT 'KhachHang',
    NgayTao DATETIME DEFAULT GETDATE(),
	PhanKhucKH NVARCHAR(100) DEFAULT N'Khách Hàng Mới',
	Train BIT DEFAULT 1, 
	GioiTinh NVARCHAR(10) NULL,           
    MucChiTieu INT NULL,       
    DoTuoi INT NULL,
    KichHoat BIT DEFAULT 1
);                   
CREATE TABLE DanhMuc (
    DanhMucID INT PRIMARY KEY IDENTITY(1,1),
    TenDanhMuc NVARCHAR(100) NOT NULL,
);
CREATE TABLE SanPham (
    SanPhamID INT PRIMARY KEY IDENTITY(1,1),
    TenSanPham NVARCHAR(100) NOT NULL,
    MoTa NVARCHAR(MAX),
    Gia DECIMAL(18, 2) NOT NULL,
    SoLuongTonKho INT NOT NULL,
	SoLuongDaBan INT DEFAULT 0,
    DanhMucID INT,
    HinhAnhUrl NVARCHAR(255),
    NgayTao DATETIME DEFAULT GETDATE(),
    KichHoat BIT DEFAULT 1,
    FOREIGN KEY (DanhMucID) REFERENCES DanhMuc(DanhMucID)
);
-- Thêm column SoLuongDaBan
--ALTER TABLE SanPham
--ADD SoLuongDaBan INT DEFAULT 0;

CREATE TABLE DonHang (
    DonHangID INT PRIMARY KEY IDENTITY(1,1),
    NguoiDungID INT NOT NULL,
    TongTien DECIMAL(18, 2) NOT NULL,
    TinhTrangDonHang NVARCHAR(50) NOT NULL,
    NgayDatHang DATETIME DEFAULT GETDATE(),
    DiaChiGiaoHang NVARCHAR(255),
    FOREIGN KEY (NguoiDungID) REFERENCES NguoiDung(NguoiDungID)
);
CREATE TABLE ChiTietDonHang (
    ChiTietDonHangID INT PRIMARY KEY IDENTITY(1,1),
    DonHangID INT NOT NULL,
    SanPhamID INT NOT NULL,
    SoLuong INT NOT NULL,
    DonGia DECIMAL(18, 2) NOT NULL,
    FOREIGN KEY (DonHangID) REFERENCES DonHang(DonHangID),
    FOREIGN KEY (SanPhamID) REFERENCES SanPham(SanPhamID)
);
CREATE TABLE GioHang (
    GioHangID INT PRIMARY KEY IDENTITY(1,1),
    NguoiDungID INT NOT NULL,
    SanPhamID INT NOT NULL,
    SoLuong INT NOT NULL,
    FOREIGN KEY (NguoiDungID) REFERENCES NguoiDung(NguoiDungID),
    FOREIGN KEY (SanPhamID) REFERENCES SanPham(SanPhamID)
);
CREATE TABLE ThanhToan (
    ThanhToanID INT PRIMARY KEY IDENTITY(1,1),
    DonHangID INT NOT NULL,
    HinhThucThanhToan NVARCHAR(50) NOT NULL,
    TinhTrangThanhToan NVARCHAR(50) NOT NULL,
    NgayThanhToan DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (DonHangID) REFERENCES DonHang(DonHangID)
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
CREATE TABLE ThongTinGiaoHang (
    DiaChiID INT PRIMARY KEY IDENTITY(1,1),
    NguoiDungID INT NOT NULL,
    TenNguoiNhan NVARCHAR(100) NOT NULL,
    SoDienThoai NVARCHAR(15) NOT NULL,
    DiaChiGiaoHang NVARCHAR(255) NOT NULL,
    DiaChiMacDinh BIT DEFAULT 0, -- Địa chỉ mặc định
    FOREIGN KEY (NguoiDungID) REFERENCES NguoiDung(NguoiDungID)
);

--delete from NguoiDung
--delete from NguoiDung where NguoiDungID = 1829
select * from NguoiDung
select * from GioHang
select * from SanPham
select * from ChiTietDonHang
select * from DanhMuc
select * from ThongTinGiaoHang
select * from ThanhToan
--Delete from SanPham
--Delete from NguoiDung
-- Nhập liệu
-- Thêm các danh mục sản phẩm mới
INSERT INTO DanhMuc (TenDanhMuc) VALUES
(N'Thể thao'),
(N'Công sở, lịch sự'),
(N'Đơn giản, thường ngày'),
(N'Thời trang du lịch'),
(N'Thời trang hot trend');


-- Sản phẩm cho sở thích "Thể thao" Thanh niên từ 0 đến 37 tuổi
INSERT INTO SanPham (TenSanPham, MoTa, Gia, SoLuongTonKho, DanhMucID, HinhAnhUrl)
VALUES 
-- Mức giá 15000-400000
--nam
(N'Áo thể thao Nam đa năng', N'Áo thể thao được thiết kế thoáng khí, phù hợp cho các hoạt động ngoài trời và thể thao', 300000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh1.jpg'),
(N'Quần thể thao Nam thấm hút mồ hôi', N'Quần thể thao với chất liệu thấm hút mồ hôi, mang lại cảm giác thoải mái khi vận động', 250000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh76.jpg'),
(N'Giày thể thao Nam chống trượt', N'Giày thể thao nhẹ, chống trượt, lý tưởng cho chạy bộ và các môn thể thao khác', 370000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh77.jpg'),
(N'Quần short thể thao Nam thoáng mát', N'Quần short thể thao thoáng mát, giúp bạn thoải mái hơn trong mọi hoạt động', 180000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh78.jpg'),
(N'Mũ lưỡi trai thời trang', N'Mũ lưỡi trai bảo vệ khỏi nắng, phù hợp cho các hoạt động thể thao ngoài trời', 108000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh79.jpg'),
--nữ
(N'Áo thể thao Nữ năng động', N'Áo thể thao nữ thoáng khí, thiết kế hiện đại cho những cô nàng yêu thể thao', 320000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh80.jpg'),
(N'Quần thể thao Nữ thời trang', N'Quần thể thao nữ với kiểu dáng thời trang, dễ phối đồ', 250000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh81.jpg'),
(N'Giày thể thao Nữ phong cách', N'Giày thể thao nữ nhẹ, phong cách, giúp bạn tự tin hơn khi tập luyện', 300000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh82.jpg'),
(N'Quần short thể thao Nữ chất liệu mềm mại', N'Quần short thể thao nữ với chất liệu mềm mại, tạo sự thoải mái khi vận động', 200000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh83.jpg'),
(N'Mũ lưỡi trai Nữ cá tính', N'Mũ lưỡi trai nữ giúp bảo vệ và tạo điểm nhấn cho trang phục thể thao', 150000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh84.jpg'),
-- Mức giá 500000-750000
--nam
(N'Áo thể thao Nam chất liệu cao cấp', N'Áo thể thao nam với chất liệu cao cấp, thích hợp cho các buổi tập luyện chuyên nghiệp', 550000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh85.jpg'),
(N'Quần thể thao Nam thời trang', N'Quần thể thao nam thời trang, tạo nên phong cách năng động', 650000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh86.jpg'),
(N'Giày thể thao Nam bảo vệ tốt', N'Giày thể thao nam thiết kế hỗ trợ tốt cho cổ chân, phù hợp với vận động mạnh', 700000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh87.jpg'),
(N'Quần short thể thao Nam chất liệu nhẹ', N'Quần short thể thao nam với chất liệu nhẹ, thoáng mát, dễ dàng vận động', 600000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh88.jpg'),
(N'Mũ lưỡi trai thời trang Nam', N'Mũ lưỡi trai giúp bảo vệ và tạo phong cách thể thao', 500000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh89.jpg'),
--nữ
(N'Áo thể thao Nữ chất liệu thấm hút', N'Áo thể thao nữ với chất liệu thấm hút, giúp bạn luôn khô ráo khi tập luyện', 450000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh90.jpg'),
(N'Quần thể thao Nữ kiểu dáng hiện đại', N'Quần thể thao nữ kiểu dáng hiện đại, thích hợp cho tập luyện và đi chơi', 480000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh91.jpg'),
(N'Giày thể thao Nữ siêu nhẹ', N'Giày thể thao nữ siêu nhẹ, phù hợp với các hoạt động thể thao', 500000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh92.jpg'),
(N'Quần short thể thao Nữ thời trang', N'Quần short thể thao nữ với thiết kế thời trang, dễ dàng phối đồ', 520000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh93.jpg'),
(N'Mũ lưỡi trai Nữ phong cách', N'Mũ lưỡi trai nữ phong cách, giúp bảo vệ và tạo nét cá tính', 530000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh94.jpg'),
-- Mức giá 800000-2000000
(N'Áo thể thao Nam cao cấp', N'Áo thể thao nam cao cấp, mang lại sự thoải mái tối đa khi tập luyện', 850000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh95.jpg'),
(N'Quần thể thao Nam cao cấp', N'Quần thể thao nam chất lượng, thiết kế hiện đại cho những ai yêu thích vận động', 950000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh96.jpg'),
(N'Giày thể thao Nam đa năng', N'Giày thể thao nam thiết kế đa năng, phục vụ cho nhiều hoạt động thể thao khác nhau', 1200000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh97.jpg'),
(N'Quần short thể thao Nam cao cấp', N'Quần short thể thao nam cao cấp, thoải mái cho mọi hoạt động', 800000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh98.jpg'),
(N'Mũ lưỡi trai Nam thời trang', N'Mũ lưỡi trai nam thời trang, bảo vệ khỏi nắng, dễ phối đồ', 700000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh799.jpg'),
--nữ
(N'Áo thể thao Nữ cao cấp', N'Áo thể thao nữ cao cấp, thoải mái và phong cách cho các hoạt động thể thao', 900000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh99.jpg'),
(N'Quần thể thao Nữ năng động', N'Quần thể thao nữ năng động, lý tưởng cho các hoạt động thể thao và du lịch', 1100000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh100.jpg'),
(N'Giày thể thao Nữ kiểu dáng đẹp', N'Giày thể thao nữ với thiết kế thời trang, giúp bạn tự tin hơn khi vận động', 1500000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh101.jpg'),
(N'Quần short thể thao Nữ chất liệu thoáng mát', N'Quần short thể thao nữ thoáng mát, tạo cảm giác dễ chịu trong suốt thời gian vận động', 850000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh102.jpg'),
(N'Mũ lưỡi trai Nữ cá tính', N'Mũ lưỡi trai nữ với thiết kế cá tính, phong cách cho mọi cô gái', 920000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh103.jpg');
-- Sản phẩm cho sở thích "Công sở, lịch sự" Thanh niên từ 0 đến 37 tuổi 
INSERT INTO SanPham (TenSanPham, MoTa, Gia, SoLuongTonKho, DanhMucID, HinhAnhUrl)
VALUES 
-- Mức giá 15000-400000
--nam
(N'Áo khoác công sở nam', N'Áo khoác nhẹ nhàng, thoải mái, thích hợp cho đi làm.', 200000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh1033.jpg'),
(N'Quần âu nam phong cách', N'Quần âu nam với thiết kế hiện đại, tôn dáng.', 350000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh104.jpg'),
(N'Giày oxford nam sang trọng', N'Giày oxford phù hợp cho các dịp trang trọng.', 400000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh105.jpg'),
(N'Quần shorts nam thoải mái', N'Quần shorts nam với chất liệu thoáng mát, dễ chịu.', 150000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh106.jpg'),-- xong
(N'Mũ lưỡi trai công sở', N'Mũ lưỡi trai thời trang, bảo vệ khỏi ánh nắng.', 300000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh107.jpg'),
--nữ
(N'Áo vest công sở nữ', N'Áo vest nữ thanh lịch, dễ phối với nhiều trang phục.', 250000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh108.jpg'),
(N'Chân váy công sở nữ', N'Chân váy xòe nữ tính, hoàn hảo cho công việc.', 350000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh109.jpg'),
(N'Giày cao gót công sở', N'Giày cao gót thời trang, nâng tầm phong cách.', 400000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh110.jpg'),
(N'Quần âu nữ hiện đại', N'Quần âu nữ với thiết kế trẻ trung, thoải mái.', 300000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh111.jpg'),
(N'Mũ lưỡi trai nữ thời trang', N'Mũ lưỡi trai giúp bạn thêm phần năng động.', 250000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh112.jpg'),
-- Mức giá 500000-750000
--nam-- xong
(N'Áo sơ mi công sở nam', N'Áo sơ mi cổ điển, phù hợp cho môi trường làm việc.', 600000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh113.jpg'),
(N'Quần tây nam hiện đại', N'Quần tây với thiết kế trẻ trung, phù hợp cho đi làm.', 700000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh114.jpg'),
(N'Giày tây nam cao cấp', N'Giày tây mang lại vẻ lịch lãm cho phái mạnh.', 650000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh115.jpg'),
(N'Quần Âu công sở nam', N'Quần short với chất liệu thoải mái, phù hợp mùa hè.', 550000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh117.jpg'),
(N'Mũ lưỡi trai thể thao', N'Mũ lưỡi trai dễ phối đồ, thích hợp cho mọi hoạt động.', 400000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh118.jpg'),
--nữ
(N'Áo sơ mi công sở nữ', N'Áo sơ mi nữ thanh lịch, dễ dàng phối đồ.', 600000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh119.jpg'),
(N'Chân váy pencil công sở', N'Chân váy bút chì tạo dáng, hoàn hảo cho môi trường công sở.', 650000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh120.jpg'),
(N'Giày búp bê công sở', N'Giày búp bê nữ tính, thoải mái cho ngày dài làm việc.', 550000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh121.jpg'),
(N'Quần tây nữ thanh lịch', N'Quần tây với chất liệu cao cấp, phù hợp với mọi dịp.', 700000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh122.jpg'),
(N'Mũ lưỡi trai công sở nữ', N'Mũ lưỡi trai thời trang, bảo vệ bạn khỏi nắng.', 500000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh123.jpg'),
-- Mức giá 800000-2000000
(N'Áo khoác công sở nam cao cấp', N'Áo khoác giữ ấm với phong cách lịch lãm.', 1800000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh124.jpg'),
(N'Quần tây nam cao cấp', N'Quần tây nam thời thượng, mang lại phong cách hoàn hảo.', 1200000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh125.jpg'),
(N'Giày lười nam công sở', N'Giày lười thoải mái, thích hợp cho công việc hàng ngày.', 950000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh126.jpg'),
(N'Chân quần midi công sở', N'Chân váy midi thanh lịch, lý tưởng cho buổi hẹn.', 800000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh127.jpg'),
(N'Mũ fedora công sở', N'Mũ fedora sang trọng, tạo điểm nhấn cho trang phục.', 850000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh128.jpg'),
--nữ
(N'Áo tay dài công sở nữ sang trọng', N'Áo khoác nữ thời trang, bảo vệ bạn khỏi cái lạnh.', 1600000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh129.jpg'),
(N'Chân váy xòe công sở', N'Chân váy xòe dễ thương, hoàn hảo cho những buổi tiệc.', 900000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh130.jpg'),
(N'Giày cao gót công sở sang trọng', N'Giày cao gót đẹp, làm nổi bật phong cách của bạn.', 1200000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh131.jpg'),
(N'Quần tây nữ cao cấp', N'Quần tây với chất liệu cao cấp, ôm sát tạo dáng đẹp.', 1100000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh132.jpg'),
(N'Mũ lưỡi trai nữ thời trang', N'Mũ lưỡi trai thời thượng, bảo vệ bạn khỏi nắng và thêm phần cá tính.', 800000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh133.jpg');
-- Sản phẩm cho sở thích "Đơn giản, thường ngày" Thanh niên từ 0 đến 37 tuổi
INSERT INTO SanPham (TenSanPham, MoTa, Gia, SoLuongTonKho, DanhMucID, HinhAnhUrl)
VALUES 
-- Mức giá 15000-400000
--nam
(N'Áo polo nam basic', N'Áo polo nam với chất liệu mềm mại, thoáng khí, phù hợp cho những ngày hè.', 250000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh134.jpg'),
(N'Quần kaki nam thanh lịch', N'Quần kaki dáng ôm, dễ phối đồ cho các sự kiện hàng ngày.', 350000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh135.jpg'),
(N'Giày lười nam phong cách', N'Giày lười nam thời trang, tiện lợi cho những buổi đi chơi.', 400000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh136.jpg'),
(N'Quần short nam thoải mái', N'Quần short năng động, lý tưởng cho các hoạt động ngoài trời.', 180000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh137.jpg'),
(N'Mũ lưỡi trai nam', N'Mũ lưỡi trai thời trang giúp bạn bảo vệ khỏi ánh nắng mặt trời.', 150000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh138.jpg'),
--nữ
(N'Áo thun nữ basic', N'Áo thun nữ thoải mái, dễ dàng phối hợp với nhiều kiểu trang phục.', 300000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh139.jpg'),
(N'Quần legging nữ co giãn', N'Quần legging nữ với chất liệu co giãn, thích hợp cho mọi hoạt động.', 250000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh140.jpg'),
(N'Giày bệt nữ thời trang', N'Giày bệt nữ với thiết kế thanh lịch, phù hợp với nhiều phong cách.', 350000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh141.jpg'),
(N'Quần jean nữ ', N'Quần jean nữ nhẹ nhàng, lý tưởng cho mùa hè.', 180000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh142.jpg'),
(N'Mũ lưỡi trai nữ', N'Mũ lưỡi trai với nhiều màu sắc trẻ trung, phù hợp với mọi lứa tuổi.', 150000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh143.jpg'),
-- Mức giá 500000-750000
--nam
(N'Áo sơ mi nam trắng', N'Sơ mi nam trắng thanh lịch, phù hợp với các buổi tiệc hoặc đi làm.', 600000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh144.jpg'),
(N'Quần tây nam lịch lãm', N'Quần tây nam với chất liệu cao cấp, phù hợp cho môi trường công sở.', 700000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh145.jpg'),
(N'Giày oxford nam cổ điển', N'Giày oxford nam với thiết kế sang trọng, phù hợp cho các dịp trang trọng.', 750000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh146.jpg'),
(N'Quần boki nam phong cách', N'Quần boki với kiểu dáng hiện đại, phù hợp.', 500000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh147.jpg'),
(N'Mũ snapback nam', N'Mũ snapback thời trang, phù hợp cho mọi phong cách.', 550000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh148.jpg'),
--nữ
(N'Áo sơ mi nữ trắng', N'Sơ mi nữ trắng thanh lịch, dễ dàng phối hợp với quần và chân váy.', 600000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh149.jpg'),
(N'Quần tây nữ lịch lãm', N'Quần tây nữ với kiểu dáng hiện đại, thích hợp cho công việc và dạo phố.', 700000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh150.jpg'),
(N'Giày cao gót nữ thời trang', N'Giày cao gót với thiết kế tinh tế, tôn dáng chân và phù hợp với nhiều trang phục.', 750000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh151.jpg'),
(N'Váy baki nữ trẻ trung', N'Váy baki nữ với thiết kế trẻ trung, phù hợp cho mùa hè.', 500000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh152.jpg'),
(N'Mũ lưỡi trai nữ cá tính', N'Mũ lưỡi trai với họa tiết độc đáo, làm nổi bật phong cách cá nhân.', 550000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh153.jpg'),
-- Mức giá 800000-2000000
(N'Áo khoác nam thời trang', N'Áo khoác nam với chất liệu dày dạn, giữ ấm trong mùa đông.', 1200000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh154.jpg'),
(N'Quần jeans nam phong cách', N'Quần jeans nam với thiết kế thời trang, phù hợp cho mọi hoạt động.', 900000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh155.jpg'),
(N'Giày thể thao nam cao cấp', N'Giày thể thao nam với đệm êm, tạo cảm giác thoải mái khi vận động.', 1500000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh156.jpg'),
(N'Quần jogger nam tiện lợi', N'Quần jogger nam với chất liệu nhẹ, thích hợp cho việc tập luyện.', 850000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh157.jpg'),
(N'Mũ lưỡi trai nam cá tính', N'Mũ lưỡi trai với kiểu dáng hiện đại, phù hợp cho nhiều phong cách.', 800000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh158.jpg'),
--nữ
(N'Áo khoác nữ thời trang', N'Áo khoác nữ dày dạn, phù hợp với thời tiết lạnh.', 1200000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh159.jpg'),
(N'Quần jeans nữ phong cách', N'Quần jeans nữ với thiết kế trẻ trung, thích hợp cho dạo phố.', 900000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh160.jpg'),
(N'Giày thể thao nữ cao cấp', N'Giày thể thao nữ với độ bám tốt, phù hợp cho các hoạt động thể thao.', 1500000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh161.jpg'),
(N'Quần jogger nữ tiện lợi', N'Quần jogger nữ với chất liệu nhẹ, thoải mái cho mọi hoạt động.', 850000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh162.jpg'),
(N'Mũ lưỡi trai nữ cá tính', N'Mũ lưỡi trai nữ với thiết kế độc đáo, phù hợp cho phong cách năng động.', 800000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh163.jpg');
-- Sản phẩm cho sở thích "Thời trang du lịch" Thanh niên từ 0 đến 37 tuổi
INSERT INTO SanPham (TenSanPham, MoTa, Gia, SoLuongTonKho, DanhMucID, HinhAnhUrl)
VALUES 
-- Mức giá 15000-400000
--nam
(N'Áo khoác chống nước nam', N'Tiện lợi khi đi du lịch, chất liệu chống nước', 320000, 60, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh164.jpg'),
(N'Quần dài nam đi trekking', N'Thiết kế gọn nhẹ, co giãn, phù hợp cho các hoạt động ngoài trời', 290000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh165.jpg'),
(N'Giày thể thao nam chống trượt', N'Đế cao su chống trượt, thoải mái khi vận động', 350000, 45, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh166.jpg'),
(N'Quần short nam du lịch', N'Chất liệu polyester, thoáng khí, phù hợp cho thời tiết nóng', 125000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh167.jpg'),
(N'Nón rộng vành nam', N'Nón che nắng, thích hợp cho các chuyến đi dài', 180000, 70, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh168.jpg'),
--nữ
(N'Áo thun nữ thoáng mát', N'Áo thun nữ chất liệu cotton, dễ chịu khi mặc', 170000, 60, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh169.jpg'),
(N'Quần short nữ đi biển', N'Phong cách thời trang, màu sắc tươi trẻ', 150000, 80, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh170.jpg'),
(N'Giày chạy bộ nữ nhẹ', N'Thiết kế năng động, phù hợp cho mọi địa hình', 280000, 40, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh171.jpg'),
(N'Váy maxi nữ đi biển', N'Chất liệu voan mềm mại, thoải mái trong các chuyến đi biển', 300000, 30, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh172.jpg'),
(N'Nón chống nắng nữ', N'Thiết kế đẹp mắt, bảo vệ da khỏi ánh nắng', 210000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh173.jpg'),
-- Mức giá 500000-750000
--nam
(N'Áo khoác gió nam', N'Chống nước, giữ ấm, phù hợp cho các chuyến đi xa', 600000, 40, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh174.jpg'),
(N'Quần dài nam chống thấm', N'Thiết kế thời trang, chống thấm, thoáng mát', 550000, 35, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh175.jpg'),
(N'Giày trekking nam cao cấp', N'Đế chống trượt, thiết kế chắc chắn cho địa hình phức tạp', 700000, 30, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh176.jpg'),
(N'Quần short nam đi biển', N'Chất liệu nhanh khô, màu sắc nổi bật', 500000, 25, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh177.jpg'),
(N'Nón bảo vệ nam đa dụng', N'Bảo vệ khỏi gió và ánh nắng mặt trời', 550000, 45, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh178.jpg'),
--nữ
(N'Áo khoác gió nữ thời trang', N'Chất liệu chống thấm, phong cách năng động', 650000, 40, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh179.jpg'),
(N'Quần dài nữ du lịch', N'Chất liệu co giãn, thoải mái cho các hoạt động ngoài trời', 700000, 35, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh180.jpg'),
(N'Giày thể thao nữ trekking', N'Giày nữ chắc chắn, phù hợp cho mọi loại địa hình', 750000, 40, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh181.jpg'),
(N'Váy maxi nữ du lịch', N'Phong cách thời trang, thoáng mát, phù hợp cho mùa hè', 550000, 30, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh182.jpg'),
(N'Nón nữ đi biển', N'Nón rộng vành, chống nắng tốt cho các hoạt động ngoài trời', 600000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh183.jpg'),
-- Mức giá 800000-2000000
--nam
(N'Áo khoác chống thấm nam cao cấp', N'Áo khoác giữ ấm, chống gió cho những chuyến đi dài', 1200000, 20, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh184.jpg'),
(N'Quần dài nam trekking cao cấp', N'Quần chống thấm, co giãn 4 chiều, thoải mái', 1500000, 25, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh185.jpg'),
(N'Giày trekking nam chuyên nghiệp', N'Thiết kế chuyên nghiệp, độ bám cao, phù hợp cho leo núi', 1800000, 15, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh186.jpg'),
(N'Quần short trekking nam', N'Chất liệu cao cấp, phù hợp cho thời tiết nóng', 850000, 30, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh187.jpg'),
(N'Nón bảo vệ nam cao cấp', N'Nón chống gió và ánh nắng cho các hoạt động ngoài trời', 950000, 25, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh188.jpg'),
--nữ
(N'Áo khoác nữ loia chuyên nghiệp', N'Áo khoác loia chống gió và thấm nước, thiết kế nhẹ nhàng', 1600000, 20, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh189.jpg'),
(N'Quần dài nữ trekking', N'Chất liệu cao cấp, co giãn tốt, phù hợp cho mọi địa hình', 1350000, 25, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh190.jpg'),
(N'Giày trekking nữ chuyên nghiệp', N'Giày bền, chống trượt, phù hợp cho các chuyến leo núi', 1800000, 15, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh191.jpg'),
(N'Quần dài nữ du lịch cao cấp', N'Chất liệu cao cấp, thoáng mát cho các chuyến đi biển', 1200000, 30, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh192.jpg'),
(N'Nón chống nắng nữ cao cấp', N'Thiết kế thời trang, bảo vệ tối đa khỏi tia UV', 1100000, 25, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh193.jpg');
-- Sản phẩm cho sở thích "Thời trang hot trend" Thanh niên từ 0 đến 37 tuổi
INSERT INTO SanPham (TenSanPham, MoTa, Gia, SoLuongTonKho, DanhMucID, HinhAnhUrl)
VALUES 
-- Mức giá 15000-400000
-- nam
(N'Áo khoác thể thao nam đa năng', N'Áo khoác nhẹ, thoáng khí, phù hợp cho mọi hoạt động thể thao.', 300000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh194.jpg'),
(N'Quần jogger nam thời trang', N'Quần jogger thoải mái, phong cách thể thao trẻ trung.', 250000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh195.jpg'),
(N'Giày chạy bộ nam siêu nhẹ', N'Giày chạy bộ với thiết kế siêu nhẹ, hỗ trợ tốt cho chân.', 400000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh196.jpg'),
(N'Quần short thể thao nam chống thấm', N'Quần short thời trang, chất liệu chống thấm nước.', 350000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh197.jpg'),
(N'Mũ lưỡi trai thể thao phong cách', N'Mũ lưỡi trai thời trang, bảo vệ tốt khi ra ngoài.', 150000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh198.jpg'),
-- nữ
(N'Áo khoác thể thao nữ thời trang', N'Áo khoác nữ phong cách, thoải mái cho mùa đông.', 320000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh199.jpg'),
(N'Quần legging nữ thời trang', N'Quần legging co giãn, dễ chịu cho mọi hoạt động.', 280000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh200.jpg'),
(N'Giày thể thao nữ thời trang', N'Giày thể thao nữ phong cách, nhẹ và bền.', 450000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh201.jpg'),
(N'Quần short thể thao nữ trẻ trung', N'Quần short nữ trẻ trung, chất liệu thoáng mát.', 290000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh202.jpg'),
(N'Mũ lưỡi trai nữ phong cách', N'Mũ lưỡi trai nữ thời trang, bảo vệ nắng hiệu quả.', 180000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh203.jpg'),
-- Mức giá 500000-750000
-- nam
(N'Áo hoodie nam phong cách', N'Áo hoodie nam thời trang, giữ ấm hiệu quả trong mùa lạnh.', 650000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh204.jpg'),
(N'Quần thể thao nam ống rộng', N'Quần thể thao ống rộng, thoải mái cho mọi hoạt động.', 500000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh205.jpg'),
(N'Giày sneaker nam thời trang', N'Giày sneaker nam, thiết kế trẻ trung và hiện đại.', 600000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh206.jpg'),
(N'Quần cargo nam phong cách', N'Quần cargo với nhiều túi tiện dụng, thời trang.', 550000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh207.jpg'),
(N'Mũ bucket nam', N'Mũ bucket phong cách, bảo vệ nắng cho mùa hè.', 250000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh208.jpg'),
-- nữ
(N'Áo khoác bomber nữ', N'Áo khoác bomber thời trang, phù hợp với nhiều trang phục.', 600000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh209.jpg'),
(N'Quần jeans nữ thời trang', N'Quần jeans nữ với kiểu dáng trẻ trung và năng động.', 700000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh210.jpg'),
(N'Giày búp bê nữ thời trang', N'Giày búp bê nữ thoải mái, thích hợp cho nhiều dịp.', 450000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh211.jpg'),-------------lon
(N'Quần culottes nữ thời trang', N'Quần culottes nữ, phong cách thoáng mát và dễ chịu.', 500000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh212.jpg'),
(N'Mũ lưỡi trai nữ', N'Mũ lưỡi trai phong cách, thời trang và tiện lợi.', 180000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh213.jpg'),
-- Mức giá 800000-2000000
(N'Áo khoác thể thao nam cao cấp', N'Áo khoác thể thao nam, chất liệu tốt, giữ ấm hiệu quả.', 800000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh214.jpg'),
(N'Quần thể thao nam cao cấp', N'Quần thể thao nam chất liệu tốt, thoải mái khi vận động.', 950000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh215.jpg'),
(N'Giày thể thao nam cao cấp', N'Giày thể thao nam với thiết kế cao cấp, hỗ trợ tốt cho chân.', 1200000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh216.jpg'),
(N'Quần short thể thao nam cao cấp', N'Quần short nam cao cấp, chất liệu thoáng khí và bền bỉ.', 850000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh217.jpg'),
(N'Mũ lưỡi trai thể thao cao cấp', N'Mũ lưỡi trai chất lượng cao, phù hợp cho mọi hoạt động ngoài trời.', 250000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh218.jpg'),
-- nữ
(N'Áo khoác thể thao nữ cao cấp', N'Áo khoác thể thao nữ, chất liệu tốt, thiết kế thời trang.', 1200000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh219.jpg'),
(N'Quần ngắn nữ cao cấp', N'Quần ngắn nữ, chất liệu thoáng khí, phù hợp cho mọi hoạt động.', 1100000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh220.jpg'),
(N'Giày cao nữ cao cấp', N'Giày cao nữ chất lượng.', 1350000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh221.jpg'),
(N'Áo thể thao nữ năng động', N'Áo thể thao nữ thoáng khí, thiết kế năng động, thoải mái cho mọi hoạt động.', 210000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh222.jpg'),

(N'Áo thể thao nam cá tính', N'Áo thể thao nam với thiết kế cá tính, phù hợp cho những buổi tập thể dục.', 190000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh223.jpg'),
(N'Áo thể thao nam phong cách', N'Áo thể thao nam mang phong cách hiện đại, thích hợp cho mọi hoạt động ngoài trời.', 220000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh224.jpg'),
(N'Áo thể thao nam khỏe khoắn', N'Áo thể thao nam thiết kế khỏe khoắn, chất liệu thoáng khí, dễ chịu.', 200000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh225.jpg'),

(N'Áo thể thao nữ thoải mái', N'Áo thể thao nữ với chất liệu mềm mại, phù hợp cho những ngày tập luyện.', 180000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh226.jpg'),
(N'Áo thể thao nữ thời trang', N'Áo thể thao nữ thời trang, trẻ trung, phù hợp với phong cách sống năng động.', 210000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh227.jpg'),

--Xong-----------------------------
(N'Áo  nam trendy', N'Áo thể thao nam trendy với màu sắc nổi bật, dễ phối đồ.', 170000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh228.jpg'),
(N'Áo thể thao nữ hiện đại', N'Áo thể thao nữ hiện đại, mang lại phong cách năng động, tự tin.', 220000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh229.jpg'),
(N'Áo thể thao nam trẻ trung', N'Áo thể thao nam trẻ trung, lý tưởng cho những buổi tập luyện.', 190000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh230.jpg'),
(N'Áo cổ nữ đẳng cấp', N'Áo nữ đẳng cấp, mang lại sự thoải mái và phong cách.', 230000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh231.jpg'),

(N'Áo thể thao nam thể thao', N'Áo thể thao nam phù hợp cho những người yêu thích hoạt động thể thao.', 175000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh232.jpg'),
(N'Áo thể thao nữ trẻ trung', N'Áo thể thao nữ trẻ trung, phù hợp cho những ngày hè năng động.', 195000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh233.jpg'),
(N'Áo thể thao nữ năng động', N'Áo thể thao nữ năng động, thiết kế nhẹ nhàng, thoáng khí.', 180000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh234.jpg'),
(N'Áo thể thao nam cá tính', N'Áo thể thao nam cá tính với chất liệu tốt, thoải mái khi tập luyện.', 210000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh235.jpg'),
(N'Áo nữ khỏe khoắn', N'Áo nữ khỏe khoắn, phù hợp cho việc tập gym và thể dục.', 205000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh236.jpg'),

(N'Áo nam phong cách', N'Áo nam phong cách hiện đại, trẻ trung, thích hợp cho mọi hoạt động.', 185000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh237.jpg'),
(N'Áo gys nữ thoáng khí', N'Áo gys nữ thoáng khí, giúp bạn luôn cảm thấy dễ chịu.', 200000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh238.jpg'),
(N'Áo hiện đại', N'Áo hiện đại, dễ phối đồ cho nhiều dịp khác nhau.', 210000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh239.jpg'),
(N'Áo somi nữ cá tính', N'Áo somi nữ cá tính với thiết kế độc đáo và nổi bật.', 220000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh240.jpg'),
(N'Váy nữ trẻ trung', N'Váy nữ trẻ trung, thích hợp cho mùa hè.', 195000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh241.jpg'),

(N'giày siêu cao nữ phong cách', N'giày siêu cao nữ phong cách, chất liệu mềm mại, thoáng khí.', 185000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh242.jpg'),
(N'giày da cá sấu nam ', N'giày da cá sấu nam, thiết kế hiện đại, dễ phối đồ.', 175000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh243.jpg'),
(N'Áo thể thao nữ thời trang', N'Áo thể thao nữ thời trang, mang đến phong cách trẻ trung.', 190000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh244.jpg'),
(N'Áo thể thao nam khỏe khoắn', N'Áo thể thao nam khỏe khoắn, phù hợp cho những ngày hoạt động mạnh.', 200000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh245.jpg'),
(N'áo somi calion', N'áo somi calion, thiết kế thời trang, dễ mặc.', 210000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh246.jpg'),

(N'cà vạt nam trendy', N'cà vạt nam trendy với nhiều màu sắc trẻ trung.', 175000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh247.jpg'),
(N'Áo văn phòng nữ ', N'Áo văn phòng nữ, mang lại sự thoải mái và tự tin.', 225000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh248.jpg'),
(N'Áo thể thao nam bakito', N'Áo thể thao nam bakito, thiết kế trẻ trung và phong cách.', 210000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh249.jpg'),
(N'Áo phông nữ cá tính', N'Áo phông nữ cá tính, phù hợp cho những hoạt động năng động.', 200000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh250.jpg'),
(N'Áo khoác thể thao nam phong cách', N'Áo khoác thể thao nam phong cách, mang đến sự năng động cho người mặc.', 185000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh251.jpg'),

(N'Áo so mi nam none', N'Áo so mi nam none với nhiều màu sắc trẻ trung.', 175000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh252.jpg'),
(N'Áo công sở nữ đẳng cấp', N'Áo công sở nữ đẳng cấp, mang lại sự thoải mái và tự tin.', 225000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh253.jpg'),
(N'Áo polo hiện đại', N'Áo polo hiện đại, thiết kế trẻ trung và phong cách.', 210000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh254.jpg'),
(N'Áo coli cá tính', N'Áo coli nữ cá tính, phù hợp cho những hoạt động năng động.', 200000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh255.jpg'),
(N'Áo baggy', N'Áo baggy nam phong cách, mang đến sự năng động cho người mặc.', 185000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh256.jpg'),
(N'Áo cho nam siêu đẹp', N' mang đến sự năng động cho người mặc.', 185000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh257.jpg');
-- Sản phẩm cho sở thích "Thể thao" Trung niên từ 38 đến 60 tuổi
INSERT INTO SanPham (TenSanPham, MoTa, Gia, SoLuongTonKho, DanhMucID, HinhAnhUrl)
VALUES 
-- Mức giá 15000-400000
--nam
(N'Áo thể thao nam cổ tròn thoáng mát', N'Áo dành cho nam giới trung niên, chất liệu thoáng khí, phù hợp cho hoạt động thể thao ngoài trời.', 180000, 45, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh258.jpg'),
(N'Quần dài thể thao nam co giãn', N'Quần thể thao nam, chất liệu mềm mại, đàn hồi tốt, lý tưởng cho tập luyện và chạy bộ.', 220000, 60, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh259.jpg'),
(N'Giày chạy bộ nam chống trượt', N'Giày thể thao nam siêu nhẹ, đế chống trượt, phù hợp cho mọi địa hình.', 350000, 40, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh260.jpg'),
(N'Áo gió thể thao nam chống nước', N'Áo khoác thể thao nam, chất liệu chống nước, bảo vệ khi chạy bộ ngoài trời.', 280000, 55, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh261.jpg'),
(N'Ba lô thể thao nam nhiều ngăn', N'Ba lô thể thao với nhiều ngăn tiện dụng, chất liệu bền, dành cho nam giới trung niên.', 320000, 35, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh262.jpg'),
--xong
--nữ
(N'Áo thể thao nữ chống nắng', N'Áo thể thao nữ trung niên, chất liệu chống nắng, phù hợp cho tập luyện ngoài trời.', 200000, 48, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh263.jpg'),
(N'Quần legging thể thao nữ co giãn', N'Quần legging nữ ôm sát, chất liệu co giãn thoải mái, lý tưởng cho yoga và chạy bộ.', 170000, 52, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh264.jpg'),
(N'Giày thể thao nữ đệm êm chân', N'Giày thể thao nữ với đệm êm ái, phù hợp cho đi bộ đường dài và chạy bộ.', 300000, 60, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh265.jpg'),
(N'Áo khoác thể thao nữ dáng rộng', N'Áo khoác thể thao nữ trung niên, dáng rộng thoải mái, chống gió và chống nước.', 290000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh266.jpg'),
(N'Túi đeo vai thể thao nữ', N'Túi đeo vai thể thao tiện lợi, phù hợp cho các hoạt động ngoài trời, dành cho nữ trung niên.', 180000, 40, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh267.jpg'),

-- Mức giá 500000-750000
--nam
(N'Áo khoác gió nam chống tia UV', N'Áo khoác gió nam trung niên, chống tia UV, thích hợp cho các hoạt động ngoài trời.', 580000, 45, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh268.jpg'),
(N'Quần short thể thao nam chống thấm', N'Quần short thể thao nam chất liệu chống thấm nước, phù hợp cho đi bộ đường dài.', 620000, 38, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh269.jpg'),
(N'Giày leo núi nam chống trượt', N'Giày leo núi nam với đế chống trượt, đệm êm chân, phù hợp cho địa hình gồ ghề.', 720000, 30, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh270.jpg'),
(N'Ba lô leo núi thể thao nam', N'Ba lô leo núi dung tích lớn, dành cho các chuyến đi dài, thiết kế đặc biệt cho nam trung niên.', 650000, 20, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh271.jpg'),
(N'Kính mát thể thao nam chống lóa', N'Kính mát thể thao với khả năng chống lóa và chống tia UV, thích hợp cho nam giới trung niên.', 580000, 55, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh272.jpg'),

--nữ
(N'Áo khoác chống tia UV nữ', N'Áo khoác thể thao nữ trung niên, chống tia UV và gió, thích hợp cho đi bộ và leo núi.', 520000, 42, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh273.jpg'),
(N'Giày leo núi nữ chống trượt', N'Giày thể thao nữ dành cho leo núi, đế chống trượt và đệm êm chân, lý tưởng cho hoạt động ngoài trời.', 690000, 32, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh274.jpg'),
(N'Quần short thể thao nữ thoáng mát', N'Quần thể thao nữ trung niên, chất liệu thoáng khí, phù hợp cho các hoạt động thể thao.', 550000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh275.jpg'),
(N'Bình nước thể thao nữ', N'Bình nước thể thao tiện lợi, dung tích lớn, giữ nhiệt tốt, dành cho nữ giới trung niên.', 520000, 40, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh276.jpg'),
(N'Kính mát thể thao nữ chống UV', N'Kính mát thể thao nữ với khả năng chống tia UV và chống lóa, phù hợp cho hoạt động ngoài trời.', 670000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh277.jpg'),

-- Mức giá 800000-2000000
--nam
(N'Áo khoác thể thao nam chống gió', N'Áo khoác thể thao nam trung niên, chống gió và nước, lý tưởng cho đi bộ và chạy bộ.', 1500000, 45, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh278.jpg'),
(N'Giày leo núi nam chuyên dụng', N'Giày leo núi nam chuyên dụng, chất liệu chống trượt và thấm nước, đệm lót siêu êm.', 1700000, 35, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh279.jpg'),
(N'Bộ quần áo thể thao nam chất liệu cao cấp', N'Bộ quần áo thể thao với chất liệu cao cấp, đàn hồi tốt, dành cho nam giới trung niên.', 1850000, 28, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh280.jpg'),
(N'Đồng hồ thể thao nam chống nước', N'Đồng hồ thể thao nam, thiết kế chống nước, phù hợp cho các hoạt động thể thao ngoài trời.', 2000000, 25, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh281.jpg'),
(N'Balo thể thao nam chuyên dụng', N'Ba lô thể thao dung tích lớn, chống nước, chuyên dụng cho các hoạt động leo núi, đi bộ đường dài.', 1800000, 18, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh282.jpg'),

--nữ 
(N'Áo khoác thể thao nữ giữ nhiệt', N'Áo khoác thể thao nữ trung niên, giữ nhiệt tốt, phù hợp cho thời tiết lạnh khi chạy bộ.', 1600000, 40, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh283.jpg'), 
(N'Giày chạy bộ nữ chất lượng cao', N'Giày chạy bộ nữ với thiết kế chuyên dụng, đệm lót êm ái, chống trượt tốt, dành cho nữ trung niên.', 1900000, 35, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh284.jpg'), 
(N'Quần dài thể thao nữ giữ nhiệt', N'Quần dài thể thao nữ, chất liệu giữ nhiệt và co giãn, phù hợp cho các hoạt động ngoài trời.', 1750000, 28, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh285.jpg'), 
(N'Đồng hồ thể thao nữ chống nước', N'Đồng hồ thể thao nữ với khả năng chống nước, thiết kế phù hợp cho các hoạt động leo núi và đi bộ.', 2000000, 22, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao '), 'hinh286.jpg'), 
(N'Balo leo núi nữ chuyên dụng', N'Balo leo núi nữ dung tích lớn, chất liệu bền bỉ, phù hợp cho các chuyến đi dài.', 1800000, 15, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh287.jpg');
-- Sản phẩm cho sở thích "Công sở, lịch sự" Trung niên từ 38 đến 60 tuổi
INSERT INTO SanPham (TenSanPham, MoTa, Gia, SoLuongTonKho, DanhMucID, HinhAnhUrl)
VALUES 
-- Mức giá 15000-400000
--nam
(N'Áo sơ mi nam dài tay cao cấp', N'Áo sơ mi lịch lãm cho nam trung niên, phù hợp đi làm và gặp gỡ đối tác', 180000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh288.jpg'),
(N'Quần âu nam thanh lịch', N'Quần âu công sở thoải mái cho nam trung niên', 250000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh289.jpg'),
(N'Giày da nam sang trọng', N'Giày da mềm mại, thiết kế tối giản nhưng tinh tế', 350000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh290.jpg'),
(N'Cà vạt họa tiết sang trọng', N'Cà vạt chất liệu lụa cao cấp, phù hợp với vest nam trung niên', 120000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh291.jpg'),
(N'Túi xách da bò', N'Túi xách công sở nam chất liệu da bò, kiểu dáng sang trọng', 370000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh292.jpg'),
--nữ
(N'Áo sơ mi nữ cổ điển', N'Áo sơ mi trắng thanh lịch, phù hợp đi làm và hội họp', 190000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh293.jpg'),
(N'Quần tây nữ ống đứng', N'Quần tây công sở dành cho nữ trung niên, thiết kế đơn giản mà tinh tế', 220000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh294.jpg'),
(N'Giày cao gót nữ thanh lịch', N'Giày cao gót nữ 5cm phù hợp cho môi trường công sở', 300000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh295.jpg'),
(N'Túi xách nữ kiểu dáng cổ điển', N'Túi xách công sở nữ thiết kế tinh tế, màu đen sang trọng', 330000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh296.jpg'),
(N'áo cổ nữ họa tiết nhẹ nhàng', N' chất liệu lụa mềm mại, tạo điểm nhấn cho trang phục công sở', 160000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh297.jpg'),
-- Mức giá 500000-750000
--nam
(N'Áo vest nam phong cách cổ điển', N'Áo vest lịch lãm, kiểu dáng cổ điển dành cho nam trung niên', 550000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh298.jpg'),
(N'Quần âu nam cắt may tinh tế', N'Quần âu cao cấp, form chuẩn cho nam giới trung niên', 650000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh299.jpg'),
(N'Giày lười nam da bò', N'Giày lười da bò mềm mại, sang trọng, phù hợp cho các buổi gặp gỡ công việc', 700000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh300.jpg'),
(N'Túi xách  cao cấp', N'Túi xách nam trung niên, chất liệu da cao cấp, thiết kế sang trọng', 730000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh301.jpg'),
(N'vest nam', N' bản to, thiết kế mạnh mẽ cho nam trung niên', 550000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh302.jpg'),
--nữ
(N'quần áo nữ cổ điển', N' công sở dành cho nữ trung niên, kiểu dáng cổ điển', 600000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh303.jpg'),
(N'Váy liền thân dáng ôm', N'Váy công sở dành cho nữ trung niên, dáng ôm tinh tế', 720000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh304.jpg'),
(N'Giày bệt nữ da bò', N'Giày bệt nữ chất liệu da bò mềm, thoải mái nhưng vẫn lịch sự', 650000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh305.jpg'),
(N'Túi xách nữ da cao cấp', N'Túi xách nữ màu nâu nhạt, thiết kế đơn giản mà tinh tế', 700000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh306.jpg'),
(N'áo choàng cổ lụa sang trọng', N'Áo choàng lụa thiết kế họa tiết nhẹ nhàng, mang lại vẻ đẹp thanh lịch', 580000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh307.jpg'),
-- Mức giá 800000-2000000
--nam
(N'Áo khoác da nam cổ điển', N'Áo khoác da thật, kiểu dáng cổ điển, phong cách lịch sự', 1500000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh308.jpg'),
(N'Quần tây nam cao cấp', N'Quần tây nam chất liệu cotton thoáng mát, phù hợp với nam trung niên', 950000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh309.jpg'),
(N'Giày Oxford nam', N'Giày Oxford cổ điển cho nam giới, kiểu dáng lịch lãm', 1200000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh310.jpg'),
(N'Túi đựng laptop da bò', N'Túi xách đựng laptop da bò cao cấp, phù hợp với doanh nhân trung niên', 1800000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh311.jpg'),
(N'Kính mát nam hàng hiệu', N'Kính mát nam thương hiệu nổi tiếng, mang lại vẻ ngoài sang trọng', 1700000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh312.jpg'),
--nữ
(N'Áo khoác da nữ thời thượng', N'Áo khoác da cho nữ trung niên, phong cách cổ điển mà hiện đại', 1450000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh313.jpg'),
(N'Váy dự tiệc công sở', N'Váy dự tiệc sang trọng, thiết kế tinh tế cho nữ trung niên', 1300000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh314.jpg'),
(N'Giày cao gót nữ đế nhọn', N'Giày cao gót đế nhọn 7cm, thiết kế tối giản nhưng sang trọng', 1600000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh315.jpg'),
(N'Túi xách tay nữ cao cấp', N'Túi xách nữ hàng hiệu cao cấp, thiết kế cổ điển và sang trọng', 1950000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh316.jpg'),
(N'Váy hàng hiệu', N'cao cấp, hàng hiệu nổi tiếng, màu sắc nhẹ nhàng và sang trọng', 1200000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh317.jpg');
-- Sản phẩm cho sở thích "Đơn giản, thường ngày" Trung niên từ 38 đến 60 tuổi
INSERT INTO SanPham (TenSanPham, MoTa, Gia, SoLuongTonKho, DanhMucID, HinhAnhUrl) 
VALUES 
-- Mức giá 15000-400000
-- nam
(N'Áo polo nam cotton thoải mái', N'Phong cách thường ngày, phù hợp cho nam giới trung niên', 180000, 40, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh318.jpg'),
(N'Quần kaki nam trung niên', N'Chất liệu kaki mềm mại, mặc thoải mái hàng ngày', 220000, 30, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh319.jpg'),
(N'Giày lười da nam trung niên', N'Giày lười tiện lợi, thiết kế đơn giản phù hợp với mọi lứa tuổi', 350000, 25, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh320.jpg'),
(N'Áo sơ mi dài tay thoáng mát', N'Sơ mi dài tay, thiết kế cổ điển cho nam trung niên', 275000, 20, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh321.jpg'),
(N'Giày quai ngang da thật nam', N'Giày quai ngang thoáng mát, phù hợp cho mùa hè', 150000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh322.jpg'),
-- nữ
(N'Áo phông nữ tay lỡ', N'Áo phông thiết kế đơn giản, thích hợp mặc thường ngày', 150000, 45, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh323.jpg'),
(N'Váy suông nữ trung niên', N'Váy suông dài cho nữ trung niên, đơn giản mà thanh lịch', 250000, 35, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh324.jpg'),
(N'Dép xỏ ngón nữ thoải mái', N'Dép xỏ ngón nhẹ nhàng, thiết kế tiện lợi', 80000, 40, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh325.jpg'),
(N'Áo khoác len nữ dáng dài', N'Áo khoác len mềm, phù hợp cho những ngày se lạnh', 300000, 15, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh326.jpg'),
(N'Mũ lưỡi trai nữ thời trang', N'Mũ lưỡi trai tiện lợi, phù hợp cho hoạt động ngoài trời', 150000, 25, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh327.jpg'),

-- Mức giá 500000-750000
-- nam
(N'Áo len cổ tròn cao cấp', N'Áo len dành cho mùa thu đông, thiết kế tối giản', 650000, 20, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh328.jpg'),
(N'Quần jeans nam trung niên', N'Quần jeans co giãn tốt, thích hợp mặc hàng ngày', 700000, 30, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh329.jpg'),
(N'Giày da lười nam', N'Giày da cao cấp, thiết kế đơn giản, dễ phối đồ', 750000, 10, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh330.jpg'),
(N'Áo khoác gió nam trung niên', N'Áo khoác gió nhẹ, chống nắng tốt', 600000, 25, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh331.jpg'),
(N'Túi đeo chéo da bò', N'Túi đeo chéo đơn giản, làm từ da bò thật', 500000, 15, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh332.jpg'),
-- nữ
(N'Váy hoa nữ trung niên', N'Váy hoa nhẹ nhàng, dễ mặc và thoải mái', 550000, 12, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh333.jpg'),
(N'Quần vải nữ công sở', N'Quần vải mềm mại, thích hợp cho nữ trung niên', 600000, 25, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh334.jpg'),
(N'Giày bệt nữ trung niên', N'Giày bệt thoải mái, thiết kế đơn giản cho nữ', 700000, 20, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh335.jpg'),
(N'Áo khoác cardigan nữ', N'Áo khoác len mỏng, phù hợp với thời tiết mát mẻ', 650000, 18, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh336.jpg'),
(N'Mũ rộng vành nữ', N'Mũ rộng vành cho nữ, thích hợp cho các chuyến du lịch', 550000, 22, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh337.jpg'),

-- Mức giá 800000-2000000
-- nam
(N'Áo vest nam trung niên', N'Áo vest sang trọng, thiết kế lịch lãm cho nam', 1800000, 10, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh338.jpg'),
(N'Quần âu nam trung niên', N'Quần âu chất lượng cao, thiết kế ôm vừa vặn', 950000, 15, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh339.jpg'),
(N'Giày da cao cấp nam', N'Giày da lịch lãm, phù hợp cho các sự kiện quan trọng', 1600000, 8, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh340.jpg'),
(N'Áo khoác da nam', N'Áo khoác da thật, bền đẹp với thời gian', 2000000, 5, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh341.jpg'),
(N'Túi da nam', N'Túi da cầm tay, phù hợp cho phong cách lịch lãm', 900000, 12, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh342.jpg'),
-- nữ
(N'Áo đơn giản', N'thiết kế tinh tế cho nữ trung niên', 1800000, 8, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh343.jpg'),
(N'Váy  ở nhà', N' tạo sự thoải mái và thanh lịch', 1600000, 10, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh344.jpg'),
(N'quần nữ trung niên', N'vừa phải, thiết kế đơn giản mà đẹp mắt', 1500000, 7, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh345.jpg'),
(N'quần ở nhà', N' gọn, thanh lịch cho nữ', 1200000, 5, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh346.jpg'),
(N'Áo khoác dạ nữ', N'Áo khoác dạ ấm áp, thích hợp cho mùa đông', 900000, 12, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh347.jpg');
-- Sản phẩm cho sở thích "Thời trang du lịch" Trung niên từ 38 đến 60 tuổi 
INSERT INTO SanPham (TenSanPham, MoTa, Gia, SoLuongTonKho, DanhMucID, HinhAnhUrl) 
VALUES 
-- Mức giá 15000-400000
--nam
(N'Áo gió du lịch nam chống thấm nước', N'Thiết kế năng động, thích hợp cho các chuyến đi', 180000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh348.jpg'),
(N'Quần ngắn du lịch nam thoáng mát', N'Tiện dụng trong mọi chuyến đi dài ngày', 220000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh349.jpg'),
(N'Giày lười nam thoáng khí', N'Giày tiện dụng, phong cách cho những buổi dạo phố', 180000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh350.jpg'),
(N'Mũ chống nắng nam thoáng mát', N'Phù hợp cho các hoạt động ngoài trời', 125000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh351.jpg'),
(N'Túi đeo chéo nam chống nước', N'Tiện lợi và phong cách cho chuyến du lịch', 170000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh352.jpg'),
--nữ
(N'Áo khoác du lịch nữ chống nắng', N'Thiết kế nhẹ, chống nắng hiệu quả', 190000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh353.jpg'),
(N'Quần vải du lịch nữ co giãn', N'Dễ chịu khi vận động trong các chuyến đi', 150000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh354.jpg'),
(N'Giày sandal nữ thoáng mát', N'Sandal nhẹ nhàng, phù hợp với nhiều loại địa hình', 140000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh355.jpg'),
(N'túi xách ', N'thời trang phù hợp đi dạo', 125000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh356.jpg'),
(N'Túi đeo chéo nữ chống nước', N'Túi nhỏ gọn nhưng đầy tiện dụng', 150000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh357.jpg'),

-- Mức giá 500000-750000
--nam
(N'Quần áo du lịch nam đa năng', N'Chống gió, chống nước phù hợp mọi địa hình', 620000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh358.jpg'),
(N'Quần du lịch nam chống nước', N'Thiết kế tiện dụng, chống thấm hiệu quả', 550000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh359.jpg'),
(N'Giày trekking nam chống trượt', N'Phù hợp cho những chuyến leo núi', 650000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh360.jpg'),
(N'Mũ vành du lịch nam', N'Chống nắng, thoáng khí cho những chuyến dã ngoại', 520000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh361.jpg'),
(N'Balo du lịch nam chống nước', N'Thiết kế rộng rãi, dễ dàng di chuyển', 700000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh362.jpg'),
--nữ
(N'Áo du lịch nữ chống gió', N'Thiết kế nhẹ, dễ gấp gọn mang theo', 590000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh363.jpg'),
(N'Quần jean du lịch nữ co giãn', N'Tiện lợi trong các hoạt động ngoài trời', 550000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh364.jpg'),
(N'Giày thể thao nữ chống trượt', N'Phù hợp mọi địa hình, bảo vệ đôi chân', 600000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh365.jpg'),
(N'Túi đeo du lịch nữ chống nước', N'Dễ dàng mang theo trong các chuyến đi', 550000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh366.jpg'),
(N'Mũ chống nắng du lịch nữ', N'Chống nắng tốt, thiết kế nữ tính', 500000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh367.jpg'),

-- Mức giá 800000-2000000
--nam
(N'Áo khoác du lịch cao cấp', N'Chất liệu cao cấp, bảo vệ cơ thể khỏi thời tiết khắc nghiệt', 1200000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh368.jpg'),
(N'Quần trekking nam chuyên dụng', N'Quần chống nước, bảo vệ đôi chân', 900000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh369.jpg'),
(N'Bình nam cao cấp', N'chất liệu bền', 1500000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh370.jpg'),
(N'Mũ du lịch nam', N'Bảo vệ đầu trong những chuyến leo núi khó khăn', 850000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh371.jpg'),
(N'Balo du lịch nam đa năng', N'Balo cỡ lớn, có nhiều ngăn tiện lợi', 1900000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh372.jpg'),
--nữ
(N'Áo quần du lịch nữ cao cấp', N'phong cách thời trang', 1200000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh373.jpg'),
(N'Quần trekking nữ co giãn', N'Quần bảo vệ, giúp thoải mái di chuyển', 900000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh374.jpg'),
(N'Giày nice nữ chống trượt', N'Giày chuyên dụng cho những chuyến leo núi', 1350000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh375.jpg'),
(N'Mũ du lịch nữ thời trang', N'Mũ thiết kế bảo vệ khỏi ánh nắng mặt trời', 850000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh376.jpg'),
(N'Túi du lịch nữ cao cấp', N'Túi lớn đa năng, thích hợp cho chuyến đi xa', 1700000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh377.jpg');
-- Sản phẩm cho sở thích "Thời trang hot trend" Trung niên từ 38 đến 60 tuổi
INSERT INTO SanPham (TenSanPham, MoTa, Gia, SoLuongTonKho, DanhMucID, HinhAnhUrl)
VALUES 
-- Mức giá 15000-400000
--nam
(N'cvải co giãn', N'Thời trang thoải mái cho hoạt động hàng ngày', 200000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh378.jpg'),
(N'Quần boki nam trung niên', N'Phong cách trẻ trung nhưng lịch sự', 350000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh379.jpg'),
(N'hính mắt da nam chống trượt', N'Lịch lãm, phù hợp cho cả công sở và dạo phố', 300000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh380.jpg'),
(N'Áo khoác nam giữ nhiệt cổ điển', N'Áo len ấm áp cho mùa đông, phong cách cổ điển', 250000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh381.jpg'),
(N'Mũ nồi nam phong cách retro', N'Thời trang retro, tạo điểm nhấn', 150000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh382.jpg'),
--nữ
(N'Áo khoác nữ trung niên dạ tweed', N'Sang trọng, giữ ấm trong mùa đông', 350000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh383.jpg'),
(N'Quần âu nữ trung niên', N'Phong cách công sở lịch sự, thoải mái', 200000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh384.jpg'),
(N'Giày cao gót nữ êm chân', N'Giày cao gót dành cho các sự kiện và công sở', 300000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh385.jpg'),
(N'Áo len nữ mỏng giữ ấm', N'Áo len mỏng, thích hợp cho mùa thu và đông', 180000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh386.jpg'),
(N'Mũ lưỡi trai nữ phong cách năng động', N'Thời trang đơn giản nhưng năng động', 120000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh387.jpg'),
-- Mức giá 500000-750000
--nam
(N'Áo sơ mi nam trung niên cao cấp', N'Chất liệu cotton cao cấp, thoáng mát', 600000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh388.jpg'),
(N'Quần kaki nam chống nhăn', N'Phong cách lịch lãm, chống nhăn hiệu quả', 550000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh389.jpg'),
(N'kính tây nam da thật', N' lịch lãm cho sự kiện và công việc', 700000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh390.jpg'),
(N'Áo  cashmere nam', N'Chất liệu cashmere mềm mại, sang trọng', 650000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh391.jpg'),
(N'Mũ cho nam cao cấp', N'Phong cách cổ điển nhưng thời trang', 500000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh392.jpg'),
--nữ
(N'Áo sơ mi nữ ren', N'Thời trang nữ trung niên với phong cách sang trọng', 650000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh393.jpg'),
(N'Quần vải nữ trung niên', N'Quần vải cao cấp, thoải mái và trang nhã', 600000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh394.jpg'),
(N'Giày cao nữ trung niên cao cấp', N'bền và sang trọng', 700000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh395.jpg'),
(N'Áo thể thao dệt kim nữ', N'Chất liệu dệt kim thoải mái', 600000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh396.jpg'),
(N'Mũ nữ thời trang', N'Phù hợp cho đi dạo và nghỉ dưỡng', 550000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh397.jpg'),
-- Mức giá 800000-2000000
--nam
(N'Áo vest nam cao cấp', N'Áo vest phong cách doanh nhân lịch lãm', 1800000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh398.jpg'),
(N'Quần âu nam chống thấm nước', N'Quần âu cao cấp với công nghệ chống thấm', 1500000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh399.jpg'),
(N'Giày lười nam da cao cấp', N'Giày lười da thật, thoải mái và sang trọng', 2000000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh400.jpg'),
(N'Áo  dạ nam dài', N'Áo khoác dạ phong cách Hàn Quốc', 1600000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh401.jpg'),
(N'Mũ da cao cấp', N'Thời trang độc đáo và sang trọng', 800000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh402.jpg'),
--nữ
(N'Áo thể thao dạ nữ nhanh khô', N'nhanh khô thoái mải thoáng mát', 1800000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh403.jpg'),
(N'Quần âu nữ chất liệu cashmere', N'Chất liệu cashmere cao cấp, mềm mại và thoải mái', 1600000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh404.jpg'),
(N'Giày cao gót nữ da thật', N'Giày cao gót da thật, phù hợp cho các dịp đặc biệt', 2000000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh405.jpg'),
(N'đống hồ cashmere nữ', N'chính xác và siêu bền', 1500000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh406.jpg'),
(N'Mũ len cao cấp nữ', N'Phù hợp cho mùa đông và các chuyến du lịch', 800000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh407.jpg');
-- Sản phẩm cho sở thích "Thể thao" Cao tuổi từ 60 tuổi trở lên
INSERT INTO SanPham (TenSanPham, MoTa, Gia, SoLuongTonKho, DanhMucID, HinhAnhUrl)
VALUES 
-- Mức giá 15000-400000
--nam
(N'Áo thể thao Nam thoáng khí', N'Thể thao năng động', 150000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh408.jpg'),
(N'Quần thể thao Nam thoáng khí', N'Thể thao năng động', 150000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh409.jpg'),
(N'Giày thể thao Nam siêu nhẹ', N'Thể thao năng động', 150000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh410.jpg'),
(N'Quần short thể thao nam xuất khẩu Kappa chất liệu polyester cao cấp', N'Thể thao năng động', 125000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh411.jpg'),
(N'Mũ lưỡi trai', N'Thể thao năng động', 150000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh412.jpg'),
--nữ
(N'Áo thể thao Nữ thoáng khí', N'Thể thao năng động', 150000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh413.jpg'),
(N'Quần thể thao Nữ thoáng khí', N'Thể thao năng động', 150000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh414.jpg'),
(N'Giày thể thao Nữ siêu nhẹ', N'Thể thao năng động', 150000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh415.jpg'),
(N'Quần sort thể thao Nữ xuất khẩu Kappa chất liệu polyester cao cấp', N'Thể thao năng động', 125000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh416.jpg'),
(N'Mũ', N'Thể thao năng động', 150000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh417.jpg'),
-- Mức giá 500000-750000
--nam
(N'Áo thể thao Nam cao cấp', N'Thể thao năng động', 650000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh418.jpg'),
(N'Quần thể thao Nam cao cấp', N'Thể thao năng động', 600000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh419.jpg'),
(N'Giày thể thao Nam siêu nhẹ cao cấp', N'Thể thao năng động', 700000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh420.jpg'),
(N'Quần short thể thao nam xuất khẩu Kappa chất liệu polyester cao cấp', N'Thể thao năng động', 550000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh421.jpg'),
(N'Mũ lưỡi trai cao cấp', N'Thể thao năng động', 500000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh422.jpg'),
--nữ
(N'Áo thể thao Nữ cao cấp', N'Thể thao năng động', 650000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh423.jpg'),
(N'Áo dưỡng sinh thể thao Nữ cao cấp', N'Thể thao năng động', 600000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh424.jpg'),
(N'Giày thể thao Nữ siêu nhẹ cao cấp', N'Thể thao năng động', 700000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh425.jpg'),
(N'Quần áo thể thao Nữ cao cấp', N'Thể thao nhẹ nhàng', 550000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh426.jpg'),
(N'Mũ lưỡi trai Nữ cotton', N'Thể thao năng động', 500000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh427.jpg'),
-- Mức giá 800000-2000000
--nam
(N'Áo thể thao Nam cao cấp đặc biệt', N'Thể thao năng động', 1200000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh428.jpg'),
(N'Quần áo thể thao Nam cao cấp đặc biệt', N'Thể thao năng động', 1100000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh429.jpg'),
(N'Giày thể thao Nam siêu nhẹ đặc biệt', N'Thể thao năng động', 1300000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh430.jpg'),
(N'Quần short thể thao nam cao cấp đặc biệt', N'Thể thao vừa phải phù hợp cao tuổi', 1000000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh431.jpg'),
(N'Mũ lưỡi trai đặc biệt', N'Thể thao năng động', 900000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh432.jpg'),
--nữ
(N'Áo thể thao Nữ cao cấp đặc biệt', N'Thể thao năng động', 1200000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh433.jpg'),
(N'Quần áo thể thao Nữ cao cấp đặc biệt', N'Thể thao năng động', 1100000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh434.jpg'),
(N'Giày thể thao Nữ siêu nhẹ đặc biệt', N'Thể thao năng động', 1300000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh435.jpg'),
(N'Quần dài đặc biệt', N'Thể thao năng động', 1000000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh436.jpg'),
(N'Mũ lưỡi trai đặc biệt', N'Thể thao năng động', 900000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thể thao'), 'hinh437.jpg');
-- Sản phẩm cho sở thích "Công sở, lịch sự" Trung niên từ 60 tuổi trở lên
INSERT INTO SanPham (TenSanPham, MoTa, Gia, SoLuongTonKho, DanhMucID, HinhAnhUrl)
VALUES 
-- Mức giá 15000-400000
--nam --mới mấy cái cuối giày đổi từ mũ
(N'Áo sơ mi nam thoáng khí', N'Phong cách công sở, dễ chịu cho người cao tuổi', 250000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh437.jpg'),
(N'Quần tây nam công sở', N'Sang trọng và thoải mái cho mọi dịp', 350000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh438.jpg'),
(N'Giày da nam lịch lãm', N'Giày da mềm mại, phù hợp cho người cao tuổi', 300000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh439.jpg'),
(N'giày nam lịch sự', N'Mẫu giày thời trang cho công sở', 200000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh440.jpg'),
(N'Cặp tài liệu', N'Bảo vệ tốt tài liệu và phong cách cho người cao tuổi', 150000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh441.jpg'),
--nữ
(N'Áo blouse nữ thoáng khí', N'Phong cách thanh lịch, thoải mái cho người cao tuổi', 250000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh442.jpg'),
(N'Quần tây nữ công sở', N'Sang trọng và dễ chịu, phù hợp với mọi vóc dáng', 350000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh443.jpg'),
(N'Giày cao gót nữ thoải mái', N'Giày thời trang giúp tôn dáng cho người lớn tuổi', 300000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh444.jpg'),
(N'váy nữ lịch sự', N'Mẫu váy năng động nhưng vẫn thanh lịch', 200000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh445.jpg'),
(N'balo thời trang nữ', N'Sản phẩm bảo vệ tốt và thời trang cho người cao tuổi', 150000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh446.jpg'),
-- Mức giá 500000-750000
--nam
(N'Áo vest nam cao cấp', N'Sản phẩm sang trọng dành cho những dịp quan trọng', 650000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh447.jpg'),
(N'Quần tây nam cao cấp', N'Mẫu quần tây được thiết kế tinh tế', 600000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh448.jpg'),
(N'Giày da nam cao cấp', N'Giày lịch lãm, phong cách cho người lớn tuổi', 700000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh449.jpg'),
(N'Đống hồ nam công sở', N'Mẫu Đống hồ thời trang cho người cao tuổi', 550000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh450.jpg'),
(N'cà vạt nam cao cấp', N'Sản phẩm thời trang cho phong cách công sở', 500000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh451.jpg'),
--nữ
(N'Áo vest nữ cao cấp', N'Sang trọng, phù hợp với mọi dịp gặp mặt', 650000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh452.jpg'),
(N'Quần tây nữ cao cấp', N'Mẫu quần tây thiết kế đẹp, thoải mái', 600000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh453.jpg'),
(N'Giày cao gót nữ cao cấp', N'Giày thanh lịch, dễ đi cho người lớn tuổi', 700000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh454.jpg'),
(N'ĐỒng hồ nữ công sở', N'phong cách và thoải mái', 550000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh455.jpg'),
(N'Giày công sơ', N'Sản phẩm thời trang, bảo vệ tốt cho người cao tuổi', 500000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh456.jpg'),
-- Mức giá 800000-2000000
--nam
(N'Áo vest nam đặc biệt', N'Sản phẩm cao cấp cho những sự kiện đặc biệt', 1200000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh457.jpg'),
(N'Vest tây nam đặc biệt', N'Mẫu Vest tây lịch lãm cho người lớn tuổi', 1100000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh458.jpg'),
(N'Giày da nam đặc biệt', N'Giày phong cách và thoải mái cho người cao tuổi', 1300000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh459.jpg'),
(N'balo đeo nam đặc biệt', N'thời trang cho mùa hè', 1000000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh460.jpg'),
(N' Giày nam đặc biệt', N'Giúp bảo vệ và thêm phần phong cách cho người cao tuổi', 900000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh461.jpg'),
--nữ
(N'váy nữ đặc biệt', N'Phong cách sang trọng, phù hợp cho những sự kiện đặc biệt', 1200000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh462.jpg'),
(N'Quần tây nữ đặc biệt', N'Mẫu quần tây thanh lịch cho người lớn tuổi', 1100000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh463.jpg'),
(N' veesst cloba nữ đặc biệt', N' lịch lãm, tôn dáng cho người lớn tuổi', 1300000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh464.jpg'),
(N'Vest nữ đặc biệt', N'Mẫu  thời trang cho mùa hè', 1000000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh465.jpg'),
(N'Giày búp bê', N'Thời trang và bảo vệ tốt cho người cao tuổi', 900000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Công sở, lịch sự'), 'hinh466.jpg');
-- Sản phẩm cho sở thích "Đơn giản, thường ngày" Cao tuổi từ 60 tuổi trở lên
INSERT INTO SanPham (TenSanPham, MoTa, Gia, SoLuongTonKho, DanhMucID, HinhAnhUrl) 
VALUES 
-- Mức giá 15000-400000
-- nam
(N'Áo cotton trung niên', N'Áo cotton mềm mại, thoáng mát, phù hợp cho nam cao tuổi', 170000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh467.jpg'),
(N'Quần  kaki nam', N'Quần kaki thoải mái, dễ chịu cho các hoạt động hàng ngày', 230000, 35, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh468.jpg'),
(N'Giày thể thao cao cấp nam', N'Giày thể thao nhẹ nhàng, đơn giản và bền bỉ cho nam giới', 320000, 28, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh469.jpg'),
(N'Áo dài tay nam', N'Áo thun giữ ấm tốt, phù hợp mặc vào mùa thu đông', 260000, 18, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh470.jpg'),
(N'Dép da thoáng khí', N'Dép da thoáng khí, nhẹ nhàng phù hợp với thời tiết nóng', 145000, 45, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh471.jpg'),
-- nữ
(N'Áo khoác nhẹ nữ', N'Áo khoác nhẹ, dễ dàng phối đồ, phù hợp với thời tiết mát mẻ', 150000, 32, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh472.jpg'),
(N'Váy dài trung niên', N'Váy dài nhẹ nhàng, phù hợp với phong cách thanh lịch của nữ cao tuổi', 270000, 20, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh473.jpg'),
(N'Dép bệt nữ', N'Dép bệt nữ thoải mái, dễ dàng mang đi dạo hay ở nhà', 85000, 38, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh474.jpg'),
(N'Áo thun nhẹ', N'Áo thun mềm mỏng cho nữ, phù hợp khi thời tiết hè', 285000, 22, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh475.jpg'),
(N'Mũ len nữ cao tuổi', N'Mũ len mềm mại, giữ ấm tốt vào mùa đông', 160000, 25, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh476.jpg'),

-- Mức giá 500000-750000
-- nam
(N'Áo ấm nam cao cấp', N'Áo ấm cao cấp, phù hợp cho thời tiết lạnh, thiết kế cổ điển', 670000, 20, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh477.jpg'),
(N'Quần đen nam', N'Quần cho nam giới, dễ chịu, bền bỉ', 700000, 27, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh478.jpg'),
(N'Giày thể thao nam đơn giản', N'Giày thể thao nhẹ nhàng, thoáng khí, phù hợp cho người cao tuổi', 750000, 12, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh479.jpg'),
(N'Áo khoác mỏng gió nam', N'Áo khoác gió nhẹ, chống nắng và bảo vệ sức khỏe tốt', 580000, 18, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh480.jpg'),
(N'Áo có cổ nam nhỏ gọn', N'mềm mại, kích thước vừa phải, phù hợp cho nam giới', 550000, 15, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh481.jpg'),
-- nữ
(N'áo suông họa tiết', N'Váy suông với họa tiết nhẹ nhàng, đơn giản nhưng trang nhã', 650000, 18, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh482.jpg'),
(N'Quần vải nữ', N'Quần vải mềm, thoáng mát cho nữ trung niên', 620000, 22, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh483.jpg'),
(N'Dép  lười nữ', N'Dép lười tiện lợi, nhẹ nhàng và thoải mái', 720000, 14, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh484.jpg'),
(N'Áo cardigan  nữ', N'Áo  cardigan đơn giản, phù hợp mặc trong mùa thu', 670000, 10, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh485.jpg'),
(N'Khăn len ấm áp', N'khăn len giữ ấm, thiết kế gọn nhẹ, dễ sử dụng', 550000, 25, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh486.jpg'),

-- Mức giá 800000-2000000
-- nam
(N'Áo thun trung niên cao cấp', N'Áo thun cao cấp, phù hợp cho các dịp trang trọng', 1900000, 7, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh487.jpg'),
(N'Quần âu cao cấp nam', N'Quần âu vừa vặn, làm từ chất liệu cao cấp, thoải mái', 900000, 18, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh488.jpg'),
(N'Giày da sang trọng', N'Giày da thiết kế tối giản, phù hợp với nhiều phong cách', 1700000, 5, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh489.jpg'),
(N'Áo khoác da thật', N'Áo khoác da sang trọng, bền bỉ với thời gian', 2000000, 8, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh490.jpg'),
(N'kính sang trọng', N' phù hợp cho phong cách lịch lãm', 850000, 10, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh491.jpg'),
-- nữ
(N'Áo vest nữ cao cấp', N'Áo vest nữ với chất liệu cao cấp, thiết kế tối giản mà tinh tế', 1800000, 5, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh492.jpg'),
(N'Váy công sở nữ', N'Váy công sở cao cấp, thoải mái và sang trọng', 1600000, 8, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh493.jpg'),
(N'Dép nhập khẩu', N'dép nhập khẩu thoải mái, phù hợp cho nữ trung niên', 1500000, 9, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh494.jpg'),
(N'Áo khoác len nữ', N'Áo khoác len sang trọng, ấm áp và dễ dàng phối đồ', 850000, 15, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh495.jpg'), 
(N'Túi da nữ sang trọng', N'Túi da nhỏ gọn, phù hợp với phong cách nữ trung niên', 1100000, 12, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Đơn giản, thường ngày'), 'hinh496.jpg');
-- Sản phẩm cho sở thích "Thời trang du lịch" Cao tuổi từ 60 tuổi trở lên
INSERT INTO SanPham (TenSanPham, MoTa, Gia, SoLuongTonKho, DanhMucID, HinhAnhUrl)
VALUES 
-- Mức giá 150000-400000
-- nam
(N'Áo khoác du lịch chống nắng Nam', N'Áo khoác nhẹ, thoáng khí, bảo vệ khỏi nắng, thích hợp cho các chuyến đi ngắn ngày.', 250000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh497.jpg'),
(N'Quần dài du lịch Nam co giãn', N'Quần dài với khả năng co giãn, thoải mái cho người lớn tuổi khi di chuyển.', 300000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh498.jpg'),
(N'áo  du lịch Nam thoáng khí', N'dễ mang, thích hợp cho người lớn tuổi trong các chuyến đi dạo.', 350000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh499.jpg'),
(N'Mũ du lịch Nam', N'Mũ rộng vành, bảo vệ khỏi nắng và dễ dàng mang theo khi di chuyển.', 200000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh500.jpg'),
(N'Bộ du lịch Nam', N'Dành cho người lớn tuổi', 150000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh501.jpg'),
-- nữ
(N'Áo khoác gió du lịch Nữ', N'Áo khoác nhẹ, phù hợp cho các chuyến đi đường dài với khả năng chống gió tốt.', 250000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh502.jpg'),
(N'Quần áo du lịch Nữ có lót ấm', N'Quần có lót giữ ấm bên trong, lý tưởng cho người cao tuổi khi đi du lịch vào mùa lạnh.', 300000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh503.jpg'),
(N'Giày bệt du lịch Nữ thoải mái', N'Giày bệt với lớp lót mềm mại, giúp đôi chân thoải mái trong các chuyến đi dài.', 350000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh504.jpg'),
(N'Mũ du và quần áo lịch Nữ chống nắng', N'Mũ rộng vành, chống nắng tốt, tiện lợi cho người lớn tuổi khi tham gia các hoạt động ngoài trời.', 200000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh505.jpg'),
(N'Túi xách du lịch Nữ thời trang', N'Túi xách nhỏ gọn, kiểu dáng thanh lịch, phù hợp cho người cao tuổi trong các chuyến đi.', 150000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh506.jpg'),
-- Mức giá 500000-750000
-- nam
(N'Áo chống thấm nước Nam', N'Áo chống thấm nước, giữ ấm tốt, phù hợp cho các chuyến du lịch dài ngày.', 650000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh507.jpg'),
(N'Đồng hồ trekking Nam chống nước', N' trekking, chống thấm tốt, co giãn thoải mái khi leo núi.', 700000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh508.jpg'),
(N'Giày trekking Nam cao cấp', N'Giày trekking chống nước, phù hợp cho địa hình gồ ghề và điều kiện thời tiết khắc nghiệt.', 750000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh509.jpg'),
(N'Mũ du lịch Nam cao cấp', N'Mũ thời trang, bảo vệ tốt khỏi ánh nắng, phù hợp cho mọi chuyến đi xa.', 550000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh510.jpg'),
-- nữ
(N'Áo quần c Nữ', N'Áo khoác tốt, lý tưởng cho các chuyến du lịch dài ngày.', 650000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh511.jpg'),
(N'Quần trekking Nữ chống thấm', N'Quần trekking chống thấm, co giãn và thoải mái khi di chuyển trên các địa hình phức tạp.', 700000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh512.jpg'),
(N'Giày trekking Nữ cao cấp', N'Giày trekking thiết kế nhẹ, chống trơn trượt, phù hợp cho các hoạt động ngoài trời.', 750000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh513.jpg'),
(N'Túi xách du lịch Nữ thời trang cao cấp', N'Túi xách với thiết kế cao cấp, tiện lợi và thời trang.', 600000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh514.jpg'),
-- Mức giá 800000-2000000
-- nam
(N'Áo khoác du lịch chống gió Nam cao cấp', N'Áo khoác cao cấp, giữ ấm tốt và chống gió, thích hợp cho người cao tuổi.', 1500000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh515.jpg'),
(N'Quần trekking Nam chất liệu cao cấp', N'Quần trekking chống nước, thoải mái và bền bỉ cho các chuyến đi dài.', 1200000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh516.jpg'),
(N'Giày trekking Nam cao cấp chính hãng', N'Giày chính hãng, hỗ trợ di chuyển trên các địa hình khó khăn.', 1800000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh517.jpg'),

-- nữ
(N'Áo khoác giữ nhiệt Nữ', N'Áo khoác giữ nhiệt, lý tưởng cho người cao tuổi khi đi du lịch trong thời tiết lạnh.', 1500000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh520.jpg'),
(N'Giày trekking Nữ chất liệu cao cấp', N'Giày trekking với thiết kế hỗ trợ đôi chân, bền bỉ và chống trơn trượt.', 1800000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh521.jpg'),
(N'Áo du lịch Nữ chống nước', N'Áo du lịch nhẹ, chống nước, giúp bảo vệ đồ dùng cá nhân trong các chuyến đi.', 1300000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh522.jpg'),
(N'bộ quần áo du lịch Nữ ', N'du lịch nhẹ, giúp bảo vệ đồ dùng cá nhân trong các chuyến đi.', 1300000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh523.jpg'),
(N'Túi du lịch Nữ chống nước', N'Túi du lịch nhẹ, chống nước, giúp bảo vệ đồ dùng cá nhân trong các chuyến đi.', 1300000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang du lịch'), 'hinh524.jpg');
-- Sản phẩm cho sở thích "Thời trang hot trend" Cao tuổi từ 60 tuổi trở lên
INSERT INTO SanPham (TenSanPham, MoTa, Gia, SoLuongTonKho, DanhMucID, HinhAnhUrl)
VALUES 
-- Mức giá 15000-400000
--nam
(N'Áo vest trung niên phong cách', N'Phong cách lịch lãm, phù hợp cho các buổi gặp gỡ và du lịch.', 250000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh524.jpg'),
(N'Quần dài kaki nam trung niên', N'Tạo cảm giác thoải mái, phù hợp cho mọi hoạt động hàng ngày.', 300000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh525.jpg'),
(N'Giày da nam thời trang', N'Mang lại sự thoải mái và vẻ ngoài tinh tế trong những buổi gặp mặt.', 350000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh526.jpg'),
(N'Áo sơ mi nam cao cấp', N'Mềm mại và thoáng mát, phù hợp cho khí hậu nhiệt đới.', 200000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh527.jpg'),
(N'Mũ sendo nam', N'Giúp bảo vệ khỏi nắng và tạo điểm nhấn trẻ trung cho người lớn.', 150000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh528.jpg'),
--nữ
(N'Áo khoác mỏng nữ', N'Thiết kế gọn nhẹ, dễ phối đồ, phù hợp khi đi dạo phố.', 250000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh529.jpg'),
(N'Quần dài nữ trung niên sang trọng', N'Mềm mại, dễ chịu, mang lại sự thoải mái tối đa.', 300000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh530.jpg'),
(N'Giày cao gót nữ thời trang', N'Nhẹ nhàng, phù hợp cho mọi hoạt động hằng ngày.', 350000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh531.jpg'),
(N'Áo Kháoc nữ đơn giản', N'Thời trang và tiện lợi, dễ dàng phối hợp trong các hoạt động ngoài trời.', 200000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh532.jpg'),
(N'Mũ vành', N'Thời trang và bảo vệ tốt khi đi dưới trời nắng.', 150000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh533.jpg'),
-- Mức giá 500000-750000
--nam
(N'Áo somi nam trung niên cao cấp', N'Thiết kế sang trọng, phù hợp với các dịp đặc biệt.', 600000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh534.jpg'),
(N'Quần áo thể thao nam cao cấp', N'Chất liệu bền bỉ, thích hợp cho các chuyến đi xa.', 650000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh535.jpg'),
(N'Giày da nam cao cấp chính hãng', N'Giày dép mang lại phong cách và sự thoải mái.', 700000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh536.jpg'),
(N'kính cho lớn tuổi nam', N'Thời trang và thanh lịch, phù hợp cho môi trường công sở.', 600000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh537.jpg'),
(N'Mũ lưỡi trai cao cấp nam', N'Tiện dụng và thời trang, bảo vệ khỏi ánh nắng mặt trời.', 500000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh538.jpg'),
--nữ

(N'Áo vest nữ trung niên thanh lịch', N'Phong cách nhẹ nhàng, dễ dàng phối đồ với váy hoặc quần.', 600000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh539.jpg'),
(N'Quần dài nữ cao cấp', N'Chất liệu cao cấp, bền đẹp và mềm mại.', 650000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh540.jpg'),
(N'Áo nữ chính hãng', N'Đem lại phong cách quyến rũ và tự tin trong mọi bước chân.', 700000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh541.jpg'),
(N'Áo phông nữ cao cấp', N'Vải cao cấp, tạo sự thoải mái trong các hoạt động hằng ngày.', 600000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh542.jpg'),
(N'Mũ trùm lớn tuổi', N'Thời trang và tiện lợi, hoàn hảo cho các chuyến du lịch.', 500000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh543.jpg'),
-- Mức giá 800000-2000000
--nam
(N'Mũ mỏ vịt trung niên chất liệu cao cấp', N'Chất liệu bền bỉ, phong cách sang trọng cho các sự kiện.', 1500000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh544.jpg'),
(N'Kính mắt mát mẻ trung niên cao cấp', N'Thiết kế thoáng mát, giúp bạn luôn thoải mái trong các hoạt động.', 1200000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh545.jpg'),
(N'Giày tây nam cao cấp chính hãng', N'Phong cách lịch lãm, kết hợp hoàn hảo giữa sự thoải mái và thời trang.', 1800000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh546.jpg'),
(N'Quần short nam chất liệu cao cấp', N'Thích hợp cho mùa hè, tạo cảm giác thoải mái nhất.', 900000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh547.jpg'),
(N'Mũ kaor vành nam cao cấp', N'Phong cách thời thượng và bảo vệ hiệu quả dưới nắng.', 800000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh548.jpg'),
--nữ
(N'Áo nhập khẩu trung quốc nữ chất liệu cao cấp', N'Chống nắng, tạo phong cách sang trọng.', 1500000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh549.jpg'),
(N'Quần dài nữ chất liệu cao cấp', N'Đem lại sự thoải mái tối đa trong mọi hoạt động.', 1200000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh550.jpg'),
(N'áo ba lỗ nữ cao cấp chính hãng', N'Thiết kế sang trọng, tạo phong cách nổi bật khih thể thao.', 1800000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh551.jpg'), 
(N'Váy nữ chất liệu cao cấp', N'Combo dạ hội.', 900000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), '	'), 
(N'Mũ vải len', N'Thời trang và bảo vệ tốt nhất trong những chuyến đi.', 800000, 50, (SELECT DanhMucID FROM DanhMuc WHERE TenDanhMuc = N'Thời trang hot trend'), 'hinh553.jpg');



SELECT sp.TenSanPham, sp.MoTa, sp.Gia, sp.HinhAnhUrl 
FROM SanPham sp
INNER JOIN DanhMuc dm ON sp.DanhMucID = dm.DanhMucID
WHERE dm.TenDanhMuc = N'Thời trang hot trend'
AND sp.Gia >= 300000 AND sp.Gia <  700000;

SELECT sp.TenSanPham, sp.MoTa, sp.Gia, sp.HinhAnhUrl 
FROM SanPham sp
INNER JOIN DanhMuc dm ON sp.DanhMucID = dm.DanhMucID
WHERE dm.TenDanhMuc = N'Thời trang hot trend'
AND sp.Gia >= 700000 AND sp.Gia < 1000000;

SELECT sp.TenSanPham, sp.MoTa, sp.Gia, sp.HinhAnhUrl 
FROM SanPham sp
INNER JOIN DanhMuc dm ON sp.DanhMucID = dm.DanhMucID
WHERE dm.TenDanhMuc = N'Thời trang hot trend'
AND sp.Gia >= 1000000 AND sp.Gia < 3000000;


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


