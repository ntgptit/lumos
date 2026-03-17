# Reminder Frontend Use Cases

## Mục tiêu nghiệp vụ
Feature `reminder` hiện chưa có màn hình độc lập ở frontend, nhưng dữ liệu nhắc học đóng vai trò dẫn dắt hành vi người dùng trong màn hình tiến độ.

## Danh sách use case
| ID | Use case | Mục tiêu nghiệp vụ |
| --- | --- | --- |
| FE-REMINDER-001 | Hiển thị tín hiệu nhắc học trong màn hình tiến độ | Cho người dùng biết có nên quay lại học ngay hay không |
| FE-REMINDER-002 | Dẫn người dùng sang deck được gợi ý | Biến tín hiệu nhắc học thành hành động cụ thể |

## FE-REMINDER-001 - Hiển thị tín hiệu nhắc học trong màn hình tiến độ
### Mục tiêu
Cho người dùng hiểu nhanh số lượng nội dung đến hạn và mức độ quá hạn.

### Luồng chính
1. Ứng dụng nhận dữ liệu nhắc học từ hệ thống.
2. Ứng dụng hiển thị tổng quan trong các thẻ báo cáo.
3. Nếu có gợi ý deck ưu tiên, ứng dụng hiển thị CTA tương ứng.

## FE-REMINDER-002 - Dẫn người dùng sang deck được gợi ý
### Mục tiêu
Cho phép người dùng đi thẳng từ tín hiệu nhắc học sang hành động học.

### Luồng chính
1. Người dùng chọn CTA của deck được gợi ý.
2. Ứng dụng mở màn hình học của deck đó.
