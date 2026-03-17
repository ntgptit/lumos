# Deck Frontend Wireframe

## Mục tiêu màn hình
Màn hình `deck` cần giúp người dùng nhanh chóng nhận biết thư mục hiện tại có những bộ thẻ nào, đồng thời hỗ trợ tạo mới và bảo trì dữ liệu ngay trên cùng một không gian làm việc.

## Cấu trúc màn hình
| Khu vực | Vị trí | Mục đích nghiệp vụ | Nội dung chính | Hành vi |
| --- | --- | --- | --- | --- |
| Vùng cảnh báo | Đầu danh sách, khi cần | Báo lỗi thao tác tạo, sửa hoặc xóa | Thông báo ngắn gọn | Chỉ hiện khi phát sinh lỗi |
| Danh sách deck | Khu vực nội dung chính | Hiển thị các bộ thẻ hiện có | Tên, mô tả, số lượng thẻ, action trên từng dòng | Cho phép mở, sửa, xóa |
| Trạng thái rỗng | Thay cho danh sách khi chưa có dữ liệu | Hướng dẫn người dùng tạo deck đầu tiên | Thông điệp và chỉ dẫn | Hiện khi danh sách trống |
| Nút tạo nhanh | Góc dưới màn hình | Tạo deck mới | CTA nổi bật | Mở hộp thoại tạo deck |
| Lớp phủ đang xử lý | Phủ nội dung khi cần | Ngăn thao tác trùng lặp | Loading overlay | Hiện khi đang tạo, sửa hoặc xóa |

## Quy tắc hiển thị
- Danh sách deck là trọng tâm của màn hình.
- Nút tạo phải luôn dễ nhìn thấy.
- Khi có lỗi nghiệp vụ, lỗi cần xuất hiện ở đầu màn hình thay vì ẩn trong hộp thoại.

## Trạng thái cần hỗ trợ
- Có dữ liệu.
- Không có dữ liệu.
- Đang làm mới.
- Đang xử lý thao tác cập nhật.
- Có lỗi sau thao tác.
