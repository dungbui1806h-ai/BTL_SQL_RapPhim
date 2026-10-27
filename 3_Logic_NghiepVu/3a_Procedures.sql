USE QuanLyRapPhim;
SET NAMES utf8mb4;
DELIMITER //
-- 1. THß╗ª Tß╗ñC TH├èM KH├üCH H├ÇNG (sp_ThemKhachHang)
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
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lß╗ùi: M├ú kh├ích h├áng ─æ├ú tß╗ôn tß║íi tr├¬n hß╗ç thß╗æng!';
    END IF;
    IF EXISTS (SELECT 1 FROM KHACH_HANG WHERE SDT = p_SDT) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lß╗ùi: Sß╗æ ─æiß╗çn thoß║íi n├áy ─æ├ú ─æ╞░ß╗úc ─æ─âng k├╜ cho t├ái khoß║ún kh├íc!';
    END IF;
    IF p_NgaySinh IS NOT NULL AND p_NgaySinh >= CURDATE() THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lß╗ùi: Ng├áy sinh cß╗ºa kh├ích h├áng phß║úi nhß╗Å h╞ín ng├áy hiß╗çn tß║íi!';
    END IF;
    INSERT INTO KHACH_HANG (MaKH, HoTen, SDT, Email, NgaySinh, DiemTichLuy)
    VALUES (p_MaKH, p_HoTen, p_SDT, p_Email, p_NgaySinh, 0);
    SELECT * FROM KHACH_HANG WHERE MaKH = p_MaKH;
END //
-- 2. THß╗ª Tß╗ñC ─Éß║╢T V├ë XEM PHIM T├ìNH TIß╗ÇN Tß╗░ ─Éß╗ÿNG (sp_DatVeXemPhim)
--    Chß╗æng tr├╣ng ghß║┐ + ─æß╗Ö tuß╗òi: trigger trg_KiemTraDatVe_BeforeInsert. T├¡ch ─æiß╗âm: trigger t├¡ch ─æiß╗âm v├⌐.
--    p_MaNV: nh├ón vi├¬n xuß║Ñt v├⌐ tß║íi quß║ºy (NULL = ─æß║╖t online).
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
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lß╗ùi: M├ú suß║Ñt chiß║┐u kh├┤ng tß╗ôn tß║íi!';
    END IF;
    IF v_TrangThaiSuat <> 'Sß║»p chiß║┐u' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lß╗ùi: Suß║Ñt chiß║┐u ─æang chiß║┐u hoß║╖c ─æ├ú kß║┐t th├║c, kh├┤ng thß╗â ─æß║╖t v├⌐!';
    END IF;
    IF NOT EXISTS (SELECT 1 FROM KHACH_HANG WHERE MaKH = p_MaKH) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lß╗ùi: M├ú kh├ích h├áng kh├┤ng tß╗ôn tß║íi!';
    END IF;
    IF p_MaNV IS NOT NULL AND NOT EXISTS (SELECT 1 FROM NHAN_VIEN WHERE MaNV = p_MaNV) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lß╗ùi: M├ú nh├ón vi├¬n xuß║Ñt v├⌐ kh├┤ng tß╗ôn tß║íi!';
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
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lß╗ùi: Sß╗æ ghß║┐ kh├┤ng tß╗ôn tß║íi trong ph├▓ng cß╗ºa suß║Ñt chiß║┐u n├áy!';
    END IF;
    SET v_GiaVeCuoi = v_GiaCoBan + v_PhuThuGhe;
    INSERT INTO DAT_VE (MaVe, NgayGioDat, GiaVe, TrangThaiThanhToan, MaKH, MaSuatChieu, MaPhong, SoGhe, MaNV)
    VALUES (p_MaVe, NOW(), v_GiaVeCuoi, IFNULL(p_TrangThaiThanhToan, 'Chß╗¥ thanh to├ín'), p_MaKH, p_MaSuatChieu, v_MaPhong, p_SoGhe, p_MaNV);
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
-- 3. THß╗ª Tß╗ñC T├îM KIß║╛M Lß╗èCH CHIß║╛U THEO Bß╗ÿ Lß╗îC (sp_TimKiemLichChieu)
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
-- 4. THß╗ª Tß╗ñC KIß╗éM TRA DANH S├üCH GHß║╛ TRß╗ÉNG Cß╗ªA SUß║ñT CHIß║╛U (sp_LayDanhSachGheTrong)
DROP PROCEDURE IF EXISTS sp_LayDanhSachGheTrong //
CREATE PROCEDURE sp_LayDanhSachGheTrong(
    IN p_MaSuatChieu VARCHAR(20)
)
BEGIN
    SELECT gn.MaPhong, gn.SoGhe, gn.LoaiGhe, gn.PhuThuGhe, 'C├▓n trß╗æng' AS TrangThaiGhe
    FROM SUAT_CHIEU sc
    JOIN GHE_NGOI gn ON sc.MaPhong = gn.MaPhong
    LEFT JOIN DAT_VE dv ON sc.MaSuatChieu = dv.MaSuatChieu AND gn.MaPhong = dv.MaPhong AND gn.SoGhe = dv.SoGhe
    WHERE sc.MaSuatChieu = p_MaSuatChieu AND dv.MaVe IS NULL
    ORDER BY gn.SoGhe ASC;
