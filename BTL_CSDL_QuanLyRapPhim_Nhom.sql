-- =============================================================================
-- BÀI TẬP LỚN MÔN CƠ SỞ DỮ LIỆU - NHÓM 04 (PTIT)
-- ĐỀ TÀI: XÂY DỰNG CƠ SỞ DỮ LIỆU QUẢN LÝ CHUỖI RẠP CHIẾU PHIM
-- Tệp cài đặt tổng hợp (DDL + DML + Stored Procedures + Triggers + Views)
-- Yêu cầu: MySQL Server 8.0+ (InnoDB, utf8mb4)
-- =============================================================================


-- =============================================================================
-- PHẦN 1: KHỞI TẠO CƠ SỞ DỮ LIỆU & CẤU TRÚC 15 BẢNG (DDL)
-- =============================================================================
-- PHAN 1: TAO CSDL QUAN LY CHUOI RAP CHIEU PHIM
-- Theo luoc do quan he trong bao cao phan 4 cua nhom 4.
-- MySQL 8.0.16+ (CHECK duoc thuc thi), InnoDB, UTF-8.
-- Chay mot lan tren CSDL moi. Khong DROP de tranh mat du lieu.
-- Ma dinh danh do nhom tu gan, vi du RAP01, PH01, SC01, KH01.

DROP DATABASE IF EXISTS QuanLyRapPhim;
CREATE DATABASE QuanLyRapPhim
    CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE QuanLyRapPhim;
SET NAMES utf8mb4;

