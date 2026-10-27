# Phß║ºn 1 ΓÇö Tß║ío bß║úng MySQL

File `1_CreateTables.sql` triß╗ân khai 15 bß║úng theo l╞░ß╗úc ─æß╗ô quan hß╗ç trong b├ío c├ío phß║ºn 4 cß╗ºa nh├│m. Y├¬u cß║ºu MySQL 8.0.16 trß╗ƒ l├¬n ─æß╗â thß╗▒c thi c├íc r├áng buß╗Öc `CHECK`.

## C├ích chß║íy

Trong MySQL Workbench: mß╗ƒ `1_CreateTables.sql`, kß║┐t nß╗æi MySQL v├á chß║íy to├án bß╗Ö file. T├ái khoß║ún cß║ºn quyß╗ün tß║ío c╞í sß╗ƒ dß╗» liß╗çu v├á bß║úng. Refresh mß╗Ñc Schemas, mß╗ƒ `QuanLyRapPhim` ─æß╗â xem kß║┐t quß║ú.

Hoß║╖c chß║íy tß╗½ th╞░ mß╗Ñc gß╗æc project:

```sh
mysql --default-character-set=utf8mb4 -u root -p < 1_DDL_TaoBang/1_CreateTables.sql
```

Kiß╗âm tra sau khi chß║íy:

```sql
USE QuanLyRapPhim;
SHOW TABLES; -- Kß║┐t quß║ú: 15 bß║úng
SHOW CREATE TABLE DAT_VE;
```

Script d├ánh cho lß║ºn khß╗ƒi tß║ío tr├¬n database ch╞░a c├│ c├íc bß║úng n├áy; kh├┤ng tß╗▒ x├│a dß╗» liß╗çu v├á kh├┤ng phß║úi script n├óng cß║Ñp database. Chß║íy lß║íi tr├¬n database ─æ├ú tß║ío sß║╜ b├ío bß║úng tß╗ôn tß║íi.

## Quy ╞░ß╗¢c ─æß╗â gh├⌐p b├ái cß╗ºa nh├│m

- Giß╗» nguy├¬n t├¬n bß║úng/cß╗Öt trong script; d├╣ng `USE QuanLyRapPhim;` ß╗ƒ ─æß║ºu c├íc file phß║ºn 2ΓÇô4.
- C├íc m├ú l├á `VARCHAR(20)` do ng╞░ß╗¥i nhß║¡p tß╗▒ ─æß║╖t, chß║│ng hß║ín `RAP01`, `PH01`, `SC01`, `KH01`; kh├┤ng tß╗▒ t─âng.
- Tiß╗ün d├╣ng `DECIMAL`, sß╗æ ─æiß╗çn thoß║íi v├á CCCD d├╣ng chuß╗ùi ─æß╗â giß╗» sß╗æ 0 ─æß║ºu. V─ân bß║ún d├╣ng `utf8mb4` ─æß╗â l╞░u tiß║┐ng Viß╗çt.
- `LoaiPhong`: `2D`, `3D`, `IMAX`; `LoaiGhe`: `Th╞░ß╗¥ng`, `VIP`, `Sweetbox`.
- `GioiHanTuoi`: `G`, `PG`, `13+`, `18+`, theo b├ío c├ío nh├│m.
- Trß║íng th├íi suß║Ñt chiß║┐u: `Sß║»p chiß║┐u`, `─Éang chiß║┐u`, `─É├ú kß║┐t th├║c`; thanh to├ín: `Chß╗¥ thanh to├ín`, `─É├ú thanh to├ín`; ca l├ám: `S├íng`, `Chiß╗üu`, `Tß╗æi`.
- Giß╗¥ bß║»t ─æß║ºu/kß║┐t th├║c cß╗ºa suß║Ñt chiß║┐u nß║▒m trong c├╣ng ng├áy. Nß║┐u cß║ºn suß║Ñt qua nß╗¡a ─æ├¬m, nh├│m phß║úi thß╗æng nhß║Ñt bß╗ò sung ng├áy kß║┐t th├║c hoß║╖c ─æß╗òi sang `DATETIME` tr╞░ß╗¢c khi viß║┐t nghiß╗çp vß╗Ñ.
- `NgayMua` l├á `DATETIME(6)`, kh├┤ng phß║úi chß╗ë ng├áy, ─æß╗â c├╣ng kh├ích c├│ thß╗â mua lß║íi c├╣ng combo trong ng├áy. Kh├│a vß║½n l├á `(MaKH, MaCombo, NgayMua)` nh╞░ b├ío c├ío; hai giao dß╗ïch tr├╣ng cß║ú ba gi├í trß╗ï sß║╜ bß╗ï tß╗½ chß╗æi.
- `NgaySinh` cß╗ºa kh├ích ─æ╞░ß╗úc ph├⌐p trß╗æng; kiß╗âm tra ─æß╗Ö tuß╗òi khi mua v├⌐ cß║ºn xß╗¡ l├╜ ß╗ƒ phß║ºn 3.
- Kh├│a ngoß║íi d├╣ng `RESTRICT` ─æß╗â kh├┤ng tß╗▒ x├│a/sß╗¡a d├óy chuyß╗ün dß╗» liß╗çu li├¬n quan.

Thß╗⌐ tß╗▒ nhß║¡p dß╗» liß╗çu: `CUM_RAP`, `PHIM`, `KHACH_HANG`, `DICH_VU_FNB` tr╞░ß╗¢c; tiß║┐p ─æß║┐n `PHONG_CHIEU`, `NHAN_VIEN`, c├íc bß║úng thß╗â loß║íi/diß╗àn vi├¬n; sau ─æ├│ `GHE_NGOI`, `SUAT_CHIEU`, ba bß║úng chß╗⌐c danh; cuß╗æi c├╣ng `MUA_FNB`, `DAT_VE`.

