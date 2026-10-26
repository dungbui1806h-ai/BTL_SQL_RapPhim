use QuanLyRapPhim;
-- TOP 5 PHIM CÓ DOANH THU CAO NHẤT
SELECT
    p.MaPhim,
    p.TenPhim,
    COUNT(v.MaVe) AS TongSoVeBanRa,
    SUM(v.GiaVe) AS TongDoanhThu
FROM
    PHIM p
    JOIN SUAT_CHIEU sc ON p.MaPhim = sc.MaPhim
    JOIN DAT_VE v ON sc.MaSuatChieu = v.MaSuatChieu
WHERE
    v.TrangThaiThanhToan = 'Đã thanh toán'
GROUP BY
    p.MaPhim,
    p.TenPhim
ORDER BY TongDoanhThu DESC
LIMIT 5;

-- DOANH THU BÁN VÉ THEO TỪNG CỤM RẠP
SELECT cr.TenRap, COUNT(v.MaVe) AS TongSoVe, SUM(v.GiaVe) AS DoanhThuBanVe
FROM
    CUM_RAP cr
    JOIN PHONG_CHIEU pc ON cr.MaRap = pc.MaRap
    JOIN SUAT_CHIEU sc ON pc.MaPhong = sc.MaPhong
    JOIN DAT_VE v ON sc.MaSuatChieu = v.MaSuatChieu
WHERE
    v.TrangThaiThanhToan = 'Đã thanh toán'
GROUP BY
    cr.MaRap,
    cr.TenRap
ORDER BY DoanhThuBanVe DESC;

-- TOP KHÁCH HÀNG CHI TIÊU MUA VÉ NHIỀU NHẤT (VIP)
SELECT
    kh.MaKH,
    kh.HoTen,
    kh.SDT,
    kh.DiemTichLuy,
    COUNT(v.MaVe) AS SoLanMuaVe,
    SUM(v.GiaVe) AS TongTienDaChi
FROM KHACH_HANG kh
    JOIN DAT_VE v ON kh.MaKH = v.MaKH
WHERE
    v.TrangThaiThanhToan = 'Đã thanh toán'
GROUP BY
    kh.MaKH,
    kh.HoTen,
    kh.SDT,
    kh.DiemTichLuy
ORDER BY TongTienDaChi DESC
LIMIT 10;

-- TẠO VIEW: BÁO CÁO DOANH THU TOÀN DIỆN (VÉ + F&B) THEO THÁNG/NĂM
CREATE OR REPLACE VIEW view_DoanhThuToanDien AS
SELECT
    'Bán Vé' AS NguonDoanhThu,
    MONTH(v.NgayGioDat) AS Thang,
    YEAR(v.NgayGioDat) AS Nam,
    COUNT(v.MaVe) AS SoLuongGiaoDich,
    SUM(v.GiaVe) AS TongTien
FROM DAT_VE v
WHERE
    v.TrangThaiThanhToan = 'Đã thanh toán'
GROUP BY
    MONTH(v.NgayGioDat),
    YEAR(v.NgayGioDat)
UNION ALL
SELECT
    'Bán F&B' AS NguonDoanhThu,
    MONTH(f.NgayMua) AS Thang,
    YEAR(f.NgayMua) AS Nam,
    COUNT(f.MaCombo) AS SoLuongGiaoDich,
    SUM(f.ThanhTien) AS TongTien
FROM MUA_FNB f
GROUP BY
    MONTH(f.NgayMua),
    YEAR(f.NgayMua);

-- Cách chạy để lấy kết quả từ View này:
SELECT * FROM view_DoanhThuToanDien ORDER BY Nam DESC, Thang DESC;

DELIMITER /
/

-- ĐÁNH GIÁ HIỆU SUẤT NHÂN VIÊN BÁN HÀNG (Dùng LEFT JOIN và Subquery)
SELECT
    nv.MaNV,
    nv.HoTen,
    cr.TenRap,
    bh.CaLamViec,
    bh.DoanhSoThang AS ChiTieuĐuocGiao,
    (
        SELECT COUNT(*)
        FROM MUA_FNB
        WHERE
            ThanhTien > 100000
    ) AS SoDonHangLon
FROM
    NHAN_VIEN nv
    JOIN NV_BAN_HANG bh ON nv.MaNV = bh.MaNV
    JOIN CUM_RAP cr ON nv.MaRap = cr.MaRap
ORDER BY bh.DoanhSoThang DESC;