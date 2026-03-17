# Folder Backend Use Cases

## Mục tiêu nghiệp vụ
Feature `folder` quản lý cấu trúc thư viện theo dạng cây, bảo đảm người dùng có thể tổ chức nội dung học thành các nhánh rõ ràng và nhất quán.

## Danh sách use case
| ID | Use case | Mục tiêu nghiệp vụ |
| --- | --- | --- |
| BE-FOLDER-001 | Tạo thư mục | Cho phép người dùng mở rộng cây thư viện |
| BE-FOLDER-002 | Xem danh sách thư mục | Cho phép người dùng duyệt cấu trúc thư viện theo từng cấp |
| BE-FOLDER-003 | Đổi tên thư mục | Cho phép người dùng chuẩn hóa lại cấu trúc thư viện |
| BE-FOLDER-004 | Cập nhật thông tin thư mục | Cho phép người dùng chỉnh sửa tên và mô tả |
| BE-FOLDER-005 | Xóa thư mục | Loại bỏ một nhánh thư viện không còn sử dụng |

## BE-FOLDER-001 - Tạo thư mục
### Mục tiêu
Cho phép người dùng tạo thư mục ở cấp gốc hoặc dưới một thư mục cha phù hợp.

### Tác nhân
- Người dùng quản lý thư viện.

### Tiền điều kiện
- Nếu tạo dưới thư mục cha, thư mục cha phải tồn tại.
- Thư mục cha không được đồng thời chứa bộ thẻ học.

### Hậu điều kiện
- Một thư mục mới được thêm vào đúng vị trí trong cây.

### Luồng chính
1. Hệ thống nhận tên, mô tả và vị trí cha nếu có.
2. Hệ thống xác định cấp sâu của thư mục mới.
3. Hệ thống kiểm tra trong cùng một cấp không có thư mục trùng tên.
4. Hệ thống tạo thư mục mới.
5. Hệ thống trả lại thông tin thư mục đã tạo.

### Luồng ngoại lệ
1. Thư mục cha không tồn tại.
2. Thư mục cha đang chứa bộ thẻ học nên không thể tạo thư mục con.
3. Tên thư mục bị trùng trong cùng cấp.

### Quy tắc nghiệp vụ
- Trong cùng một cấp, tên thư mục phải là duy nhất.
- Một thư mục cha hoặc chỉ chứa thư mục con, hoặc chỉ chứa bộ thẻ học.

## BE-FOLDER-002 - Xem danh sách thư mục
### Mục tiêu
Cho phép người dùng duyệt thư viện theo từng cấp và tìm nhanh thư mục cần mở.

### Luồng chính
1. Hệ thống nhận cấp thư mục cần xem, từ khóa tìm kiếm và cách sắp xếp.
2. Hệ thống lọc thư mục theo phạm vi được yêu cầu.
3. Hệ thống đếm số thư mục con của từng dòng dữ liệu.
4. Hệ thống trả danh sách thư mục tương ứng.

### Kết quả nghiệp vụ
- Người dùng biết thư mục nào còn nhánh con để tiếp tục mở sâu hơn.

## BE-FOLDER-003 - Đổi tên thư mục
### Mục tiêu
Cho phép người dùng đổi nhãn thư mục mà không làm thay đổi vị trí của thư mục đó trong cây.

### Luồng chính
1. Hệ thống nhận thư mục cần đổi tên.
2. Hệ thống kiểm tra tên mới không trùng với thư mục cùng cấp.
3. Hệ thống cập nhật tên thư mục.
4. Hệ thống trả thông tin sau cập nhật.

## BE-FOLDER-004 - Cập nhật thông tin thư mục
### Mục tiêu
Cho phép người dùng chỉnh sửa đầy đủ tên và mô tả của thư mục.

### Luồng chính
1. Hệ thống xác định thư mục cần cập nhật.
2. Hệ thống kiểm tra ràng buộc trùng tên trong cùng cấp.
3. Hệ thống lưu tên và mô tả mới.
4. Hệ thống trả thông tin mới nhất của thư mục.

## BE-FOLDER-005 - Xóa thư mục
### Mục tiêu
Cho phép người dùng loại bỏ cả một nhánh thư viện không còn sử dụng.

### Hậu điều kiện
- Thư mục được chọn và toàn bộ nhánh con của nó không còn xuất hiện trong thư viện đang hoạt động.

### Luồng chính
1. Hệ thống xác định thư mục được yêu cầu xóa.
2. Hệ thống xóa mềm toàn bộ nội dung học nằm trong nhánh đó.
3. Hệ thống xóa mềm toàn bộ thư mục con trong nhánh đó.
4. Hệ thống xác nhận thao tác thành công.
