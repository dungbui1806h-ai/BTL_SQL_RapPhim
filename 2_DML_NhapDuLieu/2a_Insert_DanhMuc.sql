USE QuanLyRapPhim;

-- 1. CỤM RẠP (10 Cụm rạp)
INSERT INTO CUM_RAP (MaRap, TenRap, SoNha, Duong, QuanHuyen, TinhTP, Hotline) VALUES
('RAP01', 'CGV Landmark 81', '720A', 'Điện Biên Phủ', 'Bình Thạnh', 'TP. Hồ Chí Minh', '02839991001'),
('RAP02', 'Lotte Cinema Cantavil', '01', 'Song Hành', 'TP. Thủ Đức', 'TP. Hồ Chí Minh', '02837402002'),
('RAP03', 'Galaxy Nguyễn Du', '116', 'Nguyễn Du', 'Quận 1', 'TP. Hồ Chí Minh', '02838235003'),
('RAP04', 'CGV Vincom Bà Triệu', '191', 'Bà Triệu', 'Hai Bà Trưng', 'Hà Nội', '02439741004'),
('RAP05', 'Trung tâm Chiếu phim Quốc gia', '87', 'Láng Hạ', 'Ba Đình', 'Hà Nội', '02435141005'),
('RAP06', 'BHD Star Thảo Điền', '159', 'Xa Lộ Hà Nội', 'TP. Thủ Đức', 'TP. Hồ Chí Minh', '02837446006'),
('RAP07', 'Starlight Đà Nẵng', '46', 'Nguyễn Văn Linh', 'Hải Châu', 'Đà Nẵng', '02363588007'),
('RAP08', 'Lotte Cinema Nha Trang', '58', '23 Tháng 10', 'Nha Trang', 'Khánh Hòa', '02583812008'),
('RAP09', 'CGV Vincom Cần Thơ', '209', '30 Tháng 4', 'Ninh Kiều', 'Cần Thơ', '02923739009'),
('RAP10', 'Beta Cinema Quang Trung', '645', 'Quang Trung', 'Gò Vấp', 'TP. Hồ Chí Minh', '02835894010');

-- 2. PHÒNG CHIẾU (10 Phòng)
INSERT INTO PHONG_CHIEU (MaPhong, TenPhong, LoaiPhong, TongSoGhe, MaRap) VALUES
('PH01', 'Phòng IMAX 1', 'IMAX', 120, 'RAP01'),
('PH02', 'Phòng Cinema 2', '2D', 90, 'RAP01'),
('PH03', 'Phòng 3D GoldClass', '3D', 80, 'RAP01'),
('PH04', 'Phòng Cinema 1', '2D', 100, 'RAP02'),
('PH05', 'Phòng 3D Prime', '3D', 85, 'RAP02'),
('PH06', 'Phòng Cinema 1', '2D', 110, 'RAP03'),
('PH07', 'Phòng IMAX Laser', 'IMAX', 130, 'RAP04'),
('PH08', 'Phòng Cinema 2', '2D', 95, 'RAP04'),
('PH09', 'Phòng Cinema 1', '2D', 120, 'RAP05'),
('PH10', 'Phòng 3D Premium', '3D', 75, 'RAP06');

-- 3. PHIM (10 Phim chiếu rạp thực tế)
INSERT INTO PHIM (MaPhim, TenPhim, DaoDien, ThoiLuong, NgayKhoiChieu, GioiHanTuoi) VALUES
('P01', 'Mai', 'Trấn Thành', 131, '2024-02-10', '18+'),
('P02', 'Lật Mặt 7: Một Điều Ước', 'Lý Hải', 138, '2024-04-26', 'PG'),
('P03', 'Dune: Hành Tinh Cát - Phần 2', 'Denis Villeneuve', 166, '2024-03-01', '13+'),
('P04', 'Godzilla x Kong: Đế Chế Mới', 'Adam Wingard', 115, '2024-03-29', 'PG'),
('P05', 'Kung Fu Panda 4', 'Mike Mitchell', 94, '2024-03-08', 'G'),
('P06', 'Quật Mộ Trùng Phùng (Exhuma)', 'Jang Jae-hyun', 134, '2024-03-15', '18+'),
('P07', 'Inside Out 2', 'Kelsey Mann', 96, '2024-06-14', 'G'),
('P08', 'Deadpool & Wolverine', 'Shawn Levy', 128, '2024-07-26', '18+'),
('P09', 'Đào, Phở Và Piano', 'Phi Tiến Sơn', 100, '2024-02-10', '13+'),
('P10', 'Vua Sư Tử (Mufasa: The Lion King)', 'Barry Jenkins', 118, '2024-12-20', 'G');

