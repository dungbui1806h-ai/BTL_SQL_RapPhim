USE QuanLyRapPhim;
SET NAMES utf8mb4;
DELIMITER //
-- 1. TRIGGER CHß╗ÉNG ─Éß║╢T TR├ÖNG GHß║╛ & KIß╗éM TRA ─Éß╗ÿ TUß╗öI (trg_KiemTraDatVe_BeforeInsert)
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
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lß╗ùi Double-booking: Ghß║┐ ngß╗ôi n├áy ─æ├ú c├│ ng╞░ß╗¥i ─æß║╖t trong suß║Ñt chiß║┐u ─æ├ú chß╗ìn!';
    END IF;
    SELECT sc.NgayChieu, p.GioiHanTuoi INTO v_NgayChieu, v_GioiHanTuoi
    FROM SUAT_CHIEU sc JOIN PHIM p ON sc.MaPhim = p.MaPhim
    WHERE sc.MaSuatChieu = NEW.MaSuatChieu;
    SELECT NgaySinh INTO v_NgaySinhKH FROM KHACH_HANG WHERE MaKH = NEW.MaKH;
    IF v_GioiHanTuoi IN ('13+', '18+') AND v_NgaySinhKH IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lß╗ùi ─Éß╗Ö tuß╗òi: Phim c├│ giß╗¢i hß║ín ─æß╗Ö tuß╗òi, kh├ích h├áng bß║»t buß╗Öc phß║úi cß║¡p nhß║¡t Ng├áy sinh!';
    END IF;
    IF v_NgaySinhKH IS NOT NULL THEN
        SET v_TuoiKhachHang = TIMESTAMPDIFF(YEAR, v_NgaySinhKH, v_NgayChieu);
        IF (v_GioiHanTuoi = '13+' AND v_TuoiKhachHang < 13) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lß╗ùi ─Éß╗Ö tuß╗òi: Kh├ích h├áng ch╞░a ─æß╗º 13 tuß╗òi t├¡nh ─æß║┐n ng├áy chiß║┐u ─æß╗â xem phim 13+!';
        END IF;
        IF (v_GioiHanTuoi = '18+' AND v_TuoiKhachHang < 18) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lß╗ùi ─Éß╗Ö tuß╗òi: Kh├ích h├áng ch╞░a ─æß╗º 18 tuß╗òi t├¡nh ─æß║┐n ng├áy chiß║┐u ─æß╗â xem phim 18+!';
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
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lß╗ùi Double-booking: Ghß║┐ ngß╗ôi n├áy ─æ├ú c├│ ng╞░ß╗¥i ─æß║╖t trong suß║Ñt chiß║┐u ─æ├ú chß╗ìn!';
        END IF;
    END IF;
END //
-- 2. TRIGGER T├ìCH ─ÉIß╗éM Tß╗░ ─Éß╗ÿNG KHI Tß║áO V├ë ─É├â THANH TO├üN NGAY (trg_TichDiemVe_AfterInsert)
DROP TRIGGER IF EXISTS trg_TichDiemVe_AfterInsert //
CREATE TRIGGER trg_TichDiemVe_AfterInsert
AFTER INSERT ON DAT_VE
FOR EACH ROW
BEGIN
    DECLARE v_DiemCong INT DEFAULT 0;
    IF NEW.TrangThaiThanhToan = '─É├ú thanh to├ín' THEN
        SET v_DiemCong = FLOOR(NEW.GiaVe / 10000);
        UPDATE KHACH_HANG SET DiemTichLuy = DiemTichLuy + v_DiemCong WHERE MaKH = NEW.MaKH;
    END IF;
END //
-- 3. TRIGGER T├ìCH ─ÉIß╗éM Tß╗░ ─Éß╗ÿNG KHI Cß║¼P NHß║¼T THANH TO├üN H├ôA ─É╞áN V├ë (trg_TichDiemVe_AfterUpdate)
DROP TRIGGER IF EXISTS trg_TichDiemVe_AfterUpdate //
CREATE TRIGGER trg_TichDiemVe_AfterUpdate
AFTER UPDATE ON DAT_VE
FOR EACH ROW
BEGIN
    DECLARE v_DiemCong INT DEFAULT 0;
    IF OLD.TrangThaiThanhToan <> '─É├ú thanh to├ín' AND NEW.TrangThaiThanhToan = '─É├ú thanh to├ín' THEN
        SET v_DiemCong = FLOOR(NEW.GiaVe / 10000);
        UPDATE KHACH_HANG SET DiemTichLuy = DiemTichLuy + v_DiemCong WHERE MaKH = NEW.MaKH;
    END IF;
