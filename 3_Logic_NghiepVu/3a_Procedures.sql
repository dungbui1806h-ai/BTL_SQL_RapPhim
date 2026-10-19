USE QuanLyRapPhim;
SET NAMES utf8mb4;
DELIMITER //
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
DROP PROCEDURE IF EXISTS sp_DatVeXemPhim //
CREATE PROCEDURE sp_DatVeXemPhim(
    IN p_MaVe VARCHAR(20),
    IN p_MaKH VARCHAR(20),
    IN p_MaSuatChieu VARCHAR(20),
    IN p_SoGhe VARCHAR(10),
    IN p_TrangThaiThanhToan VARCHAR(30)
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
    INSERT INTO DAT_VE (MaVe, NgayGioDat, GiaVe, TrangThaiThanhToan, MaKH, MaSuatChieu, MaPhong, SoGhe)
    VALUES (p_MaVe, NOW(), v_GiaVeCuoi, IFNULL(p_TrangThaiThanhToan, 'Chờ thanh toán'), p_MaKH, p_MaSuatChieu, v_MaPhong, p_SoGhe);
    SELECT dv.MaVe, kh.HoTen AS TenKhachHang, p.TenPhim, cr.TenRap, pc.TenPhong, pc.LoaiPhong, dv.SoGhe, gn.LoaiGhe, dv.NgayGioDat, dv.GiaVe, dv.TrangThaiThanhToan
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
DELIMITER ;