-- 4. PHIM_THE_LOAI (Danh mục thể loại phim)
INSERT INTO PHIM_THE_LOAI (MaPhim, TheLoai) VALUES
('P01', 'Tâm Lý'), ('P01', 'Tình Cảm'),
('P02', 'Gia Đình'), ('P02', 'Tâm Lý'),
('P03', 'Khoa Học Viễn Tưởng'), ('P03', 'Hành Động'),
('P04', 'Hành Động'), ('P04', 'Phiêu Lưu'),
('P05', 'Hoạt Hình'), ('P05', 'Hài Hước'),
('P06', 'Kinh Dị'), ('P06', 'Bí Ẩn'),
('P07', 'Hoạt Hình'), ('P07', 'Gia Đình'),
('P08', 'Hành Động'), ('P08', 'Hài Hước'),
('P09', 'Lịch Sử'), ('P09', 'Chiến Tranh'),
('P10', 'Hoạt Hình'), ('P10', 'Phiêu Lưu');

-- 5. PHIM_DIEN_VIEN (Danh mục diễn viên)
INSERT INTO PHIM_DIEN_VIEN (MaPhim, DienVien) VALUES
('P01', 'Phương Anh Đào'), ('P01', 'Tuấn Trần'),
('P02', 'Đinh Y Nhung'), ('P02', 'Quách Ngọc Tuyên'),
('P03', 'Timothée Chalamet'), ('P03', 'Zendaya'),
('P04', 'Rebecca Hall'), ('P04', 'Brian Tyree Henry'),
('P05', 'Jack Black'), ('P05', 'Awkwafina'),
('P06', 'Choi Min-sik'), ('P06', 'Kim Go-eun'),
('P07', 'Amy Poehler'), ('P07', 'Maya Hawke'),
('P08', 'Ryan Reynolds'), ('P08', 'Hugh Jackman'),
('P09', 'Doãn Quốc Đam'), ('P09', 'Cao Thùy Linh');

-- 6. GHẾ NGỒI (Mẫu sơ đồ ghế cho các phòng)
INSERT INTO GHE_NGOI (MaPhong, SoGhe, LoaiGhe, PhuThuGhe) VALUES
-- Phòng PH01
('PH01', 'A1', 'Thường', 0.00), ('PH01', 'A2', 'Thường', 0.00),
('PH01', 'A3', 'Thường', 0.00), ('PH01', 'A4', 'Thường', 0.00),
('PH01', 'B1', 'VIP', 15000.00), ('PH01', 'B2', 'VIP', 15000.00),
('PH01', 'B3', 'VIP', 15000.00), ('PH01', 'B4', 'VIP', 15000.00),
('PH01', 'S1', 'Sweetbox', 30000.00), ('PH01', 'S2', 'Sweetbox', 30000.00),
-- Phòng PH02
('PH02', 'A1', 'Thường', 0.00), ('PH02', 'A2', 'Thường', 0.00),
('PH02', 'B1', 'VIP', 10000.00), ('PH02', 'B2', 'VIP', 10000.00),
-- Phòng PH04
('PH04', 'A1', 'Thường', 0.00), ('PH04', 'A2', 'Thường', 0.00),
('PH04', 'B1', 'VIP', 10000.00), ('PH04', 'B2', 'VIP', 10000.00),
-- Phòng PH07
('PH07', 'A1', 'Thường', 0.00), ('PH07', 'A2', 'Thường', 0.00),
('PH07', 'B1', 'VIP', 20000.00), ('PH07', 'B2', 'VIP', 20000.00);

-- 7. KHÁCH HÀNG (10 Khách hàng)
INSERT INTO KHACH_HANG (MaKH, HoTen, SDT, Email, NgaySinh, DiemTichLuy) VALUES
('KH01', 'Nguyễn Văn An', '0903123456', 'an.nguyen@gmail.com', '1995-05-15', 120),
('KH02', 'Trần Thị Bình', '0918234567', 'binh.tran@yahoo.com', '1998-11-20', 450),
('KH03', 'Lê Hoàng Cường', '0937345678', 'cuong.le@gmail.com', '1990-03-10', 800),
('KH04', 'Phạm Minh Đức', '0946456789', 'duc.pham@outlook.com', '2001-08-25', 50),
('KH05', 'Hoàng Thùy Dương', '0985567890', 'duong.hoang@gmail.com', '1997-12-05', 300),
('KH06', 'Vũ Tiến Đạt', '0976678901', 'dat.vu@gmail.com', '2000-01-30', 0),
('KH07', 'Đặng Phương Thảo', '0967789012', 'thao.dang@gmail.com', '1996-07-14', 210),
('KH08', 'Bùi Anh Tuấn', '0928890123', 'tuan.bui@gmail.com', '1993-09-09', 620),
('KH09', 'Đỗ Mai Hương', '0909901234', 'huong.do@gmail.com', '2002-04-18', 90),
('KH10', 'Ngô Quốc Khánh', '0917012345', 'khanh.ngo@gmail.com', '1989-10-12', 1100);