## R├áng buß╗Öc ─æ├ú c├│ trong phß║ºn 1

Kh├│a ch├¡nh cho ─æß╗º 15 bß║úng; kh├│a gh├⌐p cß╗ºa ghß║┐, thuß╗Öc t├¡nh ─æa trß╗ï v├á mua F&B; sß╗æ ─æiß╗çn thoß║íi kh├ích v├á CCCD nh├ón vi├¬n duy nhß║Ñt; kh├│a ngoß║íi giß╗»a c├íc bß║úng; kiß╗âm tra gi├í trß╗ï tiß╗ün/─æiß╗âm kh├┤ng ├óm, sß╗æ l╞░ß╗úng/thß╗¥i l╞░ß╗úng d╞░╞íng v├á c├íc miß╗ün trß║íng th├íi.

`UNIQUE (MaSuatChieu, MaPhong, SoGhe)` chß║╖n b├ín tr├╣ng chß╗ù, kß╗â cß║ú v├⌐ chß╗¥ thanh to├ín. Kh├│a ngoß║íi gh├⌐p `(MaSuatChieu, MaPhong)` bß║úo ─æß║úm ghß║┐ thuß╗Öc ─æ├║ng ph├▓ng cß╗ºa suß║Ñt chiß║┐u. ─É├óy l├á bß╗ò sung r├áng buß╗Öc tr├¬n c├íc cß╗Öt sß║╡n c├│ trong b├ío c├ío.

## B├án giao cho phß║ºn 3 v├á c├íc giß╗¢i hß║ín cß╗ºa thiß║┐t kß║┐

- Procedure/transaction cß║ºn bß║úo ─æß║úm mß╗ùi nh├ón vi├¬n c├│ ─æ├║ng mß╗Öt bß║ún ghi trong ba bß║úng chß╗⌐c danh; c├íc FK 1:1 ri├¬ng lß║╗ ch╞░a bß║úo ─æß║úm t├¡nh rß╗¥i rß║íc v├á to├án phß║ºn.
- Kiß╗âm tra lß╗ïch chiß║┐u kh├┤ng chß╗ông nhau, c├│ ├¡t nhß║Ñt 15 ph├║t dß╗ìn ph├▓ng; thß╗¥i l╞░ß╗úng suß║Ñt ph├╣ hß╗úp vß╗¢i phim. Khi c├│ giao dß╗ïch ─æß╗ông thß╗¥i cß║ºn kh├│a ph├╣ hß╗úp, kh├┤ng chß╗ë truy vß║Ñn kiß╗âm tra rß╗ôi ch├¿n.
- Kiß╗âm tra tuß╗òi kh├ích tß║íi thß╗¥i ─æiß╗âm mua; t├¡nh gi├í v├⌐, th├ánh tiß╗ün F&B v├á ─æiß╗âm t├¡ch l┼⌐y; ─æß╗ông bß╗Ö `TongSoGhe` vß╗¢i sß╗æ ghß║┐ thß╗▒c tß║┐.
- Viß╗çc giß╗» chß╗ù khi ng╞░ß╗¥i d├╣ng mß╗¢i chß╗ìn ghß║┐, hß║┐t hß║ín giß╗» chß╗ù v├á hß╗ºy/ho├án v├⌐ ch╞░a c├│ m├┤ h├¼nh ri├¬ng. Unique chß╗ë giß╗» chß╗ù sau khi c├│ bß║ún ghi `DAT_VE`.
- B├ío c├ío phß║ºn 4 ch╞░a c├│ m├ú nh├ón vi├¬n xuß║Ñt v├⌐, rß║íp b├ín F&B, lß╗ïch sß╗¡ ca l├ám hoß║╖c trß║íng th├íi ng╞░ng chiß║┐u cß╗ºa phim. Cß║ºn thß╗æng nhß║Ñt bß╗ò sung nß║┐u phß║ºn 3ΓÇô4 y├¬u cß║ºu thß╗æng k├¬ theo c├íc th├┤ng tin n├áy. Kh├┤ng thß╗â suy ra rß║íp b├ín F&B chß╗ë tß╗½ kh├ích v├á combo.
- Giß╗» cß║Ñu tr├║c b├ío c├ío ─æß╗â gh├⌐p b├ái. Ri├¬ng `DAT_VE` l╞░u cß║ú `MaSuatChieu` v├á `MaPhong`, trong khi suß║Ñt chiß║┐u x├íc ─æß╗ïnh ph├▓ng; nh├│m cß║ºn r├á lß║íi tuy├¬n bß╗æ ─æß║ít 3NF trong b├ío c├ío. Kh├│a ngoß║íi gh├⌐p giß╗» nhß║Ñt qu├ín dß╗» liß╗çu nh╞░ng kh├┤ng loß║íi bß╗Å sß╗▒ d╞░ thß╗½a n├áy.

─Éß╗ü c╞░╞íng m├┤n hß╗ìc ghi SQL Server; bß║ún triß╗ân khai n├áy d├╣ng MySQL theo lß╗▒a chß╗ìn cß╗ºa bß║ín. Nß║┐u nh├│m phß║úi nß╗Öp SQL Server, cß║ºn chuyß╗ân c├║ ph├íp v├á kiß╗âm thß╗¡ lß║íi tr├¬n hß╗ç quß║ún trß╗ï ─æ├│.
