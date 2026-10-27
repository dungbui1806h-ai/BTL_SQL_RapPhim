USE QuanLyRapPhim;

-- 1. Cß╗ñM Rß║áP (10 Cß╗Ñm rß║íp)
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
        '─Éiß╗çn Bi├¬n Phß╗º',
        'B├¼nh Thß║ính',
        'TP. Hß╗ô Ch├¡ Minh',
        '02839991001'
    ),
    (
        'RAP02',
        'Lotte Cinema Cantavil',
        '01',
        'Song H├ánh',
        'TP. Thß╗º ─Éß╗⌐c',
        'TP. Hß╗ô Ch├¡ Minh',
        '02837402002'
    ),
    (
        'RAP03',
        'Galaxy Nguyß╗àn Du',
        '116',
        'Nguyß╗àn Du',
        'Quß║¡n 1',
        'TP. Hß╗ô Ch├¡ Minh',
        '02838235003'
    ),
    (
        'RAP04',
        'CGV Vincom B├á Triß╗çu',
        '191',
        'B├á Triß╗çu',
        'Hai B├á Tr╞░ng',
        'H├á Nß╗Öi',
        '02439741004'
    ),
    (
        'RAP05',
        'Trung t├óm Chiß║┐u phim Quß╗æc gia',
        '87',
        'L├íng Hß║í',
        'Ba ─É├¼nh',
        'H├á Nß╗Öi',
        '02435141005'
    ),
    (
        'RAP06',
        'BHD Star Thß║úo ─Éiß╗ün',
        '159',
        'Xa Lß╗Ö H├á Nß╗Öi',
        'TP. Thß╗º ─Éß╗⌐c',
        'TP. Hß╗ô Ch├¡ Minh',
        '02837446006'
    ),
    (
        'RAP07',
        'Starlight ─É├á Nß║╡ng',
        '46',
        'Nguyß╗àn V─ân Linh',
        'Hß║úi Ch├óu',
        '─É├á Nß║╡ng',
        '02363588007'
    ),
    (
        'RAP08',
        'Lotte Cinema Nha Trang',
        '58',
        '23 Th├íng 10',
        'Nha Trang',
        'Kh├ính H├▓a',
        '02583812008'
    ),
    (
        'RAP09',
        'CGV Vincom Cß║ºn Th╞í',
        '209',
        '30 Th├íng 4',
        'Ninh Kiß╗üu',
        'Cß║ºn Th╞í',
        '02923739009'
    ),
    (
        'RAP10',
        'Beta Cinema Quang Trung',
        '645',
        'Quang Trung',
        'G├▓ Vß║Ñp',
        'TP. Hß╗ô Ch├¡ Minh',
        '02835894010'
    );

-- 2. PH├ÆNG CHIß║╛U (10 Ph├▓ng)
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
        'Ph├▓ng IMAX 1',
        'IMAX',
        120,
        'RAP01'
    ),
    (
        'PH02',
        'Ph├▓ng Cinema 2',
        '2D',
        90,
        'RAP01'
    ),
    (
        'PH03',
        'Ph├▓ng 3D GoldClass',
        '3D',
        80,
        'RAP01'
    ),
    (
        'PH04',
        'Ph├▓ng Cinema 1',
        '2D',
        100,
        'RAP02'
    ),
    (
        'PH05',
        'Ph├▓ng 3D Prime',
        '3D',
        85,
        'RAP02'
    ),
    (
        'PH06',
        'Ph├▓ng Cinema 1',
        '2D',
        110,
        'RAP03'
    ),
    (
        'PH07',
        'Ph├▓ng IMAX Laser',
        'IMAX',
        130,
        'RAP04'
    ),
    (
        'PH08',
        'Ph├▓ng Cinema 2',
        '2D',
        95,
        'RAP04'
    ),
    (
        'PH09',
        'Ph├▓ng Cinema 1',
        '2D',
        120,
        'RAP05'
    ),
    (
        'PH10',
        'Ph├▓ng 3D Premium',
        '3D',
        75,
        'RAP06'
    );

