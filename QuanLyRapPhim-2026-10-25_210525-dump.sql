-- MySQL dump 10.13  Distrib 8.0.46, for Win64 (x86_64)
--
-- Host: mysql-36a971c6-dungbui1806h-0e62.e.aivencloud.com    Database: QuanLyRapPhim
-- ------------------------------------------------------
-- Server version	8.4.11

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
SET @MYSQLDUMP_TEMP_LOG_BIN = @@SESSION.SQL_LOG_BIN;
SET @@SESSION.SQL_LOG_BIN= 0;

--
-- GTID state at the beginning of the backup 
--

SET @@GLOBAL.GTID_PURGED=/*!80000 '+'*/ '1856ad38-cba5-11f1-8fb5-a2d3ea09ee05:1-46,
688a4538-cd59-11f1-85f7-3e479b670661:1-94,
6dedc4cd-d044-11f1-bada-e6fc5d404e4c:1-108,
ddbf7934-c584-11f1-a33e-5a7507610408:1-43';

--
-- Table structure for table `CUM_RAP`
--

DROP TABLE IF EXISTS `CUM_RAP`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `CUM_RAP` (
  `MaRap` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `TenRap` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `SoNha` varchar(30) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `Duong` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `QuanHuyen` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `TinhTP` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Hotline` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`MaRap`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `CUM_RAP`
--

LOCK TABLES `CUM_RAP` WRITE;
/*!40000 ALTER TABLE `CUM_RAP` DISABLE KEYS */;
INSERT INTO `CUM_RAP` VALUES ('RAP01','CGV Landmark 81','720A','Điện Biên Phủ','Bình Thạnh','TP. Hồ Chí Minh','02839991001'),('RAP02','Lotte Cinema Cantavil','01','Song Hành','TP. Thủ Đức','TP. Hồ Chí Minh','02837402002'),('RAP03','Galaxy Nguyễn Du','116','Nguyễn Du','Quận 1','TP. Hồ Chí Minh','02838235003'),('RAP04','CGV Vincom Bà Triệu','191','Bà Triệu','Hai Bà Trưng','Hà Nội','02439741004'),('RAP05','Trung tâm Chiếu phim Quốc gia','87','Láng Hạ','Ba Đình','Hà Nội','02435141005'),('RAP06','BHD Star Thảo Điền','159','Xa Lộ Hà Nội','TP. Thủ Đức','TP. Hồ Chí Minh','02837446006'),('RAP07','Starlight Đà Nẵng','46','Nguyễn Văn Linh','Hải Châu','Đà Nẵng','02363588007'),('RAP08','Lotte Cinema Nha Trang','58','23 Tháng 10','Nha Trang','Khánh Hòa','02583812008'),('RAP09','CGV Vincom Cần Thơ','209','30 Tháng 4','Ninh Kiều','Cần Thơ','02923739009'),('RAP10','Beta Cinema Quang Trung','645','Quang Trung','Gò Vấp','TP. Hồ Chí Minh','02835894010');
/*!40000 ALTER TABLE `CUM_RAP` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `DAT_VE`
--

DROP TABLE IF EXISTS `DAT_VE`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `DAT_VE` (
  `MaVe` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `NgayGioDat` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `GiaVe` decimal(12,2) NOT NULL,
  `TrangThaiThanhToan` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Chờ thanh toán',
  `MaKH` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `MaSuatChieu` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `MaPhong` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `SoGhe` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `MaNV` varchar(20) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`MaVe`),
  UNIQUE KEY `uq_dat_ve_ghe` (`MaSuatChieu`,`MaPhong`,`SoGhe`),
  KEY `fk_dat_ve_khach` (`MaKH`),
  KEY `fk_dat_ve_ghe` (`MaPhong`,`SoGhe`),
  KEY `fk_datve_nv` (`MaNV`),
  CONSTRAINT `fk_dat_ve_ghe` FOREIGN KEY (`MaPhong`, `SoGhe`) REFERENCES `GHE_NGOI` (`MaPhong`, `SoGhe`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_dat_ve_khach` FOREIGN KEY (`MaKH`) REFERENCES `KHACH_HANG` (`MaKH`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_dat_ve_suat_phong` FOREIGN KEY (`MaSuatChieu`, `MaPhong`) REFERENCES `SUAT_CHIEU` (`MaSuatChieu`, `MaPhong`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_datve_nv` FOREIGN KEY (`MaNV`) REFERENCES `NHAN_VIEN` (`MaNV`),
  CONSTRAINT `ck_dat_ve_gia` CHECK ((`GiaVe` >= 0)),
  CONSTRAINT `ck_dat_ve_thanh_toan` CHECK ((`TrangThaiThanhToan` in (_utf8mb4'Chờ thanh toán',_utf8mb4'Đã thanh toán')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DAT_VE`
--

LOCK TABLES `DAT_VE` WRITE;
/*!40000 ALTER TABLE `DAT_VE` DISABLE KEYS */;
INSERT INTO `DAT_VE` VALUES ('VE_TEST_TUOI','2026-10-21 16:00:05',120000.00,'Chờ thanh toán','KH_TREEM','SC01','PH01','A3',NULL),('VE_TEST_TUOI2','2026-10-21 16:00:59',120000.00,'Chờ thanh toán','KH_TREEM','SC01','PH01','A4',NULL),('VE_TEST_TUOI3','2026-10-21 16:01:54',120000.00,'Chờ thanh toán','KH_TREEM','SC01','PH01','B3',NULL),('VE01','2024-05-14 10:15:00',120000.00,'Đã thanh toán','KH01','SC01','PH01','A1',NULL),('VE02','2024-05-14 10:16:00',120000.00,'Đã thanh toán','KH01','SC01','PH01','A2',NULL),('VE03','2024-05-14 14:20:00',135000.00,'Đã thanh toán','KH02','SC01','PH01','B1',NULL),('VE04','2024-05-14 14:21:00',135000.00,'Đã thanh toán','KH02','SC01','PH01','B2',NULL),('VE05','2024-05-15 08:30:00',150000.00,'Đã thanh toán','KH03','SC03','PH01','S1',NULL),('VE06','2024-05-15 08:30:00',150000.00,'Đã thanh toán','KH03','SC03','PH01','S2',NULL),('VE07','2024-05-15 11:00:00',90000.00,'Đã thanh toán','KH04','SC04','PH02','A1',NULL),('VE08','2024-05-15 11:05:00',100000.00,'Đã thanh toán','KH05','SC05','PH02','B1',NULL),('VE09','2024-05-16 09:00:00',135000.00,'Đã thanh toán','KH07','SC06','PH01','B3',NULL),('VE10','2024-05-16 15:30:00',110000.00,'Đã thanh toán','KH08','SC08','PH04','A1',NULL),('VE11','2024-05-17 10:00:00',120000.00,'Đã thanh toán','KH09','SC10','PH07','A1',NULL),('VE12','2024-05-17 10:05:00',140000.00,'Chờ thanh toán','KH10','SC10','PH07','B1',NULL),('VE999','2026-10-21 15:49:16',150000.00,'Đã thanh toán','KH01','SC10','PH07','A2',NULL);
/*!40000 ALTER TABLE `DAT_VE` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'REAL_AS_FLOAT,PIPES_AS_CONCAT,ANSI_QUOTES,IGNORE_SPACE,ONLY_FULL_GROUP_BY,ANSI,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`avnadmin`@`%`*/ /*!50003 TRIGGER `trg_KiemTraDatVe_BeforeInsert` BEFORE INSERT ON `DAT_VE` FOR EACH ROW BEGIN
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
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'REAL_AS_FLOAT,PIPES_AS_CONCAT,ANSI_QUOTES,IGNORE_SPACE,ONLY_FULL_GROUP_BY,ANSI,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`avnadmin`@`%`*/ /*!50003 TRIGGER `trg_TichDiemVe_AfterInsert` AFTER INSERT ON `DAT_VE` FOR EACH ROW BEGIN
    DECLARE v_DiemCong INT DEFAULT 0;
    IF NEW.TrangThaiThanhToan = 'Đã thanh toán' THEN
        SET v_DiemCong = FLOOR(NEW.GiaVe / 10000);
        UPDATE KHACH_HANG SET DiemTichLuy = DiemTichLuy + v_DiemCong WHERE MaKH = NEW.MaKH;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'REAL_AS_FLOAT,PIPES_AS_CONCAT,ANSI_QUOTES,IGNORE_SPACE,ONLY_FULL_GROUP_BY,ANSI,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`avnadmin`@`%`*/ /*!50003 TRIGGER `trg_TichDiemVe_AfterUpdate` AFTER UPDATE ON `DAT_VE` FOR EACH ROW BEGIN
    DECLARE v_DiemCong INT DEFAULT 0;
    IF OLD.TrangThaiThanhToan <> 'Đã thanh toán' AND NEW.TrangThaiThanhToan = 'Đã thanh toán' THEN
        SET v_DiemCong = FLOOR(NEW.GiaVe / 10000);
        UPDATE KHACH_HANG SET DiemTichLuy = DiemTichLuy + v_DiemCong WHERE MaKH = NEW.MaKH;
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `DICH_VU_FNB`
--

DROP TABLE IF EXISTS `DICH_VU_FNB`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `DICH_VU_FNB` (
  `MaCombo` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `TenCombo` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `MoTa` text COLLATE utf8mb4_unicode_ci,
  `DonGia` decimal(12,2) NOT NULL,
  PRIMARY KEY (`MaCombo`),
  CONSTRAINT `ck_fnb_don_gia` CHECK ((`DonGia` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `DICH_VU_FNB`
--

LOCK TABLES `DICH_VU_FNB` WRITE;
/*!40000 ALTER TABLE `DICH_VU_FNB` DISABLE KEYS */;
INSERT INTO `DICH_VU_FNB` VALUES ('CB01','Combo Solo','1 Bắp ngọt vừa + 1 Nước ngọt lớn',89000.00),('CB02','Combo Couple','1 Bắp lớn + 2 Nước ngọt lớn',119000.00),('CB03','Combo Family','2 Bắp lớn + 4 Nước ngọt lớn + 1 Snack',229000.00),('CB04','Combo Party','3 Bắp lớn + 3 Nước lớn + 2 Chả giò',289000.00),('CB05','Bắp Rang Phô Mai','Bắp rang bơ vị phô mai size L',69000.00),('CB06','Bắp Rang Caramel','Bắp rang bơ vị caramel size L',69000.00),('CB07','Pepsi Lớn','Nước ngọt Pepsi ly 32oz',39000.00),('CB08','Coca Cola Lớn','Nước ngọt Coca ly 32oz',39000.00),('CB09','Snack Khoai Tây','Gói snack khoai tây Lay\'s 90g',29000.00),('CB10','Hotdog Phô Mai','Bánh mì hotdog kẹp xốt phô mai nóng',49000.00);
/*!40000 ALTER TABLE `DICH_VU_FNB` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `GHE_NGOI`
--

DROP TABLE IF EXISTS `GHE_NGOI`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `GHE_NGOI` (
  `MaPhong` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `SoGhe` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `LoaiGhe` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Thường',
  `PhuThuGhe` decimal(12,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`MaPhong`,`SoGhe`),
  CONSTRAINT `fk_ghe_phong` FOREIGN KEY (`MaPhong`) REFERENCES `PHONG_CHIEU` (`MaPhong`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `ck_ghe_loai` CHECK ((`LoaiGhe` in (_utf8mb4'Thường',_utf8mb4'VIP',_utf8mb4'Sweetbox'))),
  CONSTRAINT `ck_ghe_phu_thu` CHECK ((`PhuThuGhe` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `GHE_NGOI`
--

LOCK TABLES `GHE_NGOI` WRITE;
/*!40000 ALTER TABLE `GHE_NGOI` DISABLE KEYS */;
INSERT INTO `GHE_NGOI` VALUES ('PH01','A1','Thường',0.00),('PH01','A2','Thường',0.00),('PH01','A3','Thường',0.00),('PH01','A4','Thường',0.00),('PH01','B1','VIP',15000.00),('PH01','B2','VIP',15000.00),('PH01','B3','VIP',15000.00),('PH01','B4','VIP',15000.00),('PH01','S1','Sweetbox',30000.00),('PH01','S2','Sweetbox',30000.00),('PH02','A1','Thường',0.00),('PH02','A2','Thường',0.00),('PH02','B1','VIP',10000.00),('PH02','B2','VIP',10000.00),('PH04','A1','Thường',0.00),('PH04','A2','Thường',0.00),('PH04','B1','VIP',10000.00),('PH04','B2','VIP',10000.00),('PH07','A1','Thường',0.00),('PH07','A2','Thường',0.00),('PH07','B1','VIP',20000.00),('PH07','B2','VIP',20000.00);
/*!40000 ALTER TABLE `GHE_NGOI` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `KHACH_HANG`
--

DROP TABLE IF EXISTS `KHACH_HANG`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `KHACH_HANG` (
  `MaKH` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `HoTen` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `SDT` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `Email` varchar(254) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `NgaySinh` date DEFAULT NULL,
  `DiemTichLuy` int NOT NULL DEFAULT '0',
  PRIMARY KEY (`MaKH`),
  UNIQUE KEY `uq_khach_sdt` (`SDT`),
  CONSTRAINT `ck_khach_diem` CHECK ((`DiemTichLuy` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `KHACH_HANG`
--

LOCK TABLES `KHACH_HANG` WRITE;
/*!40000 ALTER TABLE `KHACH_HANG` DISABLE KEYS */;
INSERT INTO `KHACH_HANG` VALUES ('KH_TREEM','Nguyễn Văn Bé','0900000001','be@gmail.com','2018-01-01',0),('KH01','Nguyễn Văn An','0903123456','an.nguyen@gmail.com','1995-05-15',120),('KH02','Trần Thị Bình','0918234567','binh.tran@yahoo.com','1998-11-20',450),('KH03','Lê Hoàng Cường','0937345678','cuong.le@gmail.com','1990-03-10',800),('KH04','Phạm Minh Đức','0946456789','duc.pham@outlook.com','2001-08-25',50),('KH05','Hoàng Thùy Dương','0985567890','duong.hoang@gmail.com','1997-12-05',300),('KH06','Vũ Tiến Đạt','0976678901','dat.vu@gmail.com','2000-01-30',0),('KH07','Đặng Phương Thảo','0967789012','thao.dang@gmail.com','1996-07-14',210),('KH08','Bùi Anh Tuấn','0928890123','tuan.bui@gmail.com','1993-09-09',620),('KH09','Đỗ Mai Hương','0909901234','huong.do@gmail.com','2002-04-18',90),('KH10','Ngô Quốc Khánh','0917012345','khanh.ngo@gmail.com','1989-10-12',1100),('KH999','Nguyễn Văn A','0901234567','nguyenvana@email.com','1995-10-20',0);
/*!40000 ALTER TABLE `KHACH_HANG` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `MUA_FNB`
--

DROP TABLE IF EXISTS `MUA_FNB`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `MUA_FNB` (
  `MaKH` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `MaCombo` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `NgayMua` datetime(6) NOT NULL DEFAULT CURRENT_TIMESTAMP(6),
  `SoLuong` int NOT NULL,
  `ThanhTien` decimal(15,2) NOT NULL,
  PRIMARY KEY (`MaKH`,`MaCombo`,`NgayMua`),
  KEY `fk_mua_fnb_combo` (`MaCombo`),
  CONSTRAINT `fk_mua_fnb_combo` FOREIGN KEY (`MaCombo`) REFERENCES `DICH_VU_FNB` (`MaCombo`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_mua_fnb_khach` FOREIGN KEY (`MaKH`) REFERENCES `KHACH_HANG` (`MaKH`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `ck_mua_fnb_so_luong` CHECK ((`SoLuong` > 0)),
  CONSTRAINT `ck_mua_fnb_thanh_tien` CHECK ((`ThanhTien` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `MUA_FNB`
--

LOCK TABLES `MUA_FNB` WRITE;
/*!40000 ALTER TABLE `MUA_FNB` DISABLE KEYS */;
INSERT INTO `MUA_FNB` VALUES ('KH01','CB02','2024-05-14 10:16:30.000000',1,119000.00),('KH01','CB02','2026-10-22 12:50:39.000000',1,0.00),('KH02','CB01','2024-05-14 14:22:00.000000',2,178000.00),('KH03','CB03','2024-05-15 08:31:00.000000',1,229000.00),('KH03','CB08','2024-05-18 19:15:00.000000',2,78000.00),('KH04','CB07','2024-05-15 11:01:15.000000',1,39000.00),('KH05','CB05','2024-05-15 11:06:00.000000',1,69000.00),('KH07','CB02','2024-05-16 09:02:00.000000',1,119000.00),('KH08','CB01','2024-05-16 15:32:10.000000',1,89000.00),('KH09','CB06','2024-05-17 10:02:00.000000',1,69000.00),('KH10','CB04','2024-05-17 10:06:30.000000',1,289000.00);
/*!40000 ALTER TABLE `MUA_FNB` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'REAL_AS_FLOAT,PIPES_AS_CONCAT,ANSI_QUOTES,IGNORE_SPACE,ONLY_FULL_GROUP_BY,ANSI,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`avnadmin`@`%`*/ /*!50003 TRIGGER `trg_TinhTienMuaFNB_BeforeInsert` BEFORE INSERT ON `MUA_FNB` FOR EACH ROW BEGIN
    DECLARE v_DonGia DECIMAL(12,2);
    SELECT DonGia INTO v_DonGia FROM DICH_VU_FNB WHERE MaCombo = NEW.MaCombo;
    IF v_DonGia IS NULL THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Mã Combo F&B không tồn tại!';
    END IF;
    SET NEW.ThanhTien = NEW.SoLuong * v_DonGia;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'REAL_AS_FLOAT,PIPES_AS_CONCAT,ANSI_QUOTES,IGNORE_SPACE,ONLY_FULL_GROUP_BY,ANSI,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`avnadmin`@`%`*/ /*!50003 TRIGGER `trg_TichDiemMuaFNB_AfterInsert` AFTER INSERT ON `MUA_FNB` FOR EACH ROW BEGIN
    DECLARE v_DiemCong INT DEFAULT 0;
    SET v_DiemCong = FLOOR(NEW.ThanhTien / 10000);
    UPDATE KHACH_HANG SET DiemTichLuy = DiemTichLuy + v_DiemCong WHERE MaKH = NEW.MaKH;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `NHAN_VIEN`
--

DROP TABLE IF EXISTS `NHAN_VIEN`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `NHAN_VIEN` (
  `MaNV` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `HoTen` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `NgaySinh` date NOT NULL,
  `CCCD` char(12) COLLATE utf8mb4_unicode_ci NOT NULL,
  `SDT` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `LuongCoBan` decimal(15,2) NOT NULL,
  `NgayVaoLam` date NOT NULL,
  `MaRap` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`MaNV`),
  UNIQUE KEY `uq_nhan_vien_cccd` (`CCCD`),
  KEY `fk_nhan_vien_rap` (`MaRap`),
  CONSTRAINT `fk_nhan_vien_rap` FOREIGN KEY (`MaRap`) REFERENCES `CUM_RAP` (`MaRap`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `ck_nhan_vien_luong` CHECK ((`LuongCoBan` >= 0)),
  CONSTRAINT `ck_nhan_vien_ngay` CHECK ((`NgayVaoLam` > `NgaySinh`))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `NHAN_VIEN`
--

LOCK TABLES `NHAN_VIEN` WRITE;
/*!40000 ALTER TABLE `NHAN_VIEN` DISABLE KEYS */;
INSERT INTO `NHAN_VIEN` VALUES ('NV01','Nguyễn Văn Hùng','1988-03-12','012345678901','0901111222',18000000.00,'2018-01-15','RAP01'),('NV02','Trần Thị Mai','1992-07-24','012345678902','0901111223',15000000.00,'2019-05-20','RAP02'),('NV03','Lê Văn Nam','1990-11-05','012345678903','0901111224',16000000.00,'2020-03-10','RAP03'),('NV04','Phạm Thị Hoa','2001-02-18','012345678904','0901111225',7500000.00,'2022-06-01','RAP01'),('NV05','Hoàng Văn Tuấn','2002-09-09','012345678905','0901111226',7500000.00,'2022-08-15','RAP01'),('NV06','Vũ Thu Trang','2000-12-12','012345678906','0901111227',8000000.00,'2023-01-10','RAP02'),('NV07','Đặng Minh Quân','1999-04-05','012345678907','0901111228',7800000.00,'2023-03-01','RAP03'),('NV08','Bùi Tiến Dũng','1995-08-19','012345678908','0901111229',10500000.00,'2021-09-01','RAP01'),('NV09','Ngô Bảo Ngọc','1996-01-22','012345678909','0901111230',10000000.00,'2021-11-15','RAP02'),('NV10','Lý Văn Hải','1994-06-30','012345678910','0901111231',11000000.00,'2020-10-01','RAP04'),('NV11','Nguyen Van C','2001-05-10','012345678999','0909999888',7500000.00,'2024-01-01','RAP01');
/*!40000 ALTER TABLE `NHAN_VIEN` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `NV_BAN_HANG`
--

DROP TABLE IF EXISTS `NV_BAN_HANG`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `NV_BAN_HANG` (
  `MaNV` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `CaLamViec` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `DoanhSoThang` decimal(15,2) NOT NULL DEFAULT '0.00',
  PRIMARY KEY (`MaNV`),
  CONSTRAINT `fk_ban_hang_nv` FOREIGN KEY (`MaNV`) REFERENCES `NHAN_VIEN` (`MaNV`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `ck_ban_hang_ca` CHECK ((`CaLamViec` in (_utf8mb4'Sáng',_utf8mb4'Chiều',_utf8mb4'Tối'))),
  CONSTRAINT `ck_ban_hang_doanh_so` CHECK ((`DoanhSoThang` >= 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `NV_BAN_HANG`
--

LOCK TABLES `NV_BAN_HANG` WRITE;
/*!40000 ALTER TABLE `NV_BAN_HANG` DISABLE KEYS */;
INSERT INTO `NV_BAN_HANG` VALUES ('NV04','Sáng',25000000.00),('NV05','Chiều',32000000.00),('NV06','Tối',41000000.00),('NV07','Tối',38000000.00),('NV11','Chiều',0.00);
/*!40000 ALTER TABLE `NV_BAN_HANG` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'REAL_AS_FLOAT,PIPES_AS_CONCAT,ANSI_QUOTES,IGNORE_SPACE,ONLY_FULL_GROUP_BY,ANSI,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`avnadmin`@`%`*/ /*!50003 TRIGGER `trg_Disjoint_NVBanHang_BeforeInsert` BEFORE INSERT ON `NV_BAN_HANG` FOR EACH ROW BEGIN
    IF EXISTS (SELECT 1 FROM NV_QUAN_LY WHERE MaNV = NEW.MaNV)
       OR EXISTS (SELECT 1 FROM NV_KY_THUAT WHERE MaNV = NEW.MaNV) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi Ràng buộc Rời rạc (ISA): Nhân viên này đã thuộc bộ phận Quản lý hoặc Kỹ thuật!';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `NV_KY_THUAT`
--

DROP TABLE IF EXISTS `NV_KY_THUAT`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `NV_KY_THUAT` (
  `MaNV` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ChungChiKyThuat` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `KhuVucPhuTrach` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`MaNV`),
  CONSTRAINT `fk_ky_thuat_nv` FOREIGN KEY (`MaNV`) REFERENCES `NHAN_VIEN` (`MaNV`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `NV_KY_THUAT`
--

LOCK TABLES `NV_KY_THUAT` WRITE;
/*!40000 ALTER TABLE `NV_KY_THUAT` DISABLE KEYS */;
INSERT INTO `NV_KY_THUAT` VALUES ('NV08','Chứng chỉ Máy chiếu IMAX Digital 2022','Phòng máy PH01-PH03'),('NV09','Chứng chỉ Âm thanh Dolby Atmos','Phòng máy PH04-PH05'),('NV10','Chứng chỉ Máy chiếu Laser 4K','Phòng máy PH07-PH08');
/*!40000 ALTER TABLE `NV_KY_THUAT` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'REAL_AS_FLOAT,PIPES_AS_CONCAT,ANSI_QUOTES,IGNORE_SPACE,ONLY_FULL_GROUP_BY,ANSI,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`avnadmin`@`%`*/ /*!50003 TRIGGER `trg_Disjoint_NVKyThuat_BeforeInsert` BEFORE INSERT ON `NV_KY_THUAT` FOR EACH ROW BEGIN
    IF EXISTS (SELECT 1 FROM NV_QUAN_LY WHERE MaNV = NEW.MaNV)
       OR EXISTS (SELECT 1 FROM NV_BAN_HANG WHERE MaNV = NEW.MaNV) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi Ràng buộc Rời rạc (ISA): Nhân viên này đã thuộc bộ phận Quản lý hoặc Bán hàng!';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `NV_QUAN_LY`
--

DROP TABLE IF EXISTS `NV_QUAN_LY`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `NV_QUAN_LY` (
  `MaNV` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `HeSoTrachNhiem` decimal(5,2) NOT NULL DEFAULT '1.00',
  `QuyenHan` varchar(255) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  PRIMARY KEY (`MaNV`),
  CONSTRAINT `fk_quan_ly_nv` FOREIGN KEY (`MaNV`) REFERENCES `NHAN_VIEN` (`MaNV`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `ck_quan_ly_he_so` CHECK ((`HeSoTrachNhiem` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `NV_QUAN_LY`
--

LOCK TABLES `NV_QUAN_LY` WRITE;
/*!40000 ALTER TABLE `NV_QUAN_LY` DISABLE KEYS */;
INSERT INTO `NV_QUAN_LY` VALUES ('NV01',1.50,'Quản lý toàn bộ cụm rạp RAP01'),('NV02',1.30,'Quản lý toàn bộ cụm rạp RAP02'),('NV03',1.30,'Quản lý toàn bộ cụm rạp RAP03');
/*!40000 ALTER TABLE `NV_QUAN_LY` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'REAL_AS_FLOAT,PIPES_AS_CONCAT,ANSI_QUOTES,IGNORE_SPACE,ONLY_FULL_GROUP_BY,ANSI,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`avnadmin`@`%`*/ /*!50003 TRIGGER `trg_Disjoint_NVQuanLy_BeforeInsert` BEFORE INSERT ON `NV_QUAN_LY` FOR EACH ROW BEGIN
    IF EXISTS (SELECT 1 FROM NV_BAN_HANG WHERE MaNV = NEW.MaNV)
       OR EXISTS (SELECT 1 FROM NV_KY_THUAT WHERE MaNV = NEW.MaNV) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi Ràng buộc Rời rạc (ISA): Nhân viên này đã thuộc bộ phận Bán hàng hoặc Kỹ thuật!';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Table structure for table `PHIM`
--

DROP TABLE IF EXISTS `PHIM`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PHIM` (
  `MaPhim` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `TenPhim` varchar(200) COLLATE utf8mb4_unicode_ci NOT NULL,
  `DaoDien` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  `ThoiLuong` int NOT NULL COMMENT 'Don vi: phut',
  `NgayKhoiChieu` date NOT NULL,
  `GioiHanTuoi` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'G',
  `TrangThai` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Sắp chiếu',
  PRIMARY KEY (`MaPhim`),
  CONSTRAINT `ck_phim_do_tuoi` CHECK ((`GioiHanTuoi` in (_utf8mb4'G',_utf8mb4'PG',_utf8mb4'13+',_utf8mb4'18+'))),
  CONSTRAINT `ck_phim_thoi_luong` CHECK ((`ThoiLuong` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PHIM`
--

LOCK TABLES `PHIM` WRITE;
/*!40000 ALTER TABLE `PHIM` DISABLE KEYS */;
INSERT INTO `PHIM` VALUES ('P01','Mai','Trấn Thành',131,'2024-02-10','18+','Ngưng chiếu'),('P02','Lật Mặt 7: Một Điều Ước','Lý Hải',138,'2024-04-26','PG','Sắp chiếu'),('P03','Dune: Hành Tinh Cát - Phần 2','Denis Villeneuve',166,'2024-03-01','13+','Sắp chiếu'),('P04','Godzilla x Kong: Đế Chế Mới','Adam Wingard',115,'2024-03-29','PG','Sắp chiếu'),('P05','Kung Fu Panda 4','Mike Mitchell',94,'2024-03-08','G','Sắp chiếu'),('P06','Quật Mộ Trùng Phùng (Exhuma)','Jang Jae-hyun',134,'2024-03-15','18+','Sắp chiếu'),('P07','Inside Out 2','Kelsey Mann',96,'2024-06-14','G','Sắp chiếu'),('P08','Deadpool & Wolverine','Shawn Levy',128,'2024-07-26','18+','Sắp chiếu'),('P09','Đào, Phở Và Piano','Phi Tiến Sơn',100,'2024-02-10','13+','Sắp chiếu'),('P10','Vua Sư Tử (Mufasa: The Lion King)','Barry Jenkins',118,'2024-12-20','G','Sắp chiếu'),('P11','Avatar: The Way of Water','James Cameron',192,'2024-12-15','13+','Sắp chiếu');
/*!40000 ALTER TABLE `PHIM` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PHIM_DIEN_VIEN`
--

DROP TABLE IF EXISTS `PHIM_DIEN_VIEN`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PHIM_DIEN_VIEN` (
  `MaPhim` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `DienVien` varchar(150) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`MaPhim`,`DienVien`),
  CONSTRAINT `fk_dien_vien_phim` FOREIGN KEY (`MaPhim`) REFERENCES `PHIM` (`MaPhim`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PHIM_DIEN_VIEN`
--

LOCK TABLES `PHIM_DIEN_VIEN` WRITE;
/*!40000 ALTER TABLE `PHIM_DIEN_VIEN` DISABLE KEYS */;
INSERT INTO `PHIM_DIEN_VIEN` VALUES ('P01','Phương Anh Đào'),('P01','Tuấn Trần'),('P02','Đinh Y Nhung'),('P02','Quách Ngọc Tuyên'),('P03','Timothée Chalamet'),('P03','Zendaya'),('P04','Brian Tyree Henry'),('P04','Rebecca Hall'),('P05','Awkwafina'),('P05','Jack Black'),('P06','Choi Min-sik'),('P06','Kim Go-eun'),('P07','Amy Poehler'),('P07','Maya Hawke'),('P08','Hugh Jackman'),('P08','Ryan Reynolds'),('P09','Cao Thùy Linh'),('P09','Doãn Quốc Đam');
/*!40000 ALTER TABLE `PHIM_DIEN_VIEN` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PHIM_THE_LOAI`
--

DROP TABLE IF EXISTS `PHIM_THE_LOAI`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PHIM_THE_LOAI` (
  `MaPhim` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `TheLoai` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`MaPhim`,`TheLoai`),
  CONSTRAINT `fk_the_loai_phim` FOREIGN KEY (`MaPhim`) REFERENCES `PHIM` (`MaPhim`) ON DELETE RESTRICT ON UPDATE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PHIM_THE_LOAI`
--

LOCK TABLES `PHIM_THE_LOAI` WRITE;
/*!40000 ALTER TABLE `PHIM_THE_LOAI` DISABLE KEYS */;
INSERT INTO `PHIM_THE_LOAI` VALUES ('P01','Tâm Lý'),('P01','Tình Cảm'),('P02','Gia Đình'),('P02','Tâm Lý'),('P03','Hành Động'),('P03','Khoa Học Viễn Tưởng'),('P04','Hành Động'),('P04','Phiêu Lưu'),('P05','Hài Hước'),('P05','Hoạt Hình'),('P06','Bí Ẩn'),('P06','Kinh Dị'),('P07','Gia Đình'),('P07','Hoạt Hình'),('P08','Hài Hước'),('P08','Hành Động'),('P09','Chiến Tranh'),('P09','Lịch Sử'),('P10','Hoạt Hình'),('P10','Phiêu Lưu');
/*!40000 ALTER TABLE `PHIM_THE_LOAI` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `PHONG_CHIEU`
--

DROP TABLE IF EXISTS `PHONG_CHIEU`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `PHONG_CHIEU` (
  `MaPhong` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `TenPhong` varchar(100) COLLATE utf8mb4_unicode_ci NOT NULL,
  `LoaiPhong` varchar(10) COLLATE utf8mb4_unicode_ci NOT NULL,
  `TongSoGhe` int NOT NULL,
  `MaRap` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`MaPhong`),
  KEY `fk_phong_rap` (`MaRap`),
  CONSTRAINT `fk_phong_rap` FOREIGN KEY (`MaRap`) REFERENCES `CUM_RAP` (`MaRap`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `ck_phong_loai` CHECK ((`LoaiPhong` in (_utf8mb4'2D',_utf8mb4'3D',_utf8mb4'IMAX'))),
  CONSTRAINT `ck_phong_so_ghe` CHECK ((`TongSoGhe` > 0))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `PHONG_CHIEU`
--

LOCK TABLES `PHONG_CHIEU` WRITE;
/*!40000 ALTER TABLE `PHONG_CHIEU` DISABLE KEYS */;
INSERT INTO `PHONG_CHIEU` VALUES ('PH01','Phòng IMAX 1','IMAX',120,'RAP01'),('PH02','Phòng Cinema 2','2D',90,'RAP01'),('PH03','Phòng 3D GoldClass','3D',80,'RAP01'),('PH04','Phòng Cinema 1','2D',100,'RAP02'),('PH05','Phòng 3D Prime','3D',85,'RAP02'),('PH06','Phòng Cinema 1','2D',110,'RAP03'),('PH07','Phòng IMAX Laser','IMAX',130,'RAP04'),('PH08','Phòng Cinema 2','2D',95,'RAP04'),('PH09','Phòng Cinema 1','2D',120,'RAP05'),('PH10','Phòng 3D Premium','3D',75,'RAP06');
/*!40000 ALTER TABLE `PHONG_CHIEU` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `SUAT_CHIEU`
--

DROP TABLE IF EXISTS `SUAT_CHIEU`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!50503 SET character_set_client = utf8mb4 */;
CREATE TABLE `SUAT_CHIEU` (
  `MaSuatChieu` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `NgayChieu` date NOT NULL,
  `GioBatDau` time NOT NULL,
  `GioKetThuc` time NOT NULL,
  `TrangThai` varchar(30) COLLATE utf8mb4_unicode_ci NOT NULL DEFAULT 'Sắp chiếu',
  `MaPhim` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  `MaPhong` varchar(20) COLLATE utf8mb4_unicode_ci NOT NULL,
  PRIMARY KEY (`MaSuatChieu`),
  UNIQUE KEY `uq_suat_phong` (`MaSuatChieu`,`MaPhong`),
  KEY `fk_suat_phim` (`MaPhim`),
  KEY `idx_suat_lich_phong` (`MaPhong`,`NgayChieu`,`GioBatDau`),
  CONSTRAINT `fk_suat_phim` FOREIGN KEY (`MaPhim`) REFERENCES `PHIM` (`MaPhim`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `fk_suat_phong` FOREIGN KEY (`MaPhong`) REFERENCES `PHONG_CHIEU` (`MaPhong`) ON DELETE RESTRICT ON UPDATE RESTRICT,
  CONSTRAINT `ck_suat_gio` CHECK (((`GioBatDau` >= _utf8mb4'00:00:00') and (`GioKetThuc` < _utf8mb4'24:00:00') and (`GioKetThuc` > `GioBatDau`))),
  CONSTRAINT `ck_suat_trang_thai` CHECK ((`TrangThai` in (_utf8mb4'Sắp chiếu',_utf8mb4'Đang chiếu',_utf8mb4'Đã kết thúc')))
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `SUAT_CHIEU`
--

LOCK TABLES `SUAT_CHIEU` WRITE;
/*!40000 ALTER TABLE `SUAT_CHIEU` DISABLE KEYS */;
INSERT INTO `SUAT_CHIEU` VALUES ('SC01','2024-05-15','09:00:00','11:15:00','Đã kết thúc','P01','PH01'),('SC02','2024-05-15','14:00:00','16:15:00','Đã kết thúc','P01','PH01'),('SC03','2024-05-15','19:30:00','21:45:00','Đã kết thúc','P01','PH01'),('SC04','2024-05-15','10:00:00','12:20:00','Đã kết thúc','P02','PH02'),('SC05','2024-05-15','18:00:00','20:20:00','Đã kết thúc','P02','PH02'),('SC06','2024-05-16','13:00:00','15:45:00','Đã kết thúc','P03','PH01'),('SC07','2024-05-16','20:00:00','22:45:00','Đã kết thúc','P03','PH01'),('SC08','2024-05-16','09:30:00','11:25:00','Đã kết thúc','P04','PH04'),('SC09','2024-05-16','19:00:00','20:55:00','Đã kết thúc','P04','PH04'),('SC10','2024-05-17','18:30:00','20:05:00','Sắp chiếu','P05','PH07'),('SC11','2026-10-25','19:00:00','21:18:00','Sắp chiếu','P02','PH01');
/*!40000 ALTER TABLE `SUAT_CHIEU` ENABLE KEYS */;
UNLOCK TABLES;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'REAL_AS_FLOAT,PIPES_AS_CONCAT,ANSI_QUOTES,IGNORE_SPACE,ONLY_FULL_GROUP_BY,ANSI,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
/*!50003 CREATE*/ /*!50017 DEFINER=`avnadmin`@`%`*/ /*!50003 TRIGGER `trg_KiemTraLichChieu_BeforeInsert` BEFORE INSERT ON `SUAT_CHIEU` FOR EACH ROW BEGIN
    IF EXISTS (
        SELECT 1 FROM SUAT_CHIEU sc
        WHERE sc.MaPhong = NEW.MaPhong
          AND sc.NgayChieu = NEW.NgayChieu
          AND NEW.GioBatDau < ADDTIME(sc.GioKetThuc, '00:15:00')
          AND ADDTIME(NEW.GioKetThuc, '00:15:00') > sc.GioBatDau
    ) THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi Xếp lịch: Phòng chiếu bị trùng giờ hoặc chưa đảm bảo 15 phút dọn dẹp giữa 2 suất chiếu!';
    END IF;
END */;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Temporary view structure for view `view_DoanhThuToanDien`
--

DROP TABLE IF EXISTS `view_DoanhThuToanDien`;
/*!50001 DROP VIEW IF EXISTS `view_DoanhThuToanDien`*/;
SET @saved_cs_client     = @@character_set_client;
/*!50503 SET character_set_client = utf8mb4 */;
/*!50001 CREATE VIEW `view_DoanhThuToanDien` AS SELECT 
 1 AS `NguonDoanhThu`,
 1 AS `Thang`,
 1 AS `Nam`,
 1 AS `SoLuongGiaoDich`,
 1 AS `TongTien`*/;
SET character_set_client = @saved_cs_client;

--
-- Dumping routines for database 'QuanLyRapPhim'
--
/*!50003 DROP PROCEDURE IF EXISTS `sp_BaoCaoDoanhThu` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'REAL_AS_FLOAT,PIPES_AS_CONCAT,ANSI_QUOTES,IGNORE_SPACE,ONLY_FULL_GROUP_BY,ANSI,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER="avnadmin"@"%" PROCEDURE "sp_BaoCaoDoanhThu"(
    IN p_KieuBaoCao VARCHAR(10),
    IN p_TuNgay DATE,
    IN p_DenNgay DATE
)
BEGIN
    DECLARE v_Kieu VARCHAR(10);
    SET v_Kieu = UPPER(p_KieuBaoCao);
    IF v_Kieu IS NULL OR v_Kieu NOT IN ('NGAY', 'THANG', 'QUY') THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Kiểu báo cáo phải là NGAY, THANG hoặc QUY!';
    END IF;
    IF p_TuNgay IS NOT NULL AND p_DenNgay IS NOT NULL AND p_TuNgay > p_DenNgay THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Từ ngày phải nhỏ hơn hoặc bằng đến ngày!';
    END IF;

    SELECT x.KyBaoCao,
           SUM(CASE WHEN x.Nguon = 'VE' THEN x.SoTien ELSE 0 END) AS DoanhThuVe,
           SUM(CASE WHEN x.Nguon = 'FB' THEN x.SoTien ELSE 0 END) AS DoanhThuFB,
           SUM(x.SoTien) AS TongDoanhThu
    FROM (
        SELECT u.Nguon, u.SoTien,
               CASE v_Kieu
                   WHEN 'NGAY'  THEN DATE_FORMAT(u.Ngay, '%Y-%m-%d')
                   WHEN 'THANG' THEN DATE_FORMAT(u.Ngay, '%Y-%m')
                   ELSE CONCAT(YEAR(u.Ngay), '-Q', QUARTER(u.Ngay))
               END AS KyBaoCao
        FROM (
            SELECT 'VE' AS Nguon, DATE(NgayGioDat) AS Ngay, GiaVe AS SoTien
            FROM DAT_VE WHERE TrangThaiThanhToan = 'Đã thanh toán'
            UNION ALL
            SELECT 'FB', DATE(NgayMua), ThanhTien FROM MUA_FNB
        ) u
        WHERE (p_TuNgay IS NULL OR u.Ngay >= p_TuNgay)
          AND (p_DenNgay IS NULL OR u.Ngay <= p_DenNgay)
    ) x
    GROUP BY x.KyBaoCao
    ORDER BY x.KyBaoCao;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_BaoCaoDoanhThuTheoRap` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'REAL_AS_FLOAT,PIPES_AS_CONCAT,ANSI_QUOTES,IGNORE_SPACE,ONLY_FULL_GROUP_BY,ANSI,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER="avnadmin"@"%" PROCEDURE "sp_BaoCaoDoanhThuTheoRap"(
    IN p_TuNgay DATE,
    IN p_DenNgay DATE
)
BEGIN
    IF p_TuNgay IS NOT NULL AND p_DenNgay IS NOT NULL AND p_TuNgay > p_DenNgay THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Từ ngày phải nhỏ hơn hoặc bằng đến ngày!';
    END IF;

    SELECT cr.MaRap, cr.TenRap,
           COUNT(dv.MaVe) AS SoVeDaBan,
           IFNULL(SUM(dv.GiaVe), 0) AS DoanhThuVe
    FROM CUM_RAP cr
    LEFT JOIN PHONG_CHIEU pc ON pc.MaRap = cr.MaRap
    LEFT JOIN DAT_VE dv ON dv.MaPhong = pc.MaPhong
                       AND dv.TrangThaiThanhToan = 'Đã thanh toán'
                       AND (p_TuNgay IS NULL OR DATE(dv.NgayGioDat) >= p_TuNgay)
                       AND (p_DenNgay IS NULL OR DATE(dv.NgayGioDat) <= p_DenNgay)
    GROUP BY cr.MaRap, cr.TenRap
    ORDER BY DoanhThuVe DESC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_BaoCaoDoanhThu_TuNgayDenNgay` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_unicode_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'REAL_AS_FLOAT,PIPES_AS_CONCAT,ANSI_QUOTES,IGNORE_SPACE,ONLY_FULL_GROUP_BY,ANSI,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER="avnadmin"@"%" PROCEDURE "sp_BaoCaoDoanhThu_TuNgayDenNgay"(
    IN p_TuNgay DATE,
    IN p_DenNgay DATE
)
BEGIN
    SELECT 
        cr.TenRap,
        SUM(v.GiaVe) AS DoanhThuVe,
        (
            SELECT SUM(ThanhTien) 
            FROM MUA_FNB 
            WHERE NgayMua BETWEEN p_TuNgay AND p_DenNgay
        ) AS DoanhThuFNB_UocTinh
    FROM CUM_RAP cr
    JOIN PHONG_CHIEU pc ON cr.MaRap = pc.MaRap
    JOIN SUAT_CHIEU sc ON pc.MaPhong = sc.MaPhong
    JOIN DAT_VE v ON sc.MaSuatChieu = v.MaSuatChieu
    WHERE DATE(v.NgayGioDat) BETWEEN p_TuNgay AND p_DenNgay
      AND v.TrangThaiThanhToan = 'Đã thanh toán'
    GROUP BY cr.MaRap, cr.TenRap;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_CapNhatPhim` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'REAL_AS_FLOAT,PIPES_AS_CONCAT,ANSI_QUOTES,IGNORE_SPACE,ONLY_FULL_GROUP_BY,ANSI,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER="avnadmin"@"%" PROCEDURE "sp_CapNhatPhim"(
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_DatVeXemPhim` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'REAL_AS_FLOAT,PIPES_AS_CONCAT,ANSI_QUOTES,IGNORE_SPACE,ONLY_FULL_GROUP_BY,ANSI,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER="avnadmin"@"%" PROCEDURE "sp_DatVeXemPhim"(
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_GoBoPhim` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'REAL_AS_FLOAT,PIPES_AS_CONCAT,ANSI_QUOTES,IGNORE_SPACE,ONLY_FULL_GROUP_BY,ANSI,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER="avnadmin"@"%" PROCEDURE "sp_GoBoPhim"(
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_LayDanhSachGheTrong` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'REAL_AS_FLOAT,PIPES_AS_CONCAT,ANSI_QUOTES,IGNORE_SPACE,ONLY_FULL_GROUP_BY,ANSI,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER="avnadmin"@"%" PROCEDURE "sp_LayDanhSachGheTrong"(
    IN p_MaSuatChieu VARCHAR(20)
)
BEGIN
    SELECT gn.MaPhong, gn.SoGhe, gn.LoaiGhe, gn.PhuThuGhe, 'Còn trống' AS TrangThaiGhe
    FROM SUAT_CHIEU sc
    JOIN GHE_NGOI gn ON sc.MaPhong = gn.MaPhong
    LEFT JOIN DAT_VE dv ON sc.MaSuatChieu = dv.MaSuatChieu AND gn.MaPhong = dv.MaPhong AND gn.SoGhe = dv.SoGhe
    WHERE sc.MaSuatChieu = p_MaSuatChieu AND dv.MaVe IS NULL
    ORDER BY gn.SoGhe ASC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_MuaFB` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'REAL_AS_FLOAT,PIPES_AS_CONCAT,ANSI_QUOTES,IGNORE_SPACE,ONLY_FULL_GROUP_BY,ANSI,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER="avnadmin"@"%" PROCEDURE "sp_MuaFB"(
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_TaoSuatChieu` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'REAL_AS_FLOAT,PIPES_AS_CONCAT,ANSI_QUOTES,IGNORE_SPACE,ONLY_FULL_GROUP_BY,ANSI,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER="avnadmin"@"%" PROCEDURE "sp_TaoSuatChieu"(
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_ThanhToanVe` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'REAL_AS_FLOAT,PIPES_AS_CONCAT,ANSI_QUOTES,IGNORE_SPACE,ONLY_FULL_GROUP_BY,ANSI,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER="avnadmin"@"%" PROCEDURE "sp_ThanhToanVe"(
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_ThemKhachHang` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'REAL_AS_FLOAT,PIPES_AS_CONCAT,ANSI_QUOTES,IGNORE_SPACE,ONLY_FULL_GROUP_BY,ANSI,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER="avnadmin"@"%" PROCEDURE "sp_ThemKhachHang"(
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_ThemNhanVien` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'REAL_AS_FLOAT,PIPES_AS_CONCAT,ANSI_QUOTES,IGNORE_SPACE,ONLY_FULL_GROUP_BY,ANSI,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER="avnadmin"@"%" PROCEDURE "sp_ThemNhanVien"(
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_ThemPhim` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'REAL_AS_FLOAT,PIPES_AS_CONCAT,ANSI_QUOTES,IGNORE_SPACE,ONLY_FULL_GROUP_BY,ANSI,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER="avnadmin"@"%" PROCEDURE "sp_ThemPhim"(
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_ThongKeNhanVien` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'REAL_AS_FLOAT,PIPES_AS_CONCAT,ANSI_QUOTES,IGNORE_SPACE,ONLY_FULL_GROUP_BY,ANSI,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER="avnadmin"@"%" PROCEDURE "sp_ThongKeNhanVien"(
    IN p_MaRap VARCHAR(20),
    IN p_TuNgay DATE,
    IN p_DenNgay DATE
)
BEGIN
    IF p_TuNgay IS NOT NULL AND p_DenNgay IS NOT NULL AND p_TuNgay > p_DenNgay THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Từ ngày phải nhỏ hơn hoặc bằng đến ngày!';
    END IF;

    SELECT nv.MaNV, nv.HoTen, cr.TenRap, bh.CaLamViec,
           COUNT(dv.MaVe) AS TongGiaoDichXuLy,
           IFNULL(SUM(dv.GiaVe), 0) AS TongDoanhThuVe
    FROM NHAN_VIEN nv
    JOIN NV_BAN_HANG bh ON bh.MaNV = nv.MaNV
    JOIN CUM_RAP cr ON cr.MaRap = nv.MaRap
    LEFT JOIN DAT_VE dv ON dv.MaNV = nv.MaNV
                       AND dv.TrangThaiThanhToan = 'Đã thanh toán'
                       AND (p_TuNgay IS NULL OR DATE(dv.NgayGioDat) >= p_TuNgay)
                       AND (p_DenNgay IS NULL OR DATE(dv.NgayGioDat) <= p_DenNgay)
    WHERE (p_MaRap IS NULL OR nv.MaRap = p_MaRap)
    GROUP BY nv.MaNV, nv.HoTen, cr.TenRap, bh.CaLamViec
    ORDER BY TongGiaoDichXuLy DESC, nv.MaNV ASC;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_TimKiemLichChieu` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'REAL_AS_FLOAT,PIPES_AS_CONCAT,ANSI_QUOTES,IGNORE_SPACE,ONLY_FULL_GROUP_BY,ANSI,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER="avnadmin"@"%" PROCEDURE "sp_TimKiemLichChieu"(
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_Top5PhimDoanhThuThang` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'REAL_AS_FLOAT,PIPES_AS_CONCAT,ANSI_QUOTES,IGNORE_SPACE,ONLY_FULL_GROUP_BY,ANSI,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER="avnadmin"@"%" PROCEDURE "sp_Top5PhimDoanhThuThang"(
    IN p_Thang INT,
    IN p_Nam INT
)
BEGIN
    DECLARE v_Dau DATE;
    IF p_Thang IS NULL OR p_Thang NOT BETWEEN 1 AND 12 OR p_Nam IS NULL OR p_Nam < 2000 THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi: Tháng (1-12) hoặc năm không hợp lệ!';
    END IF;
    SET v_Dau = STR_TO_DATE(CONCAT(p_Nam, '-', p_Thang, '-01'), '%Y-%m-%d');

    SELECT p.MaPhim, p.TenPhim, COUNT(dv.MaVe) AS SoVeDaBan, SUM(dv.GiaVe) AS DoanhThu
    FROM DAT_VE dv
    JOIN SUAT_CHIEU sc ON dv.MaSuatChieu = sc.MaSuatChieu
    JOIN PHIM p ON sc.MaPhim = p.MaPhim
    WHERE dv.TrangThaiThanhToan = 'Đã thanh toán'
      AND dv.NgayGioDat >= v_Dau
      AND dv.NgayGioDat < v_Dau + INTERVAL 1 MONTH
    GROUP BY p.MaPhim, p.TenPhim
    ORDER BY DoanhThu DESC
    LIMIT 5;
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;
/*!50003 DROP PROCEDURE IF EXISTS `sp_TraCuuVe` */;
/*!50003 SET @saved_cs_client      = @@character_set_client */ ;
/*!50003 SET @saved_cs_results     = @@character_set_results */ ;
/*!50003 SET @saved_col_connection = @@collation_connection */ ;
/*!50003 SET character_set_client  = utf8mb4 */ ;
/*!50003 SET character_set_results = utf8mb4 */ ;
/*!50003 SET collation_connection  = utf8mb4_0900_ai_ci */ ;
/*!50003 SET @saved_sql_mode       = @@sql_mode */ ;
/*!50003 SET sql_mode              = 'REAL_AS_FLOAT,PIPES_AS_CONCAT,ANSI_QUOTES,IGNORE_SPACE,ONLY_FULL_GROUP_BY,ANSI,STRICT_ALL_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION' */ ;
DELIMITER ;;
CREATE DEFINER="avnadmin"@"%" PROCEDURE "sp_TraCuuVe"(
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
END ;;
DELIMITER ;
/*!50003 SET sql_mode              = @saved_sql_mode */ ;
/*!50003 SET character_set_client  = @saved_cs_client */ ;
/*!50003 SET character_set_results = @saved_cs_results */ ;
/*!50003 SET collation_connection  = @saved_col_connection */ ;

--
-- Final view structure for view `view_DoanhThuToanDien`
--

/*!50001 DROP VIEW IF EXISTS `view_DoanhThuToanDien`*/;
/*!50001 SET @saved_cs_client          = @@character_set_client */;
/*!50001 SET @saved_cs_results         = @@character_set_results */;
/*!50001 SET @saved_col_connection     = @@collation_connection */;
/*!50001 SET character_set_client      = utf8mb4 */;
/*!50001 SET character_set_results     = utf8mb4 */;
/*!50001 SET collation_connection      = utf8mb4_0900_ai_ci */;
/*!50001 CREATE ALGORITHM=UNDEFINED */
/*!50013 DEFINER=`avnadmin`@`%` SQL SECURITY DEFINER */
/*!50001 VIEW `view_DoanhThuToanDien` AS select 'Bán Vé' AS `NguonDoanhThu`,month(`v`.`NgayGioDat`) AS `Thang`,year(`v`.`NgayGioDat`) AS `Nam`,count(`v`.`MaVe`) AS `SoLuongGiaoDich`,sum(`v`.`GiaVe`) AS `TongTien` from `DAT_VE` `v` where (`v`.`TrangThaiThanhToan` = 'Đã thanh toán') group by month(`v`.`NgayGioDat`),year(`v`.`NgayGioDat`) union all select 'Bán F&B' AS `NguonDoanhThu`,month(`f`.`NgayMua`) AS `Thang`,year(`f`.`NgayMua`) AS `Nam`,count(`f`.`MaCombo`) AS `SoLuongGiaoDich`,sum(`f`.`ThanhTien`) AS `TongTien` from `MUA_FNB` `f` group by month(`f`.`NgayMua`),year(`f`.`NgayMua`) */;
/*!50001 SET character_set_client      = @saved_cs_client */;
/*!50001 SET character_set_results     = @saved_cs_results */;
/*!50001 SET collation_connection      = @saved_col_connection */;
SET @@SESSION.SQL_LOG_BIN = @MYSQLDUMP_TEMP_LOG_BIN;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2026-10-25 21:06:24