-- 8. DỊCH VỤ F&B (10 Combo / Sản phẩm)
INSERT INTO DICH_VU_FNB (MaCombo, TenCombo, MoTa, DonGia) VALUES
('CB01', 'Combo Solo', '1 Bắp ngọt vừa + 1 Nước ngọt lớn', 89000.00),
('CB02', 'Combo Couple', '1 Bắp lớn + 2 Nước ngọt lớn', 119000.00),
('CB03', 'Combo Family', '2 Bắp lớn + 4 Nước ngọt lớn + 1 Snack', 229000.00),
('CB04', 'Combo Party', '3 Bắp lớn + 3 Nước lớn + 2 Chả giò', 289000.00),
('CB05', 'Bắp Rang Phô Mai', 'Bắp rang bơ vị phô mai size L', 69000.00),
('CB06', 'Bắp Rang Caramel', 'Bắp rang bơ vị caramel size L', 69000.00),
('CB07', 'Pepsi Lớn', 'Nước ngọt Pepsi ly 32oz', 39000.00),
('CB08', 'Coca Cola Lớn', 'Nước ngọt Coca ly 32oz', 39000.00),
('CB09', 'Snack Khoai Tây', 'Gói snack khoai tây Lay\'s 90g', 29000.00),
('CB10', 'Hotdog Phô Mai', 'Bánh mì hotdog kẹp xốt phô mai nóng', 49000.00);

-- 9. NHÂN VIÊN (10 Nhân viên)
INSERT INTO NHAN_VIEN (MaNV, HoTen, NgaySinh, CCCD, SDT, LuongCoBan, NgayVaoLam, MaRap) VALUES
('NV01', 'Nguyễn Văn Hùng', '1988-03-12', '012345678901', '0901111222', 18000000.00, '2018-01-15', 'RAP01'),
('NV02', 'Trần Thị Mai', '1992-07-24', '012345678902', '0901111223', 15000000.00, '2019-05-20', 'RAP02'),
('NV03', 'Lê Văn Nam', '1990-11-05', '012345678903', '0901111224', 16000000.00, '2020-03-10', 'RAP03'),
('NV04', 'Phạm Thị Hoa', '2001-02-18', '012345678904', '0901111225', 7500000.00, '2022-06-01', 'RAP01'),
('NV05', 'Hoàng Văn Tuấn', '2002-09-09', '012345678905', '0901111226', 7500000.00, '2022-08-15', 'RAP01'),
('NV06', 'Vũ Thu Trang', '2000-12-12', '012345678906', '0901111227', 8000000.00, '2023-01-10', 'RAP02'),
('NV07', 'Đặng Minh Quân', '1999-04-05', '012345678907', '0901111228', 7800000.00, '2023-03-01', 'RAP03'),
('NV08', 'Bùi Tiến Dũng', '1995-08-19', '012345678908', '0901111229', 10500000.00, '2021-09-01', 'RAP01'),
('NV09', 'Ngô Bảo Ngọc', '1996-01-22', '012345678909', '0901111230', 10000000.00, '2021-11-15', 'RAP02'),
('NV10', 'Lý Văn Hải', '1994-06-30', '012345678910', '0901111231', 11000000.00, '2020-10-01', 'RAP04');

-- 10. PHÂN LOẠI NHÂN VIÊN (1:1 với NHAN_VIEN)
INSERT INTO NV_QUAN_LY (MaNV, HeSoTrachNhiem, QuyenHan) VALUES
('NV01', 1.50, 'Quản lý toàn bộ cụm rạp RAP01'),
('NV02', 1.30, 'Quản lý toàn bộ cụm rạp RAP02'),
('NV03', 1.30, 'Quản lý toàn bộ cụm rạp RAP03');

INSERT INTO NV_BAN_HANG (MaNV, CaLamViec, DoanhSoThang) VALUES
('NV04', 'Sáng', 25000000.00),
('NV05', 'Chiều', 32000000.00),
('NV06', 'Tối', 41000000.00),
('NV07', 'Tối', 38000000.00);

INSERT INTO NV_KY_THUAT (MaNV, ChungChiKyThuat, KhuVucPhuTrach) VALUES
('NV08', 'Chứng chỉ Máy chiếu IMAX Digital 2022', 'Phòng máy PH01-PH03'),
('NV09', 'Chứng chỉ Âm thanh Dolby Atmos', 'Phòng máy PH04-PH05'),
('NV10', 'Chứng chỉ Máy chiếu Laser 4K', 'Phòng máy PH07-PH08');