END //
-- 5. THß╗ª Tß╗ñC X├üC NHß║¼N THANH TO├üN H├ôA ─É╞áN V├ë (sp_ThanhToanVe)
DROP PROCEDURE IF EXISTS sp_ThanhToanVe //
CREATE PROCEDURE sp_ThanhToanVe(
    IN p_MaVe VARCHAR(20)
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM DAT_VE WHERE MaVe = p_MaVe) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lß╗ùi: Kh├┤ng t├¼m thß║Ñy m├ú v├⌐ cß║ºn thanh to├ín!';
    END IF;
    IF EXISTS (SELECT 1 FROM DAT_VE WHERE MaVe = p_MaVe AND TrangThaiThanhToan = '─É├ú thanh to├ín') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Th├┤ng b├ío: V├⌐ n├áy ─æ├ú ─æ╞░ß╗úc thanh to├ín tr╞░ß╗¢c ─æ├│!';
    END IF;
    UPDATE DAT_VE SET TrangThaiThanhToan = '─É├ú thanh to├ín' WHERE MaVe = p_MaVe;
END //
-- 6. THß╗ª Tß╗ñC TH├èM NH├éN VI├èN ─Éß║óM Bß║óO R├ÇNG BUß╗ÿC TO├ÇN PHß║ªN & Rß╗£I Rß║áC (sp_ThemNhanVien)
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
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lß╗ùi ISA: Nh├ón vi├¬n bß║»t buß╗Öc phß║úi thuß╗Öc ─æ├║ng 1 trong 3 bß╗Ö phß║¡n (QUAN_LY, BAN_HANG, KY_THUAT)!';
    END IF;
    START TRANSACTION;
    INSERT INTO NHAN_VIEN (MaNV, HoTen, NgaySinh, CCCD, SDT, LuongCoBan, NgayVaoLam, MaRap)
    VALUES (p_MaNV, p_HoTen, p_NgaySinh, p_CCCD, p_SDT, p_LuongCoBan, p_NgayVaoLam, p_MaRap);
    IF p_LoaiNV = 'QUAN_LY' THEN
        INSERT INTO NV_QUAN_LY (MaNV, HeSoTrachNhiem, QuyenHan)
        VALUES (p_MaNV, IFNULL(p_HeSoTrachNhiem, 1.0), p_QuyenHan);
    ELSEIF p_LoaiNV = 'BAN_HANG' THEN
        INSERT INTO NV_BAN_HANG (MaNV, CaLamViec, DoanhSoThang)
        VALUES (p_MaNV, IFNULL(p_CaLamViec, 'S├íng'), 0);
    ELSEIF p_LoaiNV = 'KY_THUAT' THEN
        INSERT INTO NV_KY_THUAT (MaNV, ChungChiKyThuat, KhuVucPhuTrach)
        VALUES (p_MaNV, p_ChungChiKyThuat, p_KhuVucPhuTrach);
    END IF;
    COMMIT;
END //
-- 7. THß╗ª Tß╗ñC TH├èM PHIM Mß╗ÜI (sp_ThemPhim)
--    [Sß╗¼A] p_GioiHanTuoi NULL tr╞░ß╗¢c ─æ├óy lß╗ìt qua kiß╗âm tra (NULL NOT IN (...) = NULL)
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
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lß╗ùi: M├ú phim n├áy ─æ├ú tß╗ôn tß║íi tr├¬n hß╗ç thß╗æng!';
    END IF;
    IF p_ThoiLuong IS NULL OR p_ThoiLuong <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lß╗ùi: Thß╗¥i l╞░ß╗úng phim phß║úi lß╗¢n h╞ín 0 ph├║t!';
    END IF;
    IF p_GioiHanTuoi IS NULL OR p_GioiHanTuoi NOT IN ('G', 'PG', '13+', '18+', 'P', 'K', 'T13', 'T16', 'T18') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lß╗ùi: Giß╗¢i hß║ín ─æß╗Ö tuß╗òi kh├┤ng hß╗úp lß╗ç!';
    END IF;
    INSERT INTO PHIM (MaPhim, TenPhim, DaoDien, ThoiLuong, NgayKhoiChieu, GioiHanTuoi)
    VALUES (p_MaPhim, p_TenPhim, p_DaoDien, p_ThoiLuong, p_NgayKhoiChieu, p_GioiHanTuoi);
    SELECT * FROM PHIM WHERE MaPhim = p_MaPhim;