CREATE TABLE CUM_RAP (
    MaRap VARCHAR(20) NOT NULL,
    TenRap VARCHAR(150) NOT NULL,
    SoNha VARCHAR(30),
    Duong VARCHAR(150) NOT NULL,
    QuanHuyen VARCHAR(100) NOT NULL,
    TinhTP VARCHAR(100) NOT NULL,
    Hotline VARCHAR(20) NOT NULL,
    CONSTRAINT pk_cum_rap PRIMARY KEY (MaRap)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE PHONG_CHIEU (
    MaPhong VARCHAR(20) NOT NULL,
    TenPhong VARCHAR(100) NOT NULL,
    LoaiPhong VARCHAR(10) NOT NULL,
    TongSoGhe INT NOT NULL,
    MaRap VARCHAR(20) NOT NULL,
    CONSTRAINT pk_phong_chieu PRIMARY KEY (MaPhong),
    CONSTRAINT ck_phong_loai CHECK (LoaiPhong IN ('2D', '3D', 'IMAX')),
    CONSTRAINT ck_phong_so_ghe CHECK (TongSoGhe > 0),
    CONSTRAINT fk_phong_rap FOREIGN KEY (MaRap) REFERENCES CUM_RAP (MaRap)
        ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE PHIM (
    MaPhim VARCHAR(20) NOT NULL,
    TenPhim VARCHAR(200) NOT NULL,
    DaoDien VARCHAR(150) NOT NULL,
    ThoiLuong INT NOT NULL COMMENT 'Don vi: phut',
    NgayKhoiChieu DATE NOT NULL,
    GioiHanTuoi VARCHAR(10) NOT NULL DEFAULT 'G',
    TrangThai VARCHAR(30) NOT NULL DEFAULT 'Sắp chiếu',
    CONSTRAINT pk_phim PRIMARY KEY (MaPhim),
    CONSTRAINT ck_phim_thoi_luong CHECK (ThoiLuong > 0),
    CONSTRAINT ck_phim_do_tuoi CHECK (GioiHanTuoi IN ('G', 'PG', '13+', '18+', 'P', 'K', 'T13', 'T16', 'T18')),
    CONSTRAINT ck_phim_trang_thai CHECK (TrangThai IN ('Sắp chiếu', 'Đang chiếu', 'Ngưng chiếu'))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE PHIM_THE_LOAI (
    MaPhim VARCHAR(20) NOT NULL,
    TheLoai VARCHAR(100) NOT NULL,
    CONSTRAINT pk_phim_the_loai PRIMARY KEY (MaPhim, TheLoai),
    CONSTRAINT fk_the_loai_phim FOREIGN KEY (MaPhim) REFERENCES PHIM (MaPhim)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE PHIM_DIEN_VIEN (
    MaPhim VARCHAR(20) NOT NULL,
    DienVien VARCHAR(150) NOT NULL,
    CONSTRAINT pk_phim_dien_vien PRIMARY KEY (MaPhim, DienVien),
    CONSTRAINT fk_dien_vien_phim FOREIGN KEY (MaPhim) REFERENCES PHIM (MaPhim)
        ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- Thuc the yeu: so ghe chi duy nhat trong tung phong.
CREATE TABLE GHE_NGOI (
    MaPhong VARCHAR(20) NOT NULL,
    SoGhe VARCHAR(10) NOT NULL,
    LoaiGhe VARCHAR(20) NOT NULL DEFAULT 'Thường',
    PhuThuGhe DECIMAL(12,2) NOT NULL DEFAULT 0,
    CONSTRAINT pk_ghe_ngoi PRIMARY KEY (MaPhong, SoGhe),
    CONSTRAINT ck_ghe_loai CHECK (LoaiGhe IN ('Thường', 'VIP', 'Sweetbox')),
    CONSTRAINT ck_ghe_phu_thu CHECK (PhuThuGhe >= 0),
    CONSTRAINT fk_ghe_phong FOREIGN KEY (MaPhong) REFERENCES PHONG_CHIEU (MaPhong)
        ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE SUAT_CHIEU (
    MaSuatChieu VARCHAR(20) NOT NULL,
    NgayChieu DATE NOT NULL,
    GioBatDau TIME NOT NULL,
    GioKetThuc TIME NOT NULL,
    TrangThai VARCHAR(30) NOT NULL DEFAULT 'Sắp chiếu',
    MaPhim VARCHAR(20) NOT NULL,
    MaPhong VARCHAR(20) NOT NULL,
    CONSTRAINT pk_suat_chieu PRIMARY KEY (MaSuatChieu),
    -- Khoa tham chieu cho DAT_VE, dam bao ghe va suat chieu cung phong.
    CONSTRAINT uq_suat_phong UNIQUE (MaSuatChieu, MaPhong),
    CONSTRAINT ck_suat_trang_thai CHECK (TrangThai IN ('Sắp chiếu', 'Đang chiếu', 'Đã kết thúc')),
    -- Quy uoc phan 1: suat chieu bat dau va ket thuc trong cung ngay.
    CONSTRAINT ck_suat_gio CHECK (
        GioBatDau >= '00:00:00' AND GioKetThuc < '24:00:00'
        AND GioKetThuc > GioBatDau
    ),
    CONSTRAINT fk_suat_phim FOREIGN KEY (MaPhim) REFERENCES PHIM (MaPhim)
        ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT fk_suat_phong FOREIGN KEY (MaPhong) REFERENCES PHONG_CHIEU (MaPhong)
        ON DELETE RESTRICT ON UPDATE RESTRICT,
    INDEX idx_suat_lich_phong (MaPhong, NgayChieu, GioBatDau)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE KHACH_HANG (
    MaKH VARCHAR(20) NOT NULL,
    HoTen VARCHAR(150) NOT NULL,
    SDT VARCHAR(20) NOT NULL,
    Email VARCHAR(254),
    NgaySinh DATE,
    DiemTichLuy INT NOT NULL DEFAULT 0,
    CONSTRAINT pk_khach_hang PRIMARY KEY (MaKH),
    CONSTRAINT uq_khach_sdt UNIQUE (SDT),
    CONSTRAINT ck_khach_diem CHECK (DiemTichLuy >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE DICH_VU_FNB (
    MaCombo VARCHAR(20) NOT NULL,
    TenCombo VARCHAR(150) NOT NULL,
    MoTa TEXT,
    DonGia DECIMAL(12,2) NOT NULL,
    CONSTRAINT pk_dich_vu_fnb PRIMARY KEY (MaCombo),
    CONSTRAINT ck_fnb_don_gia CHECK (DonGia >= 0)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE NHAN_VIEN (
    MaNV VARCHAR(20) NOT NULL,
    HoTen VARCHAR(150) NOT NULL,
    NgaySinh DATE NOT NULL,
    CCCD CHAR(12) NOT NULL,
    SDT VARCHAR(20) NOT NULL,
    LuongCoBan DECIMAL(15,2) NOT NULL,
    NgayVaoLam DATE NOT NULL,
    MaRap VARCHAR(20) NOT NULL,
    CONSTRAINT pk_nhan_vien PRIMARY KEY (MaNV),
    CONSTRAINT uq_nhan_vien_cccd UNIQUE (CCCD),
    CONSTRAINT ck_nhan_vien_luong CHECK (LuongCoBan >= 0),
    CONSTRAINT ck_nhan_vien_ngay CHECK (NgayVaoLam > NgaySinh),
    CONSTRAINT fk_nhan_vien_rap FOREIGN KEY (MaRap) REFERENCES CUM_RAP (MaRap)
        ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- PK dong thoi la FK: lien ket 1:1 giua tap cha va tung tap con.
-- Rang buoc moi NV thuoc DUNG MOT tap con can procedure/trigger o phan 3.
CREATE TABLE NV_QUAN_LY (
    MaNV VARCHAR(20) NOT NULL,
    HeSoTrachNhiem DECIMAL(5,2) NOT NULL DEFAULT 1,
    QuyenHan VARCHAR(255),
    CONSTRAINT pk_nv_quan_ly PRIMARY KEY (MaNV),
    CONSTRAINT ck_quan_ly_he_so CHECK (HeSoTrachNhiem > 0),
    CONSTRAINT fk_quan_ly_nv FOREIGN KEY (MaNV) REFERENCES NHAN_VIEN (MaNV)
        ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE NV_BAN_HANG (
    MaNV VARCHAR(20) NOT NULL,
    CaLamViec VARCHAR(20) NOT NULL,
    DoanhSoThang DECIMAL(15,2) NOT NULL DEFAULT 0,
    CONSTRAINT pk_nv_ban_hang PRIMARY KEY (MaNV),
    CONSTRAINT ck_ban_hang_ca CHECK (CaLamViec IN ('Sáng', 'Chiều', 'Tối')),
    CONSTRAINT ck_ban_hang_doanh_so CHECK (DoanhSoThang >= 0),
    CONSTRAINT fk_ban_hang_nv FOREIGN KEY (MaNV) REFERENCES NHAN_VIEN (MaNV)
        ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE NV_KY_THUAT (
    MaNV VARCHAR(20) NOT NULL,
    ChungChiKyThuat VARCHAR(255),
    KhuVucPhuTrach VARCHAR(255),
    CONSTRAINT pk_nv_ky_thuat PRIMARY KEY (MaNV),
    CONSTRAINT fk_ky_thuat_nv FOREIGN KEY (MaNV) REFERENCES NHAN_VIEN (MaNV)
        ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE MUA_FNB (
    MaKH VARCHAR(20) NOT NULL,
    MaCombo VARCHAR(20) NOT NULL,
    NgayMua DATETIME(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
    SoLuong INT NOT NULL,
    ThanhTien DECIMAL(15,2) NOT NULL,
    CONSTRAINT pk_mua_fnb PRIMARY KEY (MaKH, MaCombo, NgayMua),
    CONSTRAINT ck_mua_fnb_so_luong CHECK (SoLuong > 0),
    CONSTRAINT ck_mua_fnb_thanh_tien CHECK (ThanhTien >= 0),
    CONSTRAINT fk_mua_fnb_khach FOREIGN KEY (MaKH) REFERENCES KHACH_HANG (MaKH)
        ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT fk_mua_fnb_combo FOREIGN KEY (MaCombo) REFERENCES DICH_VU_FNB (MaCombo)
        ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE DAT_VE (
    MaVe VARCHAR(20) NOT NULL,
    NgayGioDat DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    GiaVe DECIMAL(12,2) NOT NULL,
    TrangThaiThanhToan VARCHAR(30) NOT NULL DEFAULT 'Chờ thanh toán',
    MaKH VARCHAR(20) NOT NULL,
    MaSuatChieu VARCHAR(20) NOT NULL,
    MaPhong VARCHAR(20) NOT NULL,
    SoGhe VARCHAR(10) NOT NULL,
    MaNV VARCHAR(20) DEFAULT NULL,
    CONSTRAINT pk_dat_ve PRIMARY KEY (MaVe),
    CONSTRAINT uq_dat_ve_ghe UNIQUE (MaSuatChieu, MaPhong, SoGhe),
    CONSTRAINT ck_dat_ve_gia CHECK (GiaVe >= 0),
    CONSTRAINT ck_dat_ve_thanh_toan CHECK (
        TrangThaiThanhToan IN ('Chờ thanh toán', 'Đã thanh toán')
    ),
    CONSTRAINT fk_dat_ve_khach FOREIGN KEY (MaKH) REFERENCES KHACH_HANG (MaKH)
        ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT fk_dat_ve_suat_phong FOREIGN KEY (MaSuatChieu, MaPhong)
        REFERENCES SUAT_CHIEU (MaSuatChieu, MaPhong)
        ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT fk_dat_ve_ghe FOREIGN KEY (MaPhong, SoGhe)
        REFERENCES GHE_NGOI (MaPhong, SoGhe)
        ON DELETE RESTRICT ON UPDATE RESTRICT,
    CONSTRAINT fk_datve_nv FOREIGN KEY (MaNV)
        REFERENCES NHAN_VIEN (MaNV)
        ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================================================
-- PHẦN 2A: NẠP DỮ LIỆU DANH MỤC (DML)
-- =============================================================================
USE QuanLyRapPhim;
SET NAMES utf8mb4;

-- 1. CỤM RẠP (10 Cụm rạp)
INSERT INTO
    CUM_RAP (
        MaRap,
        TenRap,
        SoNha,
        Duong,
        QuanHuyen,
        TinhTP,
        Hotline
    )
VALUES (
        'RAP01',
        'CGV Landmark 81',
        '720A',
        'Điện Biên Phủ',
        'Bình Thạnh',
        'TP. Hồ Chí Minh',
        '02839991001'
    ),
    (
        'RAP02',
        'Lotte Cinema Cantavil',
        '01',
        'Song Hành',
        'TP. Thủ Đức',
        'TP. Hồ Chí Minh',
        '02837402002'
    ),
    (
        'RAP03',
        'Galaxy Nguyễn Du',
        '116',
        'Nguyễn Du',
        'Quận 1',
        'TP. Hồ Chí Minh',
        '02838235003'
    ),
    (
        'RAP04',
        'CGV Vincom Bà Triệu',
        '191',
        'Bà Triệu',
        'Hai Bà Trưng',
        'Hà Nội',
        '02439741004'
    ),
    (
        'RAP05',
        'Trung tâm Chiếu phim Quốc gia',
        '87',
        'Láng Hạ',
        'Ba Đình',
        'Hà Nội',
        '02435141005'
    ),
    (
        'RAP06',
        'BHD Star Thảo Điền',
        '159',
        'Xa Lộ Hà Nội',
        'TP. Thủ Đức',
        'TP. Hồ Chí Minh',
        '02837446006'
    ),
    (
        'RAP07',
        'Starlight Đà Nẵng',
        '46',
        'Nguyễn Văn Linh',
        'Hải Châu',
        'Đà Nẵng',
        '02363588007'
    ),
    (
        'RAP08',
        'Lotte Cinema Nha Trang',
        '58',
        '23 Tháng 10',
        'Nha Trang',
        'Khánh Hòa',
        '02583812008'
    ),
    (
        'RAP09',
        'CGV Vincom Cần Thơ',
        '209',
        '30 Tháng 4',
        'Ninh Kiều',
        'Cần Thơ',
        '02923739009'
    ),
    (
        'RAP10',
        'Beta Cinema Quang Trung',
        '645',
        'Quang Trung',
        'Gò Vấp',
        'TP. Hồ Chí Minh',
        '02835894010'
    );

-- 2. PHÒNG CHIẾU (10 Phòng)
INSERT INTO
    PHONG_CHIEU (
        MaPhong,
        TenPhong,
        LoaiPhong,
        TongSoGhe,
        MaRap
    )
VALUES (
        'PH01',
        'Phòng IMAX 1',
        'IMAX',
        120,
        'RAP01'
    ),
    (
        'PH02',
        'Phòng Cinema 2',
        '2D',
        90,
        'RAP01'
    ),
    (
        'PH03',
        'Phòng 3D GoldClass',
        '3D',
        80,
        'RAP01'
    ),
    (
        'PH04',
        'Phòng Cinema 1',
        '2D',
        100,
        'RAP02'
    ),
    (
        'PH05',
        'Phòng 3D Prime',
        '3D',
        85,
        'RAP02'
    ),
    (
        'PH06',
        'Phòng Cinema 1',
        '2D',
        110,
        'RAP03'
    ),
    (
        'PH07',
        'Phòng IMAX Laser',
        'IMAX',
        130,
        'RAP04'
    ),
    (
        'PH08',
        'Phòng Cinema 2',
        '2D',
        95,
        'RAP04'
    ),
    (
        'PH09',
        'Phòng Cinema 1',
        '2D',
        120,
        'RAP05'
    ),
    (
        'PH10',
        'Phòng 3D Premium',
        '3D',
        75,
        'RAP06'
    );

-- 3. PHIM (10 Phim chiếu rạp thực tế)
INSERT INTO
    PHIM (
        MaPhim,
        TenPhim,
        DaoDien,
        ThoiLuong,
        NgayKhoiChieu,
        GioiHanTuoi
    )
VALUES (
        'P01',
        'Mai',
        'Trấn Thành',
        131,
        '2024-02-10',
        '18+'
    ),
    (
        'P02',
        'Lật Mặt 7: Một Điều Ước',
        'Lý Hải',
        138,
        '2024-04-26',
        'PG'
    ),
    (
        'P03',
        'Dune: Hành Tinh Cát - Phần 2',
        'Denis Villeneuve',
        166,
        '2024-03-01',
        '13+'
    ),
    (
        'P04',
        'Godzilla x Kong: Đế Chế Mới',
        'Adam Wingard',
        115,
        '2024-03-29',
        'PG'
    ),
    (
        'P05',
        'Kung Fu Panda 4',
        'Mike Mitchell',
        94,
        '2024-03-08',
        'G'
    ),
    (
        'P06',
        'Quật Mộ Trùng Phùng (Exhuma)',
        'Jang Jae-hyun',
        134,
        '2024-03-15',
        '18+'
    ),
    (
        'P07',
        'Inside Out 2',
        'Kelsey Mann',
        96,
        '2024-06-14',
        'G'
    ),
    (
        'P08',
        'Deadpool & Wolverine',
        'Shawn Levy',
        128,
        '2024-07-26',
        '18+'
    ),
    (
        'P09',
        'Đào, Phở Và Piano',
        'Phi Tiến Sơn',
        100,
        '2024-02-10',
        '13+'
    ),
    (
        'P10',
        'Vua Sư Tử (Mufasa: The Lion King)',
        'Barry Jenkins',
        118,
        '2024-12-20',
        'G'
    );

-- 4. PHIM_THE_LOAI (Danh mục thể loại phim)
INSERT INTO
    PHIM_THE_LOAI (MaPhim, TheLoai)
VALUES ('P01', 'Tâm Lý'),
    ('P01', 'Tình Cảm'),
    ('P02', 'Gia Đình'),
    ('P02', 'Tâm Lý'),
    ('P03', 'Khoa Học Viễn Tưởng'),
    ('P03', 'Hành Động'),
    ('P04', 'Hành Động'),
    ('P04', 'Phiêu Lưu'),
    ('P05', 'Hoạt Hình'),
    ('P05', 'Hài Hước'),
    ('P06', 'Kinh Dị'),
    ('P06', 'Bí Ẩn'),
    ('P07', 'Hoạt Hình'),
    ('P07', 'Gia Đình'),
    ('P08', 'Hành Động'),
    ('P08', 'Hài Hước'),
    ('P09', 'Lịch Sử'),
    ('P09', 'Chiến Tranh'),
    ('P10', 'Hoạt Hình'),
    ('P10', 'Phiêu Lưu');

-- 5. PHIM_DIEN_VIEN (Danh mục diễn viên)
INSERT INTO
    PHIM_DIEN_VIEN (MaPhim, DienVien)
VALUES ('P01', 'Phương Anh Đào'),
    ('P01', 'Tuấn Trần'),
    ('P02', 'Đinh Y Nhung'),
    ('P02', 'Quách Ngọc Tuyên'),
    ('P03', 'Timothée Chalamet'),
    ('P03', 'Zendaya'),
    ('P04', 'Rebecca Hall'),
    ('P04', 'Brian Tyree Henry'),
    ('P05', 'Jack Black'),
    ('P05', 'Awkwafina'),
    ('P06', 'Choi Min-sik'),
    ('P06', 'Kim Go-eun'),
    ('P07', 'Amy Poehler'),
    ('P07', 'Maya Hawke'),
    ('P08', 'Ryan Reynolds'),
    ('P08', 'Hugh Jackman'),
    ('P09', 'Doãn Quốc Đam'),
    ('P09', 'Cao Thùy Linh');

-- 6. GHẾ NGỒI (Mẫu sơ đồ ghế cho các phòng)
INSERT INTO
    GHE_NGOI (
        MaPhong,
        SoGhe,
        LoaiGhe,
        PhuThuGhe
    )
VALUES
    -- Phòng PH01
    ('PH01', 'A1', 'Thường', 0.00),
    ('PH01', 'A2', 'Thường', 0.00),
    ('PH01', 'A3', 'Thường', 0.00),
    ('PH01', 'A4', 'Thường', 0.00),
    ('PH01', 'B1', 'VIP', 15000.00),
    ('PH01', 'B2', 'VIP', 15000.00),
    ('PH01', 'B3', 'VIP', 15000.00),
    ('PH01', 'B4', 'VIP', 15000.00),
    (
        'PH01',
        'S1',
        'Sweetbox',
        30000.00
    ),
    (
        'PH01',
        'S2',
        'Sweetbox',
        30000.00
    ),
    -- Phòng PH02
    ('PH02', 'A1', 'Thường', 0.00),
    ('PH02', 'A2', 'Thường', 0.00),
    ('PH02', 'B1', 'VIP', 10000.00),
    ('PH02', 'B2', 'VIP', 10000.00),
    -- Phòng PH04
    ('PH04', 'A1', 'Thường', 0.00),
    ('PH04', 'A2', 'Thường', 0.00),
    ('PH04', 'B1', 'VIP', 10000.00),
    ('PH04', 'B2', 'VIP', 10000.00),
    -- Phòng PH07
    ('PH07', 'A1', 'Thường', 0.00),
    ('PH07', 'A2', 'Thường', 0.00),
    ('PH07', 'B1', 'VIP', 20000.00),
    ('PH07', 'B2', 'VIP', 20000.00);

-- 7. KHÁCH HÀNG (10 Khách hàng)
INSERT INTO
    KHACH_HANG (
        MaKH,
        HoTen,
        SDT,
        Email,
        NgaySinh,
        DiemTichLuy
    )
VALUES (
        'KH01',
        'Nguyễn Văn An',
        '0903123456',
        'an.nguyen@gmail.com',
        '1995-05-15',
        120
    ),
    (
        'KH02',
        'Trần Thị Bình',
        '0918234567',
        'binh.tran@yahoo.com',
        '1998-11-20',
        450
    ),
    (
        'KH03',
        'Lê Hoàng Cường',
        '0937345678',
        'cuong.le@gmail.com',
        '1990-03-10',
        800
    ),
    (
        'KH04',
        'Phạm Minh Đức',
        '0946456789',
        'duc.pham@outlook.com',
        '2001-08-25',
        50
    ),
    (
        'KH05',
        'Hoàng Thùy Dương',
        '0985567890',
        'duong.hoang@gmail.com',
        '1997-12-05',
        300
    ),
    (
        'KH06',
        'Vũ Tiến Đạt',
        '0976678901',
        'dat.vu@gmail.com',
        '2000-01-30',
        0
    ),
    (
        'KH07',
        'Đặng Phương Thảo',
        '0967789012',
        'thao.dang@gmail.com',
        '1996-07-14',
        210
    ),
    (
        'KH08',
        'Bùi Anh Tuấn',
        '0928890123',
        'tuan.bui@gmail.com',
        '1993-09-09',
        620
    ),
    (
        'KH09',
        'Đỗ Mai Hương',
        '0909901234',
        'huong.do@gmail.com',
        '2002-04-18',
        90
    ),
    (
        'KH10',
        'Ngô Quốc Khánh',
        '0917012345',
        'khanh.ngo@gmail.com',
        '1989-10-12',
        1100
    );

-- 8. DỊCH VỤ F&B (10 Combo / Sản phẩm)
INSERT INTO
    DICH_VU_FNB (
        MaCombo,
        TenCombo,
        MoTa,
        DonGia
    )
VALUES (
        'CB01',
        'Combo Solo',
        '1 Bắp ngọt vừa + 1 Nước ngọt lớn',
        89000.00
    ),
    (
        'CB02',
        'Combo Couple',
        '1 Bắp lớn + 2 Nước ngọt lớn',
        119000.00
    ),
    (
        'CB03',
        'Combo Family',
        '2 Bắp lớn + 4 Nước ngọt lớn + 1 Snack',
        229000.00
    ),
    (
        'CB04',
        'Combo Party',
        '3 Bắp lớn + 3 Nước lớn + 2 Chả giò',
        289000.00
    ),
    (
        'CB05',
        'Bắp Rang Phô Mai',
        'Bắp rang bơ vị phô mai size L',
        69000.00
    ),
    (
        'CB06',
        'Bắp Rang Caramel',
        'Bắp rang bơ vị caramel size L',
        69000.00
    ),
    (
        'CB07',
        'Pepsi Lớn',
        'Nước ngọt Pepsi ly 32oz',
        39000.00
    ),
    (
        'CB08',
        'Coca Cola Lớn',
        'Nước ngọt Coca ly 32oz',
        39000.00
    ),
    (
        'CB09',
        'Snack Khoai Tây',
        'Gói snack khoai tây Lay\'s 90g',
        29000.00
    ),
    (
        'CB10',
        'Hotdog Phô Mai',
        'Bánh mì hotdog kẹp xốt phô mai nóng',
        49000.00
    );

-- 9. NHÂN VIÊN (10 Nhân viên)
INSERT INTO
    NHAN_VIEN (
        MaNV,
        HoTen,
        NgaySinh,
        CCCD,
        SDT,
        LuongCoBan,
        NgayVaoLam,
        MaRap
    )
VALUES (
        'NV01',
        'Nguyễn Văn Hùng',
        '1988-03-12',
        '012345678901',
        '0901111222',
        18000000.00,
        '2018-01-15',
        'RAP01'
    ),
    (
        'NV02',
        'Trần Thị Mai',
        '1992-07-24',
        '012345678902',
        '0901111223',
        15000000.00,
        '2019-05-20',
        'RAP02'
    ),
    (
        'NV03',
        'Lê Văn Nam',
        '1990-11-05',
        '012345678903',
        '0901111224',
        16000000.00,
        '2020-03-10',
        'RAP03'
    ),
    (
        'NV04',
        'Phạm Thị Hoa',
        '2001-02-18',
        '012345678904',
        '0901111225',
        7500000.00,
        '2022-06-01',
        'RAP01'
    ),
    (
        'NV05',
        'Hoàng Văn Tuấn',
        '2002-09-09',
        '012345678905',
        '0901111226',
        7500000.00,
        '2022-08-15',
        'RAP01'
    ),
    (
        'NV06',
        'Vũ Thu Trang',
        '2000-12-12',
        '012345678906',
        '0901111227',
        8000000.00,
        '2023-01-10',
        'RAP02'
    ),
    (
        'NV07',
        'Đặng Minh Quân',
        '1999-04-05',
        '012345678907',
        '0901111228',
        7800000.00,
        '2023-03-01',
        'RAP03'
    ),
    (
        'NV08',
        'Bùi Tiến Dũng',
        '1995-08-19',
        '012345678908',
        '0901111229',
        10500000.00,
        '2021-09-01',
        'RAP01'
    ),
    (
        'NV09',
        'Ngô Bảo Ngọc',
        '1996-01-22',
        '012345678909',
        '0901111230',
        10000000.00,
        '2021-11-15',
        'RAP02'
    ),
    (
        'NV10',
        'Lý Văn Hải',
        '1994-06-30',
        '012345678910',
        '0901111231',
        11000000.00,
        '2020-10-01',
        'RAP04'
    );

-- 10. PHÂN LOẠI NHÂN VIÊN (1:1 với NHAN_VIEN)
INSERT INTO
    NV_QUAN_LY (
        MaNV,
        HeSoTrachNhiem,
        QuyenHan
    )
VALUES (
        'NV01',
        1.50,
        'Quản lý toàn bộ cụm rạp RAP01'
    ),
    (
        'NV02',
        1.30,
        'Quản lý toàn bộ cụm rạp RAP02'
    ),
    (
        'NV03',
        1.30,
        'Quản lý toàn bộ cụm rạp RAP03'
    );

INSERT INTO
    NV_BAN_HANG (MaNV, CaLamViec, DoanhSoThang)
VALUES ('NV04', 'Sáng', 25000000.00),
    ('NV05', 'Chiều', 32000000.00),
    ('NV06', 'Tối', 41000000.00),
    ('NV07', 'Tối', 38000000.00);

INSERT INTO
    NV_KY_THUAT (
        MaNV,
        ChungChiKyThuat,
        KhuVucPhuTrach
    )
VALUES (
        'NV08',
        'Chứng chỉ Máy chiếu IMAX Digital 2022',
        'Phòng máy PH01-PH03'
    ),
    (
        'NV09',
        'Chứng chỉ Âm thanh Dolby Atmos',
        'Phòng máy PH04-PH05'
    ),
    (
        'NV10',
        'Chứng chỉ Máy chiếu Laser 4K',
        'Phòng máy PH07-PH08'
    );

-- =============================================================================
-- PHẦN 2B: NẠP DỮ LIỆU GIAO DỊCH (DML)
-- =============================================================================
USE QuanLyRapPhim;
SET NAMES utf8mb4;

-- 1. SUẤT CHIẾU (10 Suất chiếu)
INSERT INTO
    SUAT_CHIEU (
        MaSuatChieu,
        NgayChieu,
        GioBatDau,
        GioKetThuc,
        TrangThai,
        MaPhim,
        MaPhong
    )
VALUES (
        'SC01',
        '2024-05-15',
        '09:00:00',
        '11:15:00',
        'Đã kết thúc',
        'P01',
        'PH01'
    ),
    (
        'SC02',
        '2024-05-15',
        '14:00:00',
        '16:15:00',
        'Đã kết thúc',
        'P01',
        'PH01'
    ),
    (
        'SC03',
        '2024-05-15',
        '19:30:00',
        '21:45:00',
        'Đã kết thúc',
        'P01',
        'PH01'
    ),
    (
        'SC04',
        '2024-05-15',
        '10:00:00',
        '12:20:00',
        'Đã kết thúc',
        'P02',
        'PH02'
    ),
    (
        'SC05',
        '2024-05-15',
        '18:00:00',
        '20:20:00',
        'Đã kết thúc',
        'P02',
        'PH02'
    ),
    (
        'SC06',
        '2024-05-16',
        '13:00:00',
        '15:45:00',
        'Đã kết thúc',
        'P03',
        'PH01'
    ),
    (
        'SC07',
        '2024-05-16',
        '20:00:00',
        '22:45:00',
        'Đã kết thúc',
        'P03',
        'PH01'
    ),
    (
        'SC08',
        '2024-05-16',
        '09:30:00',
        '11:25:00',
        'Đã kết thúc',
        'P04',
        'PH04'
    ),
    (
        'SC09',
        '2024-05-16',
        '19:00:00',
        '20:55:00',
        'Đã kết thúc',
        'P04',
        'PH04'
    ),
    (
        'SC10',
        '2024-05-17',
        '18:30:00',
        '20:05:00',
        'Sắp chiếu',
        'P05',
        'PH07'
    );

-- 2. ĐẶT VÉ (12 Vé giao dịch: 5 vé mua tại quầy có MaNV, 7 vé đặt Online có MaNV = NULL)
INSERT INTO
    DAT_VE (
        MaVe,
        NgayGioDat,
        GiaVe,
        TrangThaiThanhToan,
        MaKH,
        MaSuatChieu,
        MaPhong,
        SoGhe,
        MaNV
    )
VALUES (
        'VE01',
        '2024-05-14 10:15:00',
        120000.00,
        'Đã thanh toán',
        'KH01',
        'SC01',
        'PH01',
        'A1',
        'NV04'
    ),
    (
        'VE02',
        '2024-05-14 10:16:00',
        120000.00,
        'Đã thanh toán',
        'KH01',
        'SC01',
        'PH01',
        'A2',
        'NV04'
    ),
    (
        'VE03',
        '2024-05-14 14:20:00',
        135000.00,
        'Đã thanh toán',
        'KH02',
        'SC01',
        'PH01',
        'B1',
        'NV05'
    ),
    (
        'VE04',
        '2024-05-14 14:21:00',
        135000.00,
        'Đã thanh toán',
        'KH02',
        'SC01',
        'PH01',
        'B2',
        'NV05'
    ),
    (
        'VE05',
        '2024-05-15 08:30:00',
        150000.00,
        'Đã thanh toán',
        'KH03',
        'SC03',
        'PH01',
        'S1',
        NULL
    ),
    (
        'VE06',
        '2024-05-15 08:30:00',
        150000.00,
        'Đã thanh toán',
        'KH03',
        'SC03',
        'PH01',
        'S2',
        NULL
    ),
    (
        'VE07',
        '2024-05-15 11:00:00',
        90000.00,
        'Đã thanh toán',
        'KH04',
        'SC04',
        'PH02',
        'A1',
        NULL
    ),
    (
        'VE08',
        '2024-05-15 11:05:00',
        100000.00,
        'Đã thanh toán',
        'KH05',
        'SC05',
        'PH02',
        'B1',
        NULL
    ),
    (
        'VE09',
        '2024-05-16 09:00:00',
        135000.00,
        'Đã thanh toán',
        'KH07',
        'SC06',
        'PH01',
        'B3',
        NULL
    ),
    (
        'VE10',
        '2024-05-16 15:30:00',
        110000.00,
        'Đã thanh toán',
        'KH08',
        'SC08',
        'PH04',
        'A1',
        'NV06'
    ),
    (
        'VE11',
        '2024-05-17 10:00:00',
        120000.00,
        'Chờ thanh toán',
        'KH09',
        'SC10',
        'PH07',
        'A1',
        NULL
    ),
    (
        'VE12',
        '2024-05-17 10:05:00',
        140000.00,
        'Chờ thanh toán',
        'KH10',
        'SC10',
        'PH07',
        'B1',
        NULL
    );

-- 3. MUA F&B (10 Giao dịch dịch vụ)
INSERT INTO
    MUA_FNB (
        MaKH,
        MaCombo,
        NgayMua,
        SoLuong,
        ThanhTien
    )
VALUES (
        'KH01',
        'CB02',
        '2024-05-14 10:16:30.000000',
        1,
        119000.00
    ),
    (
        'KH02',
        'CB01',
        '2024-05-14 14:22:00.000000',
        2,
        178000.00
    ),
    (
        'KH03',
        'CB03',
        '2024-05-15 08:31:00.000000',
        1,
        229000.00
    ),
    (
        'KH04',
        'CB07',
        '2024-05-15 11:01:15.000000',
        1,
        39000.00
    ),
    (
        'KH05',
        'CB05',
        '2024-05-15 11:06:00.000000',
        1,
        69000.00
    ),
    (
        'KH07',
        'CB02',
        '2024-05-16 09:02:00.000000',
        1,
        119000.00
    ),
    (
        'KH08',
        'CB01',
        '2024-05-16 15:32:10.000000',
        1,
        89000.00
    ),
    (
        'KH09',
        'CB06',
        '2024-05-17 10:02:00.000000',
        1,
        69000.00
    ),
    (
        'KH10',
        'CB04',
        '2024-05-17 10:06:30.000000',
        1,
        289000.00
    ),
    (
        'KH03',
        'CB08',
        '2024-05-18 19:15:00.000000',
        2,
        78000.00
    );

-- =============================================================================
-- PHẦN 3A: CÀI ĐẶT THỦ TỤC LƯU TRỮ (STORED PROCEDURES)
-- =============================================================================
USE QuanLyRapPhim;
SET NAMES utf8mb4;
DELIMITER //
-- 1. THỦ TỤC THÊM KHÁCH HÀNG (sp_ThemKhachHang)
DROP PROCEDURE IF EXISTS sp_ThemKhachHang //
CREATE PROCEDURE sp_ThemKhachHang(
    IN p_MaKH VARCHAR(20),
    IN p_HoTen VARCHAR(150),
    IN p_SDT VARCHAR(20),
    IN p_Email VARCHAR(254),
    IN p_NgaySinh DATE
)
BEGIN
    IF EXISTS (SELECT 1 FROM KHACH_HANG WHERE MaKH = p_MaKH) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Mã khách hàng đã tồn tại trên hệ thống!';
    END IF;
    IF EXISTS (SELECT 1 FROM KHACH_HANG WHERE SDT = p_SDT) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Số điện thoại này đã được đăng ký cho tài khoản khác!';
    END IF;
    IF p_NgaySinh IS NOT NULL AND p_NgaySinh >= CURDATE() THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Ngày sinh của khách hàng phải nhỏ hơn ngày hiện tại!';
    END IF;
    INSERT INTO KHACH_HANG (MaKH, HoTen, SDT, Email, NgaySinh, DiemTichLuy)
    VALUES (p_MaKH, p_HoTen, p_SDT, p_Email, p_NgaySinh, 0);
    SELECT * FROM KHACH_HANG WHERE MaKH = p_MaKH;
END //
-- 2. THỦ TỤC ĐẶT VÉ XEM PHIM TÍNH TIỀN TỰ ĐỘNG (sp_DatVeXemPhim)
--    Chống trùng ghế + độ tuổi: trigger trg_KiemTraDatVe_BeforeInsert. Tích điểm: trigger tích điểm vé.
--    p_MaNV: nhân viên xuất vé tại quầy (NULL = đặt online).
DROP PROCEDURE IF EXISTS sp_DatVeXemPhim //
CREATE PROCEDURE sp_DatVeXemPhim(
    IN p_MaVe VARCHAR(20),
    IN p_MaKH VARCHAR(20),
    IN p_MaSuatChieu VARCHAR(20),
    IN p_SoGhe VARCHAR(10),
    IN p_TrangThaiThanhToan VARCHAR(30),
    IN p_MaNV VARCHAR(20)
)
BEGIN
    DECLARE v_MaPhong VARCHAR(20);
    DECLARE v_TrangThaiSuat VARCHAR(30);
    DECLARE v_LoaiPhong VARCHAR(10);
    DECLARE v_PhuThuGhe DECIMAL(12,2);
    DECLARE v_GiaCoBan DECIMAL(12,2) DEFAULT 0;
    DECLARE v_GiaVeCuoi DECIMAL(12,2) DEFAULT 0;
    SELECT MaPhong, TrangThai INTO v_MaPhong, v_TrangThaiSuat
    FROM SUAT_CHIEU WHERE MaSuatChieu = p_MaSuatChieu;
    IF v_MaPhong IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Mã suất chiếu không tồn tại!';
    END IF;
    IF v_TrangThaiSuat <> 'Sắp chiếu' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Suất chiếu đang chiếu hoặc đã kết thúc, không thể đặt vé!';
    END IF;
    IF NOT EXISTS (SELECT 1 FROM KHACH_HANG WHERE MaKH = p_MaKH) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Mã khách hàng không tồn tại!';
    END IF;
    IF p_MaNV IS NOT NULL AND NOT EXISTS (SELECT 1 FROM NHAN_VIEN WHERE MaNV = p_MaNV) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Mã nhân viên xuất vé không tồn tại!';
    END IF;
    SELECT LoaiPhong INTO v_LoaiPhong FROM PHONG_CHIEU WHERE MaPhong = v_MaPhong;
    CASE v_LoaiPhong
        WHEN '2D' THEN SET v_GiaCoBan = 75000;
        WHEN '3D' THEN SET v_GiaCoBan = 100000;
        WHEN 'IMAX' THEN SET v_GiaCoBan = 150000;
        ELSE SET v_GiaCoBan = 75000;
    END CASE;
    SELECT PhuThuGhe INTO v_PhuThuGhe FROM GHE_NGOI WHERE MaPhong = v_MaPhong AND SoGhe = p_SoGhe;
    IF v_PhuThuGhe IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Số ghế không tồn tại trong phòng của suất chiếu này!';
    END IF;
    SET v_GiaVeCuoi = v_GiaCoBan + v_PhuThuGhe;
    INSERT INTO DAT_VE (MaVe, NgayGioDat, GiaVe, TrangThaiThanhToan, MaKH, MaSuatChieu, MaPhong, SoGhe, MaNV)
    VALUES (p_MaVe, NOW(), v_GiaVeCuoi, IFNULL(p_TrangThaiThanhToan, 'Chờ thanh toán'), p_MaKH, p_MaSuatChieu, v_MaPhong, p_SoGhe, p_MaNV);
    SELECT dv.MaVe, kh.HoTen AS TenKhachHang, p.TenPhim, cr.TenRap, pc.TenPhong, pc.LoaiPhong, dv.SoGhe, gn.LoaiGhe, dv.NgayGioDat, dv.GiaVe, dv.TrangThaiThanhToan, dv.MaNV
    FROM DAT_VE dv
    JOIN KHACH_HANG kh ON dv.MaKH = kh.MaKH
    JOIN SUAT_CHIEU sc ON dv.MaSuatChieu = sc.MaSuatChieu
    JOIN PHIM p ON sc.MaPhim = p.MaPhim
    JOIN PHONG_CHIEU pc ON dv.MaPhong = pc.MaPhong
    JOIN CUM_RAP cr ON pc.MaRap = cr.MaRap
    JOIN GHE_NGOI gn ON dv.MaPhong = gn.MaPhong AND dv.SoGhe = gn.SoGhe
    WHERE dv.MaVe = p_MaVe;
END //
-- 3. THỦ TỤC TÌM KIẾM LỊCH CHIẾU THEO BỘ LỌC (sp_TimKiemLichChieu)
DROP PROCEDURE IF EXISTS sp_TimKiemLichChieu //
CREATE PROCEDURE sp_TimKiemLichChieu(
    IN p_TenPhim VARCHAR(200),
    IN p_NgayChieu DATE,
    IN p_MaRap VARCHAR(20)
)
BEGIN
    SELECT sc.MaSuatChieu, p.TenPhim, p.ThoiLuong, p.GioiHanTuoi, cr.TenRap,
           CONCAT_WS(', ', cr.SoNha, cr.Duong, cr.QuanHuyen, cr.TinhTP) AS DiaChiRap,
           pc.TenPhong, pc.LoaiPhong, sc.NgayChieu, sc.GioBatDau, sc.GioKetThuc, sc.TrangThai,
           (pc.TongSoGhe - COUNT(dv.MaVe)) AS SoGheTrong
    FROM SUAT_CHIEU sc
    JOIN PHIM p ON sc.MaPhim = p.MaPhim
    JOIN PHONG_CHIEU pc ON sc.MaPhong = pc.MaPhong
    JOIN CUM_RAP cr ON pc.MaRap = cr.MaRap
    LEFT JOIN DAT_VE dv ON sc.MaSuatChieu = dv.MaSuatChieu
    WHERE (p_TenPhim IS NULL OR p.TenPhim LIKE CONCAT('%', p_TenPhim, '%'))
      AND (p_NgayChieu IS NULL OR sc.NgayChieu = p_NgayChieu)
      AND (p_MaRap IS NULL OR cr.MaRap = p_MaRap)
    GROUP BY sc.MaSuatChieu, p.TenPhim, p.ThoiLuong, p.GioiHanTuoi, cr.TenRap, cr.SoNha, cr.Duong, cr.QuanHuyen, cr.TinhTP, pc.TenPhong, pc.LoaiPhong, sc.NgayChieu, sc.GioBatDau, sc.GioKetThuc, sc.TrangThai, pc.TongSoGhe
    ORDER BY sc.NgayChieu ASC, sc.GioBatDau ASC;
END //
-- 4. THỦ TỤC KIỂM TRA DANH SÁCH GHẾ TRỐNG CỦA SUẤT CHIẾU (sp_LayDanhSachGheTrong)
DROP PROCEDURE IF EXISTS sp_LayDanhSachGheTrong //
CREATE PROCEDURE sp_LayDanhSachGheTrong(
    IN p_MaSuatChieu VARCHAR(20)
)
BEGIN
    SELECT gn.MaPhong, gn.SoGhe, gn.LoaiGhe, gn.PhuThuGhe, 'Còn trống' AS TrangThaiGhe
    FROM SUAT_CHIEU sc
    JOIN GHE_NGOI gn ON sc.MaPhong = gn.MaPhong
    LEFT JOIN DAT_VE dv ON sc.MaSuatChieu = dv.MaSuatChieu AND gn.MaPhong = dv.MaPhong AND gn.SoGhe = dv.SoGhe
    WHERE sc.MaSuatChieu = p_MaSuatChieu AND dv.MaVe IS NULL
    ORDER BY gn.SoGhe ASC;
END //
-- 5. THỦ TỤC XÁC NHẬN THANH TOÁN HÓA ĐƠN VÉ (sp_ThanhToanVe)
DROP PROCEDURE IF EXISTS sp_ThanhToanVe //
CREATE PROCEDURE sp_ThanhToanVe(
    IN p_MaVe VARCHAR(20)
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM DAT_VE WHERE MaVe = p_MaVe) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Không tìm thấy mã vé cần thanh toán!';
    END IF;
    IF EXISTS (SELECT 1 FROM DAT_VE WHERE MaVe = p_MaVe AND TrangThaiThanhToan = 'Đã thanh toán') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Thông báo: Vé này đã được thanh toán trước đó!';
    END IF;
    UPDATE DAT_VE SET TrangThaiThanhToan = 'Đã thanh toán' WHERE MaVe = p_MaVe;
END //
-- 6. THỦ TỤC THÊM NHÂN VIÊN ĐẢM BẢO RÀNG BUỘC TOÀN PHẦN & RỜI RẠC (sp_ThemNhanVien)
DROP PROCEDURE IF EXISTS sp_ThemNhanVien //
CREATE PROCEDURE sp_ThemNhanVien(
    IN p_MaNV VARCHAR(20),
    IN p_HoTen VARCHAR(150),
    IN p_NgaySinh DATE,
    IN p_CCCD CHAR(12),
    IN p_SDT VARCHAR(20),
    IN p_LuongCoBan DECIMAL(15,2),
    IN p_NgayVaoLam DATE,
    IN p_MaRap VARCHAR(20),
    IN p_LoaiNV VARCHAR(20),
    IN p_HeSoTrachNhiem DECIMAL(5,2),
    IN p_QuyenHan VARCHAR(255),
    IN p_CaLamViec VARCHAR(20),
    IN p_ChungChiKyThuat VARCHAR(255),
    IN p_KhuVucPhuTrach VARCHAR(255)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        RESIGNAL;
    END;
    IF p_LoaiNV IS NULL OR p_LoaiNV NOT IN ('QUAN_LY', 'BAN_HANG', 'KY_THUAT') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi ISA: Nhân viên bắt buộc phải thuộc đúng 1 trong 3 bộ phận (QUAN_LY, BAN_HANG, KY_THUAT)!';
    END IF;
    START TRANSACTION;
    INSERT INTO NHAN_VIEN (MaNV, HoTen, NgaySinh, CCCD, SDT, LuongCoBan, NgayVaoLam, MaRap)
    VALUES (p_MaNV, p_HoTen, p_NgaySinh, p_CCCD, p_SDT, p_LuongCoBan, p_NgayVaoLam, p_MaRap);
    IF p_LoaiNV = 'QUAN_LY' THEN
        INSERT INTO NV_QUAN_LY (MaNV, HeSoTrachNhiem, QuyenHan)
        VALUES (p_MaNV, IFNULL(p_HeSoTrachNhiem, 1.0), p_QuyenHan);
    ELSEIF p_LoaiNV = 'BAN_HANG' THEN
        INSERT INTO NV_BAN_HANG (MaNV, CaLamViec, DoanhSoThang)
        VALUES (p_MaNV, IFNULL(p_CaLamViec, 'Sáng'), 0);
    ELSEIF p_LoaiNV = 'KY_THUAT' THEN
        INSERT INTO NV_KY_THUAT (MaNV, ChungChiKyThuat, KhuVucPhuTrach)
        VALUES (p_MaNV, p_ChungChiKyThuat, p_KhuVucPhuTrach);
    END IF;
    COMMIT;
END //
-- 7. THỦ TỤC THÊM PHIM MỚI (sp_ThemPhim)
--    [SỬA] p_GioiHanTuoi NULL trước đây lọt qua kiểm tra (NULL NOT IN (...) = NULL)
DROP PROCEDURE IF EXISTS sp_ThemPhim //
CREATE PROCEDURE sp_ThemPhim(
    IN p_MaPhim VARCHAR(20),
    IN p_TenPhim VARCHAR(200),
    IN p_DaoDien VARCHAR(150),
    IN p_ThoiLuong INT,
    IN p_NgayKhoiChieu DATE,
    IN p_GioiHanTuoi VARCHAR(10)
)
BEGIN
    IF EXISTS (SELECT 1 FROM PHIM WHERE MaPhim = p_MaPhim) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Mã phim này đã tồn tại trên hệ thống!';
    END IF;
    IF p_ThoiLuong IS NULL OR p_ThoiLuong <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Thời lượng phim phải lớn hơn 0 phút!';
    END IF;
    IF p_GioiHanTuoi IS NULL OR p_GioiHanTuoi NOT IN ('G', 'PG', '13+', '18+', 'P', 'K', 'T13', 'T16', 'T18') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Giới hạn độ tuổi không hợp lệ!';
    END IF;
    INSERT INTO PHIM (MaPhim, TenPhim, DaoDien, ThoiLuong, NgayKhoiChieu, GioiHanTuoi)
    VALUES (p_MaPhim, p_TenPhim, p_DaoDien, p_ThoiLuong, p_NgayKhoiChieu, p_GioiHanTuoi);
    SELECT * FROM PHIM WHERE MaPhim = p_MaPhim;
END //
-- 8. CẬP NHẬT THÔNG TIN PHIM (sp_CapNhatPhim)
--    Tham số nào truyền NULL thì giữ nguyên giá trị cũ.
DROP PROCEDURE IF EXISTS sp_CapNhatPhim //
CREATE PROCEDURE sp_CapNhatPhim(
    IN p_MaPhim VARCHAR(20),
    IN p_TenPhim VARCHAR(200),
    IN p_DaoDien VARCHAR(150),
    IN p_ThoiLuong INT,
    IN p_NgayKhoiChieu DATE,
    IN p_GioiHanTuoi VARCHAR(10),
    IN p_TrangThai VARCHAR(30)
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM PHIM WHERE MaPhim = p_MaPhim) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Mã phim không tồn tại!';
    END IF;
    IF p_ThoiLuong IS NOT NULL AND p_ThoiLuong <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Thời lượng phim phải lớn hơn 0 phút!';
    END IF;
    IF p_GioiHanTuoi IS NOT NULL AND p_GioiHanTuoi NOT IN ('G', 'PG', '13+', '18+', 'P', 'K', 'T13', 'T16', 'T18') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Giới hạn độ tuổi không hợp lệ!';
    END IF;
    IF p_TrangThai IS NOT NULL AND p_TrangThai NOT IN ('Sắp chiếu', 'Đang chiếu', 'Ngưng chiếu') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Trạng thái phim không hợp lệ (Sắp chiếu, Đang chiếu, Ngưng chiếu)!';
    END IF;
    -- Đổi thời lượng sẽ làm sai giờ kết thúc + 15 phút dọn dẹp của các suất chiếu đã xếp
    IF p_ThoiLuong IS NOT NULL
       AND p_ThoiLuong <> (SELECT ThoiLuong FROM PHIM WHERE MaPhim = p_MaPhim)
       AND EXISTS (SELECT 1 FROM SUAT_CHIEU WHERE MaPhim = p_MaPhim AND TrangThai = 'Sắp chiếu') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Phim còn suất chiếu sắp chiếu, không thể đổi thời lượng!';
    END IF;
    UPDATE PHIM
    SET TenPhim       = IFNULL(p_TenPhim, TenPhim),
        DaoDien       = IFNULL(p_DaoDien, DaoDien),
        ThoiLuong     = IFNULL(p_ThoiLuong, ThoiLuong),
        NgayKhoiChieu = IFNULL(p_NgayKhoiChieu, NgayKhoiChieu),
        GioiHanTuoi   = IFNULL(p_GioiHanTuoi, GioiHanTuoi),
        TrangThai     = IFNULL(p_TrangThai, TrangThai)
    WHERE MaPhim = p_MaPhim;
    SELECT * FROM PHIM WHERE MaPhim = p_MaPhim;
END //
-- 9. GỠ BỎ PHIM (sp_GoBoPhim) - Ràng buộc toàn vẹn tham chiếu (mục 4.4)
--    Phim đã có suất chiếu (đồng nghĩa có thể đã có vé) => chỉ chuyển 'Ngưng chiếu'.
--    Phim chưa có suất chiếu nào => xóa hẳn (các bảng con như thể loại/diễn viên cần ON DELETE CASCADE).
DROP PROCEDURE IF EXISTS sp_GoBoPhim //
CREATE PROCEDURE sp_GoBoPhim(
    IN p_MaPhim VARCHAR(20)
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM PHIM WHERE MaPhim = p_MaPhim) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Mã phim không tồn tại!';
    END IF;
    IF EXISTS (SELECT 1 FROM SUAT_CHIEU WHERE MaPhim = p_MaPhim) THEN
        UPDATE PHIM SET TrangThai = 'Ngưng chiếu' WHERE MaPhim = p_MaPhim;
        SELECT p_MaPhim AS MaPhim, 'Ngưng chiếu' AS KetQua,
               'Phim đã có suất chiếu/vé nên không xóa, chỉ chuyển sang trạng thái Ngưng chiếu để bảo toàn báo cáo doanh thu.' AS GhiChu;
    ELSE
        DELETE FROM PHIM WHERE MaPhim = p_MaPhim;
        SELECT p_MaPhim AS MaPhim, 'Đã xóa' AS KetQua, 'Phim chưa có suất chiếu nên đã được xóa khỏi hệ thống.' AS GhiChu;
    END IF;
END //
-- 10. TẠO SUẤT CHIẾU (sp_TaoSuatChieu)
--     Giờ kết thúc = giờ bắt đầu + thời lượng phim.
--     Chồng lịch + 15 phút dọn dẹp: trigger trg_KiemTraLichChieu_BeforeInsert.
DROP PROCEDURE IF EXISTS sp_TaoSuatChieu //
CREATE PROCEDURE sp_TaoSuatChieu(
    IN p_MaSuatChieu VARCHAR(20),
    IN p_MaPhim VARCHAR(20),
    IN p_MaPhong VARCHAR(20),
    IN p_NgayChieu DATE,
    IN p_GioBatDau TIME
)
BEGIN
    DECLARE v_ThoiLuong INT;
    DECLARE v_TrangThaiPhim VARCHAR(30);
    DECLARE v_BatDau DATETIME;
    DECLARE v_KetThuc DATETIME;
    IF NOT EXISTS (SELECT 1 FROM PHONG_CHIEU WHERE MaPhong = p_MaPhong) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Mã phòng chiếu không tồn tại!';
    END IF;
    IF EXISTS (SELECT 1 FROM SUAT_CHIEU WHERE MaSuatChieu = p_MaSuatChieu) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Mã suất chiếu đã tồn tại!';
    END IF;
    SELECT ThoiLuong, TrangThai INTO v_ThoiLuong, v_TrangThaiPhim FROM PHIM WHERE MaPhim = p_MaPhim;
    IF v_ThoiLuong IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Mã phim không tồn tại!';
    END IF;
    IF v_TrangThaiPhim = 'Ngưng chiếu' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Phim đã ngưng chiếu, không thể xếp suất chiếu mới!';
    END IF;
    SET v_BatDau = TIMESTAMP(p_NgayChieu, p_GioBatDau);
    IF v_BatDau <= NOW() THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Thời gian bắt đầu suất chiếu phải lớn hơn thời điểm hiện tại!';
    END IF;
    SET v_KetThuc = v_BatDau + INTERVAL v_ThoiLuong MINUTE;
    IF DATE(v_KetThuc) <> p_NgayChieu THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Suất chiếu không được kéo dài qua 24h của ngày chiếu!';
    END IF;
    INSERT INTO SUAT_CHIEU (MaSuatChieu, MaPhim, MaPhong, NgayChieu, GioBatDau, GioKetThuc, TrangThai)
    VALUES (p_MaSuatChieu, p_MaPhim, p_MaPhong, p_NgayChieu, TIME(v_BatDau), TIME(v_KetThuc), 'Sắp chiếu');
    SELECT * FROM SUAT_CHIEU WHERE MaSuatChieu = p_MaSuatChieu;
END //
-- 11. TRA CỨU VÉ THEO MÃ VÉ HOẶC SỐ ĐIỆN THOẠI (sp_TraCuuVe)
--     Dùng để soát vé / xử lý sự cố. Truyền NULL cho tiêu chí không dùng (cần ít nhất 1).
DROP PROCEDURE IF EXISTS sp_TraCuuVe //
CREATE PROCEDURE sp_TraCuuVe(
    IN p_MaVe VARCHAR(20),
    IN p_SDT VARCHAR(20)
)
BEGIN
    IF p_MaVe IS NULL AND p_SDT IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Cần nhập Mã vé hoặc Số điện thoại để tra cứu!';
    END IF;

    SELECT dv.MaVe, kh.MaKH, kh.HoTen, kh.SDT, p.TenPhim, p.GioiHanTuoi, cr.TenRap, pc.TenPhong,
           sc.NgayChieu, sc.GioBatDau, sc.GioKetThuc, sc.TrangThai AS TrangThaiSuat,
           dv.SoGhe, gn.LoaiGhe, dv.GiaVe, dv.TrangThaiThanhToan, dv.NgayGioDat, dv.MaNV
    FROM DAT_VE dv
    JOIN KHACH_HANG kh ON dv.MaKH = kh.MaKH
    JOIN SUAT_CHIEU sc ON dv.MaSuatChieu = sc.MaSuatChieu
    JOIN PHIM p ON sc.MaPhim = p.MaPhim
    JOIN PHONG_CHIEU pc ON dv.MaPhong = pc.MaPhong
    JOIN CUM_RAP cr ON pc.MaRap = cr.MaRap
    JOIN GHE_NGOI gn ON dv.MaPhong = gn.MaPhong AND dv.SoGhe = gn.SoGhe
    WHERE (p_MaVe IS NULL OR dv.MaVe = p_MaVe)
      AND (p_SDT IS NULL OR kh.SDT = p_SDT)
    ORDER BY sc.NgayChieu DESC, sc.GioBatDau DESC;
END //
-- 12. MUA DỊCH VỤ F&B (sp_MuaFB)
--     Kiểm tra combo + tính ThanhTien: trg_TinhTienMuaFNB_BeforeInsert (ThanhTien truyền 0 sẽ bị trigger ghi đè).
--     Cộng điểm tích lũy: trg_TichDiemMuaFNB_AfterInsert.
DROP PROCEDURE IF EXISTS sp_MuaFB //
CREATE PROCEDURE sp_MuaFB(
    IN p_MaKH VARCHAR(20),
    IN p_MaCombo VARCHAR(20),
    IN p_SoLuong INT
)
BEGIN
    DECLARE v_NgayMua DATETIME(6);
    IF p_SoLuong IS NULL OR p_SoLuong <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Số lượng phải lớn hơn 0!';
    END IF;
    IF NOT EXISTS (SELECT 1 FROM KHACH_HANG WHERE MaKH = p_MaKH) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Mã khách hàng không tồn tại!';
    END IF;
    SET v_NgayMua = NOW(6);
    INSERT INTO MUA_FNB (MaKH, MaCombo, NgayMua, SoLuong, ThanhTien)
    VALUES (p_MaKH, p_MaCombo, v_NgayMua, p_SoLuong, 0);
    SELECT kh.MaKH, kh.HoTen, fb.MaCombo, fb.TenCombo, m.SoLuong, fb.DonGia, m.ThanhTien, m.NgayMua
    FROM MUA_FNB m
    JOIN KHACH_HANG kh ON m.MaKH = kh.MaKH
    JOIN DICH_VU_FNB fb ON m.MaCombo = fb.MaCombo
    WHERE m.MaKH = p_MaKH AND m.MaCombo = p_MaCombo AND m.NgayMua = v_NgayMua;
END //
DELIMITER ;

-- =============================================================================
-- PHẦN 3B: CÀI ĐẶT TRÌNH KÍCH HOẠT (TRIGGERS)
-- =============================================================================
USE QuanLyRapPhim;
SET NAMES utf8mb4;
DELIMITER //
-- 1. TRIGGER CHỐNG ĐẶT TRÙNG GHẾ & KIỂM TRA ĐỘ TUỔI (trg_KiemTraDatVe_BeforeInsert)
DROP TRIGGER IF EXISTS trg_KiemTraDatVe_BeforeInsert //
CREATE TRIGGER trg_KiemTraDatVe_BeforeInsert
BEFORE INSERT ON DAT_VE
FOR EACH ROW
BEGIN
    DECLARE v_NgayChieu DATE;
    DECLARE v_GioiHanTuoi VARCHAR(10);
    DECLARE v_NgaySinhKH DATE;
    DECLARE v_TuoiKhachHang INT;
    IF EXISTS (
        SELECT 1 FROM DAT_VE
        WHERE MaSuatChieu = NEW.MaSuatChieu AND MaPhong = NEW.MaPhong AND SoGhe = NEW.SoGhe
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi Double-booking: Ghế ngồi này đã có người đặt trong suất chiếu đã chọn!';
    END IF;
    SELECT sc.NgayChieu, p.GioiHanTuoi INTO v_NgayChieu, v_GioiHanTuoi
    FROM SUAT_CHIEU sc JOIN PHIM p ON sc.MaPhim = p.MaPhim
    WHERE sc.MaSuatChieu = NEW.MaSuatChieu;
    SELECT NgaySinh INTO v_NgaySinhKH FROM KHACH_HANG WHERE MaKH = NEW.MaKH;
    IF v_GioiHanTuoi IN ('13+', '18+') AND v_NgaySinhKH IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi Độ tuổi: Phim có giới hạn độ tuổi, khách hàng bắt buộc phải cập nhật Ngày sinh!';
    END IF;
    IF v_NgaySinhKH IS NOT NULL THEN
        SET v_TuoiKhachHang = TIMESTAMPDIFF(YEAR, v_NgaySinhKH, v_NgayChieu);
        IF (v_GioiHanTuoi = '13+' AND v_TuoiKhachHang < 13) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi Độ tuổi: Khách hàng chưa đủ 13 tuổi tính đến ngày chiếu để xem phim 13+!';
        END IF;
        IF (v_GioiHanTuoi = '18+' AND v_TuoiKhachHang < 18) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi Độ tuổi: Khách hàng chưa đủ 18 tuổi tính đến ngày chiếu để xem phim 18+!';
        END IF;
    END IF;
END //
DROP TRIGGER IF EXISTS trg_KiemTraDatVe_BeforeUpdate //
CREATE TRIGGER trg_KiemTraDatVe_BeforeUpdate
BEFORE UPDATE ON DAT_VE
FOR EACH ROW
BEGIN
    IF (NEW.MaSuatChieu <> OLD.MaSuatChieu OR NEW.MaPhong <> OLD.MaPhong OR NEW.SoGhe <> OLD.SoGhe) THEN
        IF EXISTS (
            SELECT 1 FROM DAT_VE
            WHERE MaSuatChieu = NEW.MaSuatChieu AND MaPhong = NEW.MaPhong AND SoGhe = NEW.SoGhe
              AND MaVe <> NEW.MaVe
        ) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi Double-booking: Ghế ngồi này đã có người đặt trong suất chiếu đã chọn!';
        END IF;
    END IF;
END //
-- 2. TRIGGER TÍCH ĐIỂM TỰ ĐỘNG KHI TẠO VÉ ĐÃ THANH TOÁN NGAY (trg_TichDiemVe_AfterInsert)
DROP TRIGGER IF EXISTS trg_TichDiemVe_AfterInsert //
CREATE TRIGGER trg_TichDiemVe_AfterInsert
AFTER INSERT ON DAT_VE
FOR EACH ROW
BEGIN
    DECLARE v_DiemCong INT DEFAULT 0;
    IF NEW.TrangThaiThanhToan = 'Đã thanh toán' THEN
        SET v_DiemCong = FLOOR(NEW.GiaVe / 10000);
        UPDATE KHACH_HANG SET DiemTichLuy = DiemTichLuy + v_DiemCong WHERE MaKH = NEW.MaKH;
    END IF;
END //
-- 3. TRIGGER TÍCH ĐIỂM TỰ ĐỘNG KHI CẬP NHẬT THANH TOÁN HÓA ĐƠN VÉ (trg_TichDiemVe_AfterUpdate)
DROP TRIGGER IF EXISTS trg_TichDiemVe_AfterUpdate //
CREATE TRIGGER trg_TichDiemVe_AfterUpdate
AFTER UPDATE ON DAT_VE
FOR EACH ROW
BEGIN
    DECLARE v_DiemCong INT DEFAULT 0;
    IF OLD.TrangThaiThanhToan <> 'Đã thanh toán' AND NEW.TrangThaiThanhToan = 'Đã thanh toán' THEN
        SET v_DiemCong = FLOOR(NEW.GiaVe / 10000);
        UPDATE KHACH_HANG SET DiemTichLuy = DiemTichLuy + v_DiemCong WHERE MaKH = NEW.MaKH;
    END IF;
END //
-- 4. TRIGGER TỰ ĐỘNG TÍNH TIỀN & CỘNG ĐIỂM KHI MUA F&B
DROP TRIGGER IF EXISTS trg_TinhTienMuaFNB_BeforeInsert //
CREATE TRIGGER trg_TinhTienMuaFNB_BeforeInsert
BEFORE INSERT ON MUA_FNB
FOR EACH ROW
BEGIN
    DECLARE v_DonGia DECIMAL(12,2);
    SELECT DonGia INTO v_DonGia FROM DICH_VU_FNB WHERE MaCombo = NEW.MaCombo;
    IF v_DonGia IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Mã Combo F&B không tồn tại!';
    END IF;
    SET NEW.ThanhTien = NEW.SoLuong * v_DonGia;
END //
DROP TRIGGER IF EXISTS trg_TichDiemMuaFNB_AfterInsert //
CREATE TRIGGER trg_TichDiemMuaFNB_AfterInsert
AFTER INSERT ON MUA_FNB
FOR EACH ROW
BEGIN
    DECLARE v_DiemCong INT DEFAULT 0;
    SET v_DiemCong = FLOOR(NEW.ThanhTien / 10000);
    UPDATE KHACH_HANG SET DiemTichLuy = DiemTichLuy + v_DiemCong WHERE MaKH = NEW.MaKH;
END //
-- 5. TRIGGER CHỐNG CHỒNG CHÉO THỜI GIAN XẾP LỊCH CHIẾU (trg_KiemTraLichChieu_BeforeInsert)
DROP TRIGGER IF EXISTS trg_KiemTraLichChieu_BeforeInsert //
CREATE TRIGGER trg_KiemTraLichChieu_BeforeInsert
BEFORE INSERT ON SUAT_CHIEU
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1 FROM SUAT_CHIEU sc
        WHERE sc.MaPhong = NEW.MaPhong
          AND sc.NgayChieu = NEW.NgayChieu
          AND NEW.GioBatDau < ADDTIME(sc.GioKetThuc, '00:15:00')
          AND ADDTIME(NEW.GioKetThuc, '00:15:00') > sc.GioBatDau
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi Xếp lịch: Phòng chiếu bị trùng giờ hoặc chưa đảm bảo 15 phút dọn dẹp giữa 2 suất chiếu!';
    END IF;
END //
DROP TRIGGER IF EXISTS trg_KiemTraLichChieu_BeforeUpdate //
CREATE TRIGGER trg_KiemTraLichChieu_BeforeUpdate
BEFORE UPDATE ON SUAT_CHIEU
FOR EACH ROW
BEGIN
    IF EXISTS (
        SELECT 1 FROM SUAT_CHIEU sc
        WHERE sc.MaPhong = NEW.MaPhong
          AND sc.NgayChieu = NEW.NgayChieu
          AND sc.MaSuatChieu <> NEW.MaSuatChieu
          AND NEW.GioBatDau < ADDTIME(sc.GioKetThuc, '00:15:00')
          AND ADDTIME(NEW.GioKetThuc, '00:15:00') > sc.GioBatDau
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi Xếp lịch: Phòng chiếu bị trùng giờ hoặc chưa đảm bảo 15 phút dọn dẹp giữa 2 suất chiếu!';
    END IF;
END //
-- 6. BỘ 3 TRIGGER KIỂM TRA TÍNH RỜI RẠC (DISJOINT) CỦA NHÂN VIÊN (ISA HIERARCHY)
DROP TRIGGER IF EXISTS trg_Disjoint_NVQuanLy_BeforeInsert //
CREATE TRIGGER trg_Disjoint_NVQuanLy_BeforeInsert
BEFORE INSERT ON NV_QUAN_LY
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM NV_BAN_HANG WHERE MaNV = NEW.MaNV)
       OR EXISTS (SELECT 1 FROM NV_KY_THUAT WHERE MaNV = NEW.MaNV) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi Ràng buộc Rời rạc (ISA): Nhân viên này đã thuộc bộ phận Bán hàng hoặc Kỹ thuật!';
    END IF;
END //
DROP TRIGGER IF EXISTS trg_Disjoint_NVBanHang_BeforeInsert //
CREATE TRIGGER trg_Disjoint_NVBanHang_BeforeInsert
BEFORE INSERT ON NV_BAN_HANG
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM NV_QUAN_LY WHERE MaNV = NEW.MaNV)
       OR EXISTS (SELECT 1 FROM NV_KY_THUAT WHERE MaNV = NEW.MaNV) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi Ràng buộc Rời rạc (ISA): Nhân viên này đã thuộc bộ phận Quản lý hoặc Kỹ thuật!';
    END IF;
END //
DROP TRIGGER IF EXISTS trg_Disjoint_NVKyThuat_BeforeInsert //
CREATE TRIGGER trg_Disjoint_NVKyThuat_BeforeInsert
BEFORE INSERT ON NV_KY_THUAT
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM NV_QUAN_LY WHERE MaNV = NEW.MaNV)
       OR EXISTS (SELECT 1 FROM NV_BAN_HANG WHERE MaNV = NEW.MaNV) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi Ràng buộc Rời rạc (ISA): Nhân viên này đã thuộc bộ phận Quản lý hoặc Bán hàng!';
    END IF;
END //
DELIMITER ;

-- =============================================================================
-- PHẦN 4: KHỞI TẠO KHUNG NHÌN BÁO CÁO (VIEWS)
-- =============================================================================
USE QuanLyRapPhim;
SET NAMES utf8mb4;

CREATE OR REPLACE VIEW view_DoanhThuToanDien AS
SELECT 
    'Bán Vé' AS NguonDoanhThu,
    MONTH(v.NgayGioDat) AS Thang,
    YEAR(v.NgayGioDat) AS Nam,
    COUNT(v.MaVe) AS SoLuongGiaoDich,
    SUM(v.GiaVe) AS TongTien
FROM DAT_VE v
WHERE v.TrangThaiThanhToan = 'Đã thanh toán'
GROUP BY MONTH(v.NgayGioDat), YEAR(v.NgayGioDat)

UNION ALL

SELECT 
    'Bán F&B' AS NguonDoanhThu,
    MONTH(f.NgayMua) AS Thang,
    YEAR(f.NgayMua) AS Nam,
    COUNT(f.MaCombo) AS SoLuongGiaoDich,
    SUM(f.ThanhTien) AS TongTien
FROM MUA_FNB f
GROUP BY MONTH(f.NgayMua), YEAR(f.NgayMua);

