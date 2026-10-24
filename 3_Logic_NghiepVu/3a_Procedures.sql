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
    DECLARE v_NgayMua DATETIME;
    IF p_SoLuong IS NULL OR p_SoLuong <= 0 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Số lượng phải lớn hơn 0!';
    END IF;
    IF NOT EXISTS (SELECT 1 FROM KHACH_HANG WHERE MaKH = p_MaKH) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Mã khách hàng không tồn tại!';
    END IF;
    SET v_NgayMua = NOW();
    INSERT INTO MUA_FNB (MaKH, MaCombo, NgayMua, SoLuong, ThanhTien)
    VALUES (p_MaKH, p_MaCombo, v_NgayMua, p_SoLuong, 0);
    SELECT kh.MaKH, kh.HoTen, fb.MaCombo, fb.TenCombo, m.SoLuong, fb.DonGia, m.ThanhTien, m.NgayMua
    FROM MUA_FNB m
    JOIN KHACH_HANG kh ON m.MaKH = kh.MaKH
    JOIN DICH_VU_FNB fb ON m.MaCombo = fb.MaCombo
    WHERE m.MaKH = p_MaKH AND m.MaCombo = p_MaCombo
    ORDER BY m.NgayMua DESC
    LIMIT 1;
END //
DELIMITER ;