-- 3. PHIM (10 Phim chiß║┐u rß║íp thß╗▒c tß║┐)
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
        'Trß║Ñn Th├ánh',
        131,
        '2024-02-10',
        '18+'
    ),
    (
        'P02',
        'Lß║¡t Mß║╖t 7: Mß╗Öt ─Éiß╗üu ╞»ß╗¢c',
        'L├╜ Hß║úi',
        138,
        '2024-04-26',
        'PG'
    ),
    (
        'P03',
        'Dune: H├ánh Tinh C├ít - Phß║ºn 2',
        'Denis Villeneuve',
        166,
        '2024-03-01',
        '13+'
    ),
    (
        'P04',
        'Godzilla x Kong: ─Éß║┐ Chß║┐ Mß╗¢i',
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
        'Quß║¡t Mß╗Ö Tr├╣ng Ph├╣ng (Exhuma)',
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
        '─É├áo, Phß╗ƒ V├á Piano',
        'Phi Tiß║┐n S╞ín',
        100,
        '2024-02-10',
        '13+'
    ),
    (
        'P10',
        'Vua S╞░ Tß╗¡ (Mufasa: The Lion King)',
        'Barry Jenkins',
        118,
        '2024-12-20',
        'G'
    );

-- 4. PHIM_THE_LOAI (Danh mß╗Ñc thß╗â loß║íi phim)
INSERT INTO
    PHIM_THE_LOAI (MaPhim, TheLoai)
VALUES ('P01', 'T├óm L├╜'),
    ('P01', 'T├¼nh Cß║úm'),
    ('P02', 'Gia ─É├¼nh'),
    ('P02', 'T├óm L├╜'),
    ('P03', 'Khoa Hß╗ìc Viß╗àn T╞░ß╗ƒng'),
    ('P03', 'H├ánh ─Éß╗Öng'),
    ('P04', 'H├ánh ─Éß╗Öng'),
    ('P04', 'Phi├¬u L╞░u'),
    ('P05', 'Hoß║ít H├¼nh'),
    ('P05', 'H├ái H╞░ß╗¢c'),
    ('P06', 'Kinh Dß╗ï'),
    ('P06', 'B├¡ ß║¿n'),
    ('P07', 'Hoß║ít H├¼nh'),
    ('P07', 'Gia ─É├¼nh'),
    ('P08', 'H├ánh ─Éß╗Öng'),
    ('P08', 'H├ái H╞░ß╗¢c'),
    ('P09', 'Lß╗ïch Sß╗¡'),
    ('P09', 'Chiß║┐n Tranh'),
    ('P10', 'Hoß║ít H├¼nh'),
    ('P10', 'Phi├¬u L╞░u');

-- 5. PHIM_DIEN_VIEN (Danh mß╗Ñc diß╗àn vi├¬n)
INSERT INTO
    PHIM_DIEN_VIEN (MaPhim, DienVien)
VALUES ('P01', 'Ph╞░╞íng Anh ─É├áo'),
    ('P01', 'Tuß║Ñn Trß║ºn'),
    ('P02', '─Éinh Y Nhung'),
    ('P02', 'Qu├ích Ngß╗ìc Tuy├¬n'),
    ('P03', 'Timoth├⌐e Chalamet'),
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
    ('P09', 'Do├ún Quß╗æc ─Éam'),
    ('P09', 'Cao Th├╣y Linh');

-- 6. GHß║╛ NGß╗ÆI (Mß║½u s╞í ─æß╗ô ghß║┐ cho c├íc ph├▓ng)
INSERT INTO
    GHE_NGOI (
        MaPhong,
        SoGhe,
        LoaiGhe,
        PhuThuGhe
    )
VALUES
    -- Ph├▓ng PH01
    ('PH01', 'A1', 'Th╞░ß╗¥ng', 0.00),
    ('PH01', 'A2', 'Th╞░ß╗¥ng', 0.00),
    ('PH01', 'A3', 'Th╞░ß╗¥ng', 0.00),
    ('PH01', 'A4', 'Th╞░ß╗¥ng', 0.00),
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
    -- Ph├▓ng PH02
    ('PH02', 'A1', 'Th╞░ß╗¥ng', 0.00),
    ('PH02', 'A2', 'Th╞░ß╗¥ng', 0.00),
    ('PH02', 'B1', 'VIP', 10000.00),
    ('PH02', 'B2', 'VIP', 10000.00),
    -- Ph├▓ng PH04
    ('PH04', 'A1', 'Th╞░ß╗¥ng', 0.00),
    ('PH04', 'A2', 'Th╞░ß╗¥ng', 0.00),
    ('PH04', 'B1', 'VIP', 10000.00),
    ('PH04', 'B2', 'VIP', 10000.00),
    -- Ph├▓ng PH07
    ('PH07', 'A1', 'Th╞░ß╗¥ng', 0.00),
    ('PH07', 'A2', 'Th╞░ß╗¥ng', 0.00),
    ('PH07', 'B1', 'VIP', 20000.00),
    ('PH07', 'B2', 'VIP', 20000.00);