END //
-- 8. Cß║¼P NHß║¼T TH├öNG TIN PHIM (sp_CapNhatPhim)
--    Tham sß╗æ n├áo truyß╗ün NULL th├¼ giß╗» nguy├¬n gi├í trß╗ï c┼⌐.
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
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lß╗ùi: M├ú phim kh├┤ng tß╗ôn tß║íi!';
    END IF;
    IF p_ThoiLuong IS NOT NULL AND p_ThoiLuong <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lß╗ùi: Thß╗¥i l╞░ß╗úng phim phß║úi lß╗¢n h╞ín 0 ph├║t!';
    END IF;
    IF p_GioiHanTuoi IS NOT NULL AND p_GioiHanTuoi NOT IN ('G', 'PG', '13+', '18+', 'P', 'K', 'T13', 'T16', 'T18') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lß╗ùi: Giß╗¢i hß║ín ─æß╗Ö tuß╗òi kh├┤ng hß╗úp lß╗ç!';
    END IF;
    IF p_TrangThai IS NOT NULL AND p_TrangThai NOT IN ('Sß║»p chiß║┐u', '─Éang chiß║┐u', 'Ng╞░ng chiß║┐u') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lß╗ùi: Trß║íng th├íi phim kh├┤ng hß╗úp lß╗ç (Sß║»p chiß║┐u, ─Éang chiß║┐u, Ng╞░ng chiß║┐u)!';
    END IF;
    -- ─Éß╗òi thß╗¥i l╞░ß╗úng sß║╜ l├ám sai giß╗¥ kß║┐t th├║c + 15 ph├║t dß╗ìn dß║╣p cß╗ºa c├íc suß║Ñt chiß║┐u ─æ├ú xß║┐p
    IF p_ThoiLuong IS NOT NULL
       AND p_ThoiLuong <> (SELECT ThoiLuong FROM PHIM WHERE MaPhim = p_MaPhim)
       AND EXISTS (SELECT 1 FROM SUAT_CHIEU WHERE MaPhim = p_MaPhim AND TrangThai = 'Sß║»p chiß║┐u') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lß╗ùi: Phim c├▓n suß║Ñt chiß║┐u sß║»p chiß║┐u, kh├┤ng thß╗â ─æß╗òi thß╗¥i l╞░ß╗úng!';
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
-- 9. Gß╗á Bß╗Ä PHIM (sp_GoBoPhim) - R├áng buß╗Öc to├án vß║╣n tham chiß║┐u (mß╗Ñc 4.4)
--    Phim ─æ├ú c├│ suß║Ñt chiß║┐u (─æß╗ông ngh─⌐a c├│ thß╗â ─æ├ú c├│ v├⌐) => chß╗ë chuyß╗ân 'Ng╞░ng chiß║┐u'.
--    Phim ch╞░a c├│ suß║Ñt chiß║┐u n├áo => x├│a hß║│n (c├íc bß║úng con nh╞░ thß╗â loß║íi/diß╗àn vi├¬n cß║ºn ON DELETE CASCADE).
DROP PROCEDURE IF EXISTS sp_GoBoPhim //
CREATE PROCEDURE sp_GoBoPhim(
    IN p_MaPhim VARCHAR(20)
)
BEGIN
    IF NOT EXISTS (SELECT 1 FROM PHIM WHERE MaPhim = p_MaPhim) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lß╗ùi: M├ú phim kh├┤ng tß╗ôn tß║íi!';
    END IF;
    IF EXISTS (SELECT 1 FROM SUAT_CHIEU WHERE MaPhim = p_MaPhim) THEN
        UPDATE PHIM SET TrangThai = 'Ng╞░ng chiß║┐u' WHERE MaPhim = p_MaPhim;
        SELECT p_MaPhim AS MaPhim, 'Ng╞░ng chiß║┐u' AS KetQua,
               'Phim ─æ├ú c├│ suß║Ñt chiß║┐u/v├⌐ n├¬n kh├┤ng x├│a, chß╗ë chuyß╗ân sang trß║íng th├íi Ng╞░ng chiß║┐u ─æß╗â bß║úo to├án b├ío c├ío doanh thu.' AS GhiChu;
    ELSE
        DELETE FROM PHIM WHERE MaPhim = p_MaPhim;
        SELECT p_MaPhim AS MaPhim, '─É├ú x├│a' AS KetQua, 'Phim ch╞░a c├│ suß║Ñt chiß║┐u n├¬n ─æ├ú ─æ╞░ß╗úc x├│a khß╗Åi hß╗ç thß╗æng.' AS GhiChu;
    END IF;
