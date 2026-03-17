# Deck Frontend Use Cases

## Mục tiêu nghiệp vụ
Feature `deck` ở frontend giúp người dùng xem, quản lý và đi vào chi tiết nội dung học của từng bộ thẻ trong một thư mục cụ thể.

## Danh sách use case
| ID | Use case | Mục tiêu nghiệp vụ |
| --- | --- | --- |
| FE-DECK-001 | Xem danh sách deck | Cho người dùng thấy toàn bộ bộ thẻ thuộc thư mục hiện tại |
| FE-DECK-002 | Tạo deck mới | Cho người dùng thêm nhanh nội dung học mới |
| FE-DECK-003 | Chỉnh sửa hoặc xóa deck | Cho người dùng bảo trì thư viện hiện có |
| FE-DECK-004 | Mở một deck | Cho người dùng đi tới danh sách flashcard của deck đó |

## FE-DECK-001 - Xem danh sách deck
### Mục tiêu
Giúp người dùng biết trong thư mục hiện tại có những bộ thẻ nào.

### Luồng chính
1. Người dùng đi tới một thư mục lá.
2. Ứng dụng tải danh sách deck thuộc thư mục đó.
3. Ứng dụng hiển thị danh sách hoặc trạng thái rỗng nếu chưa có dữ liệu.
4. Người dùng có thể làm mới danh sách ngay tại chỗ.

## FE-DECK-002 - Tạo deck mới
### Mục tiêu
Giúp người dùng bổ sung một bộ nội dung học mới mà không rời màn hình đang xem.

### Luồng chính
1. Người dùng chọn tạo deck mới.
2. Ứng dụng mở hộp thoại nhập tên và mô tả.
3. Người dùng xác nhận tạo.
4. Ứng dụng gửi yêu cầu lên hệ thống.
5. Nếu thành công, danh sách deck được cập nhật lại.
6. Nếu thất bại, ứng dụng hiển thị lỗi tại chỗ.

## FE-DECK-003 - Chỉnh sửa hoặc xóa deck
### Mục tiêu
Cho phép người dùng duy trì nội dung thư viện theo thời gian.

### Luồng chính
1. Người dùng chọn sửa hoặc xóa trên một deck cụ thể.
2. Ứng dụng mở hộp thoại tương ứng.
3. Khi người dùng xác nhận, ứng dụng gửi yêu cầu lên hệ thống.
4. Ứng dụng cập nhật lại danh sách sau khi hệ thống phản hồi.

## FE-DECK-004 - Mở một deck
### Mục tiêu
Cho phép người dùng đi tiếp vào lớp dữ liệu học chi tiết là flashcard.

### Luồng chính
1. Người dùng chọn một deck trong danh sách.
2. Ứng dụng chuyển sang màn hình flashcard của deck đó.
3. Tên deck được mang theo để hiển thị ở màn hình kế tiếp.
