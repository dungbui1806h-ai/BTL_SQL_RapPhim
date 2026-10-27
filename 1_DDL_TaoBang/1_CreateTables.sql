-- PHAN 1: TAO CSDL QUAN LY CHUOI RAP CHIEU PHIM
-- Theo luoc do quan he trong bao cao phan 4 cua nhom 4.
-- MySQL 8.0.16+ (CHECK duoc thuc thi), InnoDB, UTF-8.
-- Chay mot lan tren CSDL moi. Khong DROP de tranh mat du lieu.
-- Ma dinh danh do nhom tu gan, vi du RAP01, PH01, SC01, KH01.

CREATE DATABASE IF NOT EXISTS QuanLyRapPhim
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
    TrangThai VARCHAR(30) NOT NULL DEFAULT 'Sß║»p chiß║┐u',
    CONSTRAINT pk_phim PRIMARY KEY (MaPhim),
    CONSTRAINT ck_phim_thoi_luong CHECK (ThoiLuong > 0),
    CONSTRAINT ck_phim_do_tuoi CHECK (GioiHanTuoi IN ('G', 'PG', '13+', '18+', 'P', 'K', 'T13', 'T16', 'T18')),
    CONSTRAINT ck_phim_trang_thai CHECK (TrangThai IN ('Sß║»p chiß║┐u', '─Éang chiß║┐u', 'Ng╞░ng chiß║┐u'))
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
    LoaiGhe VARCHAR(20) NOT NULL DEFAULT 'Th╞░ß╗¥ng',
    PhuThuGhe DECIMAL(12,2) NOT NULL DEFAULT 0,
    CONSTRAINT pk_ghe_ngoi PRIMARY KEY (MaPhong, SoGhe),
    CONSTRAINT ck_ghe_loai CHECK (LoaiGhe IN ('Th╞░ß╗¥ng', 'VIP', 'Sweetbox')),
    CONSTRAINT ck_ghe_phu_thu CHECK (PhuThuGhe >= 0),
    CONSTRAINT fk_ghe_phong FOREIGN KEY (MaPhong) REFERENCES PHONG_CHIEU (MaPhong)
        ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE SUAT_CHIEU (
    MaSuatChieu VARCHAR(20) NOT NULL,
    NgayChieu DATE NOT NULL,
    GioBatDau TIME NOT NULL,
    GioKetThuc TIME NOT NULL,
    TrangThai VARCHAR(30) NOT NULL DEFAULT 'Sß║»p chiß║┐u',
    MaPhim VARCHAR(20) NOT NULL,
    MaPhong VARCHAR(20) NOT NULL,
    CONSTRAINT pk_suat_chieu PRIMARY KEY (MaSuatChieu),
    -- Khoa tham chieu cho DAT_VE, dam bao ghe va suat chieu cung phong.
    CONSTRAINT uq_suat_phong UNIQUE (MaSuatChieu, MaPhong),
    CONSTRAINT ck_suat_trang_thai CHECK (TrangThai IN ('Sß║»p chiß║┐u', '─Éang chiß║┐u', '─É├ú kß║┐t th├║c')),
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
    CONSTRAINT ck_ban_hang_ca CHECK (CaLamViec IN ('S├íng', 'Chiß╗üu', 'Tß╗æi')),
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
    TrangThaiThanhToan VARCHAR(30) NOT NULL DEFAULT 'Chß╗¥ thanh to├ín',
    MaKH VARCHAR(20) NOT NULL,
    MaSuatChieu VARCHAR(20) NOT NULL,
    MaPhong VARCHAR(20) NOT NULL,
    SoGhe VARCHAR(10) NOT NULL,
    MaNV VARCHAR(20) DEFAULT NULL,
    CONSTRAINT pk_dat_ve PRIMARY KEY (MaVe),
    CONSTRAINT uq_dat_ve_ghe UNIQUE (MaSuatChieu, MaPhong, SoGhe),
    CONSTRAINT ck_dat_ve_gia CHECK (GiaVe >= 0),
    CONSTRAINT ck_dat_ve_thanh_toan CHECK (
        TrangThaiThanhToan IN ('Chß╗¥ thanh to├ín', '─É├ú thanh to├ín')
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
