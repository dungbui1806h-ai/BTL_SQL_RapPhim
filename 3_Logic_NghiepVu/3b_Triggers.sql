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