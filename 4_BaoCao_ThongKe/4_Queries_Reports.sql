USE QuanLyRapPhim;
SET NAMES utf8mb4;

-- TOP 5 PHIM C├ô DOANH THU CAO NHß║ñT
SELECT 
    p.MaPhim,
    p.TenPhim, 
    COUNT(v.MaVe) AS TongSoVeBanRa, 
    SUM(v.GiaVe) AS TongDoanhThu
FROM PHIM p
JOIN SUAT_CHIEU sc ON p.MaPhim = sc.MaPhim
JOIN DAT_VE v ON sc.MaSuatChieu = v.MaSuatChieu
WHERE v.TrangThaiThanhToan = '─É├ú thanh to├ín'
GROUP BY p.MaPhim, p.TenPhim
ORDER BY TongDoanhThu DESC
LIMIT 5;

-- DOANH THU B├üN V├ë THEO Tß╗¬NG Cß╗ñM Rß║áP
SELECT 
    cr.TenRap, 
    COUNT(v.MaVe) AS TongSoVe, 
    SUM(v.GiaVe) AS DoanhThuBanVe
FROM CUM_RAP cr
JOIN PHONG_CHIEU pc ON cr.MaRap = pc.MaRap
JOIN SUAT_CHIEU sc ON pc.MaPhong = sc.MaPhong
JOIN DAT_VE v ON sc.MaSuatChieu = v.MaSuatChieu
WHERE v.TrangThaiThanhToan = '─É├ú thanh to├ín'
GROUP BY cr.MaRap, cr.TenRap
ORDER BY DoanhThuBanVe DESC;

-- TOP KH├üCH H├ÇNG CHI TI├èU MUA V├ë NHIß╗ÇU NHß║ñT (VIP)
SELECT 
    kh.MaKH, 
    kh.HoTen, 
    kh.SDT,
    kh.DiemTichLuy,
    COUNT(v.MaVe) AS SoLanMuaVe,
    SUM(v.GiaVe) AS TongTienDaChi
FROM KHACH_HANG kh
JOIN DAT_VE v ON kh.MaKH = v.MaKH
WHERE v.TrangThaiThanhToan = '─É├ú thanh to├ín'
GROUP BY kh.MaKH, kh.HoTen, kh.SDT, kh.DiemTichLuy
ORDER BY TongTienDaChi DESC
LIMIT 10;

-- Tß║áO VIEW: B├üO C├üO DOANH THU TO├ÇN DIß╗åN (V├ë + F&B) THEO TH├üNG/N─éM
CREATE OR REPLACE VIEW view_DoanhThuToanDien AS
SELECT 
    'B├ín V├⌐' AS NguonDoanhThu,
    MONTH(v.NgayGioDat) AS Thang,
    YEAR(v.NgayGioDat) AS Nam,
    COUNT(v.MaVe) AS SoLuongGiaoDich,
    SUM(v.GiaVe) AS TongTien
FROM DAT_VE v
WHERE v.TrangThaiThanhToan = '─É├ú thanh to├ín'
GROUP BY MONTH(v.NgayGioDat), YEAR(v.NgayGioDat)

UNION ALL

SELECT 
    'B├ín F&B' AS NguonDoanhThu,
    MONTH(f.NgayMua) AS Thang,
    YEAR(f.NgayMua) AS Nam,
    COUNT(f.MaCombo) AS SoLuongGiaoDich,
    SUM(f.ThanhTien) AS TongTien
FROM MUA_FNB f
GROUP BY MONTH(f.NgayMua), YEAR(f.NgayMua);

-- C├ích chß║íy ─æß╗â lß║Ñy kß║┐t quß║ú tß╗½ View n├áy:
 SELECT * FROM view_DoanhThuToanDien ORDER BY Nam DESC, Thang DESC;



-- ─É├üNH GI├ü HIß╗åU SUß║ñT NH├éN VI├èN B├üN H├ÇNG (D├╣ng LEFT JOIN v├á Subquery)
SELECT 
    nv.MaNV,
    nv.HoTen,
    cr.TenRap,
    bh.CaLamViec,
    bh.DoanhSoThang AS ChiTieuDuocGiao,
    COUNT(dv.MaVe) AS TongSoVeBanTaiQuay,
    COALESCE(SUM(dv.GiaVe), 0) AS DoanhThuVeThucTe,
    (
        SELECT COUNT(*) 
        FROM DAT_VE dv2 
        WHERE dv2.MaNV = nv.MaNV AND dv2.GiaVe >= 120000
    ) AS SoVeGiaCao
FROM NHAN_VIEN nv
JOIN NV_BAN_HANG bh ON nv.MaNV = bh.MaNV
JOIN CUM_RAP cr ON nv.MaRap = cr.MaRap
LEFT JOIN DAT_VE dv ON nv.MaNV = dv.MaNV AND dv.TrangThaiThanhToan = '─É├ú thanh to├ín'
GROUP BY nv.MaNV, nv.HoTen, cr.TenRap, bh.CaLamViec, bh.DoanhSoThang
ORDER BY DoanhThuVeThucTe DESC;
