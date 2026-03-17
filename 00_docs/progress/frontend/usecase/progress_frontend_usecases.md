# Progress Frontend Use Cases

## Mục tiêu nghiệp vụ
Feature `progress` ở frontend giúp người dùng nhìn thấy tổng quan việc học, biết mình đang nợ bao nhiêu nội dung và nhận gợi ý rõ ràng về việc nên học deck nào tiếp theo.

## Danh sách use case
| ID | Use case | Mục tiêu nghiệp vụ |
| --- | --- | --- |
| FE-PROGRESS-001 | Xem tổng quan tiến độ học | Cho người dùng thấy tình trạng học tập hiện tại |
| FE-PROGRESS-002 | Xem gợi ý deck nên học tiếp | Hỗ trợ người dùng ra quyết định học ngay |
| FE-PROGRESS-003 | Bắt đầu học từ gợi ý | Rút ngắn đường đi từ báo cáo đến hành động |
| FE-PROGRESS-004 | Tải lại dữ liệu tiến độ | Cho phép người dùng làm mới thông tin khi cần |

## FE-PROGRESS-001 - Xem tổng quan tiến độ học
### Mục tiêu
Giúp người dùng nắm nhanh mức độ tiến bộ và mức độ tồn đọng học tập.

### Luồng chính
1. Người dùng mở tab tiến độ.
2. Ứng dụng lấy dữ liệu nhắc học và dữ liệu phân tích tiến độ.
3. Ứng dụng hiển thị các thẻ tổng quan.

## FE-PROGRESS-002 - Xem gợi ý deck nên học tiếp
### Mục tiêu
Giảm thời gian suy nghĩ xem nên học gì trước.

### Luồng chính
1. Ứng dụng kiểm tra xem hệ thống có đề xuất deck ưu tiên hay không.
2. Nếu có, ứng dụng hiển thị một thẻ gợi ý rõ ràng.
3. Người dùng nhìn thấy tên deck và mức độ tồn đọng liên quan.

## FE-PROGRESS-003 - Bắt đầu học từ gợi ý
### Mục tiêu
Cho phép người dùng đi thẳng từ báo cáo tiến độ sang phiên học thực tế.

### Luồng chính
1. Người dùng chọn bắt đầu học từ thẻ gợi ý.
2. Ứng dụng chuyển sang màn hình học của deck được đề xuất.

## FE-PROGRESS-004 - Tải lại dữ liệu tiến độ
### Mục tiêu
Đảm bảo người dùng có thể xem lại thông tin mới nhất sau khi vừa học xong hoặc khi mạng bị lỗi.

### Luồng chính
1. Nếu dữ liệu lỗi hoặc đã cũ, người dùng chọn thử lại.
2. Ứng dụng lấy lại toàn bộ dữ liệu tổng quan.