-- 7. KH├üCH H├ÇNG (10 Kh├ích h├áng)
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
        'Nguyß╗àn V─ân An',
        '0903123456',
        'an.nguyen@gmail.com',
        '1995-05-15',
        120
    ),
    (
        'KH02',
        'Trß║ºn Thß╗ï B├¼nh',
        '0918234567',
        'binh.tran@yahoo.com',
        '1998-11-20',
        450
    ),
    (
        'KH03',
        'L├¬ Ho├áng C╞░ß╗¥ng',
        '0937345678',
        'cuong.le@gmail.com',
        '1990-03-10',
        800
    ),
    (
        'KH04',
        'Phß║ím Minh ─Éß╗⌐c',
        '0946456789',
        'duc.pham@outlook.com',
        '2001-08-25',
        50
    ),
    (
        'KH05',
        'Ho├áng Th├╣y D╞░╞íng',
        '0985567890',
        'duong.hoang@gmail.com',
        '1997-12-05',
        300
    ),
    (
        'KH06',
        'V┼⌐ Tiß║┐n ─Éß║ít',
        '0976678901',
        'dat.vu@gmail.com',
        '2000-01-30',
        0
    ),
    (
        'KH07',
        '─Éß║╖ng Ph╞░╞íng Thß║úo',
        '0967789012',
        'thao.dang@gmail.com',
        '1996-07-14',
        210
    ),
    (
        'KH08',
        'B├╣i Anh Tuß║Ñn',
        '0928890123',
        'tuan.bui@gmail.com',
        '1993-09-09',
        620
    ),
    (
        'KH09',
        '─Éß╗ù Mai H╞░╞íng',
        '0909901234',
        'huong.do@gmail.com',
        '2002-04-18',
        90
    ),
    (
        'KH10',
        'Ng├┤ Quß╗æc Kh├ính',
        '0917012345',
        'khanh.ngo@gmail.com',
        '1989-10-12',
        1100
    );

-- 8. Dß╗èCH Vß╗ñ F&B (10 Combo / Sß║ún phß║⌐m)
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
        '1 Bß║»p ngß╗ìt vß╗½a + 1 N╞░ß╗¢c ngß╗ìt lß╗¢n',
        89000.00
    ),
    (
        'CB02',
        'Combo Couple',
        '1 Bß║»p lß╗¢n + 2 N╞░ß╗¢c ngß╗ìt lß╗¢n',
        119000.00
    ),
    (
        'CB03',
        'Combo Family',
        '2 Bß║»p lß╗¢n + 4 N╞░ß╗¢c ngß╗ìt lß╗¢n + 1 Snack',
        229000.00
    ),
    (
        'CB04',
        'Combo Party',
        '3 Bß║»p lß╗¢n + 3 N╞░ß╗¢c lß╗¢n + 2 Chß║ú gi├▓',
        289000.00
    ),
    (
        'CB05',
        'Bß║»p Rang Ph├┤ Mai',
        'Bß║»p rang b╞í vß╗ï ph├┤ mai size L',
        69000.00
    ),
    (
        'CB06',
        'Bß║»p Rang Caramel',
        'Bß║»p rang b╞í vß╗ï caramel size L',
        69000.00
    ),
    (
        'CB07',
        'Pepsi Lß╗¢n',
        'N╞░ß╗¢c ngß╗ìt Pepsi ly 32oz',
        39000.00
    ),
    (
        'CB08',
        'Coca Cola Lß╗¢n',
        'N╞░ß╗¢c ngß╗ìt Coca ly 32oz',
        39000.00
    ),
    (
        'CB09',
        'Snack Khoai T├óy',
        'G├│i snack khoai t├óy Lay\'s 90g',
        29000.00
    ),
    (
        'CB10',
        'Hotdog Ph├┤ Mai',
        'B├ính m├¼ hotdog kß║╣p xß╗æt ph├┤ mai n├│ng',
        49000.00
    );

