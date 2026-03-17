# Deck Backend Use Cases

## Mục tiêu nghiệp vụ
Feature `deck` quản lý các bộ thẻ học nằm trong thư mục lá, bảo đảm người dùng có thể tổ chức nội dung học theo từng chủ đề rõ ràng.

## Danh sách use case
| ID | Use case | Mục tiêu nghiệp vụ |
| --- | --- | --- |
| BE-DECK-001 | Tạo bộ thẻ học | Cho phép người dùng thêm một bộ nội dung mới vào thư viện |
| BE-DECK-002 | Xem danh sách bộ thẻ học | Cho phép người dùng duyệt các bộ thẻ trong một thư mục |
| BE-DECK-003 | Cập nhật bộ thẻ học | Cho phép người dùng đổi tên và mô tả bộ thẻ |
| BE-DECK-004 | Xóa bộ thẻ học | Loại bỏ một bộ thẻ không còn sử dụng |
| BE-DECK-005 | Import bộ thẻ học | Nạp nhanh nhiều bộ thẻ và thẻ học từ file |

## BE-DECK-001 - Tạo bộ thẻ học
### Mục tiêu
Cho phép người dùng tạo một deck mới trong đúng vị trí hợp lệ của thư viện.

### Tiền điều kiện
- Thư mục đích phải tồn tại.
- Thư mục đích không được có thư mục con.

### Luồng chính
1. Hệ thống xác định thư mục đích.
2. Hệ thống kiểm tra thư mục đó có đủ điều kiện chứa deck.
3. Hệ thống kiểm tra tên deck chưa bị trùng trong cùng thư mục.
4. Hệ thống tạo deck mới.
5. Hệ thống trả thông tin deck vừa tạo.

### Quy tắc nghiệp vụ
- Tên deck phải là duy nhất trong cùng một thư mục.
- Deck chỉ được tạo ở thư mục lá.

## BE-DECK-002 - Xem danh sách bộ thẻ học
### Mục tiêu
Cho phép người dùng xem các deck thuộc một thư mục cụ thể.

### Luồng chính
1. Hệ thống nhận thư mục cần xem.
2. Hệ thống lọc deck theo từ khóa nếu có.
3. Hệ thống sắp xếp danh sách theo điều kiện được yêu cầu.
4. Hệ thống trả danh sách deck.

## BE-DECK-003 - Cập nhật bộ thẻ học
### Mục tiêu
Cho phép người dùng điều chỉnh tên và mô tả của deck.

### Luồng chính
1. Hệ thống xác định deck cần cập nhật.
2. Hệ thống kiểm tra deck đó thuộc đúng thư mục được yêu cầu.
3. Hệ thống kiểm tra tên mới không bị trùng.
4. Hệ thống lưu thay đổi.
5. Hệ thống trả thông tin mới nhất của deck.

## BE-DECK-004 - Xóa bộ thẻ học
### Mục tiêu
Cho phép người dùng loại bỏ một deck khỏi thư viện đang sử dụng.

### Hậu điều kiện
- Deck không còn xuất hiện trong danh sách hoạt động.

### Luồng chính
1. Hệ thống xác định deck cần xóa.
2. Hệ thống xóa mềm deck.
3. Hệ thống xác nhận thao tác thành công.

## BE-DECK-005 - Import bộ thẻ học
### Mục tiêu
Giúp người dùng nạp nhanh dữ liệu học tập từ nguồn ngoài vào hệ thống.

### Luồng chính
1. Người dùng cung cấp file import cho một thư mục đích.
2. Hệ thống đọc và phân tích nội dung file.
3. Hệ thống tạo mới các deck chưa tồn tại.
4. Hệ thống nạp các flashcard tương ứng vào từng deck.
5. Hệ thống cập nhật số lượng thẻ của mỗi deck.
6. Hệ thống trả báo cáo import.

### Luồng ngoại lệ
1. File sai định dạng hoặc không đọc được.
2. Không thể đối chiếu deck sau import.