END //
-- 10. Tß║áO SUß║ñT CHIß║╛U (sp_TaoSuatChieu)
--     Giß╗¥ kß║┐t th├║c = giß╗¥ bß║»t ─æß║ºu + thß╗¥i l╞░ß╗úng phim.
--     Chß╗ông lß╗ïch + 15 ph├║t dß╗ìn dß║╣p: trigger trg_KiemTraLichChieu_BeforeInsert.
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
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lß╗ùi: M├ú ph├▓ng chiß║┐u kh├┤ng tß╗ôn tß║íi!';
    END IF;
    IF EXISTS (SELECT 1 FROM SUAT_CHIEU WHERE MaSuatChieu = p_MaSuatChieu) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lß╗ùi: M├ú suß║Ñt chiß║┐u ─æ├ú tß╗ôn tß║íi!';
    END IF;
    SELECT ThoiLuong, TrangThai INTO v_ThoiLuong, v_TrangThaiPhim FROM PHIM WHERE MaPhim = p_MaPhim;
    IF v_ThoiLuong IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lß╗ùi: M├ú phim kh├┤ng tß╗ôn tß║íi!';
    END IF;
    IF v_TrangThaiPhim = 'Ng╞░ng chiß║┐u' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lß╗ùi: Phim ─æ├ú ng╞░ng chiß║┐u, kh├┤ng thß╗â xß║┐p suß║Ñt chiß║┐u mß╗¢i!';
    END IF;
    SET v_BatDau = TIMESTAMP(p_NgayChieu, p_GioBatDau);
    IF v_BatDau <= NOW() THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lß╗ùi: Thß╗¥i gian bß║»t ─æß║ºu suß║Ñt chiß║┐u phß║úi lß╗¢n h╞ín thß╗¥i ─æiß╗âm hiß╗çn tß║íi!';
    END IF;
    SET v_KetThuc = v_BatDau + INTERVAL v_ThoiLuong MINUTE;
    IF DATE(v_KetThuc) <> p_NgayChieu THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lß╗ùi: Suß║Ñt chiß║┐u kh├┤ng ─æ╞░ß╗úc k├⌐o d├ái qua 24h cß╗ºa ng├áy chiß║┐u!';
    END IF;
    INSERT INTO SUAT_CHIEU (MaSuatChieu, MaPhim, MaPhong, NgayChieu, GioBatDau, GioKetThuc, TrangThai)
    VALUES (p_MaSuatChieu, p_MaPhim, p_MaPhong, p_NgayChieu, TIME(v_BatDau), TIME(v_KetThuc), 'Sß║»p chiß║┐u');
    SELECT * FROM SUAT_CHIEU WHERE MaSuatChieu = p_MaSuatChieu;
END //
-- 11. TRA Cß╗¿U V├ë THEO M├â V├ë HOß║╢C Sß╗É ─ÉIß╗åN THOß║áI (sp_TraCuuVe)
--     D├╣ng ─æß╗â so├ít v├⌐ / xß╗¡ l├╜ sß╗▒ cß╗æ. Truyß╗ün NULL cho ti├¬u ch├¡ kh├┤ng d├╣ng (cß║ºn ├¡t nhß║Ñt 1).
DROP PROCEDURE IF EXISTS sp_TraCuuVe //
CREATE PROCEDURE sp_TraCuuVe(
    IN p_MaVe VARCHAR(20),
    IN p_SDT VARCHAR(20)
)
BEGIN
    IF p_MaVe IS NULL AND p_SDT IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lß╗ùi: Cß║ºn nhß║¡p M├ú v├⌐ hoß║╖c Sß╗æ ─æiß╗çn thoß║íi ─æß╗â tra cß╗⌐u!';
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
-- 12. MUA Dß╗èCH Vß╗ñ F&B (sp_MuaFB)
--     Kiß╗âm tra combo + t├¡nh ThanhTien: trg_TinhTienMuaFNB_BeforeInsert (ThanhTien truyß╗ün 0 sß║╜ bß╗ï trigger ghi ─æ├¿).
--     Cß╗Öng ─æiß╗âm t├¡ch l┼⌐y: trg_TichDiemMuaFNB_AfterInsert.
DROP PROCEDURE IF EXISTS sp_MuaFB //
CREATE PROCEDURE sp_MuaFB(
    IN p_MaKH VARCHAR(20),
    IN p_MaCombo VARCHAR(20),
    IN p_SoLuong INT
)
BEGIN
    DECLARE v_NgayMua DATETIME(6);
    IF p_SoLuong IS NULL OR p_SoLuong <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lß╗ùi: Sß╗æ l╞░ß╗úng phß║úi lß╗¢n h╞ín 0!';
    END IF;
    IF NOT EXISTS (SELECT 1 FROM KHACH_HANG WHERE MaKH = p_MaKH) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lß╗ùi: M├ú kh├ích h├áng kh├┤ng tß╗ôn tß║íi!';
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