-- 9. NH├éN VI├èN (10 Nh├ón vi├¬n)
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
        'Nguyß╗àn V─ân H├╣ng',
        '1988-03-12',
        '012345678901',
        '0901111222',
        18000000.00,
        '2018-01-15',
        'RAP01'
    ),
    (
        'NV02',
        'Trß║ºn Thß╗ï Mai',
        '1992-07-24',
        '012345678902',
        '0901111223',
        15000000.00,
        '2019-05-20',
        'RAP02'
    ),
    (
        'NV03',
        'L├¬ V─ân Nam',
        '1990-11-05',
        '012345678903',
        '0901111224',
        16000000.00,
        '2020-03-10',
        'RAP03'
    ),
    (
        'NV04',
        'Phß║ím Thß╗ï Hoa',
        '2001-02-18',
        '012345678904',
        '0901111225',
        7500000.00,
        '2022-06-01',
        'RAP01'
    ),
    (
        'NV05',
        'Ho├áng V─ân Tuß║Ñn',
        '2002-09-09',
        '012345678905',
        '0901111226',
        7500000.00,
        '2022-08-15',
        'RAP01'
    ),
    (
        'NV06',
        'V┼⌐ Thu Trang',
        '2000-12-12',
        '012345678906',
        '0901111227',
        8000000.00,
        '2023-01-10',
        'RAP02'
    ),
    (
        'NV07',
        '─Éß║╖ng Minh Qu├ón',
        '1999-04-05',
        '012345678907',
        '0901111228',
        7800000.00,
        '2023-03-01',
        'RAP03'
    ),
    (
        'NV08',
        'B├╣i Tiß║┐n D┼⌐ng',
        '1995-08-19',
        '012345678908',
        '0901111229',
        10500000.00,
        '2021-09-01',
        'RAP01'
    ),
    (
        'NV09',
        'Ng├┤ Bß║úo Ngß╗ìc',
        '1996-01-22',
        '012345678909',
        '0901111230',
        10000000.00,
        '2021-11-15',
        'RAP02'
    ),
    (
        'NV10',
        'L├╜ V─ân Hß║úi',
        '1994-06-30',
        '012345678910',
        '0901111231',
        11000000.00,
        '2020-10-01',
        'RAP04'
    );

-- 10. PH├éN LOß║áI NH├éN VI├èN (1:1 vß╗¢i NHAN_VIEN)
INSERT INTO
    NV_QUAN_LY (
        MaNV,
        HeSoTrachNhiem,
        QuyenHan
    )
VALUES (
        'NV01',
        1.50,
        'Quß║ún l├╜ to├án bß╗Ö cß╗Ñm rß║íp RAP01'
    ),
    (
        'NV02',
        1.30,
        'Quß║ún l├╜ to├án bß╗Ö cß╗Ñm rß║íp RAP02'
    ),
    (
        'NV03',
        1.30,
        'Quß║ún l├╜ to├án bß╗Ö cß╗Ñm rß║íp RAP03'
    );

INSERT INTO
    NV_BAN_HANG (MaNV, CaLamViec, DoanhSoThang)
VALUES ('NV04', 'S├íng', 25000000.00),
    ('NV05', 'Chiß╗üu', 32000000.00),
    ('NV06', 'Tß╗æi', 41000000.00),
    ('NV07', 'Tß╗æi', 38000000.00);

INSERT INTO
    NV_KY_THUAT (
        MaNV,
        ChungChiKyThuat,
        KhuVucPhuTrach
    )
VALUES (
        'NV08',
        'Chß╗⌐ng chß╗ë M├íy chiß║┐u IMAX Digital 2022',
        'Ph├▓ng m├íy PH01-PH03'
    ),
    (
        'NV09',
        'Chß╗⌐ng chß╗ë ├ém thanh Dolby Atmos',
        'Ph├▓ng m├íy PH04-PH05'
    ),
    (
        'NV10',
        'Chß╗⌐ng chß╗ë M├íy chiß║┐u Laser 4K',
        'Ph├▓ng m├íy PH07-PH08'
    );
