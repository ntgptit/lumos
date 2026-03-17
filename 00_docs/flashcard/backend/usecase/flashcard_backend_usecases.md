# Flashcard Backend Use Cases

## Mục tiêu nghiệp vụ
Feature `flashcard` quản lý từng đơn vị kiến thức trong một deck, bảo đảm nội dung học có thể được tạo mới, cập nhật, xem lại và loại bỏ khi không còn phù hợp.

## Danh sách use case
| ID | Use case | Mục tiêu nghiệp vụ |
| --- | --- | --- |
| BE-FLASHCARD-001 | Tạo flashcard | Bổ sung một đơn vị kiến thức mới vào deck |
| BE-FLASHCARD-002 | Xem danh sách flashcard | Cho phép người dùng duyệt nội dung học của một deck |
| BE-FLASHCARD-003 | Cập nhật flashcard | Cho phép người dùng chỉnh sửa nội dung đã lưu |
| BE-FLASHCARD-004 | Xóa flashcard | Loại bỏ một đơn vị kiến thức khỏi deck |

## BE-FLASHCARD-001 - Tạo flashcard
### Mục tiêu
Cho phép người dùng thêm một cặp nội dung học mới vào deck.

### Tác nhân
- Người dùng quản lý nội dung học.

### Tiền điều kiện
- Deck đích phải tồn tại.

### Hậu điều kiện
- Flashcard mới được thêm vào deck.
- Số lượng thẻ của deck được cập nhật.

### Luồng chính
1. Hệ thống nhận nội dung mặt trước, mặt sau và thông tin ngôn ngữ nếu có.
2. Hệ thống kiểm tra deck đích còn hợp lệ.
3. Hệ thống lưu flashcard mới.
4. Hệ thống cập nhật số lượng thẻ của deck.
5. Hệ thống trả thông tin flashcard vừa tạo.

## BE-FLASHCARD-002 - Xem danh sách flashcard
### Mục tiêu
Cho phép người dùng xem nội dung học của một deck theo cách dễ tìm và dễ kiểm soát.

### Luồng chính
1. Hệ thống nhận deck cần xem, từ khóa tìm kiếm và cách sắp xếp.
2. Hệ thống lọc danh sách flashcard theo điều kiện được yêu cầu.
3. Hệ thống trả dữ liệu theo từng trang.

### Kết quả nghiệp vụ
- Người dùng có thể tìm nhanh flashcard theo nội dung.
- Người dùng có thể xem deck theo nhiều cách sắp xếp.

## BE-FLASHCARD-003 - Cập nhật flashcard
### Mục tiêu
Cho phép người dùng chỉnh sửa nội dung học để phản ánh đúng kiến thức mong muốn.

### Luồng chính
1. Hệ thống xác định flashcard cần cập nhật.
2. Hệ thống kiểm tra flashcard thuộc đúng deck đang được thao tác.
3. Hệ thống lưu nội dung mới.
4. Hệ thống trả thông tin đã cập nhật.

### Quy tắc nghiệp vụ
- Flashcard chỉ được cập nhật trong đúng phạm vi deck của nó.

## BE-FLASHCARD-004 - Xóa flashcard
### Mục tiêu
Cho phép người dùng loại bỏ một flashcard không còn phù hợp.

### Hậu điều kiện
- Flashcard không còn xuất hiện trong deck đang hoạt động.
- Các dữ liệu học liên quan được dọn dẹp tương ứng.

### Luồng chính
1. Hệ thống xác định flashcard cần xóa.
2. Hệ thống loại flashcard đó khỏi các ngữ cảnh học tập đang dùng.
3. Hệ thống xóa mềm flashcard.
4. Hệ thống cập nhật lại số lượng thẻ trong deck.
