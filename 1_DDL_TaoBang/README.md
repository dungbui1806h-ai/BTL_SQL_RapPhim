# Phần 1 — Tạo bảng MySQL

File `1_CreateTables.sql` triển khai 15 bảng theo lược đồ quan hệ trong báo cáo phần 4 của nhóm. Yêu cầu MySQL 8.0.16 trở lên để thực thi các ràng buộc `CHECK`.

## Cách chạy

Trong MySQL Workbench: mở `1_CreateTables.sql`, kết nối MySQL và chạy toàn bộ file. Tài khoản cần quyền tạo cơ sở dữ liệu và bảng. Refresh mục Schemas, mở `QuanLyRapPhim` để xem kết quả.

Hoặc chạy từ thư mục gốc project:

```sh
mysql --default-character-set=utf8mb4 -u root -p < 1_DDL_TaoBang/1_CreateTables.sql
```

Kiểm tra sau khi chạy:

```sql
USE QuanLyRapPhim;
SHOW TABLES; -- Kết quả: 15 bảng
SHOW CREATE TABLE DAT_VE;
```

Script dành cho lần khởi tạo trên database chưa có các bảng này; không tự xóa dữ liệu và không phải script nâng cấp database. Chạy lại trên database đã tạo sẽ báo bảng tồn tại.

## Quy ước để ghép bài của nhóm

- Giữ nguyên tên bảng/cột trong script; dùng `USE QuanLyRapPhim;` ở đầu các file phần 2–4.
- Các mã là `VARCHAR(20)` do người nhập tự đặt, chẳng hạn `RAP01`, `PH01`, `SC01`, `KH01`; không tự tăng.
- Tiền dùng `DECIMAL`, số điện thoại và CCCD dùng chuỗi để giữ số 0 đầu. Văn bản dùng `utf8mb4` để lưu tiếng Việt.
- `LoaiPhong`: `2D`, `3D`, `IMAX`; `LoaiGhe`: `Thường`, `VIP`, `Sweetbox`.
- `GioiHanTuoi`: `G`, `PG`, `13+`, `18+`, theo báo cáo nhóm.
- Trạng thái suất chiếu: `Sắp chiếu`, `Đang chiếu`, `Đã kết thúc`; thanh toán: `Chờ thanh toán`, `Đã thanh toán`; ca làm: `Sáng`, `Chiều`, `Tối`.
- Giờ bắt đầu/kết thúc của suất chiếu nằm trong cùng ngày. Nếu cần suất qua nửa đêm, nhóm phải thống nhất bổ sung ngày kết thúc hoặc đổi sang `DATETIME` trước khi viết nghiệp vụ.
- `NgayMua` là `DATETIME(6)`, không phải chỉ ngày, để cùng khách có thể mua lại cùng combo trong ngày. Khóa vẫn là `(MaKH, MaCombo, NgayMua)` như báo cáo; hai giao dịch trùng cả ba giá trị sẽ bị từ chối.
- `NgaySinh` của khách được phép trống; kiểm tra độ tuổi khi mua vé cần xử lý ở phần 3.
- Khóa ngoại dùng `RESTRICT` để không tự xóa/sửa dây chuyền dữ liệu liên quan.

Thứ tự nhập dữ liệu: `CUM_RAP`, `PHIM`, `KHACH_HANG`, `DICH_VU_FNB` trước; tiếp đến `PHONG_CHIEU`, `NHAN_VIEN`, các bảng thể loại/diễn viên; sau đó `GHE_NGOI`, `SUAT_CHIEU`, ba bảng chức danh; cuối cùng `MUA_FNB`, `DAT_VE`.

## Ràng buộc đã có trong phần 1

Khóa chính cho đủ 15 bảng; khóa ghép của ghế, thuộc tính đa trị và mua F&B; số điện thoại khách và CCCD nhân viên duy nhất; khóa ngoại giữa các bảng; kiểm tra giá trị tiền/điểm không âm, số lượng/thời lượng dương và các miền trạng thái.

`UNIQUE (MaSuatChieu, MaPhong, SoGhe)` chặn bán trùng chỗ, kể cả vé chờ thanh toán. Khóa ngoại ghép `(MaSuatChieu, MaPhong)` bảo đảm ghế thuộc đúng phòng của suất chiếu. Đây là bổ sung ràng buộc trên các cột sẵn có trong báo cáo.

## Bàn giao cho phần 3 và các giới hạn của thiết kế

- Procedure/transaction cần bảo đảm mỗi nhân viên có đúng một bản ghi trong ba bảng chức danh; các FK 1:1 riêng lẻ chưa bảo đảm tính rời rạc và toàn phần.
- Kiểm tra lịch chiếu không chồng nhau, có ít nhất 15 phút dọn phòng; thời lượng suất phù hợp với phim. Khi có giao dịch đồng thời cần khóa phù hợp, không chỉ truy vấn kiểm tra rồi chèn.
- Kiểm tra tuổi khách tại thời điểm mua; tính giá vé, thành tiền F&B và điểm tích lũy; đồng bộ `TongSoGhe` với số ghế thực tế.
- Việc giữ chỗ khi người dùng mới chọn ghế, hết hạn giữ chỗ và hủy/hoàn vé chưa có mô hình riêng. Unique chỉ giữ chỗ sau khi có bản ghi `DAT_VE`.
- Báo cáo phần 4 chưa có mã nhân viên xuất vé, rạp bán F&B, lịch sử ca làm hoặc trạng thái ngưng chiếu của phim. Cần thống nhất bổ sung nếu phần 3–4 yêu cầu thống kê theo các thông tin này. Không thể suy ra rạp bán F&B chỉ từ khách và combo.
- Giữ cấu trúc báo cáo để ghép bài. Riêng `DAT_VE` lưu cả `MaSuatChieu` và `MaPhong`, trong khi suất chiếu xác định phòng; nhóm cần rà lại tuyên bố đạt 3NF trong báo cáo. Khóa ngoại ghép giữ nhất quán dữ liệu nhưng không loại bỏ sự dư thừa này.

Đề cương môn học ghi SQL Server; bản triển khai này dùng MySQL theo lựa chọn của bạn. Nếu nhóm phải nộp SQL Server, cần chuyển cú pháp và kiểm thử lại trên hệ quản trị đó.