END //
-- 4. TRIGGER Tß╗░ ─Éß╗ÿNG T├ìNH TIß╗ÇN & Cß╗ÿNG ─ÉIß╗éM KHI MUA F&B
DROP TRIGGER IF EXISTS trg_TinhTienMuaFNB_BeforeInsert //
CREATE TRIGGER trg_TinhTienMuaFNB_BeforeInsert
BEFORE INSERT ON MUA_FNB
FOR EACH ROW
BEGIN
    DECLARE v_DonGia DECIMAL(12,2);
    SELECT DonGia INTO v_DonGia FROM DICH_VU_FNB WHERE MaCombo = NEW.MaCombo;
    IF v_DonGia IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lß╗ùi: M├ú Combo F&B kh├┤ng tß╗ôn tß║íi!';
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
-- 5. TRIGGER CHß╗ÉNG CHß╗ÆNG CH├ëO THß╗£I GIAN Xß║╛P Lß╗èCH CHIß║╛U (trg_KiemTraLichChieu_BeforeInsert)
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
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lß╗ùi Xß║┐p lß╗ïch: Ph├▓ng chiß║┐u bß╗ï tr├╣ng giß╗¥ hoß║╖c ch╞░a ─æß║úm bß║úo 15 ph├║t dß╗ìn dß║╣p giß╗»a 2 suß║Ñt chiß║┐u!';
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
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lß╗ùi Xß║┐p lß╗ïch: Ph├▓ng chiß║┐u bß╗ï tr├╣ng giß╗¥ hoß║╖c ch╞░a ─æß║úm bß║úo 15 ph├║t dß╗ìn dß║╣p giß╗»a 2 suß║Ñt chiß║┐u!';
    END IF;
END //
-- 6. Bß╗ÿ 3 TRIGGER KIß╗éM TRA T├ìNH Rß╗£I Rß║áC (DISJOINT) Cß╗ªA NH├éN VI├èN (ISA HIERARCHY)
DROP TRIGGER IF EXISTS trg_Disjoint_NVQuanLy_BeforeInsert //
CREATE TRIGGER trg_Disjoint_NVQuanLy_BeforeInsert
BEFORE INSERT ON NV_QUAN_LY
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM NV_BAN_HANG WHERE MaNV = NEW.MaNV)
       OR EXISTS (SELECT 1 FROM NV_KY_THUAT WHERE MaNV = NEW.MaNV) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lß╗ùi R├áng buß╗Öc Rß╗¥i rß║íc (ISA): Nh├ón vi├¬n n├áy ─æ├ú thuß╗Öc bß╗Ö phß║¡n B├ín h├áng hoß║╖c Kß╗╣ thuß║¡t!';
    END IF;
END //
DROP TRIGGER IF EXISTS trg_Disjoint_NVBanHang_BeforeInsert //
CREATE TRIGGER trg_Disjoint_NVBanHang_BeforeInsert
BEFORE INSERT ON NV_BAN_HANG
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM NV_QUAN_LY WHERE MaNV = NEW.MaNV)
       OR EXISTS (SELECT 1 FROM NV_KY_THUAT WHERE MaNV = NEW.MaNV) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lß╗ùi R├áng buß╗Öc Rß╗¥i rß║íc (ISA): Nh├ón vi├¬n n├áy ─æ├ú thuß╗Öc bß╗Ö phß║¡n Quß║ún l├╜ hoß║╖c Kß╗╣ thuß║¡t!';
    END IF;
END //
DROP TRIGGER IF EXISTS trg_Disjoint_NVKyThuat_BeforeInsert //
CREATE TRIGGER trg_Disjoint_NVKyThuat_BeforeInsert
BEFORE INSERT ON NV_KY_THUAT
FOR EACH ROW
BEGIN
    IF EXISTS (SELECT 1 FROM NV_QUAN_LY WHERE MaNV = NEW.MaNV)
       OR EXISTS (SELECT 1 FROM NV_BAN_HANG WHERE MaNV = NEW.MaNV) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lß╗ùi R├áng buß╗Öc Rß╗¥i rß║íc (ISA): Nh├ón vi├¬n n├áy ─æ├ú thuß╗Öc bß╗Ö phß║¡n Quß║ún l├╜ hoß║╖c B├ín h├áng!';
    END IF;
END //
DELIMITER